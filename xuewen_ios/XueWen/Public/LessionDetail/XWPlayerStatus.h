//
//  XWPlayerStatus.h
//  XueWen
//
//  Created by ShaJin on 2018/4/9.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#ifndef XWPlayerStatus_h
#define XWPlayerStatus_h

typedef NS_ENUM(NSInteger,PlayStatus){
    kStatusStop = 0, // 停止，等待播放
    kStatusLoading,  // 缓冲中
    kStatusPlay,     // 正在播放
    kStatusPause,    // 暂停
};
#endif /* XWPlayerStatus_h */
