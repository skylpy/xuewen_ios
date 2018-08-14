//
//  SubProjectViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/1/24.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "SubProjectViewController.h"
#import "ProjectModel.h"
#import "ProjectBaseCell.h"
#import "PageTitleView.h"
#import "CourseModel.h"
#import "ProjectBuyView.h"
#import "BottomAlertView.h"
#import "ClassesInfoCell.h"

@interface SubProjectViewController ()<UITableViewDelegate,UITableViewDataSource,SGPageTitleViewDelegate>

@property (nonatomic, strong) NSString *labelID;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) ProjectBuyView *buyView;

@end

@implementation SubProjectViewController
- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex{
    self.currentIndex = selectedIndex;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        int index = 0;
        if (self.model.projects[_currentIndex].picture.length > 0) {
            index = 2;
        }else{
            index = 1;
        }
        if (indexPath.row >= index) {
            CourseModel *model = self.model.projects[_currentIndex].courses[indexPath.row - index];
            [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        NSMutableArray *titles = [NSMutableArray array];
        for (ProjectModel *project in _model.projects) {
            [titles addObject:project.projectName];
        }
        PageTitleView *titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45) delegate:self titleNames:titles];
        titleView.selectedIndex = _currentIndex;
        return titleView;;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 0 : 45;
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
        ProjectModel *model = self.model.projects[_currentIndex];
        if (model.picture.length > 0) {// 有图片的情况
            switch (indexPath.row) {
                case 0:{// 封面
                    height = (kWidth / 375.0 * 136.0);
                }break;
                case 1:{
                    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithData:[model.introduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    height = [attribute boundingRectWithSize:CGSizeMake(kWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 60;
                }break;
                default:{
                    height = 90;
                }break;
            }
        }else{// 没有图片
            if (indexPath.row == 0) {
                NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithData:[model.introduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                height = [attribute boundingRectWithSize:CGSizeMake(kWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 60;
            }else{
                height = 90;
            }
        }
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = 0;
    count = (self.model.projects.count > 0) ? 2 : 1;
    if (self.model.projects.count == 0) {
        return 1;
    }
    /** 每次刷新tableView都会执行这个方法，所以在这里刷新buyView的价格 */
    ProjectModel *model = _model.projects[_currentIndex];
    if (model) {
        _buyView.hidden = model.buy;
        _buyView.price = model.price;
        _buyView.originalPrice = model.originalPrice;
    }else{
        _buyView.hidden = YES;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (section == 0) {
        count = 2;
    }else{
        count = self.model.projects[_currentIndex].courses.count + (self.model.projects[_currentIndex].picture.length > 0 ? 2 : 1);
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
        if (self.model.projects[_currentIndex].picture.length > 0) {
            switch (indexPath.row) {
                case 0:{
                    identifier = @"ProjectCoverCell";
                    model = self.model.projects[_currentIndex];
                }break;
                case 1:{
                    identifier = @"ProjectIntroductionCellID";
                    model = self.model.projects[_currentIndex];
                }break;
                default:{
                    identifier = @"CourseCellID";
                    model = self.model.projects[_currentIndex].courses[indexPath.row - 2];
                }break;
            }
        }else{
            if (indexPath.row == 0) {
                identifier = @"ProjectIntroductionCellID";
                model = self.model.projects[_currentIndex];
            }else{
                identifier = @"CourseCellID";
                model = self.model.projects[_currentIndex].courses[indexPath.row - 1];
            }
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setValue:model forKey:@"model"];
    if ([identifier isEqualToString:@"CourseCellID"]) {
        ProjectModel *project = _model.projects[_currentIndex];
        ClassesInfoCell *aCell = (ClassesInfoCell *)cell;
        aCell.showPrograss = project.buy;
    }
    cell.selectionStyle = 0;
    return cell;
}

#pragma mark- CustomMethod
- (void)buyAction:(UIButton *)sender{
    /** 点击立即购买改成跳转到确认订单界面支付 2018.03.07 */
    WeakSelf;
    ProjectModel *model = self.model.projects[_currentIndex];
    UIViewController *vc = [ViewControllerManager orderInfoWithID:model.projectID type:1 updateBlock:^{
        [weakSelf loadProjectData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initUI{
    self.title = (_model.projectName.length > 0) ? _model.projectName : @"专题";
    self.scrollView = self.tableView;
    [self loadProjectData];
}

- (void)loadData{
    
}

- (void)loadProjectData{
    WeakSelf;
    [XWNetworking getThematicInfoWithID:self.labelID completeBlock:^(ProjectModel *model) {
        weakSelf.model = model;
    }];
}

#pragma mark- Setter
- (void)setModel:(ProjectModel *)model{
    _model = model;
    [self.tableView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex != currentIndex) {
        if (currentIndex < _model.projects.count) {
            _currentIndex = currentIndex;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            _currentIndex = 0;
        }
    }
}

#pragma mark- Getter
- (ProjectBuyView *)buyView{
    if (!_buyView) {
        _buyView = [[ProjectBuyView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 81) target:self action:@selector(buyAction:)];
        _buyView.hidden = YES;
    }
    return _buyView;
}

- (NSArray *)titles{
    NSMutableArray *titles = [NSMutableArray array];
    for (ProjectModel *project in _model.projects) {
        [titles addObject:project.projectName];
    }
    _titles = titles;
    return _titles;
}

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
        _tableView.tableFooterView = self.buyView;
    }
    return _tableView;
}

- (NSString *)labelID{
    return self.model.projectID;
}

#pragma mark- LifeCycle
- (instancetype)initWithModel:(ProjectModel *)model{
    if (self = [super init]) {
        self.model = model;
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
@end
