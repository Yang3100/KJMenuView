//
//  KJDropDownMenu.h
//  KJMenuView
//
//  Created by 杨科军 on 2019/2/25.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJDropDownMenuModel.h"

/// 文字对齐方式
typedef NS_ENUM(NSInteger,KJMenuTextAlignmentType) {
    KJMenuTextAlignmentTypeLeft = 0,  // 左对齐
    KJMenuTextAlignmentTypeCenter = 1,  // 居中
};


@class KJDropDownMenu;
@protocol KJDropDownMenuDelegate <NSObject>
@optional
/// 用户点击操作
- (void)menu:(KJDropDownMenu *)menu didSelectRowWithModel:(KJDropDownMenuModel *)model;
/// 菜单处于显示还是隐藏的状态
- (void)menu:(KJDropDownMenu *)menu isDisplay:(bool)isDisplay;
@end

@protocol KJDropDownMenuDataSource <NSObject>
@required
/** 表视图显示时，个数*/
- (NSInteger)menu:(KJDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
/** 表视图显示时，显示文字*/
- (NSString *)menu:(KJDropDownMenu *)menu RowTitleWithModel:(KJDropDownMenuModel *)model;
/** 标题显示的文字时候，文字对齐方式*/
- (KJMenuTextAlignmentType)menu:(KJDropDownMenu *)menu RowTextAlignmentForColumn:(NSInteger)column;
/** 标题显示的文字*/
- (NSString *)menu:(KJDropDownMenu *)menu TopTitleForColumn:(NSInteger)column;
/** 返回当前菜单左边表选中行 */
- (NSInteger)menu:(KJDropDownMenu *)menu currentLeftSelectedRow:(NSInteger)column;
/** 表视图显示时，左边表显示比例*/
- (CGFloat)menu:(KJDropDownMenu *)menu widthRatioOfLeftColumn:(NSInteger)column;
/** 表视图显示时，是否需要两个表显示 */
- (BOOL)menu:(KJDropDownMenu *)menu haveRightTableViewInColumn:(NSInteger)column;

@optional
/** 显示数量 默认为1 */
- (NSInteger)numberOfColumnsInMenu:(KJDropDownMenu *)menu;
@end

@interface KJDropDownMenu : UIView 

@property (nonatomic, weak) id <KJDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <KJDropDownMenuDelegate> delegate;

/******************** 视图颜色相关 *********************/
/** 顶部背景颜色 */
@property (nonatomic, strong) UIColor *TopBgColor;
/** 顶部标题颜色 */
@property (nonatomic, strong) UIColor *TopTitleColor;
/** 顶部标题选中颜色 */
@property (nonatomic, strong) UIColor *TopSelectTitleColor;
/** 左边table背景颜色 */
@property (nonatomic, strong) UIColor *leftTableBgColor;
/** 右边table背景颜色 */
@property (nonatomic, strong) UIColor *rightTableBgColor;
/** 小三角颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 左边文字颜色 */
@property (nonatomic, strong) UIColor *leftTextColor;
/** 左边选中文字颜色 */
@property (nonatomic, strong) UIColor *leftSelectTextColor;
/** 右边选中文字颜色 */
@property (nonatomic, strong) UIColor *rightTextColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *separatorColor;
/** 标题文字大小，默认14 */
@property (nonatomic, strong) UIFont *topTextFont;
/** 左边文字大小，默认14 */
@property (nonatomic, strong) UIFont *leftTextFont;
/** 右边文字大小，默认14 */
@property (nonatomic, strong) UIFont *rightTextFont;
/** table最大高度，默认10个Cell高度 */
@property (nonatomic, assign) CGFloat MaxTableH;
/** Cell高度，默认40 */
@property (nonatomic, assign) CGFloat TableCellH;
/** 当前菜单是否正在显示 */
@property (nonatomic,assign,readonly) BOOL kCurrentMenuDisplay;
/** 隐藏 */
- (void)kDismiss;

@end
