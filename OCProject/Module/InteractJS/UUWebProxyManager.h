//
//  UUWebProxyManager.h
//  OCProject
//
//  Created by Pan on 2020/6/15.
//  Copyright © 2020 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUJSExportManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UUWebProxyManager : NSObject <UIWebViewDelegate, UUJSExportManagerDelegate>

@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;
@property (nonatomic, weak) id<UUJSExportManagerDelegate> exportDelegate;
@end

NS_ASSUME_NONNULL_END
