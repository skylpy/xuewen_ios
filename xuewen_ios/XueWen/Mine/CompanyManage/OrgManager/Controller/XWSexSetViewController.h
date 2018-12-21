//
//  XWSexSetViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChoiceSexBlock)(NSString *sex);

@interface XWSexSetViewController : XWBaseViewController

@property (nonatomic, copy) ChoiceSexBlock sexBlock;

@end

NS_ASSUME_NONNULL_END
