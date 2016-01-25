//
//  DSPickerView.m
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/10/30.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "DSPickerView.h"
#import "UIView+DSCommon.h"


@interface DSPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, weak) UIView *separatorView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSString *selectedDate;
@property (nonatomic, copy) PickerSelectedValueBlock block;
@property (nonatomic, assign) NSInteger selectedItem;
@property (nonatomic, assign) DSPickerViewType pickerType;
@property (nonatomic, assign) NSInteger defaultSelectedItem;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *address;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@end

@implementation DSPickerView

- (instancetype)initWithFrame:(CGRect)frame
                      content:(id)content
          defaultSelectedItem:(NSInteger)defaultSelectedItem
                         type:(DSPickerViewType)type
                        title:(NSString *)title
                 selecedBlock:(PickerSelectedValueBlock)block {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.block = block;
        self.pickerType = type;
        self.defaultSelectedItem = defaultSelectedItem;
        
        if (type == DSPickerViewTypeDatePicker) {
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            [self addSubview:datePicker];
            NSString *dateStr = @"1900-01-01";
            datePicker.minimumDate = [self.dateFormatter dateFromString:dateStr];
            datePicker.maximumDate = [NSDate date];
            [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.datePickerMode = UIDatePickerModeDate;
            NSString *dateString = [self.dateFormatter stringFromDate:datePicker.maximumDate];
            self.selectedDate = [dateString copy];
            self.datePicker = datePicker;
        } else if (type == DSPickerViewTypePickerView || type == DSPickerViewTypeAddressPicker) {
            UIPickerView *pickerView = [[UIPickerView alloc] init];
            pickerView.dataSource = self;
            pickerView.delegate = self;
            [self addSubview:pickerView];
            self.pickerView = pickerView;
        }
        
        if (type == DSPickerViewTypePickerView) {
            self.contentArray = content;
            [self.pickerView selectRow:defaultSelectedItem inComponent:0 animated:NO];
            self.selectedItem = defaultSelectedItem;
        } if (type == DSPickerViewTypeAddressPicker) {
            self.address = content ? [content mutableCopy] : [NSMutableDictionary dictionary];
            [self initAreaData];
        }
        
        UIView *toolBar = [[UIView alloc] init];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
        UIView *separatorView = [[UIView alloc] init];
        [toolBar addSubview:separatorView];
        self.separatorView = separatorView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        [toolBar addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton *confirmButton = [[UIButton alloc] init];
        [toolBar addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
    }
    return self;
}

- (void)initAreaData {
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ChinaArea.plist" ofType:nil]];
    self.cities = [self.provinces.firstObject objectForKey:@"cities"];
    self.areas = [self.cities.firstObject objectForKey:@"areas"];
    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView selectRow:0 inComponent:1 animated:NO];
    [self.pickerView selectRow:0 inComponent:2 animated:NO];
}

- (void)confirmButtonClick {
    [self.view hidePopupContentView];
    if (self.pickerType == DSPickerViewTypeDatePicker) {
        if (self.block && self.selectedDate.length > 0) {
            self.block(self.selectedDate);
        }
    } else if (self.pickerType == DSPickerViewTypePickerView) {
        if (self.block && self.selectedItem >= 0 && self.selectedItem < self.contentArray.count) {
            self.block(self.contentArray[self.selectedItem]);
        }
    } else {
        if (self.block) {
            self.block(self.address);
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolBar.backgroundColor = [UIColor whiteColor];
    self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    
    self.separatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.separatorView.frame = CGRectMake(0, 44, self.frame.size.width, 0.5);
    
    self.titleLabel.frame = self.toolBar.frame;
    self.titleLabel.center = self.toolBar.center;
    self.titleLabel.textColor = [UIColor colorWithRed:5/255 green:132/255 blue:199/255 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:1.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.confirmButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.frame = CGRectMake(self.toolBar.frame.size.width - 60, 0, 60, self.toolBar.frame.size.height);
    
    if (self.pickerType == DSPickerViewTypeDatePicker) {
        self.datePicker.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44);
    } else if (self.pickerType == DSPickerViewTypePickerView || self.pickerType == DSPickerViewTypeAddressPicker) {
        //There are only three valid heights for UIPickerView (162.0, 180.0 and 216.0).
        self.pickerView.frame = CGRectMake(0, 44, self.frame.size.width, 180.0);
//        NSLog(@"x-%f, y-%f, w-%f, h-%f", self.pickerView.frame.origin.x, self.pickerView.frame.origin.y, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    }
    
//    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0];
//    [self addConstraint:left];
//    
//    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0];
//    [self addConstraint:right];
//    
//    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:0];
//    [self addConstraint:bottom];
//    
//    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:180.0f];
//    [self.pickerView addConstraint:height];
}

#pragma mark - pickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerType == DSPickerViewTypeAddressPicker) {
        return 3;
    } 
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerType == DSPickerViewTypeAddressPicker) {
        switch (component) {
            case 0:
                return self.provinces.count;
                break;
            case 1:
                return self.cities.count;
                break;
            case 2:
                return self.areas.count;
                break;
            default:
                return 0;
                break;
        }
    }
    return self.contentArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {

    if (self.pickerType == DSPickerViewTypePickerView) {
        if ([self.contentArray[row] isKindOfClass:[NSString class]]) {
            return self.contentArray[row];
        } else {
            return [self.contentArray[row] valueForKey:@"name"];
        }
    } else {
        switch (component) {
            case 0:
                return [self.provinces[row] objectForKey:@"state"];
                break;
            case 1:
                return [self.cities[row] objectForKey:@"city"];
                break;
            case 2:
                if (self.areas.count > 0) {
                    return self.areas[row];
                    break;
                }
            default:
                return  @"";
                break;
        }
    }
}

#pragma mark - pickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if (self.pickerType == DSPickerViewTypeAddressPicker) {
        switch (component) {
            case 0:
                self.cities = [self.provinces[row] objectForKey:@"cities"];
                self.areas = [self.cities[0] objectForKey:@"areas"];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadAllComponents];
                
                self.address[@"province"] = [self.provinces[row] objectForKey:@"state"];
                self.address[@"city"] = [self.cities[0] objectForKey:@"city"];
                if (self.areas.count > 0) {
                    self.address[@"area"] = self.areas[0];
                } else{
                    self.address[@"area"] = @"";
                }
                break;
            case 1:
                self.areas = [self.cities[row] objectForKey:@"areas"];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadAllComponents];
                
                self.address[@"city"] = [self.cities[row] objectForKey:@"city"];
                if (self.areas.count > 0) {
                    self.address[@"area"] = self.areas[0];
                } else{
                    self.address[@"area"] = @"";
                }
                break;
            case 2:
                if (self.areas.count > 0) {
                    self.address[@"area"] = self.areas[row];
                } else{
                    self.address[@"area"] = @"";
                }
                break;
            default:
                break;
        }
    }
    
    self.selectedItem = row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.pickerType == DSPickerViewTypeAddressPicker) {
        return 32;
    }
    return 38;
}

- (void)showInView:(UIView *)view {
    self.view = view;
    [view showPopupContentView:self];
}

#pragma mark - date picker events
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSString *dateString = [self.dateFormatter stringFromDate:datePicker.date];
    self.selectedDate = [dateString copy];
}

#pragma mark - getters & setters
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (NSString *)selectedDate {
    if (!_selectedDate) {
        _selectedDate = [NSString string];
    }
    return _selectedDate;
}

@end
