//
//  NewsRoomVC.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "NewsRoomVC.h"
#import "MFSideMenuVC.h"

@interface NewsRoomVC ()

@end

@implementation NewsRoomVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark - leftSideMenuButtonPressed
- (IBAction)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
#pragma mark - search
- (IBAction)search:(id)sender {
    
}

@end
