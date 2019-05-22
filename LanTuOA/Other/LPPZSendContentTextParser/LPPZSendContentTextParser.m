//
//  LPPZSendContentTextParser.m
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

#import "LPPZSendContentTextParser.h"
#import "LPPZHelper.h"
//#import "NSAttributedString+YYText.h"
#import "LPPZLabelImage.h"

#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define LPFontSize(size)       ([UIFont systemFontOfSize:size])

#define LPBoldFontSize(size)   ([UIFont boldSystemFontOfSize:size])

#define LPImage(image)         ([UIImage imageNamed:image])

#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqual:[NSNull null]] || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [string isEqualToString:@"(null)"])

#define kLPPZLinkATUserName @"userName"
#define kLPPZLinkATUserID @"userID"

@implementation LPPZSendContentTextParser

- (instancetype)init {
    self = [super init];
    _font = [UIFont systemFontOfSize:16];
    _textColor = HEXRGBCOLOR(0x353535);
    _highlightTextColor = HEXRGBCOLOR(0xf08c1d);
    _atUserFont = LPFontSize(16);
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    text.yy_color= _textColor;
    text.yy_font = _font;
    
    
    {
        NSArray<NSTextCheckingResult *> *emoticonResults = [[LPPZHelper regex_MoodAtUser] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
        NSUInteger clipLength = 0;
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            
            NSMutableString *tmp1 = [NSMutableString stringWithString: [text.string substringWithRange:range]];
            
            NSMutableString *tmp2 = [NSMutableString stringWithString: [tmp1 stringByReplacingOccurrencesOfString:@"[" withString:@""]];
            NSMutableString *tmp3 = [NSMutableString stringWithString: [tmp2 stringByReplacingOccurrencesOfString:@"]" withString:@""]];
            
            NSString *emoString = [tmp3 componentsSeparatedByString:@"-"].firstObject;
            emoString = [NSString stringWithFormat:@"%@ ", emoString];
            NSString *userId = [tmp3 componentsSeparatedByString:@"-"].lastObject;
            
            if (![tmp1 hasPrefix:@"[@"]) {
                continue;
            }
            if ([tmp3 componentsSeparatedByString:@"-"].count !=2) {
                continue;
            }
            if (NULLString(userId)) {
                continue;
            }
            //将正则匹配到的文字转化为图片
            LPPZLabelImage * image = [LPPZLabelImage imageWithText:emoString
                                                              font:_atUserFont
                                                         textColor:HEXRGBCOLOR(0x0068b7)
                                                   backgroundColor:[UIColor whiteColor]];
            if (!image.image) continue;
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName
                             inRange:range
                             options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                          usingBlock:^(id value, NSRange range, BOOL *stop) {
                              if (value) {
                                  containsBindingRange = YES;
                                  *stop = YES;
                              }
                          }];
            if (containsBindingRange) continue;
            YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
            NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
            YYTextAttachment *attach = [YYTextAttachment new];
            attach.content = image.image;
            attach.contentMode = UIViewContentModeScaleAspectFit;
            attach.userInfo = @{kLPPZLinkATUserID:userId ,kLPPZLinkATUserName :emoString};
            [atr yy_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
            
            YYTextRunDelegate *delegate = [YYTextRunDelegate new];
            delegate.width = image.lppz_TextSize.width;
            CGFloat fontHeight = _font.ascender - _font.descender;
            CGFloat yOffset = _font.ascender - fontHeight * 0.5;
            delegate.ascent = image.lppz_TextSize.height * 0.5 + yOffset;
            delegate.descent = image.lppz_TextSize.height - delegate.ascent;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = image.lppz_TextSize.height;
            }
            
            CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
            [atr yy_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
            if (delegate) CFRelease(delegateRef);
            [atr yy_setTextBackedString:backed range:NSMakeRange(0, atr.length)];
            [atr yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, atr.length)];
            [text replaceCharactersInRange:range withAttributedString:atr];
            
            if (selectedRange) {
                *selectedRange = [self _replaceTextInRange:range withLength:atr.length selectedRange:*selectedRange];
            }
            clipLength += range.length - atr.length;
        }
    }
    
    return YES;
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}

@end

