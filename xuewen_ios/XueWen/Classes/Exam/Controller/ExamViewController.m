//
//  ExamViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/11.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 旧的课程测试界面，现在只用于展示考试结果，有些逻辑看起来有些奇怪是因为之前此页面用于课程测试。
#import "ExamViewController.h"
#import "ExamTableView.h"
#import "QuestionsModel.h"
#import "ExamResultViewController.h"
@interface ExamViewController ()

@property (nonatomic, strong) ExamTableView *tableView;
@property (nonatomic, weak) NSArray<QuestionsModel *> *questions;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) QuestionsModel *currentQuestion;
@property (nonatomic, assign) BOOL errorOnly;

@end

@implementation ExamViewController
#pragma mark- CustomMethod
- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitAction:(UIButton *)sender{
    if (self.currentQuestion.commited) {
        if (![self setQuestion]) {
            if (self.errorOnly) {
                NSLog(@"返回");
            }else{
                // 跳转成绩结算
                [self.navigationController pushViewController:[[ExamResultViewController alloc] initWithQuestions:self.questions withTest:NO withAtid:@""] animated:YES];
            }
        }
    }else{
        [self.tableView commit];
    }
    if (self.currentQuestion.commited) {// 此处的currentQuestion与上边的可能不是同一个对象
        if ([self isLast]) {
            if (self.errorOnly) {
                sender.hidden = YES;
            }else{
                [sender setTitle:@"完成" forState:UIControlStateNormal];
            }
        }else{
            [sender setTitle:@"下一题" forState:UIControlStateNormal];
        }
    }else{
        [sender setTitle:@"提交" forState:UIControlStateNormal];
    }
}

- (BOOL)isLast{
    if (self.errorOnly) {
        BOOL right = YES;
        for (int i = (int)self.index; i < self.questions.count; i++) {
            QuestionsModel *question = self.questions[i];
            for (QuestionsOptionModel *option in question.options) {
                if (option.isSelected != option.right) { // 选了但是该选项不正确或未选正确选项，这两种情况都是错误的
                    right = NO;
                    break;
                    break;
                }
            }
        }
        NSLog(@"right = %d",right);
        return right;
    }else{
        return self.index >= self.questions.count ;
    }
}

- (void)initUI{
    self.title = @"考试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    if (!self.showAll) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.commitButton];
    }
    UIButton *backButton = [UIButton buttonWithType:0];
    [backButton setImage:LoadImage(@"navBack") forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.index = 0;
    [self setQuestion];
}

- (void)loadData{
    
}

- (BOOL)setQuestion{
    /** showAll == YES 的话就显示全部题目，我的-我的考试-查看考试详情时显示 */
    if (self.showAll) {
        self.tableView.questions = self.showAll ? self.questions : @[self.currentQuestion];
    }else{
        if (self.errorOnly) {
            for (int i = (int)self.index; i < self.questions.count; i++) {
                QuestionsModel *question = self.questions[i];
                BOOL right = YES;
                for (QuestionsOptionModel *option in question.options) {
                    if (option.isSelected != option.right) { // 选了但是该选项不正确或未选正确选项，这两种情况都是错误的
                        right = NO;
                        break;
                    }
                }
                if (!right) {
                    self.currentQuestion = question;
                    self.index = i + 1;
                    return YES;
                }
            }
        }else{
            if (self.index < self.questions.count) {
                self.currentQuestion = self.questions[self.index++];
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark- Setter
- (void)setCurrentQuestion:(QuestionsModel *)currentQuestion{
    _currentQuestion = currentQuestion;
    self.tableView.questions = @[currentQuestion];
}

#pragma mark- Getter
- (ExamTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ExamTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:0];
        _commitButton.frame = CGRectMake(0, 0, 60, 16);
        _commitButton.titleLabel.font = kFontSize(16);
        [_commitButton setTitle:self.errorOnly ? @"下一题" : @"提交" forState:UIControlStateNormal];
        [_commitButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

#pragma mark- LifeCycle
- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions errorOnly:(BOOL)errorOnly{
    if (self = [super init]) {
        self.questions = questions;
        self.errorOnly = errorOnly;
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
