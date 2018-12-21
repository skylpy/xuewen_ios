//
//  NetWorkUrl.h
//  happyselling
//
//  Created by Pingzi on 2017/10/27.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#ifndef NetWorkUrl_h
#define NetWorkUrl_h

// 基础URL
#define BASE_URL(__param)   [NSString stringWithFormat:@"%@%@",XWURL,__param]
#define kBASE_URL(param1,param2) [NSString stringWithFormat:@"%@%@%@",XWURL,param1,param2]


#define XWURL                 [XWInstance shareInstance].url
//#define XWURL               @"http://192.168.2.253/"
//#define XWURL               @"http://xwapi.52xuewen.com/"

//#ifdef DEBUG
//#define XWURL               @"http://192.168.2.253/"
//#else
//#define XWURL               @"http://xwapi.52xuewen.com/"
//#endif

#define WebSocket           @"ws://120.78.196.118:2346"             // WebSocket地址
// url suffix
#define AppVersion          @"api/v1/AppVersion"                    // 系统版本
#define loginAccount        @"api/v1/login"                         // 账号密码登陆
#define AccountInfo         @"api/v1/AdminUser/"                    // 账号信息
#define CoursLabel          @"api/v1/CoursLabel/"                   // 课程标签
#define Cours               @"api/v1/cours/"                        // 课程
#define CoursCommon         @"api/v1/CoursComment/"                 // 课程评论相关

#define OSSSession                 @"api/v1/Oss"                           // OSS

#define addFavorite         @"api/v1/Favorite"                      //添加收藏
#define FavoriteCourse      @"api/v1/Favorite/"                     // 我的收藏
#define UserCourse          @"api/v1/UserCourse/"                   // 我的课程相关
#define CouponRecord        @"api/v1/CouponRecord/"                 // 优惠券

#define VideoPlay           @"api/v1/video_play"                    // 播放视频

#define PayCourse           @"api/v1/pay/"                          // 购买课程
#define CancelOrder         @"api/v1/PurchaseRecord/"               // 取消订单
#define UserViewingRecord   @"api/v1/UserViewingRecord"             // 观看记录
#define Userlearninghistory   @"api/v1/Userlearninghistory"         // 历史记录
#define ClearViewingRecord  @"api/v1/clear_viewing"                 // 清除观看记录
#define TransactionRecord   @"api/v1/TransactionRecord"             // 交易记录
#define GetPayOrder         @"api/pay/GetPay/index"                 // 支付参数
#define SearchCourse        @"api/v1/CoursNode/"                    // 搜索课程
#define TestNode            @"api/v1/TestNode/"                     // 考试试题
#define TestRecord          @"api/v1/TestRecord"                    // 考试结果
#define AuthCode            @"api/v1/AliyunSms"                     // 短信验证码
#define ResetPassword       @"api/v1/UserHelp"                      // 重置密码
#define RegistAccount       @"api/v1/Register"                      // 注册账号
#define PurchaseRecord      @"api/v1/PurchaseRecord"                // 订单列表
#define CourseNotes         @"api/v1/CourseNotes/"                  // 笔记列表
#define ShufflingFigure     @"api/v1/ShufflingFigure/"              // 轮播图
#define LearningPlan        @"api/v1/LearningPlanU"                 // 学习计划
#define CollegeModule       @"api/v1/CollegeModule"                 // 学院模块
#define CourseThematicLabel @"api/v1/CourseThematicLabel"           // 专题模块
#define ThematicLabelInfo   @"/api/v1/CourseThematicLabel_info/"    // 专题信息
#define ThematicPay         @"api/v1/apppay"                        // 专题购买
#define UserCoupon          @"/api/v1/UserCoupon"                   // 优惠券列表
#define CreatOrder          @"api/v1/app_new_order"                 // 创建订单
#define OrderInfo           @"api/v1/app_new_read/"                 // 订单详情
#define PayOrder            @"api/v1/app_new_order"                 // 支付订单
#define InvitationAccess    @"api/v1/InvitationAccess"              // 接收邀请
#define Invitation          @"api/v1/service/Invitation"            // 获取邀请链接
#define RegisteredRecord    @"api/v1/RegisteredRecord/"             // 注册记录/邀请明细
#define Statistics          @"api/v1/Statistics/"                   // 业务统计（公司的邀请明细）
#define UserCourseRecord    @"api/v1/user_course/"                  // 用户观看课程记录，记录的免费课程会出现在我的课程中
#define ServerTime          @"api/time"                             // 获取服务器时间
#define CoursAudio          @"api/v1/CoursAudio/"                   // 课程音频
#define PlayCourseNodePlay  @"api/v1/node_play"                     // 添加播放量

