//
//  XWProjectCourseController.m
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWProjectCourseController.h"
#import "XWSubProjectCourseCell.h"

static NSString *const XWSubProjectCourseCellID = @"XWSubProjectCourseCellID";


@interface XWProjectCourseController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation XWProjectCourseController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNaviBarH - kBottomH - 75) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#F4F4F4");
        [table registerClass:[XWSubProjectCourseCell class] forCellReuseIdentifier:XWSubProjectCourseCellID];
        _tableView = table;
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = Color(@"#F2F0F0");
    }
    return _bottomView;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = Color(@"#333333");
        _priceLabel.font = [UIFont fontWithName:kRegFont size:14];
    }
    return _priceLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = Color(@"#FD8829");
        [_buyBtn setTitle:@"全部购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont fontWithName:kMedFont size:15];
        [_buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}


#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.buyBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.left.mas_equalTo(self.view).offset(13);
        make.right.mas_equalTo(self.view).offset(-13);
        make.height.mas_equalTo(35);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.bottomView).offset(20);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(90);
    }];
}

- (void)setModel:(ProjectModel *)model{
    _model = model;
    self.title = [NSString stringWithFormat:@"%@%@", self.titleStr, _model.projectName];
    [self.tableView reloadData];
    if (model.buy) {
        NSString *priceStr = [NSString stringWithFormat:@"优惠价:¥%@", model.price];
        NSString *originalPriceStr = [NSString stringWithFormat:@"原价:¥%@", model.originalPrice];
        NSString *courseStr = [NSString stringWithFormat:@"(含%ld门课程)", model.courses.count];
        NSString *text = [NSString stringWithFormat:@"%@ %@%@", priceStr, originalPriceStr, courseStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#999999") range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:courseStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#999999") range:[text rangeOfString:courseStr]];
        self.priceLabel.attributedText = attr;
        self.buyBtn.userInteractionEnabled = NO;
        [self.buyBtn setTitle:@"已购买" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(@"#CCCCCC");
    }else{
        NSString *priceStr = [NSString stringWithFormat:@"优惠价:¥%@", model.price];
        NSString *originalPriceStr = [NSString stringWithFormat:@"原价:¥%@", model.originalPrice];
        NSString *courseStr = [NSString stringWithFormat:@"(含%ld门课程)", model.courses.count];
        NSString *text = [NSString stringWithFormat:@"%@ %@%@", priceStr, originalPriceStr, courseStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:originalPriceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:10] range:[text rangeOfString:courseStr]];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#FD8829") range:[text rangeOfString:courseStr]];
        self.priceLabel.attributedText = attr;
        self.buyBtn.userInteractionEnabled = YES;
        [self.buyBtn setTitle:@"全部购买" forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = Color(@"#FD8829");
    }
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;
}

#pragma mark - Action
- (void)buyAction:(UIButton *)btn{
    XWWeakSelf
    UIViewController *vc = [ViewControllerManager orderInfoWithID:self.model.projectID type:1 updateBlock:^{
        [weakSelf postNotificationWithName:@"UPDATEPROJECTPRICE" object:nil];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.courses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWSubProjectCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:XWSubProjectCourseCellID forIndexPath:indexPath];
    cell.model = self.model.courses[indexPath.row];
    cell.buy = self.model.buy;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseModel * model = self.model.courses[indexPath.row];
    
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.010;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
