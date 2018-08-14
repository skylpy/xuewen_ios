//
//  SelectPriceView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/7.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "SelectPriceView.h"
@interface SelectPriceView()

@property (nonatomic, strong) NSMutableArray *buttons;

@end
@implementation SelectPriceView
- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, kWidth, 208)]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
