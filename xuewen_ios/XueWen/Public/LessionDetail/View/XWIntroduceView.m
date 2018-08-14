//
//  XWIntroduceView.m
//  XueWen
//
//  Created by aaron on 2018/7/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIntroduceView.h"
#import "XWIntroduceContentCell.h"
#import "XWIntroduceTitleCell.h"
#import "XWPlayerStatus.h"
#import "AliyunVodPlayerSDK.h"
#import "XWTitleDateilCell.h"

/********************************************************/

static NSString *const XWIntroduceContentCellID = @"XWIntroduceContentCellID";
static NSString *const XWIntroduceTitleCellID = @"XWIntroduceTitleCellID";
static NSString *const XWTitleDateilCellID = @"XWTitleDateilCellID";

@interface XWIntroduceView()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat contentHeight;
/** 高度*/
@property (nonatomic, assign) CGFloat basicHeight;
/** 是否展开*/
@property (nonatomic, assign) BOOL isFull;

@end

@implementation XWIntroduceView

- (void)didAppeared{
    [self initUI];
}

#pragma mark - Lazy / Getter
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table registerClass:[XWIntroduceContentCell class] forCellReuseIdentifier:XWIntroduceContentCellID];
        [table registerClass:[XWIntroduceTitleCell class] forCellReuseIdentifier:XWIntroduceTitleCellID];
         [table registerClass:[XWTitleDateilCell class] forCellReuseIdentifier:XWTitleDateilCellID];
        _tableView = table;
    }
    return _tableView;
}

- (CGFloat)basicHeight{
    if (_basicHeight == 0) {
        if ([self.delegate respondsToSelector:@selector(getBasicHeight)]) {
            _basicHeight = [self.delegate getBasicHeight];
        }
    }
    return _basicHeight;
}



#pragma mark - Super Methods
- (void)initUI{
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-49);
    }];
    
    [self addObserver];
}

#pragma mark - Setter
- (void)setModel:(XWCoursInfoModel *)model{
    _model = model;

    
    if ([_model.course.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
        if ([XWAudioInstanceController shareInstance].player.playerState == AliyunVodPlayerStatePlay) {
 
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(0);
            }];
        }else{

            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(-49);
            }];
        }
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[self.model.course.tchOrgIntroduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSFontAttributeName : [UIFont fontWithName:kRegFont size:13]} documentAttributes:nil error:nil];
    CGSize textSize = [attrString boundingRectWithSize:CGSizeMake(kWidth-53, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    //    NSLog(@"height is %f, introduction is %@", textSize.height, self.model.course.tchOrgIntroduction);
    
    self.titleHeight = textSize.height;
    
    
    [self.tableView reloadData];
    
}

- (void)setIsAudio:(BOOL)isAudio{
    _isAudio = isAudio;
    if (_isAudio) {
        if ([_model.course.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
            if ([XWAudioInstanceController shareInstance].player.playerState == AliyunVodPlayerStatePlay) {

                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(self);
                    make.bottom.mas_equalTo(self).offset(0);
                }];
            }else{
   
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(self);
                    make.bottom.mas_equalTo(self).offset(-49);
                }];
            }
        }
    }else{

        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-49);
        }];
        
    }
}

#pragma mark - Custom Methods
- (void)addObserver{
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"IntroductionContent" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        XWIntroduceContentCell *cell = [x object];
        if (self.contentHeight != cell.height + 80) {
            self.contentHeight = cell.height + 80;
            [self.tableView reloadData];
//            [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SHOWALLINTRODCETION" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.isFull = YES;
        [self.tableView reloadData];
        //        [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HIDEALLINTRODCETION" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.isFull = NO;
        [self.tableView reloadData];
        //        [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HideLearnBtn" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        NSInteger status = [x.object integerValue];
        if (status == 2) {
     
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(0);
            }];
        }else{

            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(-49);
            }];
        }
    }];
}

/** 购买课程 */
- (void)buy{
    if ([self.delegate respondsToSelector:@selector(buyAction)] && self.delegate) {
        [self.delegate buyAction];
    }
}

/** 开始学习 */
- (void)learnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(learnAction:)]) {
        [self.delegate learnAction:sender];
    }
}

#pragma mark - UITableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

        return 85;
    }
    if (indexPath.section == 1) {
        if (self.isFull) {
            return self.titleHeight + 80;
        }else{
            return self.titleHeight/2 + 80;
        }
    }
    return self.contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        XWTitleDateilCell * cell = [tableView dequeueReusableCellWithIdentifier:XWTitleDateilCellID forIndexPath:indexPath];
        cell.model = self.model.course;
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        XWIntroduceTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:XWIntroduceTitleCellID forIndexPath:indexPath];
        cell.model = self.model.course;
        return cell;
        
    }
    
    XWIntroduceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWIntroduceContentCellID forIndexPath:indexPath];
    cell.model = self.model.course;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}


- (void)loadData{
    
}

@end
