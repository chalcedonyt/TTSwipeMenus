//
//  TTTopMenu.m
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import "TTTopMenu.h"
@interface TTTopMenu()
@property (nonatomic ) float fadeDistance;
@property (nonatomic ) BOOL isShowing;
@end

@implementation TTTopMenu
@synthesize menuItems = _menuItems;
@synthesize isShowing = _isShowing;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fadeDistance = 10.0f;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
- (void)setMenuItems:(TTMenuItems *)menuItems
{
        
    for( int i = 0; i < [menuItems count];i++ ){
        TTMenuItem *item = (TTMenuItem *)[menuItems objectAtIndex:i];

        [item setFrame:CGRectMake(item.originalSize.width*i,30-(item.originalSize.height/2),item.originalSize.width, item.originalSize.height)];
        [self addSubview:item];
    }
    _menuItems = menuItems;
}

- (void)parentDidPan:(UIPanGestureRecognizer *)recognizer
{
	CGPoint currentTouchPoint     = [recognizer locationInView:self];

        NSLog(@"Panned at %@ vs %.2f, velocity %.2f", NSStringFromCGPoint(    [recognizer translationInView:self]), self.startThreshold, [recognizer velocityInView:self].y);
    float difference = fabs( [recognizer translationInView:self].y);
    if( difference > self.startThreshold ){
        self.isShowing = YES;
        NSLog(@"Showing! (%.2f is more than %.2f)", difference, self.startThreshold);
        
    } else
    {
        NSLog(@"Not showing!");        
        self.isShowing = NO;
        self.menuItems.activeMenuItem = nil;
    }
    
    if( self.isShowing  ){

        int activeIndex = [self.menuItems indexUsingWidthFromOffset:currentTouchPoint.x];

        [self.menuItems setActiveItemByIndex:activeIndex];
	}
}
//activates the horizontal menu if the view is being pulled down
- (void)TTMenuScrollViewDidScroll:(UIScrollView *)scrollView
{
   /* float difference = fabs(scrollView.contentOffset.y);
    
    //NSLog(@"scrolled by %.2f", difference);
    if( difference > self.startThreshold ){
        self.isShowing = YES;

    } else
    {
        self.isShowing = NO;
        self.menuItems.activeMenuItem = nil;        
    }*/
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
