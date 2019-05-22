//
//  LPPZLabelImage.h
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPPZLabelImage : UIView
@property (assign, nonatomic) CGSize lppz_TextSize;
@property (strong, nonatomic) UIImage * image ;

+(LPPZLabelImage *)imageWithText:(NSString *)text
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                 backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)makeImageWithColor:(UIColor *)color
                       withSize:(CGSize)size;

@end


NS_ASSUME_NONNULL_END
