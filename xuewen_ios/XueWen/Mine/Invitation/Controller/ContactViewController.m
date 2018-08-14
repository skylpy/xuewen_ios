//
//  ContactViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/4/21.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ContactViewController.h"
#import <Contacts/Contacts.h>
#import "ContactModel.h"
#import "ContactTabCell.h"
#import <MessageUI/MessageUI.h>
#import "XWContactSearchController.h"

static NSString *const ContactTabCellID = @"ContactTabCell";

@interface ContactViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/** 是否在多选状态*/
@property (nonatomic, assign) BOOL isMultiple;

/** 存放选中的信息*/
@property (nonatomic, strong) NSMutableArray *choiceArray;

/** 底部View*/
@property (nonatomic, strong) UIView *bottomView;

/** 所有数据.做本地搜索用*/
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation ContactViewController

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kNaviBarH) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.sectionIndexColor = Color(@"#2A2732");
        [table registerClass:[ContactTabCell class] forCellReuseIdentifier:ContactTabCellID];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [table addGestureRecognizer:longPress];
        _tableView = table;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)choiceArray{
    if (!_choiceArray) {
        _choiceArray = [[NSMutableArray alloc] init];
    }
    return _choiceArray;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        UIView *bgView = [[UIView alloc] init];
        [bgView shadow:Color(@"#656565") opacity:1 radius:5 offset:CGSizeMake(0, 4)];
        bgView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"发送邀请" forState:UIControlStateNormal];
        [btn setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:kHeaFont size:16];
        [btn addTarget:self action:@selector(sendInviClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView);
            make.centerY.mas_equalTo(bgView);
        }];
        _bottomView = bgView;
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

#pragma mark - lift cyc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)loadData{
    [MBProgressHUD showActivityMessageInWindow:@"获取通讯录信息中..."];
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    XWWeakSelf
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSArray *phoneNumbers = contact.phoneNumbers;
        CNPhoneNumber * phoneNumber = [[CNPhoneNumber alloc] init];
        for (CNLabeledValue *labelValue in phoneNumbers) {
            phoneNumber = labelValue.value;
        }
        
        ContactModel *model = [[ContactModel alloc] init];
        model.name = [NSString stringWithFormat:@"%@%@", familyName, givenName];
        model.phoneNumber = phoneNumber.stringValue;
        model.first = [NSString getLetter:model.name];
        [weakSelf.searchArray addObject:model];
    }];
    
    self.dataArray = [NSMutableArray sortObjectsAccordingToInitialWithArray:self.searchArray];
    
    [MBProgressHUD hideHUD];
    [self.tableView reloadData];
    
}

#pragma mark - UI
- (void)initUI{
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithImgName:@"icon_share_search" target:self method:@selector(rightBtnClick)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    self.title = @"短信分享";
}


#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *data = self.dataArray[section];
    return data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactTabCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactTabCellID forIndexPath:indexPath];
    cell.isMultiple = self.isMultiple;
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isMultiple) {
        ContactModel *model = self.dataArray[indexPath.section][indexPath.row];
        model.isChoice = !model.isChoice;
        if ([self.choiceArray containsObject:model]) {
            [self.choiceArray removeObject:model];
        }else{
            [self.choiceArray addObject:model];
        }
        [self.tableView reloadData];
    }else{
        ContactModel *model = self.dataArray[indexPath.section][indexPath.row];
        NSMutableArray *array = [@[model] mutableCopy];
        [UIAlertController alertControllerTwo:self withTitle:@"分享学问App" withMessage:[NSString stringWithFormat:@"分享给%@", model.name] withConfirm:@"确定" withCancel:@"取消" actionConfirm:^{
            [self showMessageView:array];
        } actionCancel:^{
            
        }];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 28)];
    bgView.backgroundColor = Color(@"#F4F4F4");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithName:kRegFont size:14];
    label.textColor = Color(@"#2A2732");
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(15);
        make.centerY.mas_equalTo(bgView);
    }];
    ContactModel *model = self.dataArray[section][0];
    label.text = model.first;
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ContactModel *model = self.dataArray[section][0];
    return model.first;
}

#pragma mark - Action
- (void)longPressAction:(UILongPressGestureRecognizer *)longGesture{
    self.isMultiple = YES;
    [self.tableView reloadData];
    [self reloadUI];
}

- (void)reloadUI{
    if (self.isMultiple) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bottomView.hidden = NO;
        self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kNaviBarH-44);
        [btn setImage:LoadImage(@"commentIcoClose") forState:UIControlStateNormal];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.isMultiple = NO;
            [self.tableView reloadData];
            [self reloadUI];
        }];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }else{
        self.bottomView.hidden = YES;
        self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kNaviBarH);
        self.navigationItem.leftBarButtonItem = [self.navigationController getBackBtnItemWithImgName:@"navBack"];
    }
    
}

- (void)rightBtnClick{
    XWContactSearchController *vc = [[XWContactSearchController alloc] init];
    vc.searchArray = self.searchArray;
    vc.invitationURL = self.invitationURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendInviClick{
    NSLog(@"choiceArray is %@", self.choiceArray);
    if (self.choiceArray.count == 0) {
        [MBProgressHUD showWarnMessage:@"请选择要分享的人"];
        return;
    }
    [self showMessageView:self.choiceArray];
}

- (void)showMessageView:(NSMutableArray *)phone {
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    [phone enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContactModel *model = (ContactModel *)obj;
        [phoneArray addObject:model.phoneNumber];
    }];
    
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    vc.body = [NSString stringWithFormat:@"千名权威专家让您工作更出色生活更精彩，注册送百元奖学金! 地址: %@", self.invitationURL];
    vc.recipients = phoneArray;
    vc.messageComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultSent) {
        [MBProgressHUD showInfoMessage:@"发送成功"];
        
    }else if (result == MessageComposeResultCancelled){
        [MBProgressHUD showWarnMessage:@"用户取消发送"];
        
    }else{
        NSLog(@"发送失败");
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
