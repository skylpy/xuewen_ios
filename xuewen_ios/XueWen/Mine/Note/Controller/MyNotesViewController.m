//
//  MyNotesViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MyNotesViewController.h"
#import "CourseNoteModel.h"
#import "MJRefresh.h"
#import "MyNotesCell.h"
#import "NoteDetailViewController.h"
#import "Common.h"
@interface MyNotesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CourseNoteModel *> *dataSource;

@end

@implementation MyNotesViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseNoteModel *model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:[[NoteDetailViewController alloc] initWithModel:model] animated:YES];
}
// iOS11之后的新方法，用于侧滑删除，没有这个方法的话tableview的cell侧滑删除效果在iOS11上与iOS11之前的表现不同
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    XWWeakSelf
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView,void (^ _Nonnull completionHandler)(BOOL)){
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        CourseNoteModel *model = self.dataSource[indexPath.row];
        [XWNetworking deleteNoteWithNoteID:model.noteID];
        //在这里实现删除操作
        [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        completionHandler(true);
        
    }];
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    actions.performsFirstActionWithFullSwipe = NO;
    return actions;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commitEditingStyle");
    CourseNoteModel *model = self.dataSource[indexPath.row];
    [XWNetworking deleteNoteWithNoteID:model.noteID];
    //在这里实现删除操作
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseNoteModel *model = self.dataSource[indexPath.row];
    CGFloat height = [model.content heightWithWidth:kWidth - 30 size:14];
    return (MIN(height, [UIFont systemFontOfSize:14].lineHeight * 3)) +  67.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.isFirst = (indexPath.row == 0);
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"我的笔记";
    self.view.backgroundColor = DefaultBgColor;
    self.scrollView = self.tableView;
    [self addHeaderWithAction:@selector(loadMyNotes)];
    [self addFooterWithAction:@selector(loadMyNotes)];
    [self beginLoadData];
}

- (void)loadMyNotes{
    WeakSelf;
    [XWNetworking getMyNotesListWithPage:self.page++ completeBlock:^(NSArray<CourseNoteModel *> *notes, BOOL isLast) {
        [weakSelf loadedDataWithArray:notes isLast:isLast];
    }];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Setter
#pragma mark- Getter
- (NSMutableArray<CourseNoteModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = self.array;
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeightNoNaviBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[MyNotesCell class] forCellReuseIdentifier:@"CellID"];
        _tableView.backgroundColor = DefaultBgColor;
    }
    return _tableView;
}

- (BOOL)hiddenNaviLine{
    return NO;
}
#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Analytics event:EventMyNotes label:nil];
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
