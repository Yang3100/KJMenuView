//
//  KJHeader.h
//  KJEmitterDemo
//
//  Created by 杨科军 on 2018/11/26.
//  Copyright © 2018 杨科军. All rights reserved.
//
/*
 Github地址：https://github.com/yangKJ
 简书地址：https://www.jianshu.com/u/c84c00476ab6
 博客地址：https://blog.csdn.net/qq_34534179
 */

#ifndef KJHeader_h
#define KJHeader_h

// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...)printf("\n[%s] %s [第%d行] 😎😎 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

/******************* UIKit ******************************/
#import "KJMenuCollectionView.h"  // 菜单


#endif /* KJHeader_h */
