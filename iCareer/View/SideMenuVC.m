//
//  SideMenuVC.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "SideMenuVC.h"
#import "BoardRoomVC.h"
#import <MFSideMenu/MFSideMenu.h>
@interface SideMenuVC ()

@end

@implementation SideMenuVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    BoardRoomVC *board = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardRoomVC"];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:board];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
}
@end
