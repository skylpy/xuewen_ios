//
//  XWCollegeViewController.m
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollegeViewController.h"
#import "ProjectModel.h"
#import "ENestScrollPageView.h"
#import "XWCollegeEduView.h"


@interface XWCollegeViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@property(nonatomic,retain)ENestScrollPageView *pageView;

@property(nonatomic, strong) ENestParam * estParam;

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) XWCollegeEduModel *model;

@end

@implementation XWCollegeViewController

#pragma mark - Getter
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    }
    return _imgView;
}

- (ENestScrollPageView *)pageView{
    if (!_pageView) {
        _pageView = [[ENestScrollPageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kBottomH-kNaviBarH) headView:self.imgView subDataViews:self.vcArray setParam:self.estParam];
    }
    return _pageView;
}

- (XWCollegeEduModel *)model{
    if (!_model) {
        _model = [[XWCollegeEduModel alloc] init];
    }
    return _model;
}

/** 关联滚动属性 */
- (ENestParam *)estParam {
    
    if (!_estParam) {
        //设置一些参数等等。。。
        ENestParam *param = [[ENestParam alloc] init];
        param.scrollParam.segmentParam.type = EPageContentLeft;
        //从0开始
        param.scrollParam.segmentParam.startIndex = 0;
        //字体颜色等
        param.scrollParam.segmentParam.textColor = 0x333333;
        param.scrollParam.segmentParam.textSelectedColor = 0x3D9DFF;
        param.scrollParam.segmentParam.lineColor = Color(@"#3D9DFF");
        param.scrollParam.segmentParam.fontSize = 12;
        param.scrollParam.segmentParam.selectedfontSize = 14;
        param.scrollParam.segmentParam.bgColor = 0xffffff;
        param.scrollParam.segmentParam.topLineColor = 0xffffff;
        param.scrollParam.segmentParam.botLineColor = 0xffffff;
        //分栏高度
        param.scrollParam.headerHeight = 45;
        _estParam = param;
    }
    return _estParam;
}

/** 关联滚动页面 */
- (NSMutableArray *)vcArray {
    
    if (!_vcArray) {
        __block NSMutableArray * array = [NSMutableArray array];
        NSString * jtype = self.type == ZCJYTYPE ? @"1":@"2";
        [self.model.courseList enumerateObjectsUsingBlock:^(XWEduLabelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EScrollPageItemBaseView *v = [[XWCollegeEduView alloc] initWithPageTitle:obj.lable_name projectID:obj.lable_id withJobsType:jtype];
            [array addObject:v];
        }];
        _vcArray = array;
        
    }
    return _vcArray;
}


#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)initUI{
    XWWeakSelf
    NSString * jtype = self.type == ZCJYTYPE ? @"1":@"2";
    [XWCollegeEduModel getCollegeEduListWithJobsType:jtype Success:^(XWCollegeEduModel * model) {
        
        weakSelf.model = model;
        [weakSelf.imgView sd_setImageWithURL:[NSURL URLWithString:model.picture]];
        weakSelf.title = self.type == ZCJYTYPE ? @"职场精英":@"行业高手";
        [weakSelf drawUI];

    } failure:^(NSString * _Nonnull error) {
        [MBProgressHUD showTipMessageInWindow:error];
    }];

}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;
}

- (void)drawUI{
    [self.view addSubview:self.pageView];
}

@end
