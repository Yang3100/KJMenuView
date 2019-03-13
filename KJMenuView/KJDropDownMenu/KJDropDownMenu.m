//
//  KJDropDownMenu.m
//  KJMenuView
//
//  Created by 杨科军 on 2019/2/25.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJDropDownMenu.h"

@interface KJDropDownMenu ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIButton *bgButton;

@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, assign) NSInteger leftSelectedRow;

@end

@implementation KJDropDownMenu

#pragma mark - 默认数据
- (void)setConfig{
    self.TableCellH = 40;
    self.MaxTableH = 10 * self.TableCellH;
    self.TopBgColor = UIColor.clearColor;
    self.TopTitleColor = UIColor.blackColor;
    self.leftTableBgColor = UIColor.whiteColor;
    self.rightTableBgColor = UIColor.whiteColor;
    self.indicatorColor = UIColor.grayColor;
    self.separatorColor = UIColor.grayColor;
    self.leftTextColor = UIColor.blackColor;
    self.TopSelectTitleColor = UIColor.blackColor;
    self.leftSelectTextColor = UIColor.redColor;
    self.leftTextFont = [UIFont systemFontOfSize:14];
    self.rightTextFont = [UIFont systemFontOfSize:14];
    self.topTextFont = [UIFont systemFontOfSize:14];
}
#pragma mark - setter
- (void)setDataSource:(id<KJDropDownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:self.TopBgColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake((i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString = [_dataSource menu:self TopTitleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.TopTitleColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height/2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
}
- (BOOL)kCurrentMenuDisplay{
    return _show;
}
- (void)setTableCellH:(CGFloat)TableH{
    _TableCellH = TableH;
    self.leftTableView.rowHeight = TableH;
    self.rightTableView.rowHeight = TableH;
}
- (void)setLeftTableBgColor:(UIColor *)leftTableBgColor{
    _leftTableBgColor = leftTableBgColor;
    self.leftTableView.backgroundColor = leftTableBgColor;
}
- (void)setRightTableBgColor:(UIColor *)rightTableBgColor{
    _rightTableBgColor = rightTableBgColor;
    self.rightTableView.backgroundColor = rightTableBgColor;
}
- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    self.leftTableView.separatorColor = separatorColor;
    self.rightTableView.separatorColor = separatorColor;
}

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        [self setConfig];
        self.origin = CGPointMake(0, 0);
        _currentSelectedMenudIndex = 0;
        _show = NO;
        
        //self tapped
        self.autoresizesSubviews = NO;
        self.backgroundColor = self.TopBgColor;
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.bgButton = button;
        button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [button addTarget:self action:@selector(HideClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

#pragma mark - lazy
- (UITableView*)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _leftTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        _leftTableView.autoresizesSubviews = NO;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        /** 去除tableview 右侧滚动条 */
        _leftTableView.showsVerticalScrollIndicator = NO;
    }
    return _leftTableView;
}
- (UITableView*)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        _rightTableView.autoresizesSubviews = NO;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        /** 去除tableview 右侧滚动条 */
        _rightTableView.showsVerticalScrollIndicator = NO;
    }
    return _rightTableView;
}
#pragma mark - 事件处理
- (void)HideClick{
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:isDisplay:)]) {
        [self.delegate menu:self isDisplay:true];
    }
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        self->_show = NO;
    }];
}
/// 隐藏
- (void)kDismiss{
    [self HideClick];
}
/// 点击事件
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    __weak typeof(self) weakself = self;    /// 弱引用
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [weakself animateTitle:weakself.titles[i] show:NO complete:^{}];
            }];
        }
    }
    BOOL haveRightTableView = [_dataSource menu:self haveRightTableViewInColumn:tapIndex];
    UITableView *rightTableView = nil;
    if (haveRightTableView) {
        rightTableView = _rightTableView;
    }
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex]  leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            weakself.currentSelectedMenudIndex = tapIndex;
            weakself.show = NO;
        }];
    } else {
        _currentSelectedMenudIndex = tapIndex;
        if ([_dataSource respondsToSelector:@selector(menu:currentLeftSelectedRow:)]) {
            _leftSelectedRow = [_dataSource menu:self currentLeftSelectedRow:_currentSelectedMenudIndex];
        }
        
        if (rightTableView) {
            [rightTableView reloadData];
        }
        [_leftTableView reloadData];
        
        CGFloat ratio = [_dataSource menu:self widthRatioOfLeftColumn:_currentSelectedMenudIndex];
        if (_leftTableView) {
            _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW*ratio, 0);
        }
        
        if (_rightTableView) {
            _rightTableView.frame = CGRectMake(self.origin.x+_leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, kScreenW*(1-ratio), 0);
        }
        [self animateIdicator:_indicators[tapIndex]  leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
            weakself.show = YES;
        }];
    }
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    return layer;
}
/// 小三角形
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}
/// 文字
- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    CGSize size = [self calculateTitleSizeWithString:string];
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = _topTextFont.pointSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    return layer;
}
/// 间隔线条
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    CGFloat h = self.frame.size.height;
    [path moveToPoint:CGPointMake(0,h/6)];
    [path addLineToPoint:CGPointMake(0, h/3.0*2)];
    layer.path = path.CGPath;
    layer.lineWidth = 2.0;
    layer.strokeColor = color.CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}
