//
//  XWEnterpriseInfoViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/10.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWEnterpriseInfoViewController.h"
#import "MineInfoCell.h"
#import "PickerTool.h"
#import "XWHttpBaseModel.h"
#import "XWBannerManagerViewController.h"

static NSString *const MineInfoCellID = @"MineInfoCellID";


@interface XWEnterpriseInfoViewController () <UITableViewDelegate, UITableViewDataSource, PickerToolDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PickerTool *pick;

@end

@implementation XWEnterpriseInfoViewController

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        [table registerClass:[MineInfoCell class] forCellReuseIdentifier:MineInfoCellID];
        _tableView = table;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawUI];
}

- (void)drawUI {
    self.title = @"企业信息";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:MineInfoCellID forIndexPath:indexPath];
    cell.isFirst = indexPath.row == 0;
    switch (indexPath.row) {
        case 0:
            {
                [cell setTitle:@"头像" content:kUserInfo.company.co_picture_all type:0 canEdit:YES];
            }
            break;
        case 1:
            {
                [cell setTitle:@"企业名称" content:kUserInfo.company.name type:1 canEdit:NO];
            }
            break;
        case 2:
            {
                [cell setTitle:@"轮播图管理" content:@"" type:1 canEdit:YES];
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
        self.pick.delegate = self;
        [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
        return;
    }

    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[XWBannerManagerViewController new] animated:YES];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos{
    
    if (self.pick.selectedPhotos.count > 0) {
        XWWeakSelf
        [[XWAliOSSManager sharedInstance] asyncUploadMultiImages:self.pick.selectedPhotos CompeleteBlock:^(NSArray *nameArray) {
            NSLog(@"nameArray is %@", nameArray);
            NSDictionary *dict = [nameArray firstObject];
            [weakSelf updateCompanyInfoWithLogoName:dict[@"Img"]];
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
    }
}

#pragma mark - Custom Methods
- (void)updateCompanyInfoWithLogoName:(NSString *)logoName {
    ParmDict
    [dict setValue:logoName forKey:@"co_picture"];
    [dict setValue:kUserInfo.company.name forKey:@"co_name"];
    XWWeakSelf
    [XWHttpBaseModel BPUT:kBASE_URL(CompanyInfo, kUserInfo.company_id) parameters:dict extra:0 success:^(XWHttpBaseModel *model) {
        [XWInstance shareInstance].userInfo.company.co_picture_all = model.data[@"co_picture_all"];
        
        [weakSelf.tableView reloadData];
        [self postNotificationWithName:@"UpdateCompanyInfo" object:nil];
    } failure:^(NSString *error) {
        NSLog(@"error is %@", error);
    }];
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
