//
//  ZFTableViewCell.m
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "ZFTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZFTableViewCellButtonWidth 60.0f
#define ZFTableViewCellNotificationEnableScroll @"ZFTableViewCellNotificationEnableScroll"
#define ZFTableViewCellNotificationUnenableScroll @"ZFTableViewCellNotificationUnenableScroll"

@interface ZFTableViewCell()<UIScrollViewDelegate>{
    ZFTableViewCellState _state;/** cell的状态*/
    UIPanGestureRecognizer* _panGesture;/** pan手势*/
}
/** tableView*/
@property (nonatomic,assign) UITableView *tableView;
/** 按钮的标题*/
@property (nonatomic,copy) NSArray *rightButtonTitles;
/** 当前Cell的状态*/
@property (nonatomic,assign) ZFTableViewCellState state;
/** 右划显示btn的背景视图*/
@property (nonatomic,strong) UIView *buttonsView;

@end

@implementation ZFTableViewCell
/** 正在修改的cell*/
static ZFTableViewCell *_editingCell;
@dynamic state;

/**
 *  自定义Cell
 *
 *  @param style             cell的样式
 *  @param reuseIdentifier   cell的重用标示
 *  @param delegate          ZFTableViewCellDelegate代理
 *  @param tableView         tableView
 *  @param rowHeight         每一行cell的高度
 *  @param rightButtonTitles 右边按钮的标题数组
 *  @param rightButtonColors 右边按钮的背景颜色数组
 *
 *  @return 返回cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<ZFTableViewCellDelegate>)delegate
                  inTableView:(UITableView *)tableView
                 withRowHight:(CGFloat)rowHeight
        withRightButtonTitles:(NSArray*)rightButtonTitles
        withRightButtonColors:(NSArray *)rightButtonColors
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tableView = tableView;
        self.delegate = delegate;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, rowHeight)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth + ZFTableViewCellButtonWidth * (rightButtonTitles.count), rowHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_scrollView];
        
        //cell的分享部分
        _shareView = [[ZFShareView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, rowHeight)];
        _shareView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_shareView];
        
        //右边的Btn
        self.rightButtonTitles = rightButtonTitles;
        CGFloat leftButtonViewWidth = ZFTableViewCellButtonWidth * self.rightButtonTitles.count;
        _buttonsView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-leftButtonViewWidth, 0,
                                                               leftButtonViewWidth, rowHeight)];
        [self.scrollView addSubview:_buttonsView];
        
        CGFloat buttonWidth = ZFTableViewCellButtonWidth;
        CGFloat buttonHeight = rowHeight;
        for (int a = 0; a < self.rightButtonTitles.count; a++) {
            CGFloat left = a * (ZFTableViewCellButtonWidth);
            UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(left, 0, buttonWidth,buttonHeight)];
            button.tag = a;
            button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            button.backgroundColor = rightButtonColors[a];
            [button setTitle:self.rightButtonTitles[a] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonsView addSubview:button];
        }
        
        //cell的内容部分
        CGRect cellContentViewFrame = self.bounds;
        if ([self.tableView respondsToSelector:@selector(separatorInset)]){
            cellContentViewFrame = CGRectMake(0, 0, ScreenWidth, rowHeight);
        }
        _cellContentView = [[UIView alloc]initWithFrame:cellContentViewFrame];
        _cellContentView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_cellContentView];
        
        
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)];
        [self.cellContentView addGestureRecognizer:tapGesture];
        
        
//        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
//        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight |
//        UISwipeGestureRecognizerDirectionLeft  |
//        UISwipeGestureRecognizerDirectionUp   |
//        UISwipeGestureRecognizerDirectionDown;
//        [self.cellContentView addGestureRecognizer:swipeGesture];
        
        ///外部通知，把cell改为原来的状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChangeToUnexpanded:) name:ZFTableViewCellNotificationChangeToUnexpanded object:nil];
        ///内部通知所有的cell可以滚动scrollView了
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnableScroll:) name:ZFTableViewCellNotificationEnableScroll object:nil];
        ///内部通知所有的cell不可以滚动scrollView(除当前编辑的这个外)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUnenableScroll:) name:ZFTableViewCellNotificationUnenableScroll object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    [self.scrollView setContentOffset:CGPointZero];
}
#pragma mark - Properties
-(void)setState:(ZFTableViewCellState)state{
    _state = state;
    if (state == ZFTableViewCellStateExpanded){
        [self.scrollView setContentOffset:CGPointMake(self.buttonsView.frame.size.width, 0.0f) animated:YES];
        _editingCell = self;
        ///通知所有的cell停止滚动(除自己这个)
        [[NSNotificationCenter defaultCenter] postNotificationName:ZFTableViewCellNotificationUnenableScroll object:nil];
        ///往tableView上添加一个手势处理,使得在tableView上的拖动也只是影响当前这个cell的scrollView
        if (!_panGesture){
            _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanGesture:)];
            [self.tableView addGestureRecognizer:_panGesture];
        }
    }
    else if(state == ZFTableViewCellStateUnexpanded){
        ///停止tableView的手势
        if (_panGesture){
            [self.tableView removeGestureRecognizer:_panGesture];
            _panGesture = nil;
        }
        ///为了不让快速按下时鼓动状态固定在一半，一开始就先停止触摸
        self.tableView.userInteractionEnabled = NO;
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.tableView.userInteractionEnabled = YES;
        });
        ///
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        ///tableView可以滚动了
        _editingCell = nil;
        self.tableView.scrollEnabled = YES;
        self.tableView.allowsSelection = YES;
        ///通知所有的cell可以滚动
        [[NSNotificationCenter defaultCenter] postNotificationName:ZFTableViewCellNotificationEnableScroll object:nil];
    }
    [UIView animateWithDuration:.3 animations:^{
        self.shareView.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
    }];
}
-(ZFTableViewCellState)state{
    return _state;
}
#pragma mark - Action
-(void)onButton:(id)sender{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:self];
    UIButton* button = (UIButton*)sender;
    if ([self.delegate respondsToSelector:@selector(buttonTouchedOnCell:atIndexPath:atButtonIndex:)]){
        [self.delegate buttonTouchedOnCell:self atIndexPath:indexPath atButtonIndex:button.tag];
    }
}
#pragma mark - Gesture
-(void)onTapGesture:(UITapGestureRecognizer*)recognizer{
    if (_editingCell){
        _editingCell.state = ZFTableViewCellStateUnexpanded;
    }
    else{
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
        }
    }
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    _editingCell.state = ZFTableViewCellStateUnexpanded;
}

-(void)onPanGesture:(UIPanGestureRecognizer*)recognizer{
    if (!_editingCell)
    {
        [self.tableView removeGestureRecognizer:_panGesture];
        _panGesture = nil;
       return;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged){
        CGFloat translate_x = [recognizer translationInView:_editingCell.tableView].x;
        CGFloat offset_x = self.buttonsView.frame.size.width;
        CGFloat move_offset_x = offset_x-translate_x;
        [_editingCell.scrollView setContentOffset:CGPointMake(move_offset_x, 0)];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded||
             recognizer.state == UIGestureRecognizerStateCancelled ||
             recognizer.state == UIGestureRecognizerStateFailed){
        _editingCell.state = ZFTableViewCellStateUnexpanded;
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.buttonsView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0.0f);
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x >= self.buttonsView.frame.size.width/2 ){
        self.state = ZFTableViewCellStateExpanded;
    }
    else{
        self.state = ZFTableViewCellStateUnexpanded;
    }
}

#pragma mark - Notififcation
///外部通知，把cell改为原来的状态
-(void)notificationChangeToUnexpanded:(NSNotification*)notification{
    self.state = ZFTableViewCellStateUnexpanded;
}
///内部通知所有的cell可以滚动scrollView了
-(void)notificationEnableScroll:(NSNotification*)notification{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}
///内部通知所有的cell不可以滚动scrollView(除当前编辑的这个外)
-(void)notificationUnenableScroll:(NSNotification*)notification{
    if (_editingCell != self) {
        self.scrollView.scrollEnabled = YES;
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        [UIView animateWithDuration:.3 animations:^{
            self.shareView.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        }];
    }
}@end
