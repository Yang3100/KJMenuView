//
//  KJDropDownMenuModel.h
//  KJMenuView
//
//  Created by 杨科军 on 2019/2/25.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+KJMenuSize.h"

@interface KJDropDownMenuModel : NSObject
// 行
@property (nonatomic, assign) NSInteger column;
// 0 左边   1 右边
@property (nonatomic, assign) NSInteger leftOrRight;
// 左边行
@property (nonatomic, assign) NSInteger leftRow;
// 右边行
@property (nonatomic, assign) NSInteger rightRow;

+ (instancetype)kIndexPathWithColumn:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow;

@end
