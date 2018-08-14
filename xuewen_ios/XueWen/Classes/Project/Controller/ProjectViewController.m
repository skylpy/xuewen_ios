//
//  ProjectViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/1/22.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectBaseCell.h"
#import "ProjectModel.h"
#import "SubProjectViewController.h"
@interface ProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *projectID;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProjectModel *model;

@end

@implementation ProjectViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.model.projects.count > 0) {
            ProjectModel *model = self.model.projects[indexPath.row];
            SubProjectViewController *vc = [[SubProjectViewController alloc] initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{// 封面
                height = (kWidth / 375.0 * 136.0);
            }break;
            case 1:{
                NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithData:[self.model.introduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                height = [attribute boundingRectWithSize:CGSizeMake(kWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 60;
            }break;
            default:
                break;
        }
    }else{
        if (self.model.projects.count > 0) {
            height = (kWidth - 30) / 345.0 * 125.0 + 10;
        }else{
            height = 90;
        }
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = 1;
    if (self.model.projects.count > 0 || self.model.courses.count > 0) {
        count = 2;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (section == 0) {
        count = 2;
    }else{
        count = MAX(self.model.courses.count, self.model.projects.count);
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = CellID;
    id model = self.model;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                identifier = @"ProjectCoverCell";
            }break;
            case 1:{
                identifier = @"ProjectIntroductionCellID";
            }break;
            default:
                break;
        }
    }else{
        if (self.model.projects.count > 0) {
            identifier = @"ProjectCellID";
            model = self.model.projects[indexPath.row];
        }else{
            
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setValue:model forKey:@"model"];
    cell.selectionStyle = 0;
    return cell;
}

#pragma mark- CustomMethod
- (void)buyAction{
    
}

- (void)toLearnAction{
    
}

- (void)initUI{
    self.title = (self.model.projectName.length > 0) ? self.model.projectName : @"专题";
    self.scrollView = self.tableView;
    [self addHeaderWithAction:@selector(loadProjectData)];
    [self beginLoadData];
}

- (void)delayMethod{
    /** 这句话可能耗费太多性能放在initUI方法里边可能会导致切换页面时卡顿，所以进到界面后延迟0.1s执行，这样体验会好一些 */
//    self.scrollView = self.tableView;
}

- (void)loadProjectData{
    WeakSelf;
    [XWNetworking getThematicInfoWithID:self.projectID completeBlock:^(ProjectModel *model) {
        weakSelf.model = model;
        [weakSelf endedLoadData];
    }];
}

#pragma mark- Setter
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeightNoNaviBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID]; // 占位，防止崩溃
        [_tableView registerClass:NSClassFromString(@"ProjectCoverCell") forCellReuseIdentifier:@"ProjectCoverCell"];
        [_tableView registerClass:NSClassFromString(@"ClassesInfoCell") forCellReuseIdentifier:@"CourseCellID"];
        [_tableView registerClass:NSClassFromString(@"ProjectIntroductionCell") forCellReuseIdentifier:@"ProjectIntroductionCellID"];
        [_tableView registerClass:NSClassFromString(@"ProjectCell") forCellReuseIdentifier:@"ProjectCellID"];
    }
    return _tableView;
}

#pragma mark- LifeCycle
- (instancetype)initWithProjectID:(NSString *)projectID{
    if (self = [super init]) {
        self.projectID = projectID;
        [Analytics event:EventProjectInfo label:projectID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
