//
//  XWCommentViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/29.
//  Copyright © 2017年 ShaJin. All rights reserved.
//
// 课程详情的写笔记界面
#import "XWCommentViewController.h"
#import "SendNotesTypeView.h"
#import "IQKeyboardManager.h"
@interface XWCommentViewController ()<UITextViewDelegate>
{
    void (^completeBlock)(void);
    
}
@property (nonatomic, strong) NSString *courseID;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, assign) BOOL comment;
@property (nonatomic, copy) void (^SendBlock)(NSString *content,NSInteger status);
@property (nonatomic, strong) SendNotesTypeView *typeView;
@property (nonatomic, assign) CGRect typeFrame;

@end

@implementation XWCommentViewController
#pragma mark- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.placeholder.hidden = (textView.text.length > 0);
}

#pragma mark- Getter
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 7, kWidth - 30, 150)];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholder{
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, kWidth - 30, 15)];
        _placeholder.text = self.comment ? @"请输入评论内容" : @"请输入笔记内容";
        _placeholder.textColor = DefaultTitleDColor;
        _placeholder.font = [UIFont systemFontOfSize:15];
    }
    return _placeholder;
}

- (SendNotesTypeView *)typeView{
    if (!_typeView) {
        _typeView = [[SendNotesTypeView alloc] initWithFrame:CGRectMake(0, kHeight - 45 - kNaviBarH - kBottomH, kWidth, 45)];
        self.typeFrame = _typeView.frame;
    }
    return _typeView;
}
#pragma mark- Setter
#pragma mark- CustomMethod
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGRect endRect = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        if (!self.comment) {
            self.textView.frame = CGRectMake(12, 7, kWidth - 30, kHeight - kNaviBarH - 14 - endRect.size.height - 45);
            self.typeView.frame = CGRectMake(0, kHeight - endRect.size.height - 45 - ((IsIPhoneX) ? 88 : 64) , kWidth, 45);
        }
    }];
}

- (void)keyboardWillHidden:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        if (!self.comment) {
            self.typeView.frame = self.typeFrame;
        }
    }];
}

- (void)initUI{
    self.title = self.comment ? @"写评论" : @"写笔记";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:0];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:LoadImage(@"commentIcoClose") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *sendButton = [UIButton buttonWithType:0];
    sendButton.frame = CGRectMake(0, 0, 30, 15);
    [sendButton setTitle:@"发表" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.placeholder];
    
    if (!self.comment) {
        [self.view addSubview:self.typeView];
    }
}

- (void)backAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction:(UIButton *)sender{
    WeakSelf;
    if (self.comment) {
        
        [XWNetworking addCommentWithID:self.courseID content:self.textView.text CompletionBlock:^(BOOL succeed) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (succeed && completeBlock) {
                    completeBlock();
                }
            }];
        }];
    }else{
        if (self.SendBlock) {
            self.SendBlock(self.textView.text,self.typeView.index);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.view endEditing:YES];
}

#pragma mark- LifeCycle
- (instancetype)initWithCourseID:(NSString *)courseID sendBlock:(void(^)(void))sendBlock{
    if (self = [super init]) {
        self.courseID = courseID;
        completeBlock = sendBlock;
        self.comment = YES;
    }
    return self;
}

- (instancetype)initWithCourseID:(NSString *)courseID comment:(BOOL)comment sendBlock:(void (^)(NSString *content,NSInteger status))sendBlock{
    if (self = [super init]) {
        self.courseID = courseID;
        self.SendBlock = sendBlock;
        self.comment = comment;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNoticationWithShowAction:@selector(keyboardWillShow:) hiddenAciton:@selector(keyboardWillHidden:)];
    [IQKeyboardManager sharedManager].enable = NO; // 进入本页关闭键盘管理功能
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
    [IQKeyboardManager sharedManager].enable = YES; // 离开本页打开键盘管理功能
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
