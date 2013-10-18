//
//  TTMenuItem.h
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/9/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMenuItem : UIButton
@property (nonatomic ) BOOL isInMenu;
@property (nonatomic ) CGSize originalSize;
@property (nonatomic ) BOOL isAnimating;
@property (nonatomic ) int offset;
@property ( nonatomic, strong ) NSIndexPath *indexPath;
@property (nonatomic, strong ) UIColor *backColor;
@end
