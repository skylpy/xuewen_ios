 //
//  NoteDetailViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "SendNotesTypeView.h"
#import "CourseNoteModel.h"
@interface NoteDetailViewController ()<UITextViewDelegate>
{
    void (^completeBlock)(void);
    
}
@property (nonatomic, strong) CourseNoteModel *model;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, copy) void (^SendBlock)(NSString *content,NSInteger status);
@property (nonatomic, strong) SendNotesTypeView *typeView;
@property (nonatomic, assign) CGRect typeFrame;
@end

@implementation NoteDetailViewController
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
        _textView.editable = NO;
    }
    return _textView;
}

- (UILabel *)placeholder{
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, kWidth - 30, 15)];
        _placeholder.text =  @"请输入笔记内容";
        _placeholder.textColor = DefaultTitleDColor;
        _placeholder.font = [UIFont systemFontOfSize:15];
    }
    return _placeholder;
}

- (SendNotesTypeView *)typeView{
    if (!_typeView) {
        _typeView = [[SendNotesTypeView alloc] initWithFrame:CGRectMake(0, kHeight - 45 - ((IsIPhoneX) ? 88 : 64), kWidth, 45)];
        self.typeFrame = _typeView.frame;
    }
    return _typeView;
}
#pragma mark- Setter
#pragma mark- CustomMethod
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)initUI{
    self.title = @"笔记详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:0];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:LoadImage(@"commentIcoClose") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *sendButton = [UIButton buttonWithType:0];
    sendButton.frame = CGRectMake(0, 0, 30, 15);
    [sendButton setTitle:@"确定" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    [self.view addSubview:self.textView];
    
    self.textView.text = self.model.content;
    
    [self.view addSubview:self.typeView];
    
    self.typeView.index = [self.model.status integerValue];
    
    self.typeView.userInteractionEnabled = NO;
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- LifeCycle
- (instancetype)initWithModel:(CourseNoteModel *)model{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
@end