- (CGSize)calculateTitleSizeWithString:(NSString *)string{
    NSDictionary *dic = @{NSFontAttributeName : self.topTextFont};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}
#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)(void))complete {
    for (int i = 0; i<_titles.count; i++) {
        CATextLayer *layer = (CATextLayer *)_titles[i];
        CAShapeLayer *shapeLayer = _indicators[i];
        if (i == _currentSelectedMenudIndex && forward) {
            [layer setForegroundColor:_TopSelectTitleColor.CGColor];
            [shapeLayer setFillColor:_TopSelectTitleColor.CGColor];
        }else{
            [layer setForegroundColor:_TopTitleColor.CGColor];
            [shapeLayer setFillColor:_indicatorColor.CGColor];
        }
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    [CATransaction commit];
    complete();
}

- (void)animateShow:(BOOL)show complete:(void(^)(void))complete{
    UIView *view = nil;
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:isDisplay:)]) {
        [self.delegate menu:self isDisplay:show];
    }
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
    } else {
        [UIView animateWithDuration:0.2 animations:^{} completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

/** 动画显示下拉菜单table */
- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void(^)(void))complete{
    /// 获取分割比例
    CGFloat ratio = [_dataSource menu:self widthRatioOfLeftColumn:_currentSelectedMenudIndex];
    
    if (show) {
        self.bgButton.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW, 0);
        [self.superview addSubview:self.bgButton];
        
        CGFloat leftTableViewHeight = 0;
        CGFloat rightTableViewHeight = 0;
        if (leftTableView) {
            leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW*ratio, 0);
            [self.superview addSubview:leftTableView];
            leftTableViewHeight = self.MaxTableH;
        }
        if ([self.dataSource menu:self haveRightTableViewInColumn:_currentSelectedMenudIndex]){
            if (rightTableView) {
                rightTableView.frame = CGRectMake(self.origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, kScreenW*(1-ratio), 0);
                [self.superview addSubview:rightTableView];
                rightTableViewHeight = self.MaxTableH;
            }
        }
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW*ratio, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(self.origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, kScreenW*(1-ratio), tableViewHeight);
            }
        }];
        self.bgButton.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW, kScreenH-self.frame.origin.y - self.frame.size.height);
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW*ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(self.origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, kScreenW*(1-ratio), 0);
            }
        } completion:^(BOOL finished) {
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
        self.bgButton.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, kScreenW, 0);
        [self.bgButton removeFromSuperview];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)(void))complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (kScreenW / _numOfMenu) - 25) ? size.width : kScreenW / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator leftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)(void))complete{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateShow:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                }];
            }];
        }];
    }];
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 0 左边   1 右边
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    }
    
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight:leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"kDownMenuCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.separatorInset = UIEdgeInsetsZero;
    
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
        cell.textLabel.textColor = _leftTextColor;
        cell.textLabel.font = _rightTextFont;
        cell.backgroundColor = _rightTableBgColor;
    }else{
        cell.textLabel.font = _leftTextFont;
        cell.backgroundColor = _leftTableBgColor;
        if (_leftSelectedRow == indexPath.row) { /// 左边选中行
            cell.backgroundColor = _rightTableBgColor;;
            cell.textLabel.textColor = _leftSelectTextColor;
        }
    }
    
    CGSize textSize;
    if ([self.dataSource respondsToSelector:@selector(menu:RowTitleWithModel:)]) {
        cell.textLabel.text = [self.dataSource menu:self RowTitleWithModel:[KJDropDownMenuModel kIndexPathWithColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow rightRow:indexPath.row]];
        // 只取宽度
        textSize = [cell.textLabel.text textSizeWithFont:_rightTextFont constrainedToSize:CGSizeMake(MAXFLOAT, _rightTextFont.pointSize) lineBreakMode:NSLineBreakByWordWrapping];
    }
    CGFloat iconX = 0;
    if ([self.dataSource respondsToSelector:@selector(menu:RowTextAlignmentForColumn:)]) {
        KJMenuTextAlignmentType type = [self.dataSource menu:self RowTextAlignmentForColumn:self.currentSelectedMenudIndex];
        switch (type) {
            case KJMenuTextAlignmentTypeLeft:
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                iconX = textSize.width + 20;
                break;
            case KJMenuTextAlignmentTypeCenter:
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                iconX = (self.frame.size.width + textSize.width)/2.0 + 10;
                break;
            default:
                break;
        }
    }
    
    if (leftOrRight == 1) {
        /// 右边tableview
        iconX = textSize.width + 20;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
            UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KJDropDownMenu.bundle/ico_make"]];
            iconImageView.frame = CGRectMake(iconX, (self.frame.size.height-12)/2 - 3, 16, 12);
            [cell addSubview:iconImageView];
        }
    }else{
        if (_leftSelectedRow == indexPath.row) {
            /// 是否显示右边的table
            BOOL haveRightTableView = [_dataSource menu:self haveRightTableViewInColumn:_currentSelectedMenudIndex];
            if(!haveRightTableView){
                UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KJDropDownMenu.bundle/ico_make"]];
                iconImageView.frame = CGRectMake(iconX, (self.frame.size.height-12)/2 - 3, 16, 12);
                [cell addSubview:iconImageView];
            }
        }
    }
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger leftOrRight = 0;
    if (_rightTableView == tableView) {
        leftOrRight = 1;
    } else {
        _leftSelectedRow = indexPath.row;
    }
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowWithModel:)]) {
        BOOL haveRightTableView = [_dataSource menu:self haveRightTableViewInColumn:_currentSelectedMenudIndex];
        if ((leftOrRight==0 && !haveRightTableView) || leftOrRight==1) {
            [self confiMenuWithSelectRow:indexPath.row leftOrRight:leftOrRight];
        }
        [self.delegate menu:self didSelectRowWithModel:[KJDropDownMenuModel kIndexPathWithColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow rightRow:indexPath.row]];
        if (leftOrRight==0 && haveRightTableView) {
            [_leftTableView reloadData];
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
            [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [_rightTableView reloadData];
        }
    }
}

- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self.dataSource menu:self RowTitleWithModel:[KJDropDownMenuModel kIndexPathWithColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow rightRow:row]];
    [self animateIdicator:_indicators[_currentSelectedMenudIndex]  leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        self->_show = NO;
    }];
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}

@end

