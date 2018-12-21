//
//  XWFirmOrderCell.m
//  XueWen
//
//  Created by aaron on 2018/12/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWFirmOrderCell.h"

@interface XWFirmOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (nonatomic,assign) NSInteger number;
@end

@implementation XWFirmOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.number = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        !self.CourseManageClick?:self.CourseManageClick(self.model);
    }];
    
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self actionClick:x];
    }];
    
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self actionClick:x];
    }];
    

    [self.numberText.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        self.number = [x integerValue];
    }];
    self.numberText.enabled = NO;
    [self.numberText addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark-文本内容发生改变
-(void)passConTextChange:(id)sender{
    UITextField* target=(UITextField*)sender;
    
    self.model.people_count = [self.model.p_people_num integerValue]*[target.text integerValue];
    self.model.allprice = [target.text integerValue]*[self.model.price floatValue];
    !self.CourseManageClick?:self.CourseManageClick(self.model);
}


- (void)setModel:(XWCourseManageModel *)model {
    _model = model;
    model.allprice = [model.price floatValue];
    [self.coverImage setImageWithURL:[NSURL URLWithString:model.coverphotoall] placeholder:DefaultImage];
    self.titleLabel.text = model.coursename;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.price];
    self.selectButton.selected = model.isSelect;
}

- (void)actionClick:(UIButton *)sender {
    if (sender.tag == 1000) {
        
        if (self.number < 2) {
            
            return;
        }
        self.number --;
        self.numberText.text = [NSString stringWithFormat:@"%ld",(long)self.number];
    }else {
        
        if (self.number > 999) {
            
            return;
        }
        self.number ++;
        self.numberText.text = [NSString stringWithFormat:@"%ld",(long)self.number];
        
    }
    self.model.allprice = self.number*[self.model.price floatValue];
    self.model.people_count = [self.model.p_people_num integerValue]*self.number;
    NSLog(@"=====%.2f",self.model.allprice);
    !self.CourseManageClick?:self.CourseManageClick(self.model);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
