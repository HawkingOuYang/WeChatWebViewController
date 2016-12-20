//
//  NSMutableDictionary+Extra.h
//  TemplatesProject
//
//  Created by HawkingOuYang.com on 14-5-30.
//  Copyright (c) 2014年 [OYXJlucky@163.com] . All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief 字典category
 *  @author OuYangXiaoJin 2016.03.30
 */
@interface NSMutableDictionary (xj_Extra)

/**
 插入的值为nil或者key为nil时不做操作
 */
- (void)setObjectExtra:(id)anObject forKey:(id <NSCopying>)aKey;

@end
