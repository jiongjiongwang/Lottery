//
//  HallViewController.h
//  02-Lottery
//
//  Created by 王炯 on 16/5/28.
//  Copyright © 2016年 王炯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HallViewShowCoverDelegate.h"


@interface HallViewController : UITableViewController


@property (nonatomic,weak)id<HallViewShowCoverDelegate> delegate;


@end
