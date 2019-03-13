//
//  KJDropDownMenuVC.m
//  KJMenuView
//
//  Created by 杨科军 on 2019/3/12.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJDropDownMenuVC.h"
#import "KJDropDownMenu.h"
@interface KJDropDownMenuVC ()<KJDropDownMenuDataSource,KJDropDownMenuDelegate>{
    NSInteger addressIndex;
    NSInteger addressSubIndex;
    NSInteger index2;
    NSInteger index3;
}
@property (nonatomic,strong) KJDropDownMenu *AddressMenu;
@property (nonatomic,strong) KJDropDownMenu *AddressMenu2;
@property (nonatomic,readwrite,strong) NSMutableArray *addressTemps;

@end

@implementation KJDropDownMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.AddressMenu];
    [self.view addSubview:self.AddressMenu2];
}

- (KJDropDownMenu*)AddressMenu{
    if (!_AddressMenu) {
        KJDropDownMenu *menu = [[KJDropDownMenu alloc] initWithFrame:CGRectMake((kScreenW-100)*0.5, kSTATUSBAR_NAVIGATION_HEIGHT+100, 100, 50)];
        _AddressMenu = menu;
        menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        menu.leftTextColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        menu.separatorColor = UIColorFromHEXA(0xDFDFDF, 1);
        menu.TopSelectTitleColor = UIColor.blueColor;
        menu.TopBgColor = UIColor.yellowColor;
        menu.TopTitleColor = UIColor.redColor;
        menu.leftTableBgColor = UIColor.whiteColor;
        menu.rightTableBgColor = UIColorFromHEXA(0xF5F5F5, 1);
        menu.leftSelectTextColor = UIColor.greenColor;
        menu.dataSource = self;
        menu.delegate = self;
    }
    return _AddressMenu;
}
- (KJDropDownMenu*)AddressMenu2{
    if (!_AddressMenu2) {
        KJDropDownMenu *menu = [[KJDropDownMenu alloc] initWithFrame:CGRectMake(0, kSTATUSBAR_NAVIGATION_HEIGHT, kScreenW, 44)];
        _AddressMenu2 = menu;
        menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        menu.leftTextColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        menu.separatorColor = UIColorFromHEXA(0xDFDFDF, 1);
        menu.TopSelectTitleColor = UIColor.orangeColor;
        menu.TopBgColor = UIColor.brownColor;
        menu.TopTitleColor = UIColor.whiteColor;
        menu.leftTableBgColor = UIColor.whiteColor;
        menu.rightTableBgColor = UIColorFromHEXA(0xF5F5F5, 1);
        menu.leftSelectTextColor = UIColor.redColor;
        menu.dataSource = self;
        menu.delegate = self;
    }
    return _AddressMenu2;
}
#pragma mark - KJDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(KJDropDownMenu *)menu {
    if (menu == self.AddressMenu) {
        return 1;
    }
    return 3;
}
- (BOOL)menu:(KJDropDownMenu *)menu haveRightTableViewInColumn:(NSInteger)column{
    if (column==0) {
        return YES;
    }
    return NO;
}
- (CGFloat)menu:(KJDropDownMenu *)menu widthRatioOfLeftColumn:(NSInteger)column{
    if (column==0) {
        return 0.35;
    }
    return 1;
}

- (NSInteger)menu:(KJDropDownMenu *)menu currentLeftSelectedRow:(NSInteger)column{
    if (column==0) {
        return addressIndex;
    }else if (column==1) {
        return index2;
    }else{
        return index3;
    }
}

- (NSInteger)menu:(KJDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        if (leftOrRight==0) {
            return self.addressTemps.count;
        } else{
            NSDictionary *menuDic = [self.addressTemps objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    }else if (column==1){
        return [self extracted].count;
    }else{
        return [self extract].count;
    }
}

- (NSString *)menu:(KJDropDownMenu *)menu TopTitleForColumn:(NSInteger)column{
    switch (column) {
        case 0: return [[self.addressTemps[addressIndex] objectForKey:@"data"] objectAtIndex:addressSubIndex];
            break;
        case 1: return [self extracted][index2];
            break;
        case 2: return [self extract][index3];
            break;
        default:
            return nil;
            break;
    }
}
/** 标题显示的文字时候，文字对齐方式*/
- (KJMenuTextAlignmentType)menu:(KJDropDownMenu *)menu RowTextAlignmentForColumn:(NSInteger)column{
    if (menu == self.AddressMenu2) {
        switch (column) {
            case 0: return KJMenuTextAlignmentTypeCenter;
                break;
            case 1: return KJMenuTextAlignmentTypeLeft;
                break;
            case 2: return KJMenuTextAlignmentTypeCenter;
                break;
        }
    }
    return KJMenuTextAlignmentTypeLeft;
}
- (NSString *)menu:(KJDropDownMenu *)menu RowTitleWithModel:(KJDropDownMenuModel *)model {
    if (model.column==0) {
        if (model.leftOrRight==0) {
            NSDictionary *menuDic = [self.addressTemps objectAtIndex:model.rightRow];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = model.leftRow;
            NSDictionary *menuDic = [self.addressTemps objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:model.rightRow];
        }
    }else if (model.column==1) {
        return [self extracted][model.rightRow];
    }else {
        return [self extract][model.rightRow];
    }
}
#pragma mark - KJDropDownMenuDelegate
- (void)menu:(KJDropDownMenu *)menu didSelectRowWithModel:(KJDropDownMenuModel *)model {
    if (model.column == 0) {
        addressIndex = model.leftRow;
        addressSubIndex = model.rightRow;
    }else if(model.column == 1){
        index2 = model.leftRow;
    }else{
        index3 = model.leftRow;
    }
}
- (void)menu:(KJDropDownMenu *)menu isDisplay:(bool)isDisplay{
    if (menu == self.AddressMenu) {
        if (self.AddressMenu2.kCurrentMenuDisplay) {
            [self.AddressMenu2 kDismiss];
        }
    }else{
        if (self.AddressMenu.kCurrentMenuDisplay) {
            [self.AddressMenu kDismiss];
        }
    }
}

- (NSArray *)extracted {
    index2 = 0;
    return @[@"全金牛",@"茶店子",@"欢乐谷",@"火车北站",@"金牛万达",@"金牛周边",@"交大路",@"荷花池",@"人民北3路",@"交大12路",@"荷花43池",@"人民5北路",@"交大4324路",@"荷花34234池",@"人民北1路"];
}

- (NSArray *)extract{
    index3 = 0;
    return @[@"全成都", @"金牛区", @"武侯区", @"青羊区", @"新都区"];
}

- (NSMutableArray*)addressTemps{
    if (!_addressTemps) {
        addressIndex = 1;
        addressSubIndex = 1;
        NSArray *cd = @[@"全成都", @"金牛区", @"武侯区", @"青羊区", @"新都区"];
        NSArray *qy = @[@"全青羊",@"青羊周边"];
        _addressTemps = [NSMutableArray arrayWithObjects:@{@"title":@"全成都", @"data":cd}, @{@"title":@"青羊区", @"data":qy}, @{@"title":@"金牛区", @"data":[self extracted]}, nil];
    }
    return _addressTemps;
}


@end

