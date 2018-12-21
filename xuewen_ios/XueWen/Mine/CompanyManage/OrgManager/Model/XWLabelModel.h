//
//  XWLabelModel.h
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWLabelModel : NSObject

/** 标签id*/
@property (nonatomic, strong) NSString *labelId;
/** 标签名*/
@property (nonatomic, strong) NSString *label_name;
/** 上级id*/
@property (nonatomic, strong) NSString *pid;
/** 是否选中*/
@property (nonatomic, assign) BOOL isSelect;


@end

NS_ASSUME_NONNULL_END
