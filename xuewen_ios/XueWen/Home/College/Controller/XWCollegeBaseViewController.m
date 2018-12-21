//
//  XWCollegeBaseViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/8/13.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWCollegeBaseViewController.h"
#import "ProjectModel.h"
#import "ENestScrollPageView.h"
#import "XWCollegeView.h"

@interface XWCollegeBaseViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@property(nonatomic,retain)ENestScrollPageView *pageView;

@property(nonatomic, strong) ENestParam * estParam;

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) ProjectModel *model;

@end

@implementation XWCollegeBaseViewController

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

- (ProjectModel *)model{
    if (!_model) {
        _model = [[ProjectModel alloc] init];
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
        [self.model.projects enumerateObjectsUsingBlock:^(ProjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EScrollPageItemBaseView *v = [[XWCollegeView alloc] initWithPageTitle:obj.projectName projectID:obj.projectID];
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
    [XWNetworking getThematicInfoWithID:self.labelID completeBlock:^(ProjectModel *model) {
        weakSelf.model = model;
        weakSelf.title = weakSelf.model.projectName;
        [weakSelf.imgView sd_setImageWithURL:[NSURL URLWithString:model.picture]];
        [weakSelf drawUI];
    }];
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;
}

- (void)drawUI{
    [self.view addSubview:self.pageView];
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
