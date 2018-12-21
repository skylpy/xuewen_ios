//
//  XWCourseLibraryViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseLibraryViewController.h"
#import "MainNavigationViewController.h"
#import "XWCourseTableCell.h"
#import "XWSelectCoursesView.h"
#import "CourseModel.h"

static NSString *const XWCourseTableCellID = @"XWCourseTableCellID";
@interface XWCourseLibraryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
//全部选择
@property (weak, nonatomic) IBOutlet UIButton *allCourseBtn;
//顶部view
@property (weak, nonatomic) IBOutlet UIView *topView;
//页数
@property (nonatomic,assign) NSInteger page;
//标签
@property (nonatomic,copy) NSString * labelID;
//选择课程View
@property (nonatomic,strong) XWSelectCoursesView * selectCourseView;

@end

@implementation XWCourseLibraryViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self setNav];
    [self requestData];
   
}

//刷新
- (void)loadData {
    
    self.page = 1;
    [self requestData];
}

//加载更多
- (void)moreData {
    self.page ++;
    [self requestData];
}

/**
 *注释
 *请求数据
 */
- (void)requestData {
    
    [XWCourseManageModel courseLibraryPage:self.page Name:@"" Lid:self.labelID success:^(NSArray * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:list];
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)setNav {
    
    self.title = @"课程库";
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 18, 18);
    [rightBtn setImage:[UIImage imageNamed:@"searchico"] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    @weakify(self)
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        MainNavigationViewController *navi = [[MainNavigationViewController alloc] initWithRootViewController:[NSClassFromString(@"CourseSearchViewController") new]];
        [self presentViewController:navi animated:NO completion:nil];
    }];
    
    [self.allCourseBtn setImage:[UIImage imageNamed:@"topico"] forState:UIControlStateNormal];
    [self.allCourseBtn setImage:[UIImage imageNamed:@"downico"] forState:UIControlStateSelected];
    self.allCourseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.allCourseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.allCourseBtn.imageView.size.width, 0, self.allCourseBtn.imageView.size.width+3)];
    [self.allCourseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.allCourseBtn.titleLabel.bounds.size.width+3, 0, -self.allCourseBtn.titleLabel.bounds.size.width)];
    
    [[self.allCourseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        if (x.selected) {
            self.selectCourseView = [XWSelectCoursesView showCourseView:self.view withFrame:CGRectMake(0, 45, kWidth, kHeight-100) withCourseClick:^(NSString * _Nonnull labelID, NSString * _Nonnull labelName) {
                x.selected = !x.selected;
                self.page = 1;
                self.labelID = labelID;
                [self.allCourseBtn setTitle:labelName forState:UIControlStateNormal];
                [self.allCourseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.allCourseBtn.imageView.size.width, 0, self.allCourseBtn.imageView.size.width+3)];
                [self.allCourseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.allCourseBtn.titleLabel.bounds.size.width+3, 0, -self.allCourseBtn.titleLabel.bounds.size.width)];
                [self requestData];
            }];
            
        }else {
            [self.selectCourseView removeFromSuperview];
        }
       
        
    }];
}


- (void)drawUI {
    
    self.page = 1;
    self.labelID = @"";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.backgroundColor = Color(@"#F6F6F6");
    [self.tableView registerNib:[UINib nibWithNibName:@"XWCourseTableCell" bundle:nil] forCellReuseIdentifier:XWCourseTableCellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
}

#pragma mark tableView 代理事件

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 135;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWCourseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCourseTableCellID forIndexPath:indexPath];
    XWCourseManageModel * model = self.dataArray[indexPath.section];
    cell.libmodel = model;
    cell.hideBtn.hidden = NO;
    @weakify(self)
    [cell setFunctionClick:^{
        @strongify(self)
        NSLog(@"%@",model.coursename);
        
        [self purchase:model.Id];
    }];
    
    [cell setHideBtnClick:^(NSString * _Nonnull cid) {
        @strongify(self)
        if([model.type isEqualToString:@"0"]){
            [self addCollect:cid];
        }else {
            [self cancelCollect:cid];
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XWCourseManageModel * model = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.Id isAudio:NO] animated:YES];
}

/**
 *注释
 *添加订单
 */
- (void)purchase:(NSString *)courseId {
    
    [XWCourseManageModel addOrderCourseId:courseId success:^(NSDictionary * _Nonnull dic) {
        
        UIViewController * vc = [NSClassFromString(@"XWFirmOrderViewController") new];
        [vc setValue:dic forKey:@"dict"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

/**
 *注释
 *添加收藏
 */
- (void)addCollect:(NSString *)cid{
    
    [XWCourseManageModel addFavoriteCourseManageCourseId:cid success:^{
        [self requestData];
        [[NSNotificationCenter defaultCenter] postNotificationName:CollectionCourse object:nil];
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

/**
 *注释
 *取消收藏
 */
- (void)cancelCollect:(NSString *)cid{
    
    [XWNetworking deleteFavoriteCourseWithID:cid CompletionBlock:^(BOOL succeed) {
        
        if (succeed) {
            [self requestData];
            [[NSNotificationCenter defaultCenter] postNotificationName:CollectionCourse object:nil];
        }
        
    }];
}

@end
