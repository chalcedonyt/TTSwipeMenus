//
//  TTCellMenu.m
//  TTCellMenu
//
//  Created by Timothy Teoh on 3/10/13.
//  Copyright (c) 2013 Timothy Teoh. All rights reserved.
//  Based on ZKRevealingTableViewCell

#import "TTCellMenu.h"



@interface TTCellMenu ()

@property (nonatomic, retain) UIPanGestureRecognizer   *_panGesture;
@property (nonatomic, assign) CGFloat _initialTouchPositionX;
@property (nonatomic, assign) CGFloat _initialHorizontalCenter;
@property (nonatomic, assign) TTCellMenuDirection _lastDirection;
@property (nonatomic, assign) TTCellMenuDirection _currentDirection;


- (void)_slideInFrontViewFromDirection:(TTCellMenuDirection)direction offsetMultiplier:(CGFloat)multiplier;
- (void)_slideOutFrontViewInDirection:(TTCellMenuDirection)direction;


- (void)_setRevealing:(BOOL)revealing;

- (CGFloat)_originalCenter;
- (CGFloat)_bounceMultiplier;

@end

@implementation TTCellMenu
@synthesize menuView, backView;
#pragma mark - Private Properties

@synthesize _panGesture;
@synthesize _initialTouchPositionX;
@synthesize _initialHorizontalCenter;
@synthesize _lastDirection;
@synthesize _currentDirection;

#pragma mark - Public Properties

@dynamic revealing;
@synthesize shouldBounce = _shouldBounce;
@synthesize pixelsToReveal;
@synthesize menuItems = _menuItems;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupWithItems:(TTMenuItems *)menuItems
{
    if( !self._panGesture ){
        self._panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        self._panGesture.delegate = self;
        
        [self addGestureRecognizer:self._panGesture];
    }
    [self.menuView setFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height) withItems:menuItems];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.menuView.startThreshold = self.menuView.menuItems.itemSize.width*.9;
    self.pixelsToReveal = [self.menuView.menuItems widthOfItems]+self.menuView.menuItems.itemMargins.width;
    self.menuView.viewDelegate = self;

}

- (void)sendColor:(UIColor *)color
{
    NSLog(@"Setting back color to %@", [color description] );
    [UIView transitionWithView:self.backView
                      duration:0.2
                       options:UIViewAnimationOptionCurveLinear
                    animations:^ {
                        self.backView.backgroundColor = color;
                        
                    }
                    completion:^(BOOL completed){
                        
                    }];

}

- (void)resetColor
{
    self.backView.backgroundColor = [UIColor blackColor];
}
#pragma mark - Accessors
#import <objc/runtime.h>

