//
//  ExamResultViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "ExamResultViewController.h"
#import "QuestionsModel.h"
#import "ExamResultHeaderView.h"
#import "ExamViewController.h"
#import "ClassTestViewController.h"
//#import "XWCourseDetailViewController.h"
#import "XWExamResultCell.h"
#import "XWExamResultShareView.h"
#import "XWExamHistoryController.h"
#import "XWOldCollectionCell.h"
#import "WXApi.h"
#import "XWExamShareImgView.h"
#import "XWExamShareInfoModel.h"
#import "XWNCourseDetailViewController.h"
#import "XWCertificateModel.h"
#import "XWCerViewController.h"

static NSString *const XWExamResultCellID = @"XWExamResultCellID";
static NSString *const XWOldCollectionCellID = @"XWOldCollectionCellID";


@interface ExamResultViewController ()<ExamResultHeaderViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XWExamResultShareViewDelegate>

@property (nonatomic, weak) NSArray<QuestionsModel *> *questions;
@property (nonatomic, assign) NSInteger errorCount;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) UIImage *QRImage;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) XWExamShareInfoModel *model;
@property (nonatomic, strong) XWExamShareImgView *shareImgView;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isTest;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ExamResultViewController

#pragma mark - UICollectionViewDelegate / DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWExamResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWExamResultCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
//    XWOldCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWOldCollectionCellID forIndexPath:indexPath];
//    cell.countLabel.text = [NSString stringWithFormat:@"%ld题", self.errorCount];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ExamResultHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV" forIndexPath:indexPath];
    headView.delegate = self;
    headView.score = self.score;
    headView.comment = self.comment == nil?@"0":self.comment;
    headView.isTest = self.isTest;
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kWidth, 229+90+38);
//    return CGSizeMake(kWidth, 229);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    if (kWidth == 320) {
        height = 65;
    }else if (kWidth == 375){
        height = 50;
    }else{
        height = 40;
    }
    return CGSizeMake((kWidth-60)/2, (kWidth-60)/2*95/156 + height);
    
//    return CGSizeMake(kWidth, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    [self.navigationController pushViewController:[[ExamViewController alloc] initWithQuestions:self.questions errorOnly:YES] animated:YES];
    
    XWRecommendCourseModel *model = self.dataArray[indexPath.item];
    [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:model.courseID isAudio:NO] animated:YES];
}

#pragma mark - XWExamResultShareViewDelegate

- (void)didSelectShareItemAtIndex:(NSInteger)index{
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSData *imgData = [UIImage compressImage:self.shareImage toByte:32000];
    UIImage *image = [[UIImage alloc] initWithData:imgData];
    [message setThumbImage:image];
    WXImageObject *imgObj = [WXImageObject object];
    imgObj.imageData = UIImagePNGRepresentation(self.shareImage);
    message.mediaObject = imgObj;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.scene = index == 0 ? 0 : 1;
    req.message = message;
    req.bText = NO;
    [WXApi sendReq:req];
    
}

- (void)saveImageToPhotos:(UIImage *)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    [XWPopupWindow popupWindowsWithTitle:@"提示" message:(error != NULL) ? @"图片保存失败" : @"图片保存成功" buttonTitle:@"确定" buttonBlock:^{
        
    }];
}

#pragma mark- ExamResultHeaderViewDelegate
- (void)retestAction{
    [self clearRecord];
    [self.navigationController pushViewController:[[ClassTestViewController alloc] initWithQuestions:self.questions withTest:self.isTest withAtid:self.atid] animated:YES];
}

- (void)continueAction{
    [self pop];
}

- (void)errorAction{
    [self.navigationController pushViewController:[[ExamViewController alloc] initWithQuestions:self.questions errorOnly:YES] animated:YES];
}

