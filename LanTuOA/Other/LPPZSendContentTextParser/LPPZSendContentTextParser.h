//
//  LPPZSendContentTextParser.h
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPZSendContentTextParser : NSObject <YYTextParser>

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightTextColor;
@property (nonatomic, strong) UIFont *atUserFont;

@end

NS_ASSUME_NONNULL_END
