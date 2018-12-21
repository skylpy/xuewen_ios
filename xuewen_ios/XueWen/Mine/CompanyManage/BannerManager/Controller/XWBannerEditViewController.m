//
//  XWBannerEditViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBannerEditViewController.h"
#import "PickerTool.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface XWBannerEditViewController () <PickerToolDelegate>

@property (nonatomic, strong) UITextField *urlField;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) PickerTool *pick;
@property (nonatomic, strong) UIImageView *bgIcon;
@property (nonatomic, strong) UIButton *resetBtn;

@end

@implementation XWBannerEditViewController

#pragma mark - Getter
- (UITextField *)urlField {
    if (!_urlField) {
        UITextField *field = [[UITextField alloc] init];
        field.borderStyle = UITextBorderStyleNone;
        field.placeholder = @"请添加URL地址";
        field.font = [UIFont fontWithName:kRegFont size:15];
        _urlField = field;
    }
    return _urlField;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn rounded:0 width:1 color:Color(@"#DDDDDD")];
        [_addBtn setImage:LoadImage(@"addico") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc] init];
    }
    return _bgIcon;
}

- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"重新上传" forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont fontWithName:kRegFont size:14];
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetBtn rounded:2];
        _resetBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_resetBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    
    [self.view addSubview:self.urlField];
    
    [self.urlField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.top.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.addBtn];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.top.mas_equalTo(self.view).offset(65);
        make.height.mas_equalTo(138);
    }];
    
    [self.view addSubview:self.bgIcon];
    [self.view addSubview:self.resetBtn];
    
    [self.bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.top.mas_equalTo(self.view).offset(65);
        make.height.mas_equalTo(138);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgIcon);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    
    if (self.type == ControllerTypeAdd) {
        self.title = @"添加";
        self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"上传" target:self method:@selector(rightBtnClick)];
        
        self.addBtn.hidden = NO;
        self.bgIcon.hidden = YES;
        self.resetBtn.hidden = YES;
    }else {
        self.title = @"编辑";
        self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"保存" target:self method:@selector(rightBtnClick)];
        self.addBtn.hidden = YES;
        self.bgIcon.hidden = NO;
        self.resetBtn.hidden = NO;
        
    }
    
    
    
    
}

- (void)loadData {
    if (self.type == ControllerTypeAdd) {
        
    }else {
        [self.bgIcon sd_setImageWithURL:[NSURL URLWithString:self.banner.picture]];
        self.urlField.text = self.banner.link;
    }
}

#pragma mark - Custom Methods
- (void)rightBtnClick {
    if (self.pick.selectedPhotos.count > 0) {
        XWWeakSelf
        [[XWAliOSSManager sharedInstance] asyncUploadMultiImages:self.pick.selectedPhotos CompeleteBlock:^(NSArray *nameArray) {
            NSDictionary *dict = [nameArray firstObject];
            NSString *imgName = dict[@"Img"];
            [weakSelf saveInfoWithImgName:imgName];
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
    }else {
        if (self.type == ControllerTypeAdd) {
            [MBProgressHUD showTipMessageInWindow:@"请选择一张图片"];
        }else {
            [self saveInfoWithImgName:self.banner.pictureUrl];
        }
    }
    
    
}

- (void)saveInfoWithImgName:(NSString *)imgName {
    if (self.type == ControllerTypeAdd) {
        XWWeakSelf
        [XWHttpTool addShufflingFigureWithPictureUrl:imgName pictureLink:self.urlField.text success:^{
            [MBProgressHUD showTipMessageInWindow:@"操作成功"];
            [self postNotificationWithName:@"ReloadBannerData" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            [MBProgressHUD showTipMessageInWindow:error];
        }];
    }else {
        XWWeakSelf
        NSString *link;
        if (self.urlField.text != nil && ![self.urlField.text isEqualToString:@""]) {
            link = self.urlField.text;
        }else{
            link = self.banner.link;
        }
        [XWHttpTool putShufflingFigureWithPictureUrl:imgName pictureLink:link pictureSort:self.banner.sort bannerId:self.banner.imageID success:^{
            [MBProgressHUD showTipMessageInWindow:@"操作成功"];
            [self postNotificationWithName:@"ReloadBannerData" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error) {
            [MBProgressHUD showTipMessageInWindow:error];
        }];
    }
}

- (void)addBtnClick {
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    TZImagePickerController *vc = self.pick.imagePickerVcC;
    vc.allowCrop = YES;
    vc.cropRect = CGRectMake(0, (kHeight-150)/2, 375, 150);
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos{
    if (self.pick.selectedPhotos.count > 0) {
        UIImage *image = [self.pick.selectedPhotos firstObject];
        if (self.type == ControllerTypeAdd) {
            self.addBtn.hidden = YES;
            self.bgIcon.hidden = NO;
            self.resetBtn.hidden = NO;
            self.bgIcon.image = image;
        }else {
            self.bgIcon.image = image;
        }
    }
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
