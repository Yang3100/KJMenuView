//
//  ViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/11/26.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *MainTable;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSArray *sectionTitleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.MainTable];
}

#pragma mark - 代理区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitleArray.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *Arr = self.dataArray[section];
    return Arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"abc"];
    }
    NSArray *Arr = self.dataArray[indexPath.section];
    NSDictionary *dic = Arr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%zi. %@",indexPath.row + 1,dic[@"VCName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = UIColor.redColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"describeName"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = UIColor.purpleColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *Arr = self.dataArray[indexPath.section];
    NSDictionary *dic = Arr[indexPath.row];
    Class class = NSClassFromString(dic[@"VCName"]);
    BaseViewController *vc = [[class alloc]init];
    vc.title = dic[@"describeName"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitleArray[section];
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.textLabel.textColor = UIColor.blackColor;
    header.textLabel.font = [UIFont systemFontOfSize:14];
}
#pragma mark - 懒加载
- (UITableView *)MainTable{
    if (!_MainTable) {
        _MainTable = [[UITableView alloc]initWithFrame:self.view.frame];
        _MainTable.delegate = self;
        _MainTable.dataSource = self;
    }
    return _MainTable;
}

- (NSArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[@"菜单类"];
    }
    return _sectionTitleArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        NSMutableArray *Group2 = [NSMutableArray array];
        [Group2 addObject:@{@"VCName":@"KJDropDownMenuVC",@"describeName":@"下拉菜单"}];
        [Group2 addObject:@{@"VCName":@"KJMenuCollectionVC",@"describeName":@"右边带文字的菜单"}];
        
        NSMutableArray *Group3 = [NSMutableArray array];
        [_dataArray addObject:Group2];
        [_dataArray addObject:Group3];
    }
    return _dataArray;
}


@end
