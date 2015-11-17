# ZFTableViewCell
cell左划菜单自定义
### 效果演示：
![image](https://github.com/renzifeng/ZFTableViewCell/raw/master/ZFTableViewCell.gif)
cell的初始化创建
``` objc
    cell = [[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
    reuseIdentifier:identity
    delegate:self
    inTableView:tableView
    withRowHight:60
    withRightButtonTitles:@[@"编辑",@"下架",@"分享"]
    withRightButtonColors:@[[UIColor greenColor],[UIColor redColor],[UIColor blueColor]]];
```
# 期待
- 如果在使用过程中遇到BUG，或发现功能不够用，希望你能Issues我
- 如果觉得好用请Star!
- 谢谢!