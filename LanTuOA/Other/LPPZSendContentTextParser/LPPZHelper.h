//
//  LPPZHelper.h
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPZHelper : NSObject






/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;
//动态发布的内容展示
+ (NSRegularExpression *)regex_MoodAtUser ;


@end

NS_ASSUME_NONNULL_END
