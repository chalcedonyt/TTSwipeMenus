//
//  TTMenuItems.h
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMenuItem.h"

@interface TTMenuItems : NSObject
@property (nonatomic)CGSize itemSize;
@property (nonatomic)CGSize itemMargins;
@property (nonatomic, strong ) NSIndexPath *indexPath;
@property (nonatomic, strong ) TTMenuItem *activeMenuItem;
@property (nonatomic, strong ) NSMutableArray *visibleItems;
@property (nonatomic ) BOOL shouldHideOnDeselect;
- (float)heightOfItems;
- (float)widthOfItems;
- (int)count;
- (id)objectAtIndex:(NSUInteger)offset;
- (id) initWithArrayOfButtons:(NSArray *)array withItemSize:(CGSize )size withItemMargins:(CGSize)margins;
- (id) init;
- (int) indexUsingHeightFromOffset:(float)y;
- (int) indexUsingWidthFromOffset:(float)x;
- (void)triggerActiveItem;
- (void)setActiveItemByIndex:(int)offset;
@end
