//
//  TTMenuItem.m
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/9/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import "TTMenuItem.h"

@implementation TTMenuItem
@synthesize isInMenu, originalSize, isAnimating, offset, indexPath, backColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
