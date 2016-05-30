//
//  MainSettingController.m
//  02-Lottery
//
//  Created by 王炯 on 16/5/29.
//  Copyright © 2016年 王炯. All rights reserved.
//

#import "MainSettingController.h"
#import "CodeViewController.h"


@interface MainSettingController ()

@property (nonatomic,strong)NSArray *dataArray;


@end

@implementation MainSettingController

#warning 重写init方法，使MainSettingController在初始化的时候就是Grouped类型的tabelView
-(instancetype)init
{
    // 返回分组型的tableView
    return [super initWithStyle:UITableViewStyleGrouped];
}



static NSString *cellIdentify = @"MainSetting";

//懒加载dataArray，从plist文件中取数据
-(NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.plistName ofType:nil];
        
        _dataArray = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _dataArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

//(1)组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

//(2)行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionItem = self.dataArray[section];
    
    NSArray *rowArray = sectionItem[@"Items"];
    
    return rowArray.count;
}
//(3)行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据plist的内容来设置cell的各项属性
    NSDictionary *sectionItem = self.dataArray[indexPath.section];
    NSArray *rowArray = sectionItem[@"Items"];
    NSDictionary *rowItem = rowArray[indexPath.row];
    
    //(0)从plist文件中获取CellStyle信息
    NSString *styleString;
    
    if (!(rowItem[@"cellStyle"]))
    {
        styleString = @"UITableViewCellStyleDefault";
    }
    else
    {
        styleString = rowItem[@"cellStyle"];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
#warning 利用initWithStyle的形式来创建tabelView的cell
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:[self cellStyleWith:styleString] reuseIdentifier:cellIdentify];
    }
    
    
    
    //(1)设置cell的textLabel和imageView
    cell.textLabel.text = rowItem[@"title"];
    
    //判断有无照片
    if (rowItem[@"icon"])
    {
        cell.imageView.image = [UIImage imageNamed:rowItem[@"icon"]];
    }
    
    
    
    
    //(2)设置cell的accessoryView
    if (rowItem[@"accessoryType"])
    {
        NSString *acceStr = rowItem[@"accessoryType"];
        
#warning (1)利用运行时系统将字符串转为类
        Class className = NSClassFromString(acceStr);
        
#warning (2)利用类创建对象(使用id类型)
        id obj = [[className alloc] init];
        
#warning (3)判断类的类型
        if ([obj isKindOfClass:[UIImageView class]])
        {
            //imageView时(箭头的图标)
#warning 将obj类型强制转换成UIImageView类型
            UIImageView *imgView = (UIImageView *)obj;
            
            imgView.image = [UIImage imageNamed:rowItem[@"accessoryName"]];
            
#warning 根据图片大小自动设置imageView大小
            [imgView sizeToFit];
            
            //添加到accessoryView上
            cell.accessoryView = imgView;
        }
        else
        {
            //UISwitch的图标时
            UISwitch *switchView = (UISwitch *)obj;
            cell.accessoryView = switchView;
        }
    }
    
    
    //(3)设置detail信息
    if ([styleString isEqualToString:@"UITableViewCellStyleSubtitle"]||[styleString isEqualToString:@"UITableViewCellStyleValue1"])
    {
        cell.detailTextLabel.text = rowItem[@"SubTitle"];
        
        //设置字体红色
        if (rowItem[@"highLight"])
        {
            BOOL isHightLight = [rowItem[@"highLight"] boolValue];
            if (isHightLight)
            {
                cell.detailTextLabel.textColor = [UIColor redColor];
            }
        }
        
    }
    
    return cell;
}


//根据plist文件中的cellStyle信息来返回cell的style
-(UITableViewCellStyle)cellStyleWith:(NSString *)styleString
{
    UITableViewCellStyle style;
    
    if ([styleString isEqualToString:@"UITableViewCellStyleDefault"])
    {
        style = UITableViewCellStyleDefault;
    }
    else if ([styleString isEqualToString:@"UITableViewCellStyleValue1"])
    {
        style = UITableViewCellStyleValue1;
    }
    else if ([styleString isEqualToString:@"UITableViewCellStyleValue2"])
    {
        style = UITableViewCellStyleValue2;
    }
    else
    {
        style = UITableViewCellStyleSubtitle;
    }
    return style;

}


//(4)代理方法，实现点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从plist文件中获取targetVC信息
    NSDictionary *sectionItem = self.dataArray[indexPath.section];
    NSArray *rowArray = sectionItem[@"Items"];
    NSDictionary *rowItem = rowArray[indexPath.row];
    
    
    if (rowItem[@"targetVC"])
    {
        NSString *targetVC = rowItem[@"targetVC"];
        
        //根基targetVC判断切换到的新控制器类型
#warning (1)利用运行时系统将字符串转为类
        Class className = NSClassFromString(targetVC);
        
#warning (2)利用类创建对象(使用id类型)
        id obj = [[className alloc] init];
        
#warning (3)判断类的类型(子类也会返回YES）
        if ([obj isKindOfClass:[MainSettingController class]])
        {
            
#warning 当ScoreSettingController类是MainSettingController的子类时，此时的比分直播推送界面对应的类是ScoreSettingController类
            
            MainSettingController *pushSetting = (MainSettingController *)obj;
            
            //设置plistName，加载数据
            pushSetting.plistName = rowItem[@"plistName"];
            
            [self.navigationController pushViewController:pushSetting animated:YES];
        }
        else
        {
            CodeViewController *codeVC = (CodeViewController *)obj;
            
            [self.navigationController pushViewController:codeVC animated:YES];
        }
    }
    
}

//(5)返回组头信息
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionItem = self.dataArray[section];
    
    return sectionItem[@"Header"];
}

//(6)返回组尾信息
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSDictionary *sectionItem = self.dataArray[section];
    
    return sectionItem[@"Footer"];
}


@end
