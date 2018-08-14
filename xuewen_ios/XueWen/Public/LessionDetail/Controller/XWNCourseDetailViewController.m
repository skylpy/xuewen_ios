//
//  XWNCourseDetailViewController.m
//  XueWen
//
//  Created by aaron on 2018/7/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNCourseDetailViewController.h"
#import "ClassTestViewController.h"
#import "XWCatalogView.h"
#import "XWVideoPlayView.h"
#import "XWAudioPlayView.h"
#import "XWCoursInfoModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "QuestionsModel.h"
#import "XWCatalogueView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AliyunVodPlayerSDK.h"
#import "XWPlayerStatus.h"
#import "XWShareView.h"
#import "XWShareViewController.h"
#import "WXApi.h"
#import "XWIntroduceView.h"
#import "XWNotesView.h"
#import "XWIntroduceBuyView.h"
#import "XWNoteInputView.h"
#import "XWCommentViewController.h"
#import "MainNavigationViewController.h"

@interface XWNCourseDetailViewController ()<LessionDetailDelegate, XWAudioPlayViewDelegate, XWVideoPlayViewDelegate, XWCatalogViewDelegate, AliyunVodPlayerDelegate, XWShareViewDelegate, UITableViewDelegate, UITableViewDataSource>

/** 课程ID*/
@property (nonatomic, strong) NSString *courseID;
/** 是否是从音频课程列表进入本页*/
@property (nonatomic, assign) BOOL isAudio;

/** 课程详情Model(数据源)*/
@property (nonatomic, strong) XWCoursInfoModel *model;

/** 介绍 */
@property (nonatomic, strong) XWIntroduceView *introduceViewController;
/** 笔记 */
@property (nonatomic, strong) XWNotesView *notesViewController;
/** 讨论 */
@property (nonatomic, strong) XWNotesView *commentsViewController;

/** 播放器高度 */
@property (nonatomic, assign) CGFloat playerHeight;

/** 目录bar*/
@property (nonatomic, strong) XWCatalogView *catalogView;

/** 视频播放器*/
@property (nonatomic, strong) XWVideoPlayView *videoPlayView;
/** 放置视频图像的View*/
@property (nonatomic, strong) UIView *playView;
/** 音频播放器*/
@property (nonatomic, strong) XWAudioPlayView *audioPlayView;

/** 考题下载完成后是否跳转到考试页面 */
@property (nonatomic, assign) BOOL pushExamVC;
/** 试题 */
@property (nonatomic, strong) NSArray *questions;
/** 默认播放*/
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *cataArray;

/** 节点数据源*/
@property (nonatomic, strong) NSMutableArray *nodeArray;

/** 屏幕朝向*/
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;

/** 原始frame */
@property (nonatomic, assign) CGRect originalFrame;

@property (nonatomic, assign) BOOL hideStatus;

@property (nonatomic, assign) BOOL touchBtn;

//新增
@property(nonatomic, strong) ENestScrollPageView *pageView;
//头部
@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) NSMutableArray * vcArray;

@property(nonatomic, strong) ENestParam * estParam;

@property (nonatomic, strong) XWIntroduceBuyView *buyView;

/** 输入框*/
@property (nonatomic, strong) XWNoteInputView *noteInputView;
@property (nonatomic, strong) XWNoteInputView *keyInputView;

@property (nonatomic, strong) XWNoteInputView *commentInputView;

@property (nonatomic, assign) NSInteger indexSelect;

@end

@implementation XWNCourseDetailViewController

#pragma mark - Lazy / Getter

- (XWAudioPlayView *)audioPlayView{
    if (!_audioPlayView) {
        _audioPlayView = [[XWAudioPlayView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.playerHeight)];
        _audioPlayView.delegate = self;
    }
    return _audioPlayView;
}

- (XWVideoPlayView *)videoPlayView{
    if (!_videoPlayView) {
        _videoPlayView = [[XWVideoPlayView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.playerHeight)];
        _videoPlayView.delegate = self;
    }
    return _videoPlayView;
}

- (XWCatalogView *)catalogView{
    if (!_catalogView) {
        _catalogView = [[XWCatalogView alloc] initWithFrame:CGRectMake(0, self.playerHeight, kWidth, 55)];
        _catalogView.delegate = self;
    }
    return _catalogView;
}

