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

static NSString *const XWNoneDataTableCellID = @"XWNoneDataTableCellID";


@interface XWCompanyInfoController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XWCompanyInfoModel *infoModel;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIWebView *webView1;
@property (nonatomic, strong) UIWebView *webView2;
@property (nonatomic, strong) UIWebView *webView3;

@property (nonatomic, assign) CGFloat height;
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
        _tableView = table;
    }
    return _tableView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
        [_webView sizeToFit];
        [_webView scalesPageToFit];
    }
    return _webView;
}

- (UIWebView *)webView1{
    if (!_webView1) {
        _webView1 = [[UIWebView alloc] init];
        _webView1.delegate = self;
        _webView1.scrollView.scrollEnabled = NO;
    }
    return _webView1;
}

- (UIWebView *)webView2{
    if (!_webView2) {
        _webView2 = [[UIWebView alloc] init];
        _webView2.delegate = self;
        _webView2.scrollView.scrollEnabled = NO;
    }
    return _webView2;
}

- (UIWebView *)webView3{
    if (!_webView3) {
        _webView3 = [[UIWebView alloc] init];
        _webView3.delegate = self;
        _webView3.scrollView.scrollEnabled = NO;
    }
    return _webView3;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.title = @"公司信息";
    [self.view addSubview:self.tableView];
    self.height = 193;
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getCompanyInfoWithID:[XWInstance shareInstance].userInfo.company_id success:^(XWCompanyInfoModel *infoModel) {
        weakSelf.infoModel = infoModel;
        
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Setter
- (void)setInfoModel:(XWCompanyInfoModel *)infoModel{
    _infoModel = infoModel;
    [self.webView loadHTMLString:_infoModel.co_introduction baseURL:nil];
    [self.webView1 loadHTMLString:_infoModel.co_culture baseURL:nil];
    [self.webView2 loadHTMLString:_infoModel.co_system baseURL:nil];
    [self.webView3 loadHTMLString:_infoModel.co_product baseURL:nil];
    
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
        return self.height;
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
            
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.webView];
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(cell.contentView).offset(15);
            make.right.mas_equalTo(cell.contentView).offset(-15);
        }];
        return cell;
    }else if (indexPath.section == 1){ // 文化
        if ([self.infoModel.co_culture isEqualToString:@""] || self.infoModel.co_culture == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.webView1];
        [self.webView1.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"1"];
        [self.webView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(cell.contentView).offset(15);
            make.right.mas_equalTo(cell.contentView).offset(-15);
        }];
        return cell;
    }else if (indexPath.section == 2){ // 制度
        if ([self.infoModel.co_system isEqualToString:@""] || self.infoModel.co_system == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.webView2];
        [self.webView2.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"2"];
        [self.webView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(cell.contentView).offset(15);
            make.right.mas_equalTo(cell.contentView).offset(-15);
        }];
        return cell;
    }else{ // 产品
        if ([self.infoModel.co_product isEqualToString:@""] || self.infoModel.co_product == nil) {
            XWNoneDataTableCell *cell = [tableView dequeueReusableCellWithIdentifier:XWNoneDataTableCellID forIndexPath:indexPath];
            
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:self.webView3];
        [self.webView3.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"3"];
        [self.webView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(cell.contentView).offset(15);
            make.right.mas_equalTo(cell.contentView).offset(-15);
        }];
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js=[NSString stringWithFormat:js, kWidth, kWidth - 30];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '30%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f",20.0];
//    [webView stringByEvaluatingJavaScriptFromString:jsString];
    

    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] * 0.25;
    if (webView == self.webView) {
        NSLog(@"webVIew");
        self.height = height;
    }else if (webView == self.webView1){
        NSLog(@"webVIew1");
        self.height1 = height+300;
    }else if (webView == self.webView2){
        NSLog(@"webVIew2");
        self.height2 = height;
    }else if (webView == self.webView3){
        NSLog(@"webVIew3");
        self.height3 = height;
    }
    NSLog(@"height is %f", height);
    [self.tableView reloadData];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [MBProgressHUD showActivityMessageInWindow:@"加载中..."];
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSString *text = [NSString stringWithFormat:@"%@", context];
    if ([text isEqualToString:@"0"]) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGSize contentSize = [self.webView sizeThatFits:CGSizeZero];
            self.height = contentSize.height;
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        }
    }else if ([text isEqualToString:@"1"]){
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGSize contentSize = [self.webView1 sizeThatFits:CGSizeZero];
            self.height1 = contentSize.height;
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        }
    }else if ([text isEqualToString:@"2"]){
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGSize contentSize = [self.webView2 sizeThatFits:CGSizeZero];
            self.height2 = contentSize.height;
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        }
    }else if ([text isEqualToString:@"3"]){
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGSize contentSize = [self.webView3 sizeThatFits:CGSizeZero];
            self.height3 = contentSize.height;
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
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
