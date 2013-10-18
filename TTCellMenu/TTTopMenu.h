//
//  TTTopMenu.h
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMenuItem.h"
#import "TTMenuItems.h"
@interface TTTopMenu : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong ) TTMenuItems *menuItems;
@property (nonatomic ) float startThreshold;
- (void)TTMenuScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)parentDidPan:(UIPanGestureRecognizer *)recognizer;
@end