- (XWIntroduceBuyView *)buyView{
    if (!_buyView) {
        _buyView = [XWIntroduceBuyView buyViewWithTarget:self buyAction:@selector(buy) learnAction:@selector(learnAction:)];
    }
    return _buyView;
}

- (XWNoteInputView *)noteInputView{
    if (!_noteInputView) {
        CGFloat height = [self getBasicHeight];
        _noteInputView = [[XWNoteInputView alloc] initWithFrame:CGRectMake(0, kHeight-150, kWidth, 50)];
        XWWeakSelf
        _noteInputView.TapAction = ^(BOOL isNotes){
            [weakSelf pushEditNoteViewController:isNotes];
        };
        _noteInputView.TapBecomeAction = ^(BOOL isNotes){
            [kMainWindow addSubview:weakSelf.keyInputView];
            [weakSelf.keyInputView.textView becomeFirstResponder];
        };
        _noteInputView.isNotes = YES;
    }
    return _noteInputView;
}

- (XWNoteInputView *)commentInputView{
    if (!_commentInputView) {
        CGFloat height = [self getBasicHeight];
        _commentInputView = [[XWNoteInputView alloc] initWithFrame:CGRectMake(0, kHeight-150, kWidth, 50)];
        XWWeakSelf
        _commentInputView.TapAction = ^(BOOL isNotes){
            [weakSelf pushEditNoteViewController:isNotes];
        };
        _commentInputView.TapBecomeAction = ^(BOOL isNotes){
            [kMainWindow addSubview:weakSelf.keyInputView];
            [weakSelf.keyInputView.textView becomeFirstResponder];
        };
        _commentInputView.isNotes = NO;
    }
    return _commentInputView;
}

- (XWNoteInputView *)keyInputView{
    if (!_keyInputView) {
        _keyInputView = [[XWNoteInputView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 50)];
        XWWeakSelf
        _keyInputView.SendText = ^(NSString *text){
            [weakSelf addCommonWithText:text];
        };
    }
    return _keyInputView;
}

/** 添加讨论*/
- (void)addCommonWithText:(NSString *)text{
    XWWeakSelf
    [XWNetworking addCommentWithID:self.courseID content:text CompletionBlock:^(BOOL succeed) {
        if (succeed) {
            [weakSelf loadData];
        }
    }];
}

/** 购买课程 */
- (void)buy{
    
    [self buyAction];
}


- (NSMutableArray *)cataArray{
    if (!_cataArray) {
        _cataArray = [[NSMutableArray alloc] init];
    }
    return _cataArray;
}

/** 课程介绍 */
- (XWIntroduceView *)introduceViewController{
    if (!_introduceViewController) {
        _introduceViewController = [XWIntroduceView new];
        _introduceViewController.delegate = self;
    }
    return _introduceViewController;
}

/** 课程笔记 */
- (XWNotesView *)notesViewController{
    if (!_notesViewController) {
        _notesViewController = [XWNotesView new];
        _notesViewController.delegate = self;
    }
    return _notesViewController;
}

/** 课程讨论 */
- (XWNotesView *)commentsViewController{
    if (!_commentsViewController) {
        _commentsViewController = [XWNotesView new];
        _commentsViewController.delegate = self;
    }
    return _commentsViewController;
}

- (NSMutableArray *)nodeArray{
    if (!_nodeArray) {
        _nodeArray = [[NSMutableArray alloc] init];
    }
    return _nodeArray;
}

/** 添加笔记*/
- (void)pushEditNoteViewController:(BOOL) isNotes{
    if(isNotes){
        if ([self.model.type isEqualToString:@"1"]){
            WeakSelf;
            [self presentViewController:[[MainNavigationViewController alloc] initWithRootViewController:[[XWCommentViewController alloc] initWithCourseID:self.courseID comment:NO sendBlock:^(NSString *content,NSInteger status) {
                                        [weakSelf addCourseNote:content status:status];
                                    }]] animated:YES completion:nil];
        }else{
            [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"您还未购买该课程，不能添加笔记呦！" buttonTitle:@"好的" buttonBlock:nil];
        }
    }
}