- (void)hosAction{
    XWExamHistoryController *historyVC = [[XWExamHistoryController alloc] init];
    historyVC.courseId = self.courseId;
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)shareAction:(BOOL)isTest{
    if (isTest) {
        if (self.score < 60) return;

        [XWCertificateModel createcertificatetestId:self.atid withName:@"" success:^(XWCertificateModel *cmodel) {
            
            XWCerViewController * vc = [[UIStoryboard storyboardWithName:@"MyCertificate" bundle:nil] instantiateViewControllerWithIdentifier:@"XWCerView"];
            vc.model = cmodel;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSString *error) {
            NSLog(@"%@",error);
        }];
    }else {
        [self createShareImg];
        XWExamResultShareView *shareView = [[XWExamResultShareView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        shareView.delegate = self;
        [kMainWindow addSubview:shareView];
    }
}

#pragma mark - Custom Methods
// 清空答题记录
- (void)clearRecord{
    for (QuestionsModel *question in self.questions) {
        question.commited = NO;
        for (QuestionsOptionModel *option in question.options) {
            option.isSelected = NO;
        }
    }
}

// 计算分数
- (void)countScore{
    NSInteger score = 0;
    NSInteger rightCount = 0;
    NSString *courseID = @"";
    for (QuestionsModel *question in self.questions) {
        question.commited = YES;
        //考试ID
        courseID = question.testID;//self.isTest?self.atid:question.courseID;
        BOOL right = YES;
        for (QuestionsOptionModel *option in question.options) {
            if (option.isSelected != option.right) { // 选了但是该选项不正确或未选正确选项，这两种情况都是错误的
                right = NO;
                break;
            }
        }
        rightCount += right;
    }
    score = rightCount * 1.0 / self.questions.count * 100;
    
    NSInteger errorCount = self.questions.count - rightCount;
    self.score = score;
    self.errorCount = errorCount;
    [self.collectionView reloadData];
    [self saveScoreWithCourseID:courseID rightCount:rightCount errorCount:errorCount score:score];
}

// 上传分数
- (void)saveScoreWithCourseID:(NSString *)courseID rightCount:(NSInteger)rightCount errorCount:(NSInteger)errorCount score:(NSInteger)score{
    
    XWWeakSelf
    [XWNetworking saveTestResultWithCourseID:courseID rightCount:rightCount errorCount:errorCount score:score withTest:self.isTest questions:self.questions completionBlock:^(id result) {
        NSLog(@"%@",result);
        
        weakSelf.comment = result[@"data"][@"comment"];
        
        weakSelf.model.courseName = result[@"data"][@"course_name"];
        weakSelf.model.teacherName = result[@"data"][@"teacher_name"];
        [weakSelf.collectionView reloadData];
    }];
}




- (void)initUI{
    self.title = @"考试结果";
    self.view.backgroundColor = DefaultBgColor;
    [self.view addSubview:self.collectionView];
    UIButton *backButton = [UIButton buttonWithType:0];
    [backButton setImage:LoadImage(@"navBack") forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *rightButton = [UIButton buttonWithType:0];
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setTitleColor:Color(@"#333333") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton = rightButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if (self.isTest) {
        self.backButton.hidden = YES;
        self.rightButton.hidden = NO;
    }else {
        self.rightButton.hidden = YES;
        self.backButton.hidden = NO;
    }
    
//    for (NSString *fontFamilyName in [UIFont familyNames]) {
//        NSLog(@"----- %@ -----", fontFamilyName);
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
//            NSLog(@"   ---- %@", fontName);
//        }
//    }
}

- (void)loadData{
    XWWeakSelf
    [XWNetworking getInvitationURLWithcompletionBlock:^(NSString *url) {
        [XWInstance shareInstance].invitationURL = url;
        weakSelf.QRImage = [UIImage QRImageWithString:url];
    }];
    
    QuestionsModel *model = [self.questions firstObject];
    NSString * courseId = self.isTest ? model.testID : model.courseID;
    [XWHttpTool getRecommendCourseWith:courseId withTestId:self.atid withT:self.isTest success:^(NSMutableArray *array) {
        weakSelf.dataArray = array;
        [weakSelf.collectionView reloadData];
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
    
}

/** 生成需要分享出去的图片*/
- (void)createShareImg{
    
    self.shareImgView.score = self.score;
    self.shareImgView.QRImage = self.QRImage;
    self.shareImgView.model = self.model;
    UIImage *image = [[UIImage alloc] init];
    self.shareImage = [image screenshotForView:self.shareImgView];
}

- (void)backAction:(UIButton *)sender{
    [self pop];
}

- (XWNCourseDetailViewController *)pop{
    [self clearRecord];
    NSArray *controllers = self.navigationController.viewControllers;
    for ( id viewController in controllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"XWNCourseDetailViewController")]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return (XWNCourseDetailViewController *)viewController;
        }
    }
    return nil;
}

#pragma mark- Setter
- (void)setQuestions:(NSArray<QuestionsModel *> *)questions{
    _questions = questions;
}

#pragma mark- Getter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 横向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kWidth,kHeight-kNaviBarH-kBottomH) collectionViewLayout:flowLayout];
//        _collectionView.backgroundColor = Color(@"#F7F7F7");
        _collectionView.backgroundColor = DefaultBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XWExamResultCell" bundle:nil] forCellWithReuseIdentifier:XWExamResultCellID];
        [_collectionView registerClass:[ExamResultHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV"];
        [_collectionView registerNib:[UINib nibWithNibName:@"XWOldCollectionCell" bundle:nil] forCellWithReuseIdentifier:XWOldCollectionCellID];
    }
    return _collectionView;
}

- (XWExamShareInfoModel *)model{
    if (!_model) {
        _model = [[XWExamShareInfoModel alloc] init];
    }
    return _model;
}

- (XWExamShareImgView *)shareImgView{
    if (!_shareImgView) {
        _shareImgView = [[XWExamShareImgView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomH)];
    }
    return _shareImgView;
}

#pragma mark- LifeCycle
- (instancetype)initWithQuestions:(NSArray<QuestionsModel *> *)questions withTest:(BOOL)isTest withAtid:(NSString *)atid{
    if (self = [super init]) {
        self.questions = questions;
        QuestionsModel *model = [questions firstObject];
        self.courseId = model.courseID;
        self.isTest = isTest;
        self.atid = atid;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    [self countScore];
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
