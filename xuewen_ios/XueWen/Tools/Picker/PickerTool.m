//
//  PickerTool.m
//  happyselling
//
//  Created by Pingzi on 2017/11/9.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "PickerTool.h"



@interface PickerTool ()<TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

// 最多选择资源个数
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@end

@implementation PickerTool


- (instancetype)initWithMaxCount:(NSInteger)maxCount selectedAssets:(NSMutableArray *)selectedAssets
{
    if (self = [super init])
    {
        self.maxCount = maxCount;
        self.selectedAssets = selectedAssets;
        self.columnNum = 3;
        self.allowPickingVideo = NO;
        self.allowPickingImage = YES;
        self.allowPickingOriginalPhoto = YES;
        self.allowPickingGif = NO;
    }
    return self;
}

- (TZImagePickerController *)getPreViewVCWithIndex:(NSInteger)index
{
    self.imagePreviewVC = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:index];
    self.imagePreviewVC.maxImagesCount = self.maxCount;
    self.imagePreviewVC.allowPickingOriginalPhoto = YES;
    self.imagePreviewVC.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    @weakify(self)
    [self.imagePreviewVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self)
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        if ([self.delegate respondsToSelector:@selector(didPickedPhotos)]) {
            [self.delegate didPickedPhotos];
        }
    }];
    return self.imagePreviewVC;
}


- (TZImagePickerController *)imagePickerVcC
{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:self.columnNum delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideo;
    imagePickerVc.allowPickingImage = self.allowPickingImage;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    imagePickerVc.allowPickingGif = self.allowPickingGif;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    imagePickerVc.alwaysEnableDoneBtn = YES;
    
    /*** 获取照片 ***/
    @weakify(self)
    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        @strongify(self)
//        self.imagesArray = photos;
//    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(didPickedVedioWithCoverImage:asset:)]) {
            [self.delegate didPickedVedioWithCoverImage:coverImage asset:asset];
        }
    }];
    _imagePickerVcC = imagePickerVc;
    return _imagePickerVcC;
}



#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imagesArray = photos;
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    if ([self.delegate respondsToSelector:@selector(didPickedPhotos)]) {
        [self.delegate didPickedPhotos];
    }
//    [_collectionView reloadData];
    
    
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}




@end
