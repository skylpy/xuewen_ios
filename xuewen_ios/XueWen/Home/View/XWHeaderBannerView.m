//
//  XWHeaderBannerView.m
//  XueWen
//
//  Created by Karron Su on 2018/4/25.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHeaderBannerView.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"
#import "ClassesSearchViewController.h"
#import "MainNavigationViewController.h"
#import "ViewControllerManager.h"


@interface XWHeaderBannerView () <SDCycleScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) SDCycleScrollView *banner;
@end

@implementation XWHeaderBannerView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.banner];
    }
    return self;
}

#pragma mark - Setter

- (void)setModelArray:(NSMutableArray *)modelArray{
    _modelArray = modelArray;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (BannerModel *banner in modelArray) {
        if (banner.picture && banner.link) {
            [array addObject:banner.picture];
        }
    }
    self.banner.imageURLStringsGroup = array;
}

#pragma mark- SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerModel *banner = self.modelArray[index];
    [Analytics event:EventClickBanner label:banner.imageID];
    NSString *url = banner.appurl;
    //@"xuewen://m.52xuewen.com/?action=course&open=model&id=504";
    //@"xuewen://m.52xuewen.com/?open=innerview&uri=https://a.eqxiu.com/s/cSk2xdQV";
    NSRange range = [url rangeOfString:@"xuewen://m.52xuewen.com/?"];
    NSString *subStr1 = [url substringFromIndex:range.length];
    
    NSArray *subStr2Arr = [subStr1 componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [subStr2Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *objStr = [NSString stringWithFormat:@"%@", obj];
        NSArray *subStr3Arr = [objStr componentsSeparatedByString:@"="];
        NSString *key = [subStr3Arr firstObject];
        NSString *value = [subStr3Arr lastObject];
        [dict setValue:value forKey:key];
    }];
    
    NSString *actionValue = [dict valueForKey:@"action"];
    if ([actionValue isEqualToString:@""] || actionValue == nil) { // 必定是用webView打开
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dict valueForKey:@"uri"]]];
    }else{
        if ([actionValue isEqualToString:@"course"]) {
            [self.navigationController pushViewController:[ViewControllerManager detailViewControllerWithCourseID:[dict valueForKey:@"id"] isAudio:NO] animated:YES];
        }
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{

}

#pragma mark- Getter
- (SDCycleScrollView *)banner{
    if (!_banner) {
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height)  delegate:self placeholderImage:LoadImage(@"")];
        _banner.autoScrollTimeInterval = 5.0f;
        _banner.showPageControl = YES;
        _banner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _banner.pageControlBottomOffset = 5;
        _banner.pageControlDotSize = CGSizeMake(2, 2);
        _banner.currentPageDotColor = Color(@"#ffffff");
        _banner.pageDotColor = ColorA(255, 255, 255, 0.2);
    }
    return _banner;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
