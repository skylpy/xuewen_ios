//
//  ClassTestViewController.m
//  XueWen
//
//  Created by ShaJin on 2018/1/8.
//  Copyright © 2018年 ShaJin. All rights reserved.
//
// 新的课程测试界面，用于替换ExamViewController
#import "ClassTestViewController.h"
#import "QuestionsModel.h"
#import "ClassTestCell.h"
#import "SwitchQuestionView.h"
#import "ExamResultViewController.h"
@interface ClassTestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray<QuestionsModel *> *questions;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) SwitchQuestionView *switchView;

@end

@implementation ClassTestViewController

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    /** 这个方法是cell在屏幕上消失时调用的，因为collectionView设置了pagingEnabled = YES 所以此时一定是展示完毕一道题（可能是原来那道）所以在这里调用刷新switchView上button的方法 */
    [self checkEnabled];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.width, kHeight - kNaviBarH - 49);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questions.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.model = self.questions[indexPath.row];
    return cell;
}

#pragma mark- CustomMethod
- (void)initUI{
    self.title = @"考试";
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightButton = [self setRightItemWithTitle:@"提交" action:@selector(commit)];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.switchView];
    
    self.switchView.sd_layout.bottomSpaceToView(self.view, (IsIPhoneX ? 34 : 0)).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(49);
    self.collectionView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).bottomSpaceToView(self.switchView,0).rightSpaceToView(self.view,0);
    
    [self.collectionView updateLayout];
    [self checkEnabled];
}

/** 提交 */
- (void)commit{
    /** 先判断是否有未选择的题目，如果有就提示先答完全部题目再提交 */
    BOOL canCommit = YES;
    for (QuestionsModel *question in self.questions) {
        /** 是否回答 */
        BOOL hasAnswered = NO;
        for (QuestionsOptionModel *option in question.options) {
            if (option.isSelected) {
                hasAnswered = YES;
                break;
            }
        }
        if (!hasAnswered) {
            canCommit = NO;
            break;
        }
    }
    if (canCommit) {
        // commit
        // 跳转成绩结算
        [self.navigationController pushViewController:[[ExamResultViewController alloc] initWithQuestions:self.questions] animated:YES];
    }else{
        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"抱歉！需要答完全部的题目\n才可以提交哦！" buttonTitle:@"继续答题" buttonBlock:nil];
    }
}

- (void)loadData{
    
}

- (BOOL)hiddenNaviLine{
    return NO;
}

- (void)checkEnabled{
    NSInteger index = self.currentIndex;
    self.switchView.hasLastQuestion = (index > 0);
    self.switchView.hasNextQuestion = (index < self.questions.count - 1);
}

- (void)lastQuestion{
    if (self.currentIndex > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)nextQuestion{
    if (self.currentIndex < self.questions.count - 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark- Setter
#pragma mark- Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.minimumLineSpacing = 0; // 垂直
        flowLayout.minimumInteritemSpacing = 0; // 水平
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0 , 0) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ClassTestCell class] forCellWithReuseIdentifier:CellID];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (NSInteger)currentIndex{
    // 将屏幕中心点转换成collectionView上的坐标点，根据坐标取当前indexPath
    CGPoint point = [self.view convertPoint:self.view.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    return indexPath.row;
}

- (SwitchQuestionView *)switchView{
    if (!_switchView) {
        _switchView = [[SwitchQuestionView alloc] initWithTarget:self lastQuestion:@selector(lastQuestion) nextQuestion:@selector(nextQuestion)];
    }
    return _switchView;
}

#pragma mark- LifeCycle
- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions{
    if (self = [super init]) {
        self.questions = questions;
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
