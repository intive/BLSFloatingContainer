//
//  BLSFloatingContainer.h
//  BLSFloatingContainer
//
//  Created by Arek on 28.06.2014.
//  Copyright (c) 2014 Arkadiusz Banaś. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLSFloatingContainerEnums.h"
#import "BLSFloatingContainerDelegate.h"

@interface BLSFloatingContainer : UIView

/**
 *  Size of minimized container
 */
@property (nonatomic, readonly) CGSize minizmiedContainerSize;

/**
 *  Position of minimized container
 *  @see BLSFloatingContainerPosition
 */
@property (nonatomic, readonly) BLSFloatingContainerPosition minimizedContainerPosition;

/**
 *  Current container state
 *  @see BLSFloatingContainerState
 */
@property (nonatomic, readonly) BLSFloatingContainerState state;

/**
 *  Container margins (left, top, bottom, right) in minimized state.
 */
@property (nonatomic) UIEdgeInsets minimizedContainerMargins;

/**
 *  The object that acts as the delegate of the receiving container.
 *  @see BLSFloatingContainerDelegate
 */
@property (weak, nonatomic) id <BLSFloatingContainerDelegate> delegate;

/**
 *  Initialization. Controller can be nil, but you will have to add subview manually
 *
 *  @param controller    Controller inside of container. This controller will have assigned BLSFLoatingContainerDelegate automatically
 *  @param containerSize Size of minimized container
 *
 *  @return Initialized BLSFloatingContainer object
 *  @see BLSFloatingContainerDelegate
 */
- (id)initWithController:(UIViewController <BLSFloatingContainerDelegate> *)controller andMinimizedContainerSize:(CGSize)containerSize;

/**
 *  Call this method after initialization to add container to UIWindow object. This method should be called only once for each BLSFloatingContainer object.
 *
 *  @param window   Add container to this window object
 *  @param position First minimized container position
 *  @param state    First container state
 *  @see BLSFloatingContainerPosition
 *  @see BLSFloatingContainerState
 */
- (void)addToWindow:(UIWindow *)window atPostion:(BLSFloatingContainerPosition)position andState:(BLSFloatingContainerState)state;

/**
 *  Changing positions of minimized container.
 *
 *  @param position  New position of minimized container
 *  @param animation  Constant that indicates whether there should be an animation.
 *  @see BLSFloatingContainerPosition
 */
- (void)changePosition:(BLSFloatingContainerPosition)position withAnimation:(BOOL)animation;

/**
 *  Changing container state. Use it to maxmize, minimize or close container
 *
 *  @param state     New state of container
 *  @param animation Constant that indicates whether there should be an animation.
 *  @see BLSFloatingContainerState
 */
- (void)changeState:(BLSFloatingContainerState)state withAnimation:(BOOL)animation;


@end
