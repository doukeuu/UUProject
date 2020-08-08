//
//  UUImageBrowseController.h
//  OCProject
//
//  Created by Pan on 2020/6/30.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUImageBrowseController : UIViewController

@property (nonatomic, strong) NSArray *imagesArray;         // 浏览的图片数组
@property (nonatomic, assign) NSInteger imageSelectedIndex; // 最后浏览的图片下标
@end

NS_ASSUME_NONNULL_END