/** 发送笔记*/
- (void)addCourseNote:(NSString *)note status:(NSInteger)status{
    WeakSelf;
    NSString *type = @"";
    switch (status) {
        case 1:{
            type = @"企业笔记";
        }break;
        case 2:{
            type = @"个人笔记";
        }break;
        default:
            type = @"全部笔记";
            break;
    }
    
    [XWNetworking addCourseNoteWithCourseID:self.courseID courseName:@"" content:note status:[NSString stringWithFormat:@"%ld",(long)status] completeBlock:^{
        [weakSelf loadData];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self pageView];
    
    [self.view addSubview:self.buyView];
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(1);
        make.height.offset(50);
    }];
    
    self.noteInputView.hidden = YES;
    [self.view addSubview:self.noteInputView];
    [self.noteInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
    
    self.commentInputView.hidden = YES;
    [self.view addSubview:self.commentInputView];
    [self.commentInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
}

/** 头部视图 */
- (UIView *)headerView {
    
    if (_headerView == nil) {
        UIView *headView = [[UIView alloc] init];
        _headerView = headView;
    }
    return _headerView;
}

/** 关联滚动设置 */
- (ENestScrollPageView *)pageView{
    if (_pageView == nil) {
        
        self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.playerHeight+55);
        [self.headerView addSubview:self.catalogView];
        
        if (self.isAudio) {
            [self.headerView addSubview:self.audioPlayView];
        }else{
            [self.headerView addSubview:self.videoPlayView];
            self.originalFrame = self.videoPlayView.frame;
        }
        self.headerView.backgroundColor = [UIColor whiteColor];
        
        _pageView = [[ENestScrollPageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) headView:self.headerView subDataViews:self.vcArray setParam:self.estParam];
        [self.view addSubview:_pageView];
    }
    return _pageView;
}

/** 关联滚动属性 */
- (ENestParam *)estParam {
    
    if (!_estParam) {
        //设置一些参数等等。。。
        ENestParam *param = [[ENestParam alloc] init];
        //从0开始
        param.scrollParam.segmentParam.startIndex = 0;
        //字体颜色等
        param.scrollParam.segmentParam.textColor = 0xa6a6a6;
        param.scrollParam.segmentParam.textSelectedColor = 0x000000;
        param.scrollParam.segmentParam.lineColor = Color(@"#000000");
        param.scrollParam.segmentParam.lineWidth = 40;
        //分栏高度
        param.scrollParam.headerHeight = 45;
        _estParam = param;
    }
    return _estParam;
}

/** 关联滚动页面 */
- (NSMutableArray *)vcArray {
    
    if (!_vcArray) {
        EScrollPageItemBaseView *v1 = [[XWIntroduceView alloc] initWithPageTitle:@"介绍"];
        self.introduceViewController = (XWIntroduceView *)v1;

        EScrollPageItemBaseView *v2 = [[XWNotesView alloc] initWithPageTitle:@"笔记"];
        self.notesViewController = (XWNotesView *) v2;

        EScrollPageItemBaseView *v3 = [[XWNotesView alloc] initWithPageTitle:@"讨论"];
        self.commentsViewController = (XWNotesView *)v3;

        NSMutableArray * array = [NSMutableArray array];
        _vcArray = array;
        [array addObject:v1];
        [array addObject:v2];
        [array addObject:v3];
    }
    return _vcArray;
}

#pragma mark - LifeCycle

- (instancetype)initWithCourseID:(NSString *)courseID isAudio:(BOOL)isAudio{
    if (self = [super init]) {
        self.courseID = courseID;
        self.isAudio = isAudio;
        [Analytics event:EventClassInfo label:courseID];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO; // 进入本页关闭键盘管理功能
    [self addNotificationWithName:NotiExamAction selector:@selector(examAction:)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.keyInputView.textView resignFirstResponder];
    [IQKeyboardManager sharedManager].enable = YES; // 离开本页打开键盘管理功能
    /** 为了防止出现莫名其妙的bug,退出这个页面时,将屏幕朝向设置向上,并且移除监听屏幕方向的通知*/
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    [self removeNotificationWithName:UIDeviceOrientationDidChangeNotification];
    [self removeNotificationWithName:NotiExamAction];
}

#pragma mark - Super Methods

- (void)initUI{
    self.title = @"课程详情";
    if (self.isAudio) {
        self.playerHeight = 211;//235;
    }else{
        self.playerHeight = 211;
    }
    
    self.indexSelect = 0;
    /** 观察者*/
    [self addObserver];
    
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getCourseDetailWithCourseID:self.courseID success:^(XWCoursInfoModel *infoModel) {
        weakSelf.model = infoModel;
        if ([infoModel.type isEqualToString:@"1"]) {
            self.buyView.price = @"0";
        }else{
            self.buyView.price = infoModel.course.amount;
        }
        if (self.isAudio) {
            [weakSelf reloadData];
        }else{
            if ([infoModel.audioType isEqualToString:@"2"]) {
                [weakSelf reloadAllSubViews];
            }else{
                [weakSelf reloadData];
            }
        }
        
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showErrorMessage:errorInfo];
    }];
}

