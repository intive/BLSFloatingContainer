//
//  BLSViewController.m
//  BLSFloatingContainer
//
//  Created by Arek on 28.06.2014.
//  Copyright (c) 2014 Arkadiusz Banaś. All rights reserved.
//

#import "BLSViewController.h"
#import "BLSFloatingContainer.h"
#import "BLSPlayerViewController.h"

@interface BLSViewController ()
@property (strong, nonatomic) BLSFloatingContainer *container;
@property (strong, nonatomic) BLSPlayerViewController *player;
@end

@implementation BLSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:1 green:0.26 blue:0.17 alpha:1]];
    
    self.player = [[BLSPlayerViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.container){
        self.container = [[BLSFloatingContainer alloc] initWithController:self.player andMinimizedContainerSize:CGSizeMake(100, 100)];
        [self.container addToWindow:[[[UIApplication sharedApplication] delegate] window] atPostion:BLSFloatingContainerPositionBottomLeft andState:BLSFloatingContainerStateMinimized];
    }
}
@end
