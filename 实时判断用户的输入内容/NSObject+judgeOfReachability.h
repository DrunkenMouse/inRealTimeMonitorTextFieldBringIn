//
//  NSObject+judgeOfReachability.h
//  LiCaiBang
//
//  Created by 王奥东 on 16/7/13.
//  Copyright © 2016年 AnBang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (judgeOfReachability)
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号18位
+ (BOOL)checkUserIdCard: (NSString *) idCard;


@end