/** 隐藏导航栏 */
- (BOOL)hiddenNavigationBar{
    
    return YES;
}

#pragma mark - Custom Methods

- (void)addObserver{
    
    [self addNotificationWithName:UIDeviceOrientationDidChangeNotification selector:@selector(orientationDidChange:)];
    [self addKeyboardNoticationWithShowAction:@selector(keyboardWillShow:) hiddenAciton:@selector(keyboardWillHidden:)];
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UPDATETITLE" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        NSInteger idx = [x.object integerValue];
        XWAudioNodeModel *model1 = self.nodeArray[idx];
        self.title = model1.nodeTitle;
    }];
    
    //点击选择介绍 / 笔记 / 讨论
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SELECTEDINDEX" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        NSInteger idx = [x.userInfo[@"index"] integerValue];
        NSLog(@"====%ld",idx);
        self.indexSelect = idx;
        if (idx == 0) {
            self.buyView.hidden = NO;
            self.noteInputView.hidden = YES;
            self.commentInputView.hidden = YES;
        }else if(idx == 1){
            self.buyView.hidden = YES;
            self.commentInputView.hidden = YES;
            self.noteInputView.hidden = NO;
        }else if(idx == 2){
            self.buyView.hidden = YES;
            self.commentInputView.hidden = NO;
            self.noteInputView.hidden = YES;
        }
    }];
    
    //返回
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BACK" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGRect endRect = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    XWWeakSelf
    [UIView animateWithDuration:duration animations:^{
        weakSelf.keyInputView.frame = CGRectMake(0, kHeight-endRect.size.height-50, kWidth, 50);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    XWWeakSelf
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.keyInputView removeFromSuperview];
    }];
}

- (void)reloadData{
    /** 给播放器上部分赋值*/
    if (self.isAudio) {
        self.audioPlayView.infoModel = self.model;
        self.audioPlayView.model = self.model.course;
        self.audioPlayView.dataArray = self.model.nodeAudioArray;
    }else{
        if ([self.model.audioType isEqualToString:@"2"]) {
            self.audioPlayView.infoModel = self.model;
            self.audioPlayView.model = self.model.course;
            self.audioPlayView.dataArray = self.model.nodeAudioArray;
        }else{
            self.videoPlayView.infoModel = self.model;
            self.videoPlayView.model = self.model.course;
            self.videoPlayView.dataArray = self.model.courseAudioArray;
        }
    }
    
    /** 控制是否显示切换按钮*/
    if ([self.model.audioType isEqualToString:@"1"]) {
        self.videoPlayView.isHideAudioBtn = YES;
    }else if ([self.model.audioType isEqualToString:@"2"]){
        self.audioPlayView.isHideVideoBtn = YES;
    }else if ([self.model.audioType isEqualToString:@"3"]){
        self.videoPlayView.isHideAudioBtn = NO;
        self.audioPlayView.isHideVideoBtn = NO;
    }
    
    if (self.isAudio) {
        self.nodeArray = self.model.nodeAudioArray;
    }else{
        if ([self.model.audioType isEqualToString:@"2"]) {
            self.nodeArray = self.model.nodeAudioArray;
        }else{
            self.nodeArray = self.model.courseAudioArray;
        }
        
    }
    
    /** 正在播放中的音频...*/
    if ([self.model.course.courseId isEqualToString:[XWAudioInstanceController shareInstance].model.courseId]) {
        self.selectedIndex = [XWAudioInstanceController shareInstance].playIndex;
        XWAudioNodeModel *model = self.nodeArray[self.selectedIndex];
        self.title = model.nodeTitle;
    }else{
        XWAudioNodeModel *model = self.nodeArray[self.selectedIndex];
        self.title = model.nodeTitle;
    }
    
    /** 目录赋值*/
    self.catalogView.model = self.model.course;
    
    /** 介绍赋值*/
    self.introduceViewController.model = self.model;
    self.introduceViewController.isAudio = self.isAudio;
    /** 讨论和笔记*/
    self.notesViewController.type = self.model.type;
    [self.notesViewController initWithCoursId:self.courseID isNotes:YES];

    self.commentsViewController.type = self.model.type;
    [self.commentsViewController initWithCoursId:self.courseID isNotes:NO];
    /** 下载试题*/
    [self loadQuestionList];
}

