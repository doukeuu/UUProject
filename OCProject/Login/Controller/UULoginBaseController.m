//
//  UULoginBaseController.m
//  OCProject
//
//  Created by Pan on 2020/6/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULoginBaseController.h"

#import "UUAnimatedTransitioning.h"
#import "UUInteractiveTransition.h"

@interface UULoginBaseController () <UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UUAnimatedTransitioning *transitioning; // 转场动画
@property (nonatomic, strong) UUInteractiveTransition *interactive;   // 转场手势管理
@end

@implementation UULoginBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addKeyboardObserver = NO;
    
    [self configureNavigationRightItem];
    [self configureBackgroundView];
    
    self.transitioning = [[UUAnimatedTransitioning alloc] initWithType:UUTransitioningPushFromBottom];
    self.interactive = [[UUInteractiveTransition alloc] initWithPanGestureAddedController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_addKeyboardObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_addKeyboardObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    self.navigationController.delegate = nil;
}

- (void)dealloc {
    NSLog(@" == %@", [self class]);
}

#pragma mark - Configure Subview

// 导航右边取消按钮
- (void)configureNavigationRightItem {
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel_Login"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -8;
    self.navigationItem.rightBarButtonItems = @[spaceItem, rightItem];
}

// 背景视图
- (void)configureBackgroundView {
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"bg_Login"];
    backView.contentMode = UIViewContentModeScaleToFill;
    backView.userInteractionEnabled = YES;
    self.view = backView;
}

// 输入列表
- (UITableView *)tableView {
    
    if (_tableView) return _tableView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, NAVIGATOR_H, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATOR_H);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view insertSubview:_tableView atIndex:0];
    return _tableView;
}


#pragma mark - Touch Action

// 点击取消按钮
- (void)clickCancelButton {
    
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 键盘展示通知
- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (self.selectedIndexPath.section != 1) return;
    CGRect bounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    CGFloat scrollY = cell.bounds.origin.y + cell.bounds.size.height + bounds.size.height - self.tableView.bounds.size.height;
    
    if (scrollY > self.tableView.contentOffset.y) {
        [UIView animateWithDuration:duration animations:^{
            self.tableView.contentOffset = CGPointMake(0, scrollY);
        }];
    }
}

// 键盘隐藏通知
- (void)keyboardWillHidden:(NSNotification *)notification {
    if (self.selectedIndexPath.section != 1) return;
    [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return 30 * SCREEN_RATIO;
    if (indexPath.section == 1) return 49 * SCREEN_RATIO;
    return 40 *SCREEN_RATIO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 130 * SCREEN_RATIO;
    return 32 * SCREEN_RATIO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        self.transitioning.transitioningType = UUTransitioningPushFromBottom;
    } else if (operation == UINavigationControllerOperationPop) {
        self.transitioning.transitioningType = UUTransitioningPopFromTop;
    } else {
        return nil;
    }
    return self.transitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if (self.transitioning.transitioningType == UUTransitioningPopFromTop) {
        return self.interactive.isInterating ? self.interactive : nil;
    }
    return nil;
}

@end
