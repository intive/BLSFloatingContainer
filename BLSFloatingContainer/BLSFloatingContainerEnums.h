//
//  BLSFloatingContainerEnums.h
//  BLSFloatingContainer
//
//  Created by Arek on 28.06.2014.
//  Copyright (c) 2014 Arkadiusz Banaś. All rights reserved.
//

#ifndef BLSFloatingContainer_BLSFloatingContainerEnums_h
#define BLSFloatingContainer_BLSFloatingContainerEnums_h

#define BLSFloatinContainerPositionIsOnTop(position) ((position) == BLSFloatingContainerPositionTopLeft || (position) == BLSFloatingContainerPositionTopRight)
#define BLSFloatinContainerPositionIsOnLeft(position) ((position) == BLSFloatingContainerPositionTopLeft || (position) == BLSFloatingContainerPositionBottomLeft)

/**
 *  Options of minimized container positions.
 */
typedef NS_ENUM(NSInteger, BLSFloatingContainerPosition){
    /**
     *  Position in top, left corner of window.
     */
    BLSFloatingContainerPositionTopLeft,
    /**
     *  Position in top, right corner of window.
     */
    BLSFloatingContainerPositionTopRight,
    /**
     *  Position in bottom, left corner of window.
     */
    BLSFloatingContainerPositionBottomLeft,
    /**
     *  Position in bottom, right corner of window.
     */
    BLSFloatingContainerPositionBottomRight
};

/**
 *  States of container object.
 */
typedef NS_ENUM(NSInteger, BLSFloatingContainerState){
    /**
     *  Fullscreen mode.
     */
    BLSFloatingContainerStateMaximized,
    /**
     *  Minimized mode.
     */
    //Fullscreen
    BLSFloatingContainerStateMinimized,
    /**
     *  State when container is closed.
     */
    BLSFloatingContainerStateClosed
};

#endif