- (void)reloadAllSubViews{
    
    self.playerHeight = 211;
    
    /** 是点击切换按钮的才需要做动画*/
    if (self.touchBtn) {
        /** 翻转动画效果*/
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView commitAnimations];
    }
    
    self.catalogView.frame = CGRectMake(0, self.playerHeight, kWidth, 55);
    self.audioPlayView.frame = CGRectMake(0, 0, kWidth, self.playerHeight);
    self.videoPlayView.frame = CGRectMake(0, 0, kWidth, self.playerHeight);
    
    self.headerView.frame = CGRectMake(0, 0, kWidth, self.playerHeight+55);
    [self.notesViewController reloadData];
    [self.commentsViewController reloadData];
    if (self.isAudio) { // 音频页进入
        [self.videoPlayView removeFromSuperview];
        [self.headerView addSubview:self.audioPlayView];
    }else{
        /** 如果不是重音频页进入,需判断是否为纯音频,为纯音频需切换界面*/
        if ([self.model.audioType isEqualToString:@"2"]) {
            [self.videoPlayView removeFromSuperview];
            [self.headerView addSubview:self.audioPlayView];
        }else{
            [self.audioPlayView removeFromSuperview];
            [self.headerView addSubview:self.videoPlayView];
            self.originalFrame = self.videoPlayView.frame;
        }
    }
    
    [self reloadData];
    [self.cataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XWCatalogueView *cataView = (XWCatalogueView *)obj;
        [cataView removeFromSuperview];
    }];
    [self.cataArray removeAllObjects];
}

/** 考试 */
- (void)examAction:(id)sender{
    // 有试题并且已经购买就可以考试 2018.01.18
    if ([self.model.type isEqualToString:@"1"] && self.questions) {
        [self pushExamViewController]; // 去考试
    }else if (![self.model.type isEqualToString:@"1"]){
        [XWPopupWindow popupWindowsWithTitle:@"提示" message:@"请先购买课程" buttonTitle:@"好的" buttonBlock:nil];
    }else if (!self.questions){
        self.pushExamVC = YES;
        [MBProgressHUD showTipMessageInWindow:@"下载试题中"];
    }else{
        [XWPopupWindow popupWindowsWithTitle:@"错误，无法考试！" message:[NSString stringWithFormat:(@"课程代码：%@\n试题代码%@\n"),self.courseID,self.model.course.testid] buttonTitle:@"好的" buttonBlock:nil];
    }
}

/** 下载考试列表 */
- (void)loadQuestionList{
    /** 试题ID为0时没有考题 */
    if ([self.model.course.testid isEqualToString:@"0"]) {
        return;
    }
    XWWeakSelf
    [XWNetworking getQuestionsListWithTestID:self.model.course.testid CompletionBlock:^(NSArray<QuestionsModel *> *questions) {
        weakSelf.questions = questions;
        if (weakSelf.pushExamVC) {
            [weakSelf pushExamViewController];
        }
        [weakSelf clearRecord];
    }];
}
// 清空答题记录
- (void)clearRecord{
    for (QuestionsModel *question in self.questions) {
        question.commited = NO;
        question.courseID = self.courseID;
        for (QuestionsOptionModel *option in question.options) {
            option.isSelected = NO;
        }
    }
}
/** 跳转考试界面 */
- (void)pushExamViewController{
    if (self.questions.count > 0) {
        [self.navigationController pushViewController:[[ClassTestViewController alloc] initWithQuestions:self.questions] animated:YES];
    }else{
        [XWPopupWindow popupWindowsWithTitle:@"错误" message:@"暂时没有对应的试题" buttonTitle:@"好的" buttonBlock:nil];
    }
    
}

/** 屏幕转向通知*/
- (void)orientationDidChange:(NSNotification *)noti{
    if (self.isAudio) {
        return;
    }
    UIInterfaceOrientation currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    if (currentOrientation == UIDeviceOrientationLandscapeRight || currentOrientation == UIDeviceOrientationLandscapeLeft) {
        self.videoPlayView.isFullScreen = YES;
        
    }else if (currentOrientation == UIDeviceOrientationPortrait || currentOrientation == UIDeviceOrientationPortraitUpsideDown){
        self.videoPlayView.isFullScreen = NO;
        
    }else{
        
    }
}

