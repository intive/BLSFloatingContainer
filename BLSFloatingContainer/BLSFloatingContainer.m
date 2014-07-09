//
//  BLSFloatingContainer.m
//  BLSFloatingContainer
//
//  Created by Arek on 28.06.2014.
//  Copyright (c) 2014 Arkadiusz Banaś. All rights reserved.
//

#import "BLSFloatingContainer.h"

#define kBLSDefaultMargins UIEdgeInsetsMake(70, 5, 5, 5)
#define kBLSMaximizeMinimizeAnimationDuration 0.2
#define kBLSMinimumContainerAlpha 0.2

@interface BLSFloatingContainer () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *controller;
@property BOOL shouldAllowPan;

@end

@implementation BLSFloatingContainer

#pragma mark - Public Methods
- (id)initWithController:(UIViewController <BLSFloatingContainerDelegate> *)controller andMinimizedContainerSize:(CGSize)containerSize
{
    self = [super initWithFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];
    if (self) {
        
        self.clipsToBounds = YES;
        
        // Set default values for properties
        _minimizedContainerMargins = kBLSDefaultMargins; // default margins
        _minimizedContainerPosition = BLSFloatingContainerPositionBottomRight; // default position
        _minizmiedContainerSize = containerSize;
        
        // Add gesture recognizers
        UIPanGestureRecognizer *panGestireRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
        panGestireRecognizer.delegate = self;
        [self addGestureRecognizer:panGestireRecognizer];
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_press:)];
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        UITapGestureRecognizer *tapsGestireRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
        tapsGestireRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapsGestireRecognizer];

        // Assign delgate to controller
        self.delegate = controller;
        
        // Add controller as subview
        self.controller = controller;
        [self addSubview:self.controller.view];
    }
    return self;
}

- (void)addToWindow:(UIWindow *)window atPostion:(BLSFloatingContainerPosition)position andState:(BLSFloatingContainerState)state
{
    // initial values for properties
    _state = state;
    _minimizedContainerPosition = position;
    
    // Add container to window
    _window = window;
    [self.window addSubview:self];
    
    // Change position and state
    [self changePosition:position withAnimation:NO];
    [self changeState:state withAnimation:NO];
}

- (void)changePosition:(BLSFloatingContainerPosition)position withAnimation:(BOOL)animation
{
    // Call delegate method
    if ([self.delegate respondsToSelector:@selector(floatingContainer:willMoveToPosition:)]){
        [self.delegate floatingContainer:self willMoveToPosition:position];
    }

    // set time to 0 if user don't want to animate this action
    NSTimeInterval duration = animation ? kBLSMaximizeMinimizeAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.center = [self _containerCenterForPosition:position];
    } completion:^(BOOL finished) {
        _minimizedContainerPosition = position;
        
        if ([self.delegate respondsToSelector:@selector(floatingContainer:didMoveToPosition:)]){
            [self.delegate floatingContainer:self didMoveToPosition:position];
        }
    }];
}

- (void)changeState:(BLSFloatingContainerState)state withAnimation:(BOOL)animation
{
    if ([self.delegate respondsToSelector:@selector(floatingContainer:willChangeState:andContainerSize:)]){
        [self.delegate floatingContainer:self willChangeState:state andContainerSize:[self _containerSizeForState:state]];
    }
    
    switch (state) {
        case BLSFloatingContainerStateMaximized:
            [self _maximizeWithAnimation:animation];
            break;
        case BLSFloatingContainerStateMinimized:
            [self _minimizeWithAnimation:animation];
            break;
        case BLSFloatingContainerStateClosed:
            [self _closeWithAnimation:animation];
            break;
    }
}

#pragma mark - Private Methods
- (void)_minimizeWithAnimation:(BOOL)animation
{
    // set time to 0 if user don't want to animate this action
    NSTimeInterval duration = animation ? kBLSMaximizeMinimizeAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.frame = [self _containerFrameForPosition:_minimizedContainerPosition];
        
        [self _updateAlpha];
    } completion:^(BOOL finished) {
        _state = BLSFloatingContainerStateMinimized;
        
        if ([self.delegate respondsToSelector:@selector(floatingContainer:didChangedState:andContainerSize:)]){
            [self.delegate floatingContainer:self didChangedState:_state andContainerSize:[self _containerSizeForState:_state]];
        }
    }];
}

