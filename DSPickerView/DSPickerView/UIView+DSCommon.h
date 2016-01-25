//
//  UIView+dsCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 6/15/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DSCommon)

@property (nonatomic, strong) UIView *popupMaskView;
@property (nonatomic, strong) UIView *popupContentView;

- (void)showPopupContentView:(UIView *)popupContentView;
- (void)hidePopupContentView;

- (void)ds_setY:(CGFloat)y;
- (void)ds_setX:(CGFloat)x;
- (void)ds_setOrigin:(CGPoint)origin;
- (void)ds_setHeight:(CGFloat)height;
- (void)ds_setWidth:(CGFloat)width;
- (void)ds_setSize:(CGSize)size;

- (UIViewController *)ds_viewController;
- (UINavigationController *)ds_navigationController;
@end
