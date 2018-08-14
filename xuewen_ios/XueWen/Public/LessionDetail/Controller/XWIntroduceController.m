//
//  XWIntroduceController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIntroduceController.h"
#import "XWIntroduceContentCell.h"
#import "XWIntroduceTitleCell.h"
#import "XWIntroduceBuyView.h"
#import "XWPlayerStatus.h"
#import "AliyunVodPlayerSDK.h"

static NSString *const XWIntroduceContentCellID = @"XWIntroduceContentCellID";
static NSString *const XWIntroduceTitleCellID = @"XWIntroduceTitleCellID";


@interface XWIntroduceController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) XWIntroduceBuyView *buyView;
/** 高度*/
@property (nonatomic, assign) CGFloat basicHeight;
/** 是否展开*/
@property (nonatomic, assign) BOOL isFull;

@end

@implementation XWIntroduceController

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
    
        _tableView = table;
    }
    return _tableView;
}

- (XWIntroduceBuyView *)buyView{
    if (!_buyView) {
        _buyView = [XWIntroduceBuyView buyViewWithTarget:self buyAction:@selector(buy) learnAction:@selector(learnAction:)];
    }
    return _buyView;
}

- (CGFloat)basicHeight{
    if (_basicHeight == 0) {
        if ([self.delegate respondsToSelector:@selector(getBasicHeight)]) {
            _basicHeight = [self.delegate getBasicHeight];
        }
    }
    return _basicHeight;
}


#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - Super Methods
- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buyView];
    [self.view bringSubviewToFront:self.buyView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-49);
    }];
    
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    [self addObserver];
}

#pragma mark - Setter
- (void)setModel:(XWCoursInfoModel *)model{
    _model = model;
    if ([_model.type isEqualToString:@"1"]) {
        self.buyView.price = @"0";
    }else{
        self.buyView.price = _model.course.amount;
    }
    
    if ([_model.course.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
        if ([XWAudioInstanceController shareInstance].player.playerState == AliyunVodPlayerStatePlay) {
            self.buyView.hidden = YES;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.view).offset(0);
            }];
        }else{
            self.buyView.hidden = NO;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.view).offset(-49);
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
                self.buyView.hidden = YES;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(self.view);
                    make.bottom.mas_equalTo(self.view).offset(0);
                }];
            }else{
                self.buyView.hidden = NO;
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(self.view);
                    make.bottom.mas_equalTo(self.view).offset(-49);
                }];
            }
        }
    }else{
        self.buyView.hidden = NO;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-49);
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
            [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
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
            self.buyView.hidden = YES;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.view).offset(0);
            }];
        }else{
            self.buyView.hidden = NO;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.view);
                make.bottom.mas_equalTo(self.view).offset(-49);
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.isFull) {
            return self.titleHeight + 80;
        }else{
            return self.titleHeight/2 + 80;
        }
    }
    return self.contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        XWIntroduceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWIntroduceContentCellID forIndexPath:indexPath];
        cell.model = self.model.course;
        return cell;
    }
    
    XWIntroduceTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:XWIntroduceTitleCellID forIndexPath:indexPath];
    cell.model = self.model.course;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (void)loadData{
    
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
