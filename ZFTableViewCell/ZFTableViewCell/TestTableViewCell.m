//
//  TestTableViewCell.m
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "TestTableViewCell.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation TestTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<ZFTableViewCellDelegate>)delegate
                  inTableView:(UITableView *)tableView
                 withRowHight:(CGFloat)rowHeight
        withRightButtonTitles:(NSArray *)rightButtonTitles
        withRightButtonColors:(NSArray *)rightButtonColors
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
                       delegate:delegate
                    inTableView:tableView
                   withRowHight:rowHeight
          withRightButtonTitles:rightButtonTitles
          withRightButtonColors:rightButtonColors];
    if (self){
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, rowHeight)];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.cellContentView addSubview:_contentLabel];
    }
    return self;
}
//-(CGSize)sizeThatFits:(CGSize)size
//{
//    int height = 80;
//    return CGSizeMake(ScreenWidth, height);
//}

@end
