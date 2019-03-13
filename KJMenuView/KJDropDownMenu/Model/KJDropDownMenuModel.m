//
//  KJDropDownMenuModel.m
//  KJMenuView
//
//  Created by 杨科军 on 2019/2/25.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJDropDownMenuModel.h"

@implementation KJDropDownMenuModel
- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow {
    if (self = [super init]) {
        _column = column;
        _leftOrRight = leftOrRight;
        _leftRow = leftRow;
        _rightRow = rightRow;
    }
    return self;
}

+ (instancetype)kIndexPathWithColumn:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow rightRow:(NSInteger)rightRow {
    KJDropDownMenuModel *indexPath = [[self alloc] initWithColumn:col leftOrRight:leftOrRight leftRow:leftRow rightRow:rightRow];
    return indexPath;
}
@end
