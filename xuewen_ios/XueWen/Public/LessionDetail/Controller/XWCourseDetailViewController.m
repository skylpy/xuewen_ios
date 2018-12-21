//
//  XWCourseDetailViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCourseDetailViewController.h"
#import "XWIntroduceController.h"
#import "ClassTestViewController.h"
#import "SGPageView.h"
#import "XWCatalogView.h"
#import "XWVideoPlayView.h"
#import "XWAudioPlayView.h"
#import "XWCoursInfoModel.h"
#import "XWNotesController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "QuestionsModel.h"
#import "XWCatalogueView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AliyunVodPlayerSDK.h"
#import "XWPlayerStatus.h"
#import "XWShareView.h"
#import "XWShareViewController.h"
#import "WXApi.h"

@interface XWCourseDetailViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegare, LessionDetailDelegate, XWAudioPlayViewDelegate, XWVideoPlayViewDelegate, XWCatalogViewDelegate, AliyunVodPlayerDelegate, XWShareViewDelegate, UITableViewDelegate, UITableViewDataSource>

/** 课程ID*/
@property (nonatomic, strong) NSString *courseID;
/** 是否是从音频课程列表进入本页*/
@property (nonatomic, assign) BOOL isAudio;

/** 课程详情Model(数据源)*/
@property (nonatomic, strong) XWCoursInfoModel *model;

/** 分页控件 */
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

/** 介绍 */
@property (nonatomic, strong) XWIntroduceController *introduceViewController;
/** 笔记 */
@property (nonatomic, strong) XWNotesController *notesViewController;
/** 讨论 */
@property (nonatomic, strong) XWNotesController *commentsViewController;

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

@end

@implementation XWCourseDetailViewController

#pragma mark - Lazy / Getter

- (XWAudioPlayView *)audioPlayView{
    if (!_audioPlayView) {
        _audioPlayView = [[XWAudioPlayView alloc] initWithFrame:CGRectMake(0, kStasusBarH, kWidth, self.playerHeight)];
        _audioPlayView.delegate = self;
     }
    return _audioPlayView;
}

- (XWVideoPlayView *)videoPlayView{
    if (!_videoPlayView) {
        _videoPlayView = [[XWVideoPlayView alloc] initWithFrame:CGRectMake(0, kStasusBarH, kWidth, self.playerHeight)];
        _videoPlayView.delegate = self;
    }
    return _videoPlayView;
}

- (XWCatalogView *)catalogView{
    if (!_catalogView) {
        _catalogView = [[XWCatalogView alloc] initWithFrame:CGRectMake(0, self.playerHeight+kStasusBarH, kWidth, 55)];
        _catalogView.delegate = self;
    }
    return _catalogView;
}

- (NSMutableArray *)cataArray{
    if (!_cataArray) {
        _cataArray = [[NSMutableArray alloc] init];
    }
    return _cataArray;
}

- (SGPageTitleView *)pageTitleView{
    if (!_pageTitleView) {
        _pageTitleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, self.playerHeight+55+kStasusBarH, kWidth, 44) delegate:self titleNames:@[@"介绍",@"笔记",@"讨论"]];
        _pageTitleView.isNeedBounces = NO;
        _pageTitleView.indicatorLengthStyle = SGIndicatorLengthTypeEqual;
        _pageTitleView.titleColorStateNormal = Color(@"#a6a6a6");
        _pageTitleView.titleColorStateSelected = Color(@"#000000");
        _pageTitleView.indicatorColor = Color(@"#000000");
        _pageTitleView.indicatorHeight = 1.0;
        _pageTitleView.backgroundColor = Color(@"#F2F2F2");
    }
    return _pageTitleView;
}
- (SGPageContentView *)pageContentView{
    if (!_pageContentView) {
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, self.playerHeight+55+44+kStasusBarH, kWidth, kHeight-self.playerHeight-55-44-kBottomH-kStasusBarH) parentVC:self childVCs:@[self.introduceViewController,self.notesViewController,self.commentsViewController]];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (XWIntroduceController *)introduceViewController{
    if (!_introduceViewController) {
        _introduceViewController = [XWIntroduceController new];
        _introduceViewController.delegate = self;
    }
    return _introduceViewController;
}