- (void)_maximizeWithAnimation:(BOOL)animation
{
    // set time to 0 if user don't want to animate this action
    NSTimeInterval duration = animation ? kBLSMaximizeMinimizeAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.frame = self.window.frame;
    } completion:^(BOOL finished) {
        _state = BLSFloatingContainerStateMaximized;
        
        if ([self.delegate respondsToSelector:@selector(floatingContainer:didChangedState:andContainerSize:)]){
            [self.delegate floatingContainer:self didChangedState:_state andContainerSize:[self _containerSizeForState:_state]];
        }
    }];
}

- (void)_closeWithAnimation:(BOOL)animation
{
    // set time to 0 if user don't want to animate this action
    NSTimeInterval duration = animation ? kBLSMaximizeMinimizeAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{

        CGPoint newCenter;
        BLSFloatingContainerPosition position = [self containerPositionForCenterPoint:self.center];
        
        // If container is on the left side of window hide container view on left side of window
        // else put it on the right side
        if (position == BLSFloatingContainerPositionTopLeft || position == BLSFloatingContainerPositionBottomLeft) {
            newCenter = CGPointMake(-_minizmiedContainerSize.width, self.center.y);
        } else {
            newCenter = CGPointMake(self.window.frame.size.width + _minizmiedContainerSize.width, self.center.y);
        }
        
        self.center = newCenter;
        
    } completion:^(BOOL finished) {
        _state = BLSFloatingContainerStateClosed;
        
        if ([self.delegate respondsToSelector:@selector(floatingContainer:didChangedState:andContainerSize:)]){
            [self.delegate floatingContainer:self didChangedState:_state andContainerSize:[self _containerSizeForState:_state]];
        }
    }];

}

// Call this method after paning. It will calculate new proper center point for each position
- (void)_alignToMarginsWithAnimation:(BOOL)animation
{
    BLSFloatingContainerPosition currentPosition = [self containerPositionForCenterPoint:self.center];
    [self changePosition:currentPosition withAnimation:animation];
}

// Method will calculate center point for each position
- (CGPoint)_containerCenterForPosition:(BLSFloatingContainerPosition)position
{
    CGFloat x;
    CGFloat y;
    
    CGRect windowFrame = self.window.frame;
    
    if (BLSFloatinContainerPositionIsOnTop(position)) {
        y = _minimizedContainerMargins.top + _minizmiedContainerSize.height/2;
    } else {
        y = windowFrame.size.height - _minimizedContainerMargins.bottom - _minizmiedContainerSize.height/2;
    }
    
    if (BLSFloatinContainerPositionIsOnLeft(position)) {
        x = _minimizedContainerMargins.left + _minizmiedContainerSize.width/2;
    } else {
        x = windowFrame.size.width - _minimizedContainerMargins.right - _minizmiedContainerSize.width/2;
    }
    
    CGPoint ret =CGPointMake(x, y);
    
    return ret;
}

// Return container size for position.
- (CGSize)_containerSizeForState:(BLSFloatingContainerState)state
{
    if (state == BLSFloatingContainerStateMaximized){
        return self.window.frame.size;
    }
    
    return _minizmiedContainerSize;
}

// Helper method. It will return proper frame (of minimized container) for position argument.
- (CGRect)_containerFrameForPosition:(BLSFloatingContainerPosition)position
{
    CGPoint center = [self _containerCenterForPosition:position];
    return CGRectMake(center.x - _minizmiedContainerSize.width/2,
                      center.y - _minizmiedContainerSize.height/2,
                      _minizmiedContainerSize.width,
                      _minizmiedContainerSize.height);
}

