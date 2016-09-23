//
//  FutureCommon.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#ifndef FutureCommon_h
#define FutureCommon_h

#define MUSICNOTFIKEY  @"musicStop"

#define PICTURE_PATH(B) [NSString stringWithFormat:@"%@%@",PATH, B]

#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define F(string, args...)                  [NSString stringWithFormat:string, args]


#define  ALERT(title,msg)                   [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];

#define UserDefaultWrite(key,value)                [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];

#define UserDefaultRead(key)                     [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define UserDefaultRemove(key)                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];

#define UserDefaultSynchronize        [[NSUserDefaults standardUserDefaults] synchronize];


#define SELECTED_VIEW_CONTROLLER_TAG 20161314520

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


#endif /* FutureCommon_h */
