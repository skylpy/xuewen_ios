//
//  XWCollectionCourseViewController.m
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollectionCourseViewController.h"
#import "XWCourseTableCell.h"
#import "XWCourseCollectionCell.h"
#import "CAShapeLayer+XWLayer.h"
#import "XWNoneManageCell.h"

static NSString *const XWCourseTableCellID = @"XWCourseTableCellID";
static NSString *const XWCourseCollectionCellID = @"XWCourseCollectionCellID";
static NSString *const XWNoneManageCellID = @"XWNoneManageCellID";
@interface XWCollectionCourseViewController ()<UITableViewDataSource,UITableViewDelegate>
//购买按钮
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
//底部view
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//数组
@property (nonatomic,strong) NSMutableArray * dataArray;
//长按列表显示
@property (nonatomic,assign) BOOL isTable;
//底部view显示
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutY;
//页数
@property (nonatomic,assign) NSInteger page;

@end

@implementation XWCollectionCourseViewController

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawUI];
    [self requestData];
    [self addNoti];
}

- (void)addNoti {
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:CollectionCourse object:nil] throttle:1] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        [self loadData];
    }];
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

- (void)requestData {
    
    [XWCourseManageModel favoriteCourseManagePage:self.page success:^(NSArray * _Nonnull list) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.page == 1) {
            
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:list];
        if(self.dataArray.count == 0){
            
            self.tableView.scrollEnabled = NO;
        }else {
            
            self.tableView.scrollEnabled = YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

- (void)drawUI {
    
    self.page = 1;
    self.isTable = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.backgroundColor = Color(@"#F6F6F6");
    [self.tableView registerNib:[UINib nibWithNibName:@"XWCourseTableCell" bundle:nil] forCellReuseIdentifier:XWCourseTableCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWCourseCollectionCell" bundle:nil] forCellReuseIdentifier:XWCourseCollectionCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWNoneManageCell" bundle:nil] forCellReuseIdentifier:XWNoneManageCellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    
    [self.purchaseBtn.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 60, 30) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    self.purchaseBtn.backgroundColor = Color(@"#FD4743");
    [self.collectBtn.layer setMask:[CAShapeLayer shapeLayerRect:CGRectMake(0, 0, 70, 30) withCornerRadius:2 addStrokeColor:[UIColor clearColor] wlineWidth:1.0f]];
    self.collectBtn.layer.borderColor = Color(@"#999999").CGColor;
    self.collectBtn.layer.borderWidth = 1;
    
    @weakify(self)
    [[self.purchaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        NSString * courseId = @"";
        for (XWCourseManageModel * model in self.dataArray) {
            
            if (model.isSelect) {
                
                if ([courseId isEqualToString:@""]) {
                    courseId = model.Id;
                }else {
                    courseId = [NSString stringWithFormat:@"%@,%@",courseId,model.Id];
                }
            }
        }
        [self purchase:courseId];
        
    }];
    
    [[self.collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self cancelCollect];
    }];
    
    [[self.allSelectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        
        if (x.selected) {
            for (XWCourseManageModel * model in self.dataArray) {
                model.isSelect = YES;
            }
        }else {
            for (XWCourseManageModel * model in self.dataArray) {
                model.isSelect = NO;
            }
        }
        
        [self.tableView reloadData];
    }];
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

//添加收藏
- (void)addCollect{
    NSString * co_id = [self favoriteCourse];
    [XWNetworking addFavoriteCourseWithID:co_id CompletionBlock:^(BOOL succeed) {
        [self requestData];
    }];
}

//收藏数据处理
- (NSString *)favoriteCourse {
    NSString * co_id = @"";;
    for (XWCourseManageModel * model in self.dataArray) {
        if (model.isSelect) {
            if ([co_id isEqualToString:@""]) {
                co_id = model.Id;
            }else {
                co_id = [NSString stringWithFormat:@"%@,%@",co_id,model.Id];
            }
        }
    }
    return co_id;
}
//取消收藏
- (void)cancelCollect{
    NSString * co_id = [self favoriteCourse];
    
    [self cancel:co_id];
}

- (void)cancel:(NSString *)cid {
    [XWNetworking deleteFavoriteCourseWithID:cid CompletionBlock:^(BOOL succeed) {
        [self requestData];
    }];
}

#pragma mark tableView代理事件

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataArray.count > 0?135:kHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count > 0?self.dataArray.count:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count == 0) {
        XWNoneManageCell * cell = [tableView dequeueReusableCellWithIdentifier:XWNoneManageCellID forIndexPath:indexPath];
        cell.titleLabel.text = @"没收藏任何课程哦～";
        return cell;
        
    }
    if (self.isTable) {
        XWCourseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCourseTableCellID forIndexPath:indexPath];
        XWCourseManageModel * model = self.dataArray[indexPath.section];
        cell.cmodel = model;
        cell.hideBtn.hidden = NO;
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                        
                                                        initWithTarget:self action:@selector(handleLongPress:)];
        
        
        [cell addGestureRecognizer:longPressReger];
        @weakify(self)
        [cell setFunctionClick:^{
            @strongify(self)

            [self purchase:model.Id];
        }];
        
        [cell setHideBtnClick:^(NSString * _Nonnull cid) {
            @strongify(self)
            
            [self cancel:cid];
        }];
        
        return cell;
    }
    XWCourseCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:XWCourseCollectionCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    @weakify(self)
    [cell setPurchaseClick:^(NSString * _Nonnull courseId) {
        @strongify(self)
        [self purchase:courseId];
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) return;
    XWCourseManageModel * model = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.Id isAudio:NO] animated:YES];
}

/**
 *注释
 *长按事件
 */
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        
        self.isTable = NO;
        [self.tableView reloadData];
        
        [UIView animateWithDuration:1 animations:^{
            
            self.bottomViewLayoutY.constant = 0;
        }];
       
    }
    
}

@end
