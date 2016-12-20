//
//  HTmAlertAction.m
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 15/4/10.
//  Copyright (c) 2015年 [OYXJlucky@163.com] All rights reserved.
//

#import "HTmAlertAction.h"


@implementation HTmAlertAction


#pragma mark - PUBLIC
+ (instancetype)actionWithTitle:(NSString *)title handler:(HTmAlertActionHandler)handler
{
    return [[HTmAlertAction alloc] initWithTitle:title handler:handler];
}

#pragma mark - private
- (instancetype)initWithTitle:(NSString *)title handler:(HTmAlertActionHandler)handler
{
    if (self = [super init]) {
        
        if (title.length > 0) {
            _title = [title copy];
            _handler = [handler copy];
        }
        
    }
    return self;
}

@end
