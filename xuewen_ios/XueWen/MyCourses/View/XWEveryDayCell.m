//
//  XWEveryDayCell.m
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWEveryDayCell.h"
#import "KKChartView.h"
#import "XWMyPlanModel.h"
#import "NSMutableAttributedString+XWUtil.h"

@interface XWEveryDayCell()

//每天学习
@property (nonatomic,strong) UILabel * everyDayLabel;

@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) KKChartView *chartView;

@end

@implementation XWEveryDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)setModel:(XWMyPlanModel *)model {
    _model = model;
    NSArray * dataAry = [self redataArray:self.model.learning];
    NSArray* redaArray = [[dataAry reverseObjectEnumerator] allObjects];
    self.chartView.dataAry = redaArray;
    NSArray * array = [NSDate latelyEightTime:@"MM.dd"];
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    self.chartView.dateArray = reversedArray;
    
}

- (NSArray *)redataArray:(NSArray *)learning {
    
    NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    NSArray * array = [NSDate latelyEightTime:@"yyyy-MM-dd"];

    for (int i = 0 ;i < array.count ;i ++) {
        
        for (int j = 0; j < learning.count; j ++) {
            XWMyPlanRecordsModel * model = learning[j];
            if ([model.date isEqualToString:array[i]]) {
                
                [arr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.2f",[model.studyTime floatValue]/100]];
            }
        }
    }
    return arr;
}


- (NSMutableArray *)arraySplitSubArrays:(NSArray *)array {
    // 数组去重,根据数组元素对象中time字段去重
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(XWMyPlanRecordsModel *obj in array) {
        
        [dic setValue:obj forKey:obj.date];
        
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSString *dictKey in dic) {
        [tempArr addObject:dictKey];
        
    }
    NSArray *sortedArray = [tempArr sortedArrayUsingSelector:@selector(compare:)]; NSLog(@"排序后:%@",sortedArray);
    // 字典重不会有重复值,allKeys返回的是无序的数组
    NSLog(@"去重后字典:%@",[dic allKeys]);
    NSMutableArray *temps = [NSMutableArray array];
    for (NSString *dictKey in sortedArray) {
        NSMutableArray *subTemps = [NSMutableArray array];
        for (XWMyPlanRecordsModel *obj in array) {
            if ([dictKey isEqualToString:obj.date]) {
                [subTemps addObject:obj];
                
            }
            
        }
        [temps addObject:subTemps]; }
    // 排序后,元素倒序的,逆向遍历
    NSEnumerator *enumerator = [temps reverseObjectEnumerator];
    temps = (NSMutableArray*)[enumerator allObjects];
    NSLog(@"temps:%@",temps);
    return temps;
    
}

- (KKChartView *)chartView{
    
    if (!_chartView) {
        KKChartView *view = [[KKChartView alloc]initWithFrame:CGRectMake(-30, 60, kWidth, 100)];
        self.chartView = view;
        view.coordinateColor = [UIColor clearColor];
        view.lineWidth = 2;
        view.isCell = YES;
        view.lineColor = Color(@"#3699FF");
//            view.dataAry = @[@"0",@"0",@"0",@"0",@"0",@"1.07",@"0.61"];
        view.isShowGradient = YES;
        view.gradientColor = @"3699FF";
        
//            [view setDataAry:@[@"0",@"0",@"0",@"0",@"0",@"1.07",@"0.61"] withDateArray:reversedArray];
    }
    return _chartView;
}

- (void)drawUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.chartView];
    
    [self addSubview:self.everyDayLabel];
//    [self addSubview:self.lineView];
    
    [self.everyDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-25);
        make.height.offset(18);
    }];
    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.everyDayLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.mas_left);
//        make.width.offset(kWidth);
//        make.height.offset(1);
//    }];
}


- (UILabel *)everyDayLabel {
    
    if (!_everyDayLabel) {
        UILabel * label = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:12] withColor:Color(@"#333333")];
        _everyDayLabel = label;
        label.attributedText = [NSMutableAttributedString setupAttributeString:@"每日学习（分钟）" rangeText:@"（分钟）" textFont:[UIFont fontWithName:kRegFont size:10] textColor:Color(@"#999999")];
    }
    return _everyDayLabel;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        UIView * lineView = [UIView new];
        _lineView = lineView;
        lineView.backgroundColor = Color(@"#CCCCCC");
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
