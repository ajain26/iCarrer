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

@interface SideMenuVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SideMenuHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *sideArray;
@property (strong, nonatomic) NSMutableArray *iconsArray;
@end

@implementation SideMenuVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setInitialView];
    
}
#pragma mark - setInitialView
-(void)setInitialView{
    self.headerView = [[SideMenuHeaderView alloc] init];
    self.tableView.tableHeaderView = self.headerView;
    
    self.sideArray = [[NSMutableArray alloc] initWithObjects:@"Boardroom", @"Newsroom", @"iProfile", @"Logout", nil];
    self.iconsArray = [[NSMutableArray alloc] initWithObjects:@"board", @"news", @"iprofile", @"logout", nil];
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
}
@end
