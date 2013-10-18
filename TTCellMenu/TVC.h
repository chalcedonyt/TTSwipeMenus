//
//  TVC.h
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/9/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTopMenu.h"
#import "TTCellMenu.h"
#import "TTMenuItems.h"
#import "TTMenuItem.h"
@interface TVC : UITableViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong ) TTTopMenu *topMenu;
@end
