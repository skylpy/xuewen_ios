//
//  XWCompanyInfoController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/30.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCompanyInfoController.h"
#import "XWNoneDataTableCell.h"
#import "XWCompanyInfoModel.h"
#import "XWNewCompanyInfoCell.h"

static NSString *const XWNoneDataTableCellID = @"XWNoneDataTableCellID";
static NSString *const XWNewCompanyInfoCellID = @"XWNewCompanyInfoCellID";


@interface XWCompanyInfoController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XWCompanyInfoModel *infoModel;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat height1;
@property (nonatomic, assign) CGFloat height2;
@property (nonatomic, assign) CGFloat height3;

@end

@implementation XWCompanyInfoController

#pragma mark - Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomH-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.backgroundColor = Color(@"#f4f4f4");
        [table registerNib:[UINib nibWithNibName:@"XWNoneDataTableCell" bundle:nil] forCellReuseIdentifier:XWNoneDataTableCellID];
        [table registerClass:[XWNewCompanyInfoCell class] forCellReuseIdentifier:XWNewCompanyInfoCellID];
        _tableView = table;
    }
    return _tableView;
}



#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.title = @"公司信息";
    [self.view addSubview:self.tableView];
    self.cellHeight = self.height1 = self.height2 = self.height3 = 100;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeight:) name:@"WEBVIEWHEIGHT" object:nil];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getCompanyInfoWithID:self.companyId success:^(XWCompanyInfoModel *infoModel) {
        weakSelf.infoModel = infoModel;

    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Setter
- (void)setInfoModel:(XWCompanyInfoModel *)infoModel{
    _infoModel = infoModel;
    NSString *qian = @"<div style='display: inline-block;pidding: 0px;margin-bottom: 10px;'";
    NSString *hou = @"</div>";
    NSString *introduction = [NSString stringWithFormat:@"%@%@%@", qian, _infoModel.co_introduction, hou];
    NSString *co_product = [NSString stringWithFormat:@"%@%@%@", qian, _infoModel.co_product, hou];
    NSString *co_culture = [NSString stringWithFormat:@"%@%@%@", qian, _infoModel.co_culture, hou];
    NSString *co_system = [NSString stringWithFormat:@"%@%@%@", qian, _infoModel.co_system, hou];

    _infoModel.co_system = [self replaceString:co_system];
    _infoModel.co_introduction = [self replaceString:introduction];
    _infoModel.co_product = [self replaceString:co_product];
    _infoModel.co_culture = [self replaceString:co_culture];
    
    [self.tableView reloadData];

}

/** 阿里云图片处理*/
- (NSString *)replaceString:(NSString *)text {
    NSString *png = [NSString stringWithFormat:@".png?x-oss-process=image/resize,w_%.f,/sharpen,100", kWidth];
    NSString *jpg = [NSString stringWithFormat:@".jpg?x-oss-process=image/resize,w_%.f,/sharpen,100", kWidth];
    NSString *str1 = [text stringByReplacingOccurrencesOfString:@".png" withString:png];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@".jpg" withString:jpg];
    return str2;
//    NSString *src = [NSString stringWithFormat:@"data-original"];
//    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"src" withString:src];
//    return str3;
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) { //简介
        if ([self.infoModel.co_introduction isEqualToString:@""] || self.infoModel.co_introduction == nil) {
            return 193;
        }
        return self.cellHeight;
    }else if (indexPath.section == 1){ // 文化
        if ([self.infoModel.co_culture isEqualToString:@""] || self.infoModel.co_culture == nil) {
            return 193;
        }
        return self.height1;
    }else if (indexPath.section == 2){ // 制度
        if ([self.infoModel.co_system isEqualToString:@""] || self.infoModel.co_system == nil) {
            return 193;
        }
        return self.height2;
    }else{ // 产品
        if ([self.infoModel.co_product isEqualToString:@""] || self.infoModel.co_product == nil) {
            return 193;
        }
        return self.height3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //简介
        if ([self.infoModel.co_introduction isEqualToString:@""] || self.infoModel.co_introduction == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            cell.infoLabel.text = @"暂无相关信息:) ";
            return cell;
        }
        
        XWNewCompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNewCompanyInfoCellID forIndexPath:indexPath];
        cell.html = self.infoModel.co_introduction;
        return cell;
        
    }else if (indexPath.section == 1){ // 文化
        if ([self.infoModel.co_culture isEqualToString:@""] || self.infoModel.co_culture == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            cell.infoLabel.text = @"暂无相关信息:) ";
            return cell;
        }
        XWNewCompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNewCompanyInfoCellID forIndexPath:indexPath];
        cell.html = self.infoModel.co_culture;
        return cell;
        
    }else if (indexPath.section == 2){ // 制度
        if ([self.infoModel.co_system isEqualToString:@""] || self.infoModel.co_system == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            cell.infoLabel.text = @"暂无相关制度:) ";
            return cell;
        }
        
        XWNewCompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNewCompanyInfoCellID forIndexPath:indexPath];
        cell.html = self.infoModel.co_system;
        return cell;
        
    }else{ // 产品
        if ([self.infoModel.co_product isEqualToString:@""] || self.infoModel.co_product == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            cell.infoLabel.text = @"暂无相关产品:) ";
            return cell;
        }
        
        XWNewCompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNewCompanyInfoCellID forIndexPath:indexPath];
        cell.html = self.infoModel.co_product;
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color(@"#333333");
    label.font = [UIFont fontWithName:kMedFont size:14];
    
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(25);
        make.top.mas_equalTo(bgView).offset(30);
    }];
    switch (section) {
        case 0:
        {
            label.text = @"企业简介";
        }
            break;
        case 1:
        {
            label.text = @"企业文化";
        }
            break;
        case 2:
        {
            label.text = @"企业制度";
        }
            break;
        case 3:
        {
            label.text = @"企业产品";
        }
            break;
        default:
            break;
    }
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 0.01;
    }
    return 10;
}



- (void)changeHeight:(NSNotification *)noti{

    XWNewCompanyInfoCell *cell = noti.object;
    if ([cell.html isEqualToString:self.infoModel.co_introduction]) { // 简介
        if (self.cellHeight != cell.cellHeight) {
            self.cellHeight = cell.cellHeight;
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([cell.html isEqualToString:self.infoModel.co_culture]){ // 文化
        if (self.height1 != cell.cellHeight) {
            self.height1 = cell.cellHeight;
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([cell.html isEqualToString:self.infoModel.co_system]){ // 制度
        if (self.height2 != cell.cellHeight) {
            self.height2 = cell.cellHeight;
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([cell.html isEqualToString:self.infoModel.co_product]){ // 产品
        if (self.height3 != cell.cellHeight) {
            self.height3 = cell.cellHeight;
            [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
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
