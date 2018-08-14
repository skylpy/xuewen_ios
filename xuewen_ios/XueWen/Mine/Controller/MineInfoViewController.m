//
//  MineInfoViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineInfoCell.h"
#import "PickerTool.h"
#import "MineEditViewController.h"
#import "TMLAreaPickerView.h"
#import "TMLSinglePickerView.h"
#import "AreaModel.h"
@interface MineInfoViewController ()<UITableViewDelegate,UITableViewDataSource,PickerToolDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PickerTool *pick;
@property (nonatomic, strong) NSArray<ProvinceModel *> *provinceArray;

@end

@implementation MineInfoViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
            self.pick.delegate = self;
            [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
        }else if (indexPath.row == 2){
            [self.navigationController pushViewController:[[MineEditViewController alloc] initWithText:kUserInfo.nick_name viewType:kEditNickName complete:^(NSString *text) {
                if (![text isEqualToString:kUserInfo.nick_name]) {
                    [XWNetworking setPersonalInfoWithParam:@{@"nick_name":text} completionBlock:nil];
                }
            }] animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 1){
            TMLSinglePickerView *pickerView = [[TMLSinglePickerView alloc] initPickerArray:[NSMutableArray arrayWithArray:@[@"男",@"女"]] defaultPick:kUserInfo.sex WithCompleteBlock:^(TMLPickerModel *model) {
                if (![model.pickerStr isEqualToString:kUserInfo.sex]) {
                    NSString *sex = [model.pickerStr isEqualToString:@"男"] ? @"1" : @"0" ;
                    [XWNetworking setPersonalInfoWithParam:@{@"sex":sex} completionBlock:nil];
                }
            }];
            [pickerView show];
        }else if (indexPath.row == 2){
            TMLAreaPickerView *pickerView = [[TMLAreaPickerView alloc] initAreaPickerWithDataSource:self.provinceArray];
            [pickerView show];
        }
    }else if (indexPath.section == 2){
        [self.navigationController pushViewController:[[MineEditViewController alloc] initWithText:kUserInfo.introduction viewType:kEditSignature complete:^(NSString *text) {
            if (![text isEqualToString:kUserInfo.introduction]) {
                [XWNetworking setPersonalInfoWithParam:@{@"introduction":text} completionBlock:nil];
            }
        }] animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 54;
    if (indexPath.section == 0 && indexPath.row == 0) {
        height = 80;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    switch (section) {
        case 0:{
            count = 3;
        }break;
        case 1:{
            count = 3;
        }break;
        case 2:{
            count = 1;
        }break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.isFirst = indexPath.row == 0;
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    [cell setTitle:@"头像" content:kUserInfo.picture type:0 canEdit:YES];
                }break;
                case 1:{
                    [cell setTitle:@"用户名" content:kUserInfo.name type:1 canEdit:NO];
                }break;
                case 2:{
                    [cell setTitle:@"昵称" content:kUserInfo.nick_name type:1 canEdit:YES];
                }break;
                default:
                    break;
            }
        }break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    [cell setTitle:@"手机号" content:kUserInfo.phone type:1 canEdit:NO];
                }break;
                case 1:{
                    [cell setTitle:@"性别" content:kUserInfo.sex type:1 canEdit:YES];
                }break;
                case 2:{
                    [cell setTitle:@"地区" content:kUserInfo.region_name type:1 canEdit:YES];
                }break;
                default:
                    break;
            }
        }break;
        case 2:{
            [cell setTitle:@"个人简介" content:kUserInfo.introduction type:1 canEdit:YES];
        }break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos{
    
    if (self.pick.selectedPhotos.count > 0) {
        UIImage *image = self.pick.selectedPhotos.firstObject;
        [XWNetworking setPersonalHeaderWithImage:image completionBlock:^(NSString *status) {
            
        }];
    }
}

#pragma mark- CustomMethod
- (void)reloadData{
    [self.tableView reloadData];
}

- (void)initUI{
    self.title = @"个人信息";
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    NSError *error = nil;
    NSString *jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"] encoding:4 error:&error];
    self.provinceArray = [ProvinceModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithJsonString:jsonStr]];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[MineInfoCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.backgroundColor = DefaultBgColor;
    }
    return _tableView;
}

#pragma mark- LifeCycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotificationWithName:PersonalInformationUpdate selector:@selector(reloadData)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
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
