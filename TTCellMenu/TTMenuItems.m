//
//  TTMenuItems.m
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//  Problem getting properties to work with categories, can't subclass NSMutableArray, so have to do this

#import "TTMenuItems.h"
@interface TTMenuItems()
@property (nonatomic, strong ) NSMutableArray *items;
@end
@implementation TTMenuItems
@synthesize itemMargins, indexPath, visibleItems, shouldHideOnDeselect;
@synthesize itemSize = _itemSize;
@synthesize activeMenuItem = _activeMenuItem;
- (id) init
{
    self = [super init];
    self.itemSize = CGSizeMake(0,0);
    self.itemMargins = CGSizeMake(0,0);
    return self;
}
- (id) initWithArrayOfButtons:(NSArray *)array withItemSize:(CGSize )size withItemMargins:(CGSize)margins
{
    self = [super init];
    self.shouldHideOnDeselect = YES;
    self.items = [NSMutableArray arrayWithArray:array];
    self.itemSize = size;
    self.itemMargins = margins;
    self.visibleItems = [[NSMutableArray alloc] init];
    return self;
}

- (int) indexUsingHeightFromOffset:(float)y
{
    return floor(y/self.itemSize.height);
}
- (int) indexUsingWidthFromOffset:(float)x
{

    int index = floor(x/self.itemSize.width);
       
    return index;
}
- (float)heightOfItems
{
    return ( [self.items count] * self.itemSize.height );
}
- (float)widthOfItems
{
    return ( [self.items count] * self.itemSize.width );
}
- (int)count
{
    return [self.items count];
}
- (id)objectAtIndex:(NSUInteger)offset
{
    return [self.items objectAtIndex:offset];
}
- (void)triggerActiveItem
{
    NSLog(@"Triggering item");
    if( self.activeMenuItem )
        [self.activeMenuItem sendActionsForControlEvents:UIControlEventTouchUpInside];
}
- (void)setActiveMenuItem:(TTMenuItem *)activeMenuItem
{
    if( !activeMenuItem ){
        if( self.activeMenuItem )
            self.activeMenuItem.highlighted = NO;
    }
    _activeMenuItem = activeMenuItem;
}


- (void)setActiveItemByIndex:(int)offset
{
    if( offset >= [self.items count] )
        offset = [self.items count]-1;
    for( int i = 0; i < [self.items count]; i++ ){
        TTMenuItem *item = (TTMenuItem *)[self.items objectAtIndex:i];
        if( !item.isInMenu && self.shouldHideOnDeselect )
            continue;
        if( i == offset ){
            self.activeMenuItem = item;
            item.highlighted = YES;
        }
        else item.highlighted = NO;
    }
}
@end
