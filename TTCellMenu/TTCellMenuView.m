//
//  TTCellMenuView.m
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import "TTCellMenuView.h"

@interface TTCellMenuView()
@property (nonatomic ) float originalWidth;

@end

@implementation TTCellMenuView

@synthesize startThreshold, topView, menuItems, viewDelegate;

- (void)setFrame:(CGRect)frame withItems:(TTMenuItems *)items;
{
    self.originalWidth = self.frame.size.width;
    self.menuItems = items;
}

- (void)hasMovedByFloat:(float)x toTheDirection:(TTCellMenuDirection)direction
{
    if( x > self.startThreshold  ){
        NSLog(@"Front moved by %.2f (array count is %d)", x, [self.menuItems count] );
        
        int index = [self.menuItems indexUsingWidthFromOffset:x-self.startThreshold];

        NSLog(@"Index related is %d", index );

        [self addMenuItemAtIndex:index];
        [self removeMenuItemsAfterIndex:index];
        [self.menuItems setActiveItemByIndex:index];
        if( self.menuItems.activeMenuItem.backColor && [self.viewDelegate respondsToSelector:@selector(sendColor:)] ){
            NSLog(@"Setting color");
            [self.viewDelegate sendColor:self.menuItems.activeMenuItem.backColor];
        }
        /* if( direction == TTCellMenuDirectionRight && offset > 0){
         
         }*/
    }
    else{
        self.menuItems.activeMenuItem = nil;
        [self.viewDelegate resetColor];
        [self removeMenuItems];
    }
}

- (void)addMenuItemAtIndex:(NSUInteger)index
{
    if( index >= [self.menuItems count] ) return;
    
    TTMenuItem *item = (TTMenuItem *)[self.menuItems objectAtIndex:index];
    if( ![self.subviews containsObject:item] && !item.isAnimating){
        
        float itemX = self.originalWidth + self.menuItems.itemMargins.width + (self.menuItems.itemSize.width*index);
        item.isInMenu = YES;
        item.isAnimating = YES;
        item.tag = 10+index;
        [item setFrame:CGRectMake(itemX,self.center.y-(item.originalSize.height/4),item.originalSize.width/2, item.originalSize.height/2)];
        [[self viewWithTag:item.tag] removeFromSuperview];
        item.alpha = 0;
        [self addSubview:item];

        [UIView transitionWithView:self
                          duration:0.2
                           options:UIViewAnimationOptionCurveLinear
                        animations:^ {
                            [item setFrame:CGRectMake(itemX,self.center.y-(item.originalSize.height/2),item.originalSize.width, item.originalSize.height)];
                            item.alpha = 1;
                            
                        }
                        completion:^(BOOL completed){

                        }];
        
    }
}
- (void)removeMenuItemsAfterIndex:(int)index
{
    //    NSLog(@"Remove items after %d", index);
    if( index >= 0){
        for( int i = index+1; i < [self.menuItems count]; i++ ){
            [self removeMenuItemAtIndex:i];
        }
    }
}

- (void)removeMenuItems
{
   // NSLog(@"Removing all menu items");
    for( int i = 0; i < [self.menuItems count]; i++ ){
        
        [self removeMenuItemAtIndex:i];
    }
}
- (void)removeMenuItemAtIndex:(int)i
{
   // NSLog(@"Remove item %d", i);
    TTMenuItem *item = (TTMenuItem *)[self viewWithTag:(10+i)];
    if( !item )
        return;
    item.isInMenu = NO;
    item.isAnimating = YES;
    [self.viewDelegate resetColor];
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionCurveLinear
                    animations:^ {
                        [item setFrame:CGRectMake(item.frame.origin.x+(item.originalSize.width/4),self.center.y-(item.originalSize.height/4),item.originalSize.width/2, item.originalSize.height/2)];
                        item.alpha = 0;
                    }
                    completion:^(BOOL completion){

                        int tagToRemove = 10+i;
                            [[self viewWithTag:tagToRemove] removeFromSuperview];
                            item.isAnimating = NO;                        
                        /*dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [[self viewWithTag:tagToRemove] removeFromSuperview];
                            item.isAnimating = NO;
                        });*/
                    }];
    
    
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