static char BOOLRevealing;
- (BOOL)isRevealing
{
	return [(NSNumber *)objc_getAssociatedObject(self, &BOOLRevealing) boolValue];
}
- (void)_setRevealing:(BOOL)revealing
{
	[self willChangeValueForKey:@"isRevealing"];
	objc_setAssociatedObject(self, &BOOLRevealing, [NSNumber numberWithBool:revealing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"isRevealing"];
	
	/*if (self.isRevealing && [self.delegate respondsToSelector:@selector(cellDidReveal:)])
     [self.delegate cellDidReveal:self];*/
}
- (CGFloat)_originalCenter
{
	return ceil(self.menuView.bounds.size.width / 2);
}

#define kMinimumVelocity self.contentView.frame.size.width
#define kMinimumPan      60.0
- (CGFloat)_bounceMultiplier
{
    if (self.shouldBounce) {
        CGFloat offset = ABS(self._originalCenter - self.menuView.center.x);
        return MIN(offset / kMinimumPan, 1.0);
    }
    return 0.f;
}

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
    float panSpeed = 2;
	CGPoint translation           = [recognizer translationInView:self];
	CGPoint currentTouchPoint     = [recognizer locationInView:self];
	CGPoint velocity              = [recognizer velocityInView:self];
	
	CGFloat originalCenter        = self._originalCenter;
	CGFloat currentTouchPositionX = currentTouchPoint.x;
	CGFloat panAmount             = self._initialTouchPositionX - currentTouchPositionX;
	CGFloat newCenterPosition     = self._initialHorizontalCenter - (panAmount*panSpeed);
	CGFloat centerX               = self.menuView.center.x;
    
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		
		// Set a baseline for the panning
		self._initialTouchPositionX = currentTouchPositionX;
		self._initialHorizontalCenter = self.menuView.center.x;
		
		//if ([self.delegate respondsToSelector:@selector(cellDidBeginPan:)])
		//	[self.delegate cellDidBeginPan:self];
        
		
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
		// If the pan amount is negative, then the last direction is left, and vice versa.
		if (newCenterPosition - centerX < 0)
			self._lastDirection = TTCellMenuDirectionLeft;
		else
			self._lastDirection = TTCellMenuDirectionRight;
		
		// Don't let you drag past a certain point depending on direction
		if ( newCenterPosition > originalCenter)
			newCenterPosition = originalCenter;
		
		if (self.pixelsToReveal != 0) {
			// Let's not go waaay out of bounds
			if (newCenterPosition > originalCenter + self.pixelsToReveal)
				newCenterPosition = originalCenter + self.pixelsToReveal;
			
			else if (newCenterPosition < originalCenter - self.pixelsToReveal)
				newCenterPosition = originalCenter - self.pixelsToReveal;
		}else {
			// Let's not go waaay out of bounds
			if (newCenterPosition > self.bounds.size.width + originalCenter)
				newCenterPosition = self.bounds.size.width + originalCenter;
			
			else if (newCenterPosition < -originalCenter)
				newCenterPosition = -originalCenter;
		}
		
		CGPoint center = self.menuView.topView.center;
		center.x = newCenterPosition;
        
        float difference = fabs(center.x - originalCenter);
        
        [self.menuView hasMovedByFloat:difference toTheDirection:self._lastDirection];
        
		self.menuView.layer.position = center;
		
	} else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if( self._lastDirection == TTCellMenuDirectionLeft )
            NSLog(@"Direction is left, velocity %.2f", velocity.x);
        else NSLog(@"Direciton is right, velocity %.2f", velocity.x);

		
		if (self.isRevealing && translation.x != 0) {
			CGFloat multiplier = self._bounceMultiplier;
			if (!self.isRevealing)
				multiplier *= -1.0;
            
			[self _slideInFrontViewFromDirection:self._currentDirection offsetMultiplier:multiplier];
			[self _setRevealing:NO];
            NSLog(@"Restoring frontview (1)");
            [self.menuView.menuItems triggerActiveItem];
            [self.menuView removeMenuItems];
		} else if (translation.x != 0) {
			// Figure out which side we've dragged on.
			TTCellMenuDirection finalDir = TTCellMenuDirectionRight;
			if (translation.x < 0)
				finalDir = TTCellMenuDirectionLeft;
            
			[self _slideInFrontViewFromDirection:finalDir offsetMultiplier:-1.0 * self._bounceMultiplier];
			[self _setRevealing:NO];
            NSLog(@"Restoring frontview (2)");
            if(  fabs(velocity.x) < 100)
                [self.menuView.menuItems triggerActiveItem];
            [self.menuView removeMenuItems];
		}
	}
}

#pragma mark - Sliding
#define kBOUNCE_DISTANCE 7.0

- (void)_slideInFrontViewFromDirection:(TTCellMenuDirection)direction offsetMultiplier:(CGFloat)multiplier
{
	CGFloat bounceDistance;
	
	if (self.menuView.center.x == self._originalCenter)
		return;
	
	switch (direction) {
		case TTCellMenuDirectionRight:
			bounceDistance = kBOUNCE_DISTANCE * multiplier;
            
			break;
		case TTCellMenuDirectionLeft:
			bounceDistance = -kBOUNCE_DISTANCE * multiplier;
			break;
		default:
			@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:direction] forKey:@"direction"]];
			break;
	}
	
	
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction
					 animations:^{ self.menuView.center = CGPointMake(self._originalCenter, self.menuView.center.y); }
					 completion:^(BOOL f) {
                         
						 [UIView animateWithDuration:0.1 delay:0
											 options:UIViewAnimationOptionCurveEaseOut
										  animations:^{ self.menuView.frame = CGRectOffset(self.menuView.frame, bounceDistance, 0); }
										  completion:^(BOOL f2) {
											  
                                              [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{ self.menuView.frame = CGRectOffset(self.menuView.frame, -bounceDistance, 0); }
                                                               completion:NULL];
										  }
						  ];
					 }];
}

- (void)_slideOutFrontViewInDirection:(TTCellMenuDirection)direction;
{
	CGFloat x;
    
	if (self.pixelsToReveal != 0) {
		switch (direction) {
			case TTCellMenuDirectionLeft:
				x = self._originalCenter - self.pixelsToReveal;
                
				break;
			case TTCellMenuDirectionRight:
				x = self._originalCenter + self.pixelsToReveal;
                
                
				break;
                
			default:
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:direction] forKey:@"direction"]];
				break;
		}
	} else {
		switch (direction) {
			case TTCellMenuDirectionLeft:
				x = - self._originalCenter;
                
				break;
			case TTCellMenuDirectionRight:
				x = self.menuView.frame.size.width + self._originalCenter;
				break;
			default:
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:direction] forKey:@"direction"]];
				break;
		}
	}

}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == self._panGesture ) {
		UIScrollView *superview = (UIScrollView *)self.superview;
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:superview];
		
		// Make sure it is scrolling horizontally
		return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO && (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
	}
	return NO;
}

@end

