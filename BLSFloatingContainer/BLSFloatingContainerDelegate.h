//
//  BLSFloatingContainerDelegate.h
//  BLSFloatingContainer
//
//  Created by Arek on 28.06.2014.
//  Copyright (c) 2014 Arkadiusz Banaś. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLSFloatingContainerEnums.h"

@class BLSFloatingContainer;

@protocol BLSFloatingContainerDelegate <NSObject>

@required
/**
 *  Tells the container if it can be closed by swiping beyond screen
 *
 *  @param container The container object requesting this information.
 *
 *  @return BOOL indicator of possibility of closing container by swipping beyond screen
 *  @see BLSFloatingContainer
 */
- (BOOL)canCloseFloatingPlayerContainer:(BLSFloatingContainer *)container;

@optional
/**
 *  Called when container will move to different positions in minimized state.
 *
 *  @param container The container object that is making this request.
 *  @param position  New position for minimized container
 *  @see BLSFloatingContainer
 *  @see BLSFloatingContainerPosition
 */
- (void)floatingContainer:(BLSFloatingContainer *)container willMoveToPosition:(BLSFloatingContainerPosition)position;

/**
 *  Called when container did move to different positions in minimized state.
 *
 *  @param container The container object that is making this request.
 *  @param position  New position for minimized container
 *  @see BLSFloatingContainer
 *  @see BLSFloatingContainerPosition
 */
- (void)floatingContainer:(BLSFloatingContainer *)container didMoveToPosition:(BLSFloatingContainerPosition)position;

/**
 *  Called when container will change state.
 *
 *  @param container    The container object that is making this request.
 *  @param state        New state of container.
 *  @param containerSize New container size.
 *  @see BLSFloatingContainer
 *  @see BLSFloatingContainerState
 */
- (void)floatingContainer:(BLSFloatingContainer *)container willChangeState:(BLSFloatingContainerState)state andContainerSize:(CGSize)containerSize;

/**
 *  Called when container did change state.
 *
 *  @param container    The container object that is making this request.
 *  @param state        New state of container.
 *  @param containerSize New container size.
 *  @see BLSFloatingContainer
 *  @see BLSFloatingContainerState
 */
- (void)floatingContainer:(BLSFloatingContainer *)container didChangedState:(BLSFloatingContainerState)state andContainerSize:(CGSize)containerSize;

/**
 *  Called during container panning.
 *
 *  @param container The container object that is making this request.
 *  @param center    New coneter point of container.
 *  @see BLSFloatingContainer
 */
- (void)floatingContainer:(BLSFloatingContainer *)container didPanWithCenterPoint:(CGPoint)center;
@end
