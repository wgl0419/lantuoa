//
//  LPPZHelper.m
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

#import "LPPZHelper.h"

@implementation LPPZHelper



+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[[^\\]]*\\])" options:kNilOptions error:NULL];
        
        //        regex = [NSRegularExpression regularExpressionWithPattern:@"@[^@]+?\\s" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regex_MoodAtUser {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[[^\\]]*\\])" options:kNilOptions error:NULL];
        
        //        regex = [NSRegularExpression regularExpressionWithPattern:@"@[^@]+?\\s/" options:kNilOptions error:NULL];
    });
    return regex;
}









@end
