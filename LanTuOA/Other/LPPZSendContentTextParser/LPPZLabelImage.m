//
//  LPPZLabelImage.m
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

#import "LPPZLabelImage.h"

@interface LPPZLabelImage()



@end

@implementation LPPZLabelImage

+(LPPZLabelImage *)imageWithText:(NSString *)text
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                 backgroundColor:(UIColor *)backgroundColor{
    
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    UIImage * textImage = [LPPZLabelImage imageForView:label];
    LPPZLabelImage * labelImage = [[LPPZLabelImage alloc] init];
    labelImage.image = textImage;
    labelImage.lppz_TextSize = label.frame.size;
    
    return labelImage;
}


+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)imageForView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//生成一张带颜色的图片
+ (UIImage *)makeImageWithColor:(UIColor *)color withSize:(CGSize)size{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = CGRectMake(0, 0, size.width, size.height);
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


@end
