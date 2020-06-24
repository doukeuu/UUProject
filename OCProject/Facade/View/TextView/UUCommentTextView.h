//
//  UUCommentTextView.h
//  OCProject
//
//  Created by Pan on 2020/6/24.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UUCommentTextViewDelegate <NSObject>
/// 发表评论操作代理
- (void)commentTextViewDidPostComment:(NSString *)comment;
@end


@interface UUCommentTextView : UIView <UITextViewDelegate>

@property (strong, nonatomic) NSString *placeholderString;         // 占位符
@property (assign, nonatomic) NSInteger limitNumber;               // 限定输入字符数，默认200个
@property (weak, nonatomic) id<UUCommentTextViewDelegate> delegate; // 代理
@end

NS_ASSUME_NONNULL_END
