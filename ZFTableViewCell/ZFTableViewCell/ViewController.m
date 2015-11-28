//
//  ViewController.m
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "ViewController.h"
#import "ZFTableViewCell.h"
#import "TestTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,ZFTableViewCellDelegate,UIActionSheetDelegate>{
    NSMutableArray* _rows;
}
@property (nonatomic,retain) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_rows){
        _rows = [[NSMutableArray alloc]init];
    }
    for (int a = 0; a < 30; a++) {
        [_rows addObject:[NSString stringWithFormat:@"Cell in Table at Row :%d",a]];
    }
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}
#pragma mark - UITableDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 == 0) {
        return 60;
    }
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rows.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity = @"FDFeedCell";
    TestTableViewCell* cell = (TestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell){
        cell = [[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identity
                                              delegate:self
                                           inTableView:tableView
                                 withRightButtonTitles:@[@"编辑",@"下架",@"分享"]
                                 withRightButtonColors:@[[UIColor greenColor],[UIColor redColor],[UIColor blueColor]]];
    }
    cell.contentLabel.text = _rows[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"select row at indexPath:%ld",(long)indexPath.row);
}
#pragma mark - ZFTableViewCellDelegate
-(void)buttonTouchedOnCell:(ZFTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
    if (buttonIndex == 0){
     
    }else if (buttonIndex == 1){
        [_rows removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }else if (buttonIndex == 2) {
        //分享
        [cell.scrollView setContentOffset:CGPointMake(ScreenWidth, 0.0f) animated:YES];
        [UIView animateWithDuration:.3 animations:^{
            cell.shareView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
            cell.shareView.frame = CGRectMake(0, cell.shareView.frame.origin.y, cell.shareView.frame.size.width, cell.shareView.frame.size.height);
        }];
        cell.shareView.shareBlock = ^(NSInteger index) {
            NSLog(@"点击了第%zd个",index);
            //把cell复原
            [[NSNotificationCenter defaultCenter] postNotificationName:ZFTableViewCellNotificationChangeToUnexpanded object:nil];
        };
        return;
    }
    //把cell复原
    [[NSNotificationCenter defaultCenter] postNotificationName:ZFTableViewCellNotificationChangeToUnexpanded object:nil];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //通知，把cell改为原来的状态
    [[NSNotificationCenter defaultCenter] postNotificationName:ZFTableViewCellNotificationChangeToUnexpanded object:nil];
}
@end
