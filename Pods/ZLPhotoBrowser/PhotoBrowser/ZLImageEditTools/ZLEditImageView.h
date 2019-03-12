//
//  ZLBrushBoardImageView.h
//  ZLPhotoBrowser
//
//  Created by long on 2018/5/9.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLEditImageView : UIImageView

@property (nonatomic, strong) UIColor *drawColor;

@property (nonatomic, assign) BOOL drawEnable;

- (void)rotate;
- (void)revoke;

@end
