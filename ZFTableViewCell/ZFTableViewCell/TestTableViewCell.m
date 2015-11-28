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
        withRightButtonTitles:(NSArray *)rightButtonTitles
        withRightButtonColors:(NSArray *)rightButtonColors
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
                       delegate:delegate
                    inTableView:tableView
          withRightButtonTitles:rightButtonTitles
          withRightButtonColors:rightButtonColors];
    if (self){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.cellContentView addSubview:_contentLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _contentLabel.frame = CGRectMake(10, 0, 200, self.bounds.size.height);
}

@end
