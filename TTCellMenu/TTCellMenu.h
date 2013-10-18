//
//  TTCellMenu.h
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TTCellMenuView.h"
#import "TTMenuItems.h"

@interface TTCellMenu : UITableViewCell <UIGestureRecognizerDelegate, MenuViewDelegate>
@property (nonatomic, strong ) TTMenuItems *menuItems;
@property (nonatomic, strong ) IBOutlet TTCellMenuView *menuView;
@property (nonatomic, strong ) IBOutlet UIView *backView;
@property (nonatomic, assign, getter = isRevealing) BOOL revealing;
@property (nonatomic, assign) BOOL shouldBounce;
@property CGFloat pixelsToReveal;
- (void)setupWithItems:(TTMenuItems *)menuItems;
@end