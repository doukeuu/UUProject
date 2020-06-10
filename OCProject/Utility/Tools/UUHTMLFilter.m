//
//  UUHTMLFilter.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUHTMLFilter.h"
#import "TFHpple.h"

@implementation UUHTMLFilter

// 去除HTML语言标签
+ (NSString *)filterHTMLContentWithData:(NSData *)data{
    
    TFHpple *filter = [[TFHpple alloc] initWithData:data isXML:NO];
    NSArray *textNodes = [filter searchWithXPathQuery:@"//text()"];
    NSMutableString *result = [[NSMutableString alloc] init];
    for (TFHppleElement *element in textNodes) {
        [result appendString:element.content];
    }
    return [result copy];
}

@end
