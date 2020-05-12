//
//  UUDefineNS.h
//  OCProject
//
//  Created by Pan on 2020/5/12.
//  Copyright © 2020 xyz. All rights reserved.
//

#ifndef UUDefineNS_h
#define UUDefineNS_h

// 打印信息及其所在类、方法和行号
#ifdef DEBUG
#define UULog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define UULog(...)
#endif

#endif /* UUDefineNS_h */
