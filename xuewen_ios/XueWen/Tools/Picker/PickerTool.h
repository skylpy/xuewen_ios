//
//  PickerTool.h
//  happyselling
//
//  Created by Pingzi on 2017/11/9.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZLocationManager.h"
#import "ReactiveObjC.h"
#import <ReactiveObjC/RACEXTScope.h>

@protocol PickerToolDelegate <NSObject>
@optional
/** 选择图片回调 **/
- (void)didPickedPhotos;
/** 拍照回调 **/
//-(void)didTookPhotoWithAsset:(id)asset image:(UIImage *)image;

/** 选择视频回调 **/
- (void)didPickedVedioWithCoverImage:(UIImage *)coverImage asset:(id)asset;

@end

@interface PickerTool : NSObject


// 每行展示资源个数  默认是3
@property (nonatomic, assign) NSInteger columnNum;

//设置是否可以选择视频/图片/原图
// 默认不选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;
// 默认选择图片
@property (nonatomic, assign) BOOL allowPickingImage;
// 默认支持原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
// 默认不选择Gif
@property (nonatomic, assign) BOOL allowPickingGif;


/** 照片选择控制器 **/
@property (nonatomic, strong) TZImagePickerController *imagePickerVcC;

/** 照片预览控制器 **/
@property (nonatomic, strong) TZImagePickerController *imagePreviewVC;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;



/** 选择的图片数组，和selectedPhotos内容一致 **/
@property (nonatomic, strong) NSArray *imagesArray;
/** 选择的资源 **/
@property (nonatomic, strong) NSMutableArray *selectedAssets;

/** 选择的视频数组 **/
//@property(nonatomic,strong)NSMutableArray *vedioArray;

@property (nonatomic, weak) id<PickerToolDelegate> delegate;

- (instancetype)initWithMaxCount:(NSInteger)maxCount selectedAssets:(NSMutableArray *)selectedAssets;
/*** 获取预览看破能感知器 ***/
- (TZImagePickerController *)getPreViewVCWithIndex:(NSInteger)index;
@end