#pragma mark - XWAudioPlayViewDelegate
/** 切换视频按钮*/
- (void)videoBtnClick{
    self.touchBtn = YES;
    self.isAudio = NO;
    
    [self reloadAllSubViews];
}

/** 分享事件*/
- (void)shareBtnClick{
    XWShareView *shareView = [[XWShareView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    shareView.delegate = self;
    [kMainWindow addSubview:shareView];
}

#pragma mark - XWShareViewDelegate

- (void)didSelectShareItemAtIndex:(NSInteger)index{
    
    switch (index) {
        case 0:  // 生成海报
        {
            XWShareViewController *shareVC = [[XWShareViewController alloc] init];
            shareVC.model = self.model;
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
        case 1: // 分享到微信
        {
            WXWebpageObject *pageObj = [WXWebpageObject object];
            pageObj.webpageUrl = self.model.shareUrl;
            // 消息对象
            WXMediaMessage *message = [WXMediaMessage message];
            message.mediaObject = pageObj;
            message.title = self.model.shareTitle;
            message.description = self.model.shareContent;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.course.tchOrgPhotoAll]]];
            message.thumbData = [UIImage compressImage:image toByte:32000];
            
            //            XWAudioNodeModel *model = [self.nodeArray firstObject];
            
            //分享音频
            //            WXMusicObject *musicObj = [WXMusicObject object];
            //            NSLog(@"音频播放链接---> : %@", model.nodeUrl);
            //            musicObj.musicUrl = model.nodeUrl;
            //            musicObj.musicLowBandUrl = musicObj.musicUrl;
            //            musicObj.musicDataUrl = self.model.shareUrl;
            //            musicObj.musicLowBandDataUrl = musicObj.musicDataUrl;
            //            message.mediaObject = musicObj;
            
            // 请求对象
            SendMessageToWXReq *req = [SendMessageToWXReq new];
            req.scene = index == 1 ? 0 : 1;
            req.message = message;
            req.bText = NO;
            [WXApi sendReq:req];
        }
            break;
        case 2: // 分享到朋友圈
        {
            WXWebpageObject *pageObj = [WXWebpageObject object];
            pageObj.webpageUrl = self.model.shareUrl;
            // 消息对象
            WXMediaMessage *message = [WXMediaMessage message];
            message.mediaObject = pageObj;
            message.title = self.model.friendCircleTitle;
            message.description = self.model.shareContent;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.course.tchOrgPhotoAll]]];
            message.thumbData = [UIImage compressImage:image toByte:32000];
            // 请求对象
            SendMessageToWXReq *req = [SendMessageToWXReq new];
            req.scene = index == 1 ? 0 : 1;
            req.message = message;
            req.bText = NO;
            [WXApi sendReq:req];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - XWVideoPlayViewDelegate
/** 切换音频界面*/
- (void)audioBtnClick{
    self.touchBtn = YES;
    self.isAudio = YES;
    
    [self reloadAllSubViews];
}

/** 全屏*/
- (void)fullScreenAction:(BOOL)isFullScreen{
    UIInterfaceOrientation currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    if (isFullScreen) {
        if (currentOrientation == UIInterfaceOrientationLandscapeLeft) {
            self.currentOrientation = UIInterfaceOrientationLandscapeLeft;
        }else{
            self.currentOrientation = UIInterfaceOrientationLandscapeRight;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISSRCOLLVIEW" object:nil userInfo:@{@"IS":@"YES"}];
        self.buyView.hidden = YES;
        self.noteInputView.hidden = YES;
    }else{
        self.currentOrientation = UIInterfaceOrientationPortrait;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISSRCOLLVIEW" object:nil userInfo:@{@"IS":@"NO"}];
        if (self.indexSelect == 0) {
            self.buyView.hidden = NO;
            self.noteInputView.hidden = YES;
        }else {
            self.buyView.hidden = YES;
            self.noteInputView.hidden = NO;
        }
    }
    
    if (isFullScreen) {
        [self.cataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWCatalogueView *cataView = (XWCatalogueView *)obj;
            [cataView removeFromSuperview];
        }];
        [self.cataArray removeAllObjects];
    }
}

#pragma mark - LessionDetailDelegate
- (CGFloat)getBasicHeight{
    return self.playerHeight + 55;
}