// Return position of minimized container view for center point.
- (BLSFloatingContainerPosition)containerPositionForCenterPoint:(CGPoint)center
{
    CGFloat horizontalBoundary = self.window.frame.size.width/2;
    CGFloat verticalBoundary = self.window.frame.size.height/2;
    
    BLSFloatingContainerPosition position = BLSFloatingContainerPositionBottomRight;
    
    if (center.x < horizontalBoundary && center.y < verticalBoundary){ //TopLeft
        position = BLSFloatingContainerPositionTopLeft;
    } else if (center.x > horizontalBoundary && center.y < verticalBoundary){ // TopRight
        position = BLSFloatingContainerPositionTopRight;
    } else if (center.x < horizontalBoundary && center.y > verticalBoundary){ // BottomLeft
        position = BLSFloatingContainerPositionBottomLeft;
    }
    
    return position;
}

// Method will calculte new alpha value of container for current conter point.
- (void)_updateAlpha
{
    BOOL canCloseContainer = [self.delegate canCloseFloatingPlayerContainer:self];
    if (!canCloseContainer){
        self.alpha = 1.0f;
        return;
    }
    
    CGFloat leftBound = self.frame.origin.x;
    CGFloat rightBound = leftBound + self.frame.size.width;
    
    if (rightBound >= self.window.frame.size.width - _minimizedContainerMargins.right){
        self.alpha = [self _alphaForRightMarginOffset:rightBound];
    } else if (leftBound < _minimizedContainerMargins.left){
        self.alpha = [self _alphaForLeftMarginOffset:leftBound];
        
    } else {
        self.alpha = 1.0f;
    }
}

// Helper method for updating alpha value. Calculation of alpha for right side of window
- (CGFloat)_alphaForRightMarginOffset:(CGFloat)margin
{
    CGFloat left = self.window.frame.size.width - _minimizedContainerMargins.right;
    
    CGFloat alpha =  1 - (margin - left)/20;
    if (alpha < kBLSMinimumContainerAlpha){
        alpha = kBLSMinimumContainerAlpha;
    }
    return alpha;
}

// Helper method for updating alpha value. Calculation of alpha for left side of window
- (CGFloat)_alphaForLeftMarginOffset:(CGFloat)margin
{
    CGFloat alpha;
    if (margin < 0){
        alpha = 1 - (- margin + _minimizedContainerMargins.left)/15;
    } else {
        alpha = 1 - (_minimizedContainerMargins.left - margin)/15;
    }
    
    if (alpha < kBLSMinimumContainerAlpha){
        alpha = kBLSMinimumContainerAlpha;
    }
    
    return alpha;
}

- (void)_commitStartPaningAnimation
{
    CGFloat sizeDifference = 5.0f;
    [UIView animateWithDuration:0.08 animations:^{
        // make container smaller
        self.frame = CGRectInset(self.frame, sizeDifference, sizeDifference);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08 animations:^{
            // if 'making small animation' finished start returning container to previous size
            self.frame = CGRectInset(self.frame, -sizeDifference, -sizeDifference);
        }];
    }];
}

#pragma mark - Gesture Recognizers
- (void)_pan:(UIPanGestureRecognizer *)sender
{
    if (self.shouldAllowPan){
        CGPoint center = [sender locationInView:self.window];
        self.center = center;
        
        if ([self.delegate respondsToSelector:@selector(floatingContainer:didPanWithCenterPoint:)]){
            [self.delegate floatingContainer:self didPanWithCenterPoint:center];
        }
        
        [self _updateAlpha];
    }
}

- (void)_press:(UILongPressGestureRecognizer *)sender
{
    // allow panning only during minimized state
    if (_state != BLSFloatingContainerStateMinimized){
        return;
    }
    
    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
        self.shouldAllowPan = NO;
        
        if (self.alpha < 0.3){
            [self _closeWithAnimation:YES];
        } else {
            [self _alignToMarginsWithAnimation:YES];
            [self _updateAlpha];
        }
        
    } else {
        // if start paning commit animation
        if (!self.shouldAllowPan){
            [self _commitStartPaningAnimation];
        }
        
        self.shouldAllowPan = YES;
    }
}

- (void)_tap:(UITapGestureRecognizer *)tap
{
    BLSFloatingContainerState newState = _state == BLSFloatingContainerStateMaximized ? BLSFloatingContainerStateMinimized : BLSFloatingContainerStateMaximized;
    [self changeState:newState withAnimation:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ! self.shouldAllowPan) {
        return NO;
    }
    return YES;
}


@end
