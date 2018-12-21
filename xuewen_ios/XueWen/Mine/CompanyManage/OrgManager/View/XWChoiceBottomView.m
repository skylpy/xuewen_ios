//
//  XWChoiceBottomView.m
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWChoiceBottomView.h"

@interface XWChoiceBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation XWChoiceBottomView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"XWChoiceBottomView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    [self.nextBtn rounded:2];
    [self addNotificationWithName:@"ChangeChoiceStatus" selector:@selector(changeChoiceBtn:)];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - Custom Methods
- (void)changeChoiceBtn:(NSNotification *)noti {
    
    self.choiceBtn.selected = [noti.object boolValue];
    if (self.choiceBtn.selected) {
        [self.choiceBtn setImage:LoadImage(@"Checklist2") forState:UIControlStateNormal];
    }else {
        [self.choiceBtn setImage:LoadImage(@"xuanzico") forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (IBAction)choiceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:LoadImage(@"Checklist2") forState:UIControlStateNormal];
    }else {
        [sender setImage:LoadImage(@"xuanzico") forState:UIControlStateNormal];
    }
    
    !self.choiceBlock ? : self.choiceBlock(sender.selected);
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    !self.nextBlock ? : self.nextBlock();
}

@end
