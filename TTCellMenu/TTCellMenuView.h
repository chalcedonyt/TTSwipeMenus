//
//  TTCellMenuView.h
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMenuItem.h"
#import "TTMenuItems.h"

typedef enum {
    TTCellMenuDirectionRight = 0,
    TTCellMenuDirectionLeft
} TTCellMenuDirection;

@protocol MenuViewDelegate <NSObject>
- (void)resetColor;
@optional
- (void)sendColor:(UIColor *)color;

@end
@interface TTCellMenuView : UIView
@property (nonatomic ) float startThreshold;

@property (nonatomic, strong ) IBOutlet UIView *topView;
@property (nonatomic, strong ) TTMenuItems *menuItems;
@property (nonatomic, strong ) id <MenuViewDelegate> viewDelegate;
- (void)setFrame:(CGRect)frame withItems:(TTMenuItems *)items;
- (void)hasMovedByFloat:(float)x toTheDirection:(TTCellMenuDirection)direction;
- (void)removeMenuItems;
@end
