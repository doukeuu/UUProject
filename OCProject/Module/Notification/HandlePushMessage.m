//
//  HandlePushMessage.m
//  MingYi
//
//  Created by NTIT on 2017/3/7.
//  Copyright © 2017年 SHNTIT. All rights reserved.
//
//  在接受到通知后，存储通知数量在字典中，并在TabBar上显示，点开查看通知后，发送通知NoticeModifyBadgeContentInfo来减少字典中的数量并重置TabBar上的数字

#import "HandlePushMessage.h"

//#import "LoginRegisterController.h"

@interface HandlePushMessage ()

@property (nonatomic, strong) NSMutableDictionary *badgeDic; // 存储未读角标数
@end

@implementation HandlePushMessage

// 单例
+ (instancetype)shareHandler {
    
    static HandlePushMessage *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[HandlePushMessage alloc] init];
    });
    return handler;
}

- (instancetype)init {
    
    if (self = [super init]) {
        // 修改未读角标的记录的通知
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(modifyBadgeContent:)
//                                                     name:NoticeModifyBadgeContentInfo
//                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NoticeModifyBadgeContentInfo object:nil];
}

- (NSMutableDictionary *)badgeDic {
    
    if (_badgeDic) return _badgeDic;
//    _badgeDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0, kBadgeTotal, nil];
    return _badgeDic;
}

// 增加角标记录数，Number角标数量，Item为TabBar下标，type为通知类型，详见宏定义
- (NSInteger)addBadgeNumber:(NSInteger)number atItem:(NSInteger)item withType:(NSString *)type {
    
    NSInteger badge = [[self.badgeDic objectForKey:type] integerValue];
//    NSInteger total = [[self.badgeDic objectForKey:kBadgeTotal] integerValue];
    
//    badge += number;
//    total += number;
    
//    [self.badgeDic setObject:@(badge) forKey:type];        // 设置各类型角标数
//    [self.badgeDic setObject:@(total) forKey:kBadgeTotal]; // 设置App总角标数
//    [self resetTabBarItemBadgeValue:number atItem:item];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = total;
    
    return badge;
}

// 减少角标记录数
- (void)modifyBadgeContent:(NSNotification *)notification {
    
//    NSString *type = [notification.userInfo objectForKey:kBadgeType];
//    NSInteger item = [[notification.userInfo objectForKey:kBadgeItem] integerValue];
//    NSInteger count = [[notification.userInfo objectForKey:kBadgeNumber] integerValue];
//
//    NSInteger badge = [[self.badgeDic objectForKey:type] integerValue];
//    NSInteger total = [[self.badgeDic objectForKey:kBadgeTotal] integerValue];
    
//    badge -= count;
//    total -= count;
//    if (badge < 0) badge = 0;
//    if (total < 0) total = 0;
    
//    [self.badgeDic setObject:@(badge) forKey:type];        // 设置各类型角标数
//    [self.badgeDic setObject:@(total) forKey:kBadgeTotal]; // 设置App总角标数
//    [self resetTabBarItemBadgeValue:-count atItem:item];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = total;
}

// 设置TabBarItem角标数字
- (void)resetTabBarItemBadgeValue:(NSInteger)badge atItem:(NSInteger)item {
    
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    UITabBarController *tabBarController = (UITabBarController *)keyWindow.rootViewController;
//    UITabBar *tabBar = tabBarController.tabBar;
//
//    if (tabBar.items.count <= item || item < 0) return;
//
//    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:item];
//    NSInteger total = tabBarItem.badgeValue.integerValue + badge;
//    tabBarItem.badgeValue = total <= 0 ? nil : [NSString stringWithFormat:@"%ld", (long)total];
}


#pragma mark - Handle Notification

// 处理远程推送的通知
+ (void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo {
    
    if (!userInfo) return;
    
    NSInteger notiType = [[userInfo objectForKey:@"notiType"] integerValue];
    switch (notiType) {
        case 1: // 实名认证通过
            [self dealRealNameVerifyPayloadDic:userInfo];
            [self justShowNotificationInfo:userInfo];
            break;
        case 2: // 医保预约挂号成功通知
            [self dealRegisterAppointmentSuccessfully];
            [self justShowNotificationInfo:userInfo];
            break;
        case 3: // 预约挂号，翼支付或银联支付完成后通知
            [self dealRegisterAppointmentSuccessfully];
            [self justShowNotificationInfo:userInfo];
            break;
        case 9: // 申请查看家人报告权限
            [self justShowNotificationInfo:userInfo];
            break;
        case 10: // 你添加家人的申请已通过
            [self justShowNotificationInfo:userInfo];
            break;
        case 11: // 有人申请添加你为家人的通知
            [self dealFamilyAdditionRequest];
            [self justShowNotificationInfo:userInfo];
            break;
        case 12: // 诊间支付推送过来的未支付订单
            [self dealPaymentDuringClinic];
            [self justShowNotificationInfo:userInfo];
            break;
        case 13: // 肿瘤联合体专家回复
            [self dealConsortiumExpertReply:userInfo];
            [self justShowNotificationInfo:userInfo];
            break;
        case 14: // 肿瘤联合体患者预约后给医生推送消息
            [self dealPatientReservationForExpert];
            [self justShowNotificationInfo:userInfo];
            break;
        case 15: // 账号在其他手机登陆的通知
            [self userAccountLoginedAnotherPhone:userInfo];
            break;
        default:
            break;
    }
}

// 处理本地推送通知
+ (void)handleLocalNotificationMessage:(NSDictionary *)info {
    NSLog(@"Local info: %@", info);
}


#pragma mark - Deal Info

// 处理实名认证信息
+ (void)dealRealNameVerifyPayloadDic:(NSDictionary *)dic {
    
    NSInteger verifyResult = [[dic objectForKey:@"verifyResult"] integerValue];
    if (verifyResult == 1) {
//        [USER modifyUserVerifyFlag:UserAuthenticationRefused];
//        [USER modifyUserRealName:@"" andIDCard:@""];
    } else if (verifyResult == 2) {
//        [USER modifyUserVerifyFlag:UserAuthenticationPassed];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeRealNameCertification object:nil];
}

// 处理诊间支付推送的需支付的信息
+ (void)dealPaymentDuringClinic {
    
//    NSInteger paymentBadge = [[HandlePushMessage shareHandler] addBadgeNumber:1 atItem:0 withType:kBadgePaymentClinic];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeNewPaymentDuringClinic object:nil userInfo:@{kBadgeNumber:@(paymentBadge)}];
}

// 处理家人添加申请通知信息
+ (void)dealFamilyAdditionRequest {
    
//    NSInteger badge = [[HandlePushMessage shareHandler] addBadgeNumber:1 atItem:1 withType:kBadgeCareFamily];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeFamilyAddtionRequest object:nil userInfo:@{kBadgeNumber:@(badge)}];
}

// 处理预约成功信息
+ (void)dealRegisterAppointmentSuccessfully {
    
//    NSInteger badge = [[HandlePushMessage shareHandler] addBadgeNumber:1 atItem:2 withType:kBadgeUserMessage];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeReceiveRemoteMessege object:nil userInfo:@{kBadgeNumber:@(badge)}];
}

// 肿瘤联合体专家回复
+ (void)dealConsortiumExpertReply:(NSDictionary *)info {
    
//    NSDictionary *reply = [info objectForKey:@"Response"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeConsortiumExpertReply object:nil userInfo:reply];
}

// 肿瘤联合体患者预约后给医生推送消息
+ (void)dealPatientReservationForExpert {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeExpertPatientReservation object:nil];
}

// 账号在其他手机登陆的通知
+ (void)userAccountLoginedAnotherPhone:(NSDictionary *)info {
    
//    NSDictionary *response = [info objectForKey:@"Response"];
//    NSString *userID = [response objectForKey:@"UserID"];
//    if (![USER.info.userID isEqualToString:userID]) return;
    
//    UIViewController *controller = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    // 当前界面navigation为透明时，原在ViewWillDisappear里面的这些设置不透明的功能就不顶用了，所以搬到这里来了
//    if ([[controller valueForKey:@"navigationTransparent"] boolValue]) {
//        controller.navigationController.navigationBar.translucent = NO;
//        [controller.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_TabBar"] forBarMetrics:UIBarMetricsDefault];
//        [controller.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_line"]];
//    }
//    [controller.navigationController popToRootViewControllerAnimated:YES];
//    [USER logout];
//
//    controller = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    UIViewController *present = controller.presentedViewController;
//    [present dismissViewControllerAnimated:YES completion:nil];
//
//    NSString *tips = @"您的账号在另一手机上登陆，请确认您的账号和密码是否泄漏！！";
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [LoginRegisterController presentedFrom:controller];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [controller presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Utility Method

// 仅仅将通知消息显示一下就行
+ (void)justShowNotificationInfo:(NSDictionary *)dic {
    
//    NSDictionary *aps = [dic objectForKey:@"aps"];
//    NSDictionary *alert = [aps objectForKey:@"alert"];
//    NSString *body = [alert objectForKey:@"body"];
//    [PromptHUD showPromptText:body];
}

// 查找NavigationController最底层的视图控制器
//+ (UIViewController *)topViewController:(UIViewController *)controller {
//
//    if ([controller isKindOfClass:[UINavigationController class]]) {
//        return [self topViewController:[(UINavigationController *)controller topViewController]];
//    } else if ([controller isKindOfClass:[UITabBarController class]]) {
//        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
//    } else {
//        return controller;
//    }
//}

@end