/** 购买课程*/
- (void)buyAction{
    XWWeakSelf
    UIViewController *vc = [ViewControllerManager orderInfoWithID:self.courseID type:0 updateBlock:^{
        [weakSelf loadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    [Analytics event:EventPayCourse label:self.courseID];
}

/** 开始学习*/
- (void)learnAction:(UIButton *)sender{
    XWWeakSelf
    [self.nodeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /** 查找哪些是看完的,接着之前的播放进度开始播放*/
        XWAudioNodeModel *model = (XWAudioNodeModel *)obj;
        if ([model.play isEqualToString:@"0"]) {
            weakSelf.selectedIndex = idx;
            *stop = YES;
        }else{
            if ([model.finished isEqualToString:@"0"]) {
                weakSelf.selectedIndex = idx;
                *stop = YES;
            }
        }
        if ([weakSelf.model.type isEqualToString:@"0"]) {
            weakSelf.selectedIndex = 0;
        }
    }];
    if (self.isAudio) {
        self.audioPlayView.isManual = NO;
        [self.audioPlayView playIndex:self.selectedIndex];
    }else{
        [self.videoPlayView playIndex:self.selectedIndex];
    }
}


#pragma mark - XWCatalogViewDelegate
- (void)catalogBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 打开目录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISSRCOLLVIEW" object:nil userInfo:@{@"IS":@"YES"}];
        if (self.isAudio) {
            self.selectedIndex = [XWAudioInstanceController shareInstance].playIndex;
        }else{
            self.selectedIndex = self.videoPlayView.playIndex;
        }
        XWWeakSelf
        XWCatalogueView *cataView = [[XWCatalogueView alloc] initWithDataArray:self.nodeArray doBlock:^(NSInteger selectedIndex) {
            
            weakSelf.selectedIndex = selectedIndex;
            if (weakSelf.isAudio) {
                weakSelf.audioPlayView.isManual = NO;
                [weakSelf.audioPlayView playIndex:weakSelf.selectedIndex];
            }else{
                [weakSelf.videoPlayView playIndex:weakSelf.selectedIndex];
            }
        } playIndex:self.selectedIndex infoModel:self.model isAudio:self.isAudio];
        [weakSelf.view addSubview:cataView];
        [weakSelf.cataArray addObject:cataView];
        [cataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(weakSelf.view);
            make.top.mas_equalTo(weakSelf.playerHeight+55+kStasusBarH-20);
        }];
    }else{ // 关闭目录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISSRCOLLVIEW" object:nil userInfo:@{@"IS":@"NO"}];
        [self.cataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XWCatalogueView *cataView = (XWCatalogueView *)obj;
            [cataView removeFromSuperview];
        }];
        [self.cataArray removeAllObjects];
    }
}

#pragma mark - 设置屏幕方向

// 设置屏幕方向
- (void)setCurrentOrientation:(UIInterfaceOrientation)currentOrientation{
    if (_currentOrientation != currentOrientation && !self.isAudio) {
        [UIApplication sharedApplication].statusBarOrientation = currentOrientation;
        
        _currentOrientation = currentOrientation;
        
        CGFloat angle = 0;
        CGRect frame = CGRectZero;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            frame = self.originalFrame;
            self.hideStatus = NO;
            //            [self.navigationController setNavigationBarHidden:NO animated:YES];
            if (self.videoPlayView.isHideAudioBtn) {
                self.videoPlayView.audioBtn.hidden = YES;
            }else{
                self.videoPlayView.audioBtn.hidden = NO;
            }
            self.videoPlayView.shareBtn.hidden = NO;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        else{
            angle = (currentOrientation == UIInterfaceOrientationLandscapeLeft) ? -M_PI_2 : M_PI_2;
            frame = CGRectMake(0, 0, kHeight, kWidth);
            self.hideStatus = YES;
            //            [self.navigationController setNavigationBarHidden:YES animated:YES];
            self.videoPlayView.audioBtn.hidden = YES;
            self.videoPlayView.shareBtn.hidden = YES;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
        XWWeakSelf
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.videoPlayView.transform = CGAffineTransformMakeRotation(angle);
            weakSelf.videoPlayView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (BOOL)prefersStatusBarHidden{
    return self.hideStatus;
}

- (void)clearEditing{
    // 跳转时取消页面的编辑状态
    [self.view endEditing:YES];
}

- (void)dealloc{
    NSLog(@"课程信息页面释放了");
    [self postNotificationWithName:@"videoEND" object:nil];
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end


