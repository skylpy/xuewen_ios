//
//  XWHotContentController.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHotContentController.h"
#import "XWArticleContentModel.h"
#import "XWArticleContentCell.h"
#import "XWArticleTitleView.h"

static NSString *const XWArticleContentCellID = @"XWArticleContentCellID";



@interface XWHotContentController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XWArticleContentModel *dataModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat cellheight;

@end

@implementation XWHotContentController

#pragma mark - Lazy / Getter

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table registerNib:[UINib nibWithNibName:@"XWArticleContentCell" bundle:nil] forCellReuseIdentifier:XWArticleContentCellID];
        
        _tableView = table;
    }
    return _tableView;
}



#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - kNaviBarH - 50;;
}

- (void)initUI{
    self.cellheight = kHeight;
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ARTICLE_WEBVIEW_LOADFINISH" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        XWArticleContentCell *cell = [x object];
        if (self.cellheight != cell.cellHeight) {
            self.cellheight = cell.cellHeight;
            [self.tableView reloadData];
        }
        
    }];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getArticleContentWith:self.articleId success:^(XWArticleContentModel *model) {
        weakSelf.dataModel = model;
        
        weakSelf.title = model.title;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
    }];
}




#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 文章内容
    XWArticleContentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWArticleContentCellID forIndexPath:indexPath];
    cell.model = self.dataModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"XWArticleTitleView" owner:self options:nil].firstObject;
    headerView.frame = CGRectMake(0, 0, kWidth, 37 + 25 + [self.dataModel.title calculateHeightWithFont:[UIFont fontWithName:kMedFont size:18] Width:kWidth-29]);
    [headerView setValue:self.dataModel forKey:@"model"];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37 + 25 + [self.dataModel.title calculateHeightWithFont:[UIFont fontWithName:kMedFont size:18] Width:kWidth-29];
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
