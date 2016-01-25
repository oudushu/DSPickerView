//
//  ViewController.m
//  DSPickerView
//
//  Created by 欧杜书 on 16/1/17.
//  Copyright © 2016年 DuShu. All rights reserved.
//

#import "ViewController.h"
#import "DSPickerView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    DSPickerView *picker = [[DSPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) content:nil defaultSelectedItem:0 type:DSPickerViewTypeDatePicker title:@"日期选择" selecedBlock:^(id selectedItem) {
        weakSelf.dateLabel.text = selectedItem;
    }];
    [picker showInView:self.view];
}

- (IBAction)areaPickerClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    DSPickerView *picker = [[DSPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) content:nil defaultSelectedItem:0 type:DSPickerViewTypeAddressPicker title:@"地区选择" selecedBlock:^(id selectedItem) {
        weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@", selectedItem[@"province"], selectedItem[@"city"], selectedItem[@"area"]];
    }];
    [picker showInView:self.view];
}

- (IBAction)customPickerClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    DSPickerView *picker = [[DSPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) content:@[@"first", @"second", @"third"] defaultSelectedItem:1 type:DSPickerViewTypePickerView title:@"自定义选择" selecedBlock:^(id selectedItem) {
        weakSelf.customLabel.text = selectedItem;
    }];
    [picker showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
