//
//  UUCostantKey.m
//  OCProject
//
//  Created by Pan on 2020/5/13.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUCostantKey.h"

#pragma mark - Notice Name

NSString * const NoticeReceivedNewMessage = @"kNoticeReceivedNewMessage";

#pragma mark - Javascript

NSString * const JSInjectedFormat = @"var meta = document.createElement('meta'); \
                                    meta.setAttribute('name', 'viewport'); \
                                    meta.setAttribute('content', 'width=device-width'); \
                                    document.getElementsByTagName('head')[0].appendChild(meta); \
                                    var imgs = document.getElementsByTagName('img'); \
                                    for (var i in imgs) { \
                                        imgs[i].style.maxWidth='100%'; \
                                        imgs[i].style.height='auto'; \
                                    }";
