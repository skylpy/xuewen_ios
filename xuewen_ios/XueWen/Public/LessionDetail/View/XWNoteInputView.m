//
//  XWNoteInputView.m
//  XueWen
//
//  Created by Karron Su on 2018/5/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNoteInputView.h"

@interface XWNoteInputView () <UITextViewDelegate>

@end

@implementation XWNoteInputView

#pragma mark - Lazy / Getter

- (HSTextView *)textView{
    if (!_textView) {
        _textView = [[HSTextView alloc] init];
        _textView.font = [UIFont fontWithName:kRegFont size:14];
        _textView.textColor = DefaultTitleAColor;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.placeHolderColor = Color(@"#b7b7b7");
        _textView.backgroundColor = Color(@"#f6f6f6");
        [_textView rounded:3];
        
    }
    return _textView;
}


#pragma mark - Setter
- (void)setIsNotes:(BOOL)isNotes{
    _isNotes = isNotes;
    NSLog(@"%d",isNotes);
    _textView.placeHolder = isNotes ? @"请输入笔记内容" : @"请输入评论内容";
}



#pragma mark- CustomMethod
- (void)clear{
    self.textView.text = @"";
//    self.numberOfLines = 1;
}

- (void)drawUI{
    [self addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self).offset(-11);
        make.top.mas_equalTo(self).offset(7);
    }];
    
    [self.textView updateLayout];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_isNotes) {
        if (self.TapAction) {
            self.TapAction(_isNotes);
            return NO;
        }
    }else{
        if (self.TapBecomeAction) {
            self.TapBecomeAction(_isNotes);
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 拦截send按钮点击事件
    if ([text isEqualToString:@"\n"]){
        if (self.SendText) {
            self.SendText(textView.text);
        }
        [self clear];
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = (COLOR(204, 208, 225)).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -2.5f);
        self.layer.shadowOpacity = 0.2;
        self.layer.masksToBounds = NO;
        [self drawUI];
    }
    return self;
}



@end
