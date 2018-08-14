//
//  MyClassesViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/16.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyClassesViewController.h"
#import "ClassesInfoCell.h"
#import "CourseModel.h"

@interface MyClassesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CourseModel *> *dataSource;
@property (nonatomic, assign) MyClassesViewType type;

@end

@implementation MyClassesViewController

#pragma mark- TableView&&Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseModel *model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassesInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassesId" forIndexPath:indexPath];
    CourseModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.showPrograss = YES;
    return cell;
}

#pragma mark- CustomMethod
- (void)searchAction:(UIButton *)sender{
    NSLog(@"push to searchViewController");
}

- (void)initUI{
    self.title = (self.type == kMyClasses) ? @"我的课程" : @"在学课程";
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = self.tableView;

    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [self addHeaderFooterAction:@selector(loadMyClass)];
    [self beginLoadData];
}

- (void)loadMyClass{
    WeakSelf;
    if (self.type == kLearningClasses) {
        [XWNetworking getMyLearningRecordWithPage:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
            [weakSelf loadedDataWithArray:array isLast:isLast];
        }];
    }else{
        [XWNetworking getCourseListWithMyClass:self.type == kMyClasses page:self.page++ CompletionBlock:^(NSArray *array, NSInteger totalCount, BOOL isLast) {
            [weakSelf loadedDataWithArray:array isLast:isLast];
        }];
    }
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:NSClassFromString(@"ClassesInfoCell") forCellReuseIdentifier:@"ClassesId"];
    }
    return _tableView;
}

- (NSMutableArray<CourseModel *> *)dataSource{
    return self.array;
}

#pragma mark- LifeCycle
- (instancetype)initWithType:(MyClassesViewType)type{
    if (self = [super init]) {
        self.type = type;
        NSString *label = nil;
        switch (type) {
            case 0:
                label = @"我的课程";
                break;
            case 1:{
                label = @"在学课程";
            }break;
            case 2:{
                label = @"企业课程";
            }break;
            default:
                break;
        }
        [Analytics event:EventMyCourse label:label];
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
