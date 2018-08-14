//
//  XWShareViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/6/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWShareViewController.h"
#import "WXApi.h"
#import "XWShareCollectionViewCell.h"
#import "XWIntroduceContentCell.h"
#import "XWShareTitleCell.h"

static NSString *const XWShareCollectionViewCellID = @"XWShareCollectionViewCellID";
static NSString *const XWIntroduceContentCellID = @"XWIntroduceContentCellID";
static NSString *const XWShareTitleCellID = @"XWShareTitleCellID";

@interface XWShareViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XWShareViewController

#pragma mark - Getter / Lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 瀑布流
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10,kWidth,130) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Color(@"#F0F0F0");
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XWShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:XWShareCollectionViewCellID];
    }
    return _collectionView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-140-kNaviBarH, kWidth, 140)];
        _bgView.backgroundColor = Color(@"#F0F0F0");
    }
    return _bgView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-140-kNaviBarH) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0.0;
        table.estimatedSectionFooterHeight = 0.0;
        table.estimatedSectionHeaderHeight = 0.0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table registerClass:[XWIntroduceContentCell class] forCellReuseIdentifier:XWIntroduceContentCellID];
        [table registerNib:[UINib nibWithNibName:@"XWShareTitleCell" bundle:nil] forCellReuseIdentifier:XWShareTitleCellID];
        _tableView = table;
    }
    return _tableView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
    }
    return _webView;
}


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self drawUI];
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Custom Methods
- (void)drawUI{
    self.title = @"分享给朋友";
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
    
    [self.webView loadHTMLString:self.model.course.introduction baseURL:nil];
    
    [self.view addSubview:self.tableView];
}

- (void)addObserver{
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ShareIntroductionTitle" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        XWShareTitleCell *cell = [x object];
        if (self.titleHeight != cell.height + 96) {
            self.titleHeight = cell.height + 96;
            [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)didSelectCollectionItemWith:(NSInteger)index{
    
    UIImage *image = [[UIImage alloc] init];
    UIImage *newImage = [image screenshotForView:self.tableView];
    
    switch (index) {
        case 0: // 保存到本地的操作
        {
            [self saveImageToPhotos:newImage];
        }
            break;
        case 1: // 分享到微信
        {
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *imgObj = [WXImageObject object];
            imgObj.imageData = UIImagePNGRepresentation(newImage);
            message.mediaObject = imgObj;
            
            SendMessageToWXReq *req = [SendMessageToWXReq new];
            req.scene = index == 1 ? 0 : 1;
            req.message = message;
            req.bText = NO;
            [WXApi sendReq:req];
        }
            break;
        case 2: // 分享到朋友圈
        {
            WXMediaMessage *message = [WXMediaMessage message];
            WXImageObject *imgObj = [WXImageObject object];
            imgObj.imageData = UIImagePNGRepresentation(newImage);
            message.mediaObject = imgObj;
            
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

/** 保存图片 */
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

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showActivityMessageInWindow:@"正在加载..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js=[NSString stringWithFormat:js, kWidth, kWidth - 30];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.contentHeight = height + 50;
    [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    [MBProgressHUD hideHUD];
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
        return self.titleHeight;
    }
    return self.contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        XWIntroduceContentCell *cell = [tableView dequeueReusableCellWithIdentifier:XWIntroduceContentCellID forIndexPath:indexPath];
        cell.model = self.model.course;
        
        return cell;
    }
    
    XWShareTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:XWShareTitleCellID forIndexPath:indexPath];
    cell.model = self.model.course;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 145;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 145)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.course.coverPhotoAll] placeholderImage:DefaultImage];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-63-52, 5, 52, 52)];
    imgView.image = [UIImage QRImageWithString:self.model.shareUrl];
    [bgView addSubview:imgView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithName:kRegFont size:13];
    label.textColor = Color(@"#333333");
    label.text = @"长按二维码观看课程";
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView).offset(-28);
        make.top.mas_equalTo(imgView.mas_bottom).offset(3);
    }];
    return bgView;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self didSelectCollectionItemWith:indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth-20)/3, 130);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 判断有没有安装微信
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) ? 3 : 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XWShareCollectionViewCellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            [cell setIcon:@"icon_share_hb" title:@"保存本地"];
        }break;
        case 1:{
            [cell setIcon:@"icon_share_wx" title:@"微信"];
        }break;
        case 2:{
            [cell setIcon:@"icon_share_pyq" title:@"朋友圈"];
        }break;
            
        default:
            break;
    }
    return cell;
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
