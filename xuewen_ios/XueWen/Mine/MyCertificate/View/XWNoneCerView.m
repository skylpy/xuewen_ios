//
//  XWNoneCerView.m
//  XueWen
//
//  Created by aaron on 2018/8/20.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNoneCerView.h"

@interface XWNoneCerView()

@property (weak, nonatomic) IBOutlet UIView *bgVIew;


@end

@implementation XWNoneCerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgVIew.clipsToBounds = YES;
    self.bgVIew.layer.cornerRadius = 5;
}

+ (instancetype)shareNoneCerView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWNoneCerView" owner:self options:nil].firstObject;
}

- (void)showFromView:(UIView *)superView {
    
    self.frame = superView.frame;
    
    [superView addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
}

@end
