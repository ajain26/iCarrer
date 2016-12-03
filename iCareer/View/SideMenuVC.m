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
#import "SideMenuHeaderView.h"
#import "SideMenuCell.h"
#import "NewsRoomVC.h"
#import "IprofileVC.h"
#import "AppDelegate.h"
#import "AppHelper.h"

@interface SideMenuVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SideMenuHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *sideArray;
@property (strong, nonatomic) NSMutableArray *iconsArray;
@property (strong, nonatomic) NSDictionary *userDict;
@end

@implementation SideMenuVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setInitialView];
    
}
#pragma mark - setInitialView
-(void)setInitialView{
    self.selectedIndex = 0;
    
    self.headerView = [[SideMenuHeaderView alloc] init];
    self.tableView.tableHeaderView = self.headerView;
    
    self.sideArray = [[NSMutableArray alloc] initWithObjects:@"Boardroom", @"Newsroom", @"iProfile", @"Logout", nil];
    self.iconsArray = [[NSMutableArray alloc] initWithObjects:@"board", @"news", @"iprofile", @"logout", nil];
    
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    if (![self.userDict isKindOfClass:[NSNull class]] && self.userDict) {
        self.headerView.userNameLabel.text = [self.userDict objectForKey:@"username"];
        self.headerView.emailLabel.text = [self.userDict objectForKey:@"email"];
    }
}
#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sideArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SideMenuCell";
    
    SideMenuCell *cell = (SideMenuCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = @"";
    cell.iconImageView.image = nil;
    
    [cell assignTitle:[self.sideArray objectAtIndex:indexPath.row] andIcon:[self.iconsArray objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    if (indexPath.row == 0) {//boardroom
        if (self.selectedIndex != indexPath.row) {
            self.selectedIndex = indexPath.row;
            
            BoardRoomVC *board = (BoardRoomVC*)[storyboard instantiateViewControllerWithIdentifier:@"BoardRoomVC"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:board];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        } else {
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    } else if (indexPath.row == 1){//newsroom
        if (self.selectedIndex != indexPath.row) {
            self.selectedIndex = indexPath.row;
            
            NewsRoomVC *news = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsRoomVC"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:news];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        } else {
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    } else if (indexPath.row == 2){//iprofile
        if (self.selectedIndex != indexPath.row) {
            self.selectedIndex = indexPath.row;
            
            IprofileVC *board = (IprofileVC*)[storyboard instantiateViewControllerWithIdentifier:@"IprofileVC"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:board];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        } else {
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    } else {//logout
        [self logout];
    }
}
#pragma mark - logout
-(void)logout{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[self.userDict objectForKey:@"username"] message:@"Do you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [AppHelper removeFromUserDefaultsWithKey:@"user"];
        [AppHelper removeFromUserDefaultsWithKey:@"skill"];
        [[AppDelegate getAppDelegate] logout];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    
    // Present action sheet.
    [self presentViewController:alert animated:YES completion:nil];
}
@end
