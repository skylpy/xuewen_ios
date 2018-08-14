//
//  MineEditViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/11/17.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "MineEditViewController.h"
#define kMaxLength 20
@interface MineEditViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    void (^CompleteBlock)(NSString *);
}
@property (nonatomic, assign) EditViewType type;
@property (nonatomic, strong) NSString *editText;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation MineEditViewController
#pragma mark- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
    [mStr replaceCharactersInRange:range withString:text];
    return (mStr.length <= kMaxLength);
}

- (void)textViewDidChange:(UITextView *)textView{
    self.placeHolder.hidden = (textView.text.length > 0);
    self.editText = textView.text;
    self.countLabel.text = [NSString stringWithFormat:@"%d",[self leftCount]];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"完成");
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self done];
    return YES;
}

- (void)textChanged:(UITextField *)textField{
    self.editText = textField.text;
}

#pragma mark- CustomMethod
- (void)done{
    [self.view endEditing:YES];
    if (CompleteBlock) {
        CompleteBlock(self.editText);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)initUI{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       COLOR(51, 51, 51), NSForegroundColorAttributeName,
                                       [UIFont fontWithName:kRegFont size:14], NSFontAttributeName,
                                       nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = DefaultBgColor;
    /** 设置昵称和个人简介统一改成原设置个人简介的样式并且限制最大字数为20个字符 2018.01.16 */
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.textView];
    [self.backgroundView addSubview:self.placeHolder];
    [self.backgroundView addSubview:self.countLabel];
    self.countLabel.text = [NSString stringWithFormat:@"%d",[self leftCount]];
    self.backgroundView.sd_layout.topSpaceToView(self.view,10).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(80);
    self.textView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 25 , 15));
    self.countLabel.sd_layout.rightSpaceToView(self.backgroundView,15).bottomSpaceToView(self.backgroundView,15).widthIs(40).heightIs(13);
    self.textView.text = self.editText;
    [self textViewDidChange:self.textView];
    switch (self.type) {
        case kEditName:{
            self.title = @"姓名";
        }break;
        case kEditNickName:{
            self.title = @"昵称";
        }break;
        case kEditSignature:{
            self.title = @"个人简介";
        }break;
        default:
            break;
    }
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kNaviBarH - kBottomH - 50;
}

#pragma mark- Getter
- (int)leftCount{
    return kMaxLength - (int)self.editText.length;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.delegate = self;
    }
    return _textView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = COLOR(51, 51, 51);
        _textField.placeholder = @"昵称";
        _textField.returnKeyType = UIReturnKeyDone;
        [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UILabel *)placeHolder{
    if (!_placeHolder) {
        NSString *text = @"写点什么";
        _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, [text widthWithSize:13], 13)];
        _placeHolder.textColor = COLOR(183, 183, 183);
        _placeHolder.font = [UIFont systemFontOfSize:13];
        _placeHolder.text = text;
    }
    return _placeHolder;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.textColor = COLOR(183, 183, 183);
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textAlignment = 2;
    }
    return _countLabel;
}

#pragma mark- LifeCycle
- (instancetype)initWithText:(NSString *)text viewType:(EditViewType)type complete:(void(^)(NSString *text))complete{
    if (self = [super init]) {
        CompleteBlock = complete;
        self.editText = (text.length > kMaxLength) ? [text substringToIndex:kMaxLength] : text;
        self.type = type;
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