- (XWNotesController *)notesViewController{
    if (!_notesViewController) {
        _notesViewController = [[XWNotesController alloc] initWithCoursId:self.courseID isNotes:YES ];
        _notesViewController.delegate = self;
    }
    return _notesViewController;
}
- (XWNotesController *)commentsViewController{
    if (!_commentsViewController) {
        _commentsViewController = [[XWNotesController alloc] initWithCoursId:self.courseID isNotes:NO];
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

#pragma mark - LifeCycle

- (instancetype)initWithCourseID:(NSString *)courseID isAudio:(BOOL)isAudio{
    if (self = [super init]) {
        self.courseID = courseID;
        self.isAudio = isAudio;
        [Analytics event:EventClassInfo label:courseID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO; // 进入本页关闭键盘管理功能
    [self addNotificationWithName:NotiExamAction selector:@selector(examAction:)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
        self.playerHeight = 235;
    }else{
        self.playerHeight = 211;
    }
    [self.view addSubview:self.catalogView];
    [self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
    [self.view bringSubviewToFront:self.pageTitleView];
    
    if (self.isAudio) {
        [self.view addSubview:self.audioPlayView];
    }else{
        [self.view addSubview:self.videoPlayView];
        self.originalFrame = self.videoPlayView.frame;
    }
    
    /** 观察者*/
    [self addObserver];
    
}

- (void)loadData{
    XWWeakSelf
    [XWHttpTool getCourseDetailWithCourseID:self.courseID success:^(XWCoursInfoModel *infoModel) {
        weakSelf.model = infoModel;
        
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

- (BOOL)hiddenNavigationBar{
    return YES;
}

#pragma mark - Custom Methods

- (void)addObserver{
    [self addNotificationWithName:UIDeviceOrientationDidChangeNotification selector:@selector(orientationDidChange:)];
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
    
    /** 下载试题*/
    [self loadQuestionList];
}

- (void)reloadAllSubViews{
    if (self.isAudio) {
        self.playerHeight = 235;
    }else{
        if ([self.model.audioType isEqualToString:@"2"]) {
            self.playerHeight = 235;
        }else{
            self.playerHeight = 211;
        }
        
    }
    
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
    
    self.catalogView.frame = CGRectMake(0, self.playerHeight+kStasusBarH, kWidth, 55);
    self.pageTitleView.frame = CGRectMake(0, self.playerHeight+55+kStasusBarH, kWidth, 44);
    self.pageContentView.frame = CGRectMake(0, self.playerHeight+55+44+kStasusBarH, kWidth, kHeight-self.playerHeight-55-44-kBottomH-kStasusBarH);
    self.pageContentView.collectionView.frame = self.pageContentView.bounds;
    [self.pageContentView.collectionView reloadData];
    self.audioPlayView.frame = CGRectMake(0, kStasusBarH, kWidth, self.playerHeight);
    self.videoPlayView.frame = CGRectMake(0, kStasusBarH, kWidth, self.playerHeight);
    
    [self.notesViewController reloadData];
    [self.commentsViewController reloadData];
    if (self.isAudio) { // 音频页进入
        [self.videoPlayView removeFromSuperview];
        [self.view addSubview:self.audioPlayView];
    }else{
        /** 如果不是重音频页进入,需判断是否为纯音频,为纯音频需切换界面*/
        if ([self.model.audioType isEqualToString:@"2"]) {
            [self.videoPlayView removeFromSuperview];
            [self.view addSubview:self.audioPlayView];
        }else{
            [self.audioPlayView removeFromSuperview];
            [self.view addSubview:self.videoPlayView];
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
        [self.navigationController pushViewController:[[ClassTestViewController alloc] initWithQuestions:self.questions withTest:NO withAtid:self.courseID] animated:YES];
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
            message.title = @"这是我在学问APP学过最好的课，送给你";
            message.description = [NSString stringWithFormat:@"一起来学%@老师讲%@", self.model.course.tchOrg, self.model.course.courseName];
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
        case 2: // 分享到朋友圈
        {
            WXWebpageObject *pageObj = [WXWebpageObject object];
            pageObj.webpageUrl = self.model.shareUrl;
            // 消息对象
            WXMediaMessage *message = [WXMediaMessage message];
            message.mediaObject = pageObj;
            message.title = @"这是我在学问APP学过最好的课，送给你";
            message.description = [NSString stringWithFormat:@"一起来学%@老师讲%@", self.model.course.tchOrg, self.model.course.courseName];
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
    }else{
        self.currentOrientation = UIInterfaceOrientationPortrait;
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
            make.top.mas_equalTo(weakSelf.playerHeight+55+kStasusBarH);
        }];
    }else{ // 关闭目录
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

#pragma mark- PageViewDelegate
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self clearEditing];
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self clearEditing];
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)clearEditing{
    // 跳转时取消页面的编辑状态
    [self.view endEditing:YES];
}

- (void)dealloc{
    NSLog(@"课程信息页面释放了");
    [self removeNotification];
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
