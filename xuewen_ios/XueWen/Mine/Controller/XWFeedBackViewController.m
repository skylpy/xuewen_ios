//
//  XWFeedBackViewController.m
//  XueWen
//
//  Created by Karron Su on 2018/8/7.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWFeedBackViewController.h"
#import "PickerTool.h"

@interface XWFeedBackViewController () <PickerToolDelegate, UITextViewDelegate>

@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic, strong) HSTextView *textView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UILabel *imgCountLabel;
@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) PickerTool *pick;

@property (nonatomic, strong) UIImage *img;


@end

@implementation XWFeedBackViewController

#pragma mark - Getter
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 285)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (HSTextView *)textView{
    if (!_textView) {
        _textView = [[HSTextView alloc] init];
        _textView.placeHolder = @"请说明建议，我们将为您不断改进~~";
        _textView.placeHolderColor = Color(@"#CCCCCC");
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.text = @"0/200";
        _countLabel.textColor = Color(@"#CCCCCC");
        _countLabel.font = [UIFont fontWithName:kRegFont size:12];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [[NSMutableArray alloc] init];
        
        [_imgArray addObject:self.img];
    }
    return _imgArray;
}

- (UIImage *)img{
    if (!_img) {
        _img = LoadImage(@"icon_add");
    }
    return _img;
}

- (UILabel *)imgCountLabel{
    if (!_imgCountLabel) {
        _imgCountLabel = [[UILabel alloc] init];
        _imgCountLabel.text = @"0/4";
        _imgCountLabel.textColor = Color(@"#CCCCCC");
        _imgCountLabel.font = [UIFont fontWithName:kRegFont size:12];
        _imgCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _imgCountLabel;
}

- (UITextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        NSString *text = @"请输入手机号方便联系";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRegFont size:13] range:NSMakeRange(0, text.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:Color(@"#CCCCCC") range:NSMakeRange(0, text.length)];
        _phoneField.attributedPlaceholder = attr;
        _phoneField.borderStyle = UITextBorderStyleNone;
    }
    return _phoneField;
}

- (NSMutableArray *)viewArray{
    if (!_viewArray) {
        _viewArray = [[NSMutableArray alloc] init];
    }
    return _viewArray;
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}


#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.title = @"用户反馈";
    self.view.backgroundColor = Color(@"#f6f6f6");
    
    self.navigationItem.rightBarButtonItem = [self.navigationController getRightBtnItemWithTitle:@"提交" target:self method:@selector(rightBtnClick)];
    
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.countLabel];
    [self.bgView addSubview:self.phoneField];
    [self.bgView addSubview:self.imgCountLabel];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(17);
        make.left.mas_equalTo(self.bgView).offset(25);
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.height.mas_equalTo(100);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.right.mas_equalTo(self.bgView).offset(-25);
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(25);
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.bottom.mas_equalTo(self.bgView);
        make.height.mas_equalTo(35);
    }];
    
    [self.imgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(-25);
        make.bottom.mas_equalTo(self.phoneField.mas_top);
    }];
    
    [self reloadUI];
    
}

- (CGFloat)audioPlayerViewHieght{
    return kHeight - kBottomH - 49 - kNaviBarH;;
}

- (void)reloadUI{
    
    [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = (UIImageView *)obj;
        [imgView removeFromSuperview];
    }];
    
    [self.viewArray removeAllObjects];
    
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        [btn removeFromSuperview];
    }];
    
    [self.btnArray removeAllObjects];
    
    XWWeakSelf
    [self.imgArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *img = (UIImage *)obj;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        [imgView rounded:3];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [weakSelf.bgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.bgView).offset(25 + ((kWidth-125)/4 + 25)*idx);
            make.size.mas_equalTo(CGSizeMake((kWidth-125)/4, (kWidth-125)/4));
            make.bottom.mas_equalTo(self.bgView).offset(-60);
        }];
        
        [weakSelf.viewArray addObject:imgView];
        if (img != self.img) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:LoadImage(@"icon_delete") forState:UIControlStateNormal];
            btn.tag = idx + 1000;
            [btn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.bgView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(imgView.mas_right).offset(-9);
                make.size.mas_equalTo(CGSizeMake(17, 17));
                make.top.mas_equalTo(imgView.mas_top).offset(-8);
            }];
            
            
            [weakSelf.btnArray addObject:btn];
        }else{
            [imgView addTapTarget:self action:@selector(addClick)];
        }
        
    }];
    
    self.imgCountLabel.text = [NSString stringWithFormat:@"%ld/4", self.imgArray.count-1];
}



#pragma mark - Methods
- (void)rightBtnClick{
    NSLog(@"点击了提交");
    if ([self.imgArray containsObject:self.img]) {
        [self.imgArray removeObject:self.img];
    }
    
    if (self.imgArray.count == 0) {
        [self commitInfoWithImgUrl:@""];
        return;
    }
    XWWeakSelf
    [[XWAliOSSManager sharedInstance] asyncUploadMultiImages:self.imgArray CompeleteBlock:^(NSArray *nameArray) {
        NSLog(@"nameArray is %@", nameArray);
        __block NSMutableArray *imgArr = [[NSMutableArray alloc] init];
        [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dict = (NSMutableDictionary *)obj;
            NSString *img = dict[@"Img"];
            [imgArr addObject:img];
        }];
        
        NSString *imgUrl = [imgArr componentsJoinedByString:@","];
        [weakSelf commitInfoWithImgUrl:imgUrl];
    } ErrowBlock:^(NSString *errrInfo) {
        [MBProgressHUD showTipMessageInWindow:@"提交失败,请重试!!!"];
    }];
}

- (void)commitInfoWithImgUrl:(NSString *)imgUrl{
    NSString *phoneStr = self.phoneField.text;
    if (![NSString isValidateMobile:phoneStr]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的手机号码"];
        return;
    }
    [XWHttpTool postUserFeedBackWithMessage:self.textView.text phone:self.phoneField.text img:imgUrl success:^{
        [MBProgressHUD showTipMessageInWindow:@"提交成功,感谢您的反馈!!!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showTipMessageInWindow:errorInfo];
    }];
}

- (void)addClick{
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
}

- (void)deleteClick:(UIButton *)btn{
    NSInteger idx = btn.tag - 1000;
    [self.imgArray removeObjectAtIndex:idx];
    if (![self.imgArray containsObject:self.img]) {
        [self.imgArray addObject:self.img];
    }
    [self reloadUI];
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos{
    
    [self.imgArray insertObject:[self.pick.imagesArray firstObject] atIndex:0];
    
    [self reloadUI];
    
}

#pragma mark - HSTextView Delegate
- (void)textViewDidChange:(UITextView *)textView{
    NSString *text = self.textView.text;
    if (text.length >= 200) {
        self.textView.text = [text substringToIndex:200];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld/200", self.textView.text.length];
    
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
