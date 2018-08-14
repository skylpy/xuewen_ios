//
//  CompleteInfoViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/3/20.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 填完邀请码之后的补全资料界面
#import "CompleteInfoViewController.h"
#import "MineInfoCell.h"
#import "PickerTool.h"
#import "MineEditViewController.h"
#import "TMLAreaPickerView.h"
#import "TMLSinglePickerView.h"
#import "AreaModel.h"

@interface CompleteInfoViewController ()<UITableViewDelegate,UITableViewDataSource,PickerToolDelegate>

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) NSMutableDictionary *mDic;
@property (nonatomic, strong) PickerTool *pick;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) NSArray<ProvinceModel *> *provinceArray;

@end

@implementation CompleteInfoViewController
- (void)didPickedPhotos{
    //    图片就是self.pick.selectedPhotos.firstObject
    
    if (self.pick.selectedPhotos.count > 0) {
        self.headerImage = self.pick.selectedPhotos.firstObject;
        MineInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setHeaderImage:self.headerImage];
    }
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeakSelf;
    MineInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                // 设置头像
                self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
                self.pick.delegate = self;
                [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
            }break;
            case 1:{
                // 设置姓名
                [self.navigationController pushViewController:[[MineEditViewController alloc] initWithText:kUserInfo.name viewType:kEditName complete:^(NSString *text) {
                    if (![text isEqualToString:kUserInfo.name]) {
                        [weakSelf.mDic setObject:text forKey:@"name"];
                        [cell setContent:text];
                    }
                }] animated:YES];
            }break;
            case 2:{
                // 设置昵称
                [self.navigationController pushViewController:[[MineEditViewController alloc] initWithText:kUserInfo.nick_name viewType:kEditNickName complete:^(NSString *text) {
                    if (![text isEqualToString:kUserInfo.nick_name]) {
                        [weakSelf.mDic setObject:text forKey:@"nick_name"];
                        [cell setContent:text];
                    }
                }] animated:YES];
            }break;
            default:
                break;
        }
    }else{
        if (indexPath.row == 0){
            TMLSinglePickerView *pickerView = [[TMLSinglePickerView alloc] initPickerArray:[NSMutableArray arrayWithArray:@[@"男",@"女"]] defaultPick:kUserInfo.sex WithCompleteBlock:^(TMLPickerModel *model) {
                NSString *sex = [model.pickerStr isEqualToString:@"男"] ? @"1" : @"0" ;
                [cell setContent:model.pickerStr];
                [weakSelf.mDic setObject:sex forKey:@"sex"];
            }];
            [pickerView show];
        }else if (indexPath.row == 1){
            TMLAreaPickerView *pickerView = [[TMLAreaPickerView alloc] initAreaPickerWithDataSource:self.provinceArray];
            [pickerView show];
            pickerView.CompleteBlock = ^(NSDictionary *dict) {
                for (NSString *key in [dict allKeys]) {
                    [weakSelf.mDic setObject:dict[key] forKey:key];
                }
                NSString *address = dict[@"region_name"];
                if (address.length > 0) {
                    [cell setContent:dict[@"region_name"]];
                }
            };
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 10 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 0 && indexPath.row == 0) ? 80 : 53;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                [cell setTitle:@"头像" content:kUserInfo.picture type:0 canEdit:YES];
            }break;
            case 1:{
                [cell setTitle:@"姓名" content:kUserInfo.name type:3 canEdit:YES];
            }break;
            case 2:{
                [cell setTitle:@"昵称" content:kUserInfo.nick_name type:1 canEdit:YES];
            }break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                [cell setTitle:@"性别" content:kUserInfo.sex type:1 canEdit:YES];
            }break;
            case 1:{
                [cell setTitle:@"地区" content:kUserInfo.region_name type:1 canEdit:YES];
            }break;
            default:
                break;
        }
    }
    [cell setIsFirst:indexPath.row == 0 leftSpace:15 rightSpace:0];
    return cell;
}

#pragma mark- CustomMethod
- (void)popWithMessage:(NSString *)message{
    if ([message isEqualToString:Succeed]) {
        WeakSelf;
        [XWNetworking invitationAccessWithCode:self.code completionBlock:^(BOOL succeed) {
            if (succeed) {
                [XWNetworking getAccountInfoWithCompletionBlock:nil];
                [weakSelf popToViewController:@"SettingViewController"];
            }
        }];
    }else{
        [MBProgressHUD showErrorMessage:@"修改失败!"];
    }
}

- (void)completeAction:(UIButton *)sender{
    [self.view endEditing:YES];
    NSString *name = self.mDic[@"name"];
    if (name.length > 0) {
        WeakSelf;
        if (self.headerImage) {
            [XWNetworking setPersonalHeaderWithImage:self.headerImage completionBlock:^(NSString *status) {
                [XWNetworking setPersonalInfoWithParam:self.mDic completionBlock:^(NSString *status) {
                    [weakSelf popWithMessage:status];
                }];
            }];
        }else{
            [XWNetworking setPersonalInfoWithParam:self.mDic completionBlock:^(NSString *status) {
                [weakSelf popWithMessage:status];
            }];
        }
    }else{
        [XWPopupWindow popupWindowsWithTitle:@"错误" message:@"请输入姓名" buttonTitle:@"好的" buttonBlock:nil];
    }
}

- (void)initUI{
    self.title = @"完善个人信息";
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.completeButton];
    
    
    self.textLabel.sd_layout.topSpaceToView(self.view, 20).leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 0).heightIs(14);
    self.completeButton.sd_layout.topSpaceToView(self.tableView, 30).leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 15).heightIs(44);
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
#pragma mark- Getter
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel labelWithTextColor:DefaultTitleCColor size:13];
        _textLabel.text = @"请完善个人信息，方便管理员为您分配课程";
    }
    return _textLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView tableViewWithFrame:CGRectMake(0, 43, kWidth, 302) style:UITableViewStylePlain delegate:self dataSource:self registerClass:@{@"MineInfoCell":CellID}];
    }
    return _tableView;
}

- (UIButton *)completeButton{
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:0];
        _completeButton.backgroundColor = kThemeColor;
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_completeButton, 1);
    }
    return _completeButton;
}

- (NSMutableDictionary *)mDic{
    if (!_mDic) {
        _mDic = [NSMutableDictionary dictionary];
    }
    return _mDic;
}

- (NSArray<ProvinceModel *> *)provinceArray{
    if (!_provinceArray) {
        NSError *error = nil;
        NSString *jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"] encoding:4 error:&error];
        _provinceArray = [ProvinceModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithJsonString:jsonStr]];
    }
    return _provinceArray;
}

#pragma mark- LifeCycle
- (instancetype)initWithInvationCode:(NSString *)code{
    if (self = [super init]) {
        self.code = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
