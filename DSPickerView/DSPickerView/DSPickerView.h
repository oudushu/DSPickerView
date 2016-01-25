//
//  DSPickerView.h
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/10/30.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DSPickerViewType) {
    DSPickerViewTypeDatePicker,
    DSPickerViewTypePickerView,
    DSPickerViewTypeAddressPicker
};

typedef void (^PickerSelectedValueBlock)(id selectedItem);

@interface DSPickerView : UIView

/**
 *  创建一个pickerView
 *
 *  @param frame               可传入: CGRectMake(0, 0, self.view.frame.size.width, 240)
 *  @param content             content的类型可以是字符串数组或者模型数组. 如果是模型数组, 模型里面必须有"name"属性, 如果选择日期则传入nil
 *  @param defaultSelectedItem 默认选中项
 *  @param type                日期选择器或者其他选择器
 *  @param title               标题
 *  @param block               选中项的回调
 */
- (instancetype)initWithFrame:(CGRect)frame
                      content:(id)content
          defaultSelectedItem:(NSInteger)defaultSelectedItem
                         type:(DSPickerViewType)type
                        title:(NSString *)title
                 selecedBlock:(PickerSelectedValueBlock)block;

- (void)showInView:(UIView *)view;

@end
