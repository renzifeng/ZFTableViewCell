//
//  ZFTableViewCell.h
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFShareView.h"

#define ZFTableViewCellNotificationChangeToUnexpanded @"ZFTableViewCellNotificationChangeToUnexpanded"

typedef NS_ENUM(NSInteger,ZFTableViewCellState){
    ZFTableViewCellStateUnexpanded = 0,//cell状态关闭
    ZFTableViewCellStateExpanded,//cell状态打开
};

@class ZFTableViewCell;

@protocol ZFTableViewCellDelegate <NSObject>
-(void)buttonTouchedOnCell:(ZFTableViewCell*)cell
               atIndexPath:(NSIndexPath*)indexPath
             atButtonIndex:(NSInteger)buttonIndex;

@end

@interface ZFTableViewCell : UITableViewCell{
    ZFTableViewCellState _state;
}
/** 当前Cell的状态*/
@property (nonatomic,assign) ZFTableViewCellState state;
@property (nonatomic,assign) UITableView *tableView;
/** 右划显示btn的背景视图*/
@property (nonatomic,strong) UIView *buttonsView;
/** 分享的View*/
@property (strong, nonatomic) ZFShareView *shareView;
/** 每个cell上的右划ScrollView */
@property (nonatomic,strong) UIScrollView *scrollView;
/** cell的contentView*/
@property (nonatomic,strong) UIView *cellContentView;
/** 右划编辑的代理*/
@property (nonatomic,assign) id<ZFTableViewCellDelegate> delegate;
/** 按钮的标题*/
@property (nonatomic,copy) NSArray *rightButtonTitles;
/**
 *  自定义Cell
 *
 *  @param style             cell的样式
 *  @param reuseIdentifier   cell的重用标示
 *  @param delegate          ZFTableViewCellDelegate代理
 *  @param tableView         tableView
 *  @param rightButtonTitles 右边按钮的标题数组
 *  @param rightButtonColors 右边按钮的背景颜色数组
 *
 *  @return 返回cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<ZFTableViewCellDelegate>)delegate
                  inTableView:(UITableView*)tableView
                 withRowHight:(CGFloat)rowHeight
        withRightButtonTitles:(NSArray*)rightButtonTitles
        withRightButtonColors:(NSArray *)rightButtonColors;

@end
