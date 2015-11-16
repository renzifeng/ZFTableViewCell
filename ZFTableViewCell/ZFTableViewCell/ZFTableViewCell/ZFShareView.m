//
//  ZFShareView.m
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/14.
//  Copyright © 2015年 任子丰. All rights reserved.
//

#import "ZFShareView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation ZFShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *titleArr = @[@"qq",@"微博",@"微信",@"朋友圈"];
        NSArray *colorArr = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor grayColor]];
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ScreenWidth/4*i, 0, ScreenWidth/4, frame.size.height);
            btn.tag = i;
            btn.backgroundColor = colorArr[i];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)shareAction:(UIButton *)sender
{
    if (self.shareBlock) {
        self.shareBlock(sender.tag);//对外回调，点击分享按钮的下标
    }
}

@end