#define Countplaytime   @"api/v1/Countplaytime/"                    //我的学习记录汇总（有折线图部分）
#define CountPlaytimes   @"api/v1/Countplaytime"
#pragma mark - 新版首页

#define CourseIndex         @"api/v1/course_index"                  // 热门课程和近期上线
#define LickCourse          @"api/v1/lick_course"                   // 猜你喜欢
#define CourseLabel         @"api/v1/course_label"                  // 标签
#define Article             @"api/v1/Article/"                      // 文章-获取列表

#pragma mark - 音频列表

#define AudioCourse         @"api/v1/CoursAudio/"                   // 音频列表


#pragma mark - 商城跳转

#define GetShopJump         @"api/v1/service/GetShopJump"           //商城跳转-获取

#pragma mark - 考试相关
#define GetHistoryInfo      @"api/v1/TestMark/"                     //获取单门考试历史记录
#define RecommendCourse     @"api/v1/Recommend/"                    //个人课程标签推荐

#pragma mark - 商学院
#define GetLearning         @"api/v1/learning"                      //大家在学
#define CompanyCourse       @"api/v1/CompanyCourse"                 //企业课程列表
#define CompanyInfo         @"api/v1/CompanyInfo/"                  //公司信息
#define CountPlayTime       @"api/v1/Countplaytime"                 //商学院学习排名
#define GetTargetData       @"api/v1/target"                        //目标排名
#define PostFabulous        @"api/v1/fabulous_save"                 //添加点赞量
#define UserFeedback        @"api/v1/UserFeedback"                  //用户上传反馈

#define AchievementThematic     @"api/v1/AchievementThematic"       // 我的证书

#define Achievements            @"api/v1/Achievements"              // 生成证书

#define CollegeName             @"api/v1/college_name"              // 学院名称

#pragma mark- 提现相关

#define BonusesEarnings         @"api/v1/bonuses_earnings"          // 红包收益与佣金收益
#define MyTransactionList       @"api/v1/getMyTransactionList"      // 提现记录
#define GetPayeeAccount         @"/api/v1/getPayeeAccount"          // 获取提现账号跟可提现金额
#define CreateTransactionRecord @"api/v1/createTransactionRecord"   // 生成提现订单/提交提现申请
#define BindingAccount          @"api/v1/BindingAccount"            // 绑定支付宝账号





#define RedBackBonuses          @"api/v1/Bonuses"          //获取红包

#define RedBackBonusesNum       @"api/v1/bonuses_num"          //红包数量

#define RedBackBonusesList      @"api/v1/bonuses_list"        //红包列表

#define GetJobTest              @"api/v1/getJobTest"    //获取测一测列表
#define Cours_Label             @"api/v1/CoursLabel"     //课程标签列表
#define Cours_list              @"api/v1/HomeCourse"     // 课程

#define Discovery               @"api/v1/Discovery"   //发现
#define SuperGroup              @"api/v1/SuperGroup"     //超级组织
#define GetJobCollege           @"api/v1/getJobCollege"  //首页测一测和强推学院
#define GetRecommendCourse      @"api/v1/getRecommendCourse" // 获取考试推荐课程

#define CheckApplePay           @"api/pay/ApplePay/CheckApplePay" //苹果验签

#define StoreIsHide                  @"api/v1/isHide"



#pragma mark - 轮播图管理
#define FigurePut               @"api/v1/figureput/"        // 单个修改轮播图

#pragma mark - 组织管理
#define CompanyDepartment       @"api/v1/getCompanyDepartmentList" // 获取组织结构和人员
#define CompanyDepartment1      @"api/v1/CompanyDepartment/"  // 添加组织
#define GiveGold                @"api/v1/GiveGold"            // 赠送金币
#define CompanyCoupon           @"api/v1/CompanyCoupon"       // 管理员赠送用户奖学金

#define pricePCPay              @"api/v1/price"

#endif /* NetWorkUrl_h */
