//
//  ZFShareView.h
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/14.
//  Copyright © 2015年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareViewBlock)(NSInteger);

@interface ZFShareView : UIView
/** 对外暴露，点击分享的回调*/
@property (copy, nonatomic) ShareViewBlock shareBlock;

@end
