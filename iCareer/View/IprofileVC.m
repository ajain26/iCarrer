//
//  IprofileVC.m
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "IprofileVC.h"
#import "MFSideMenuVC.h"
#import "Services.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppHelper.h"

@interface IprofileVC ()
@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) NSDictionary *profileDict;
@end

@implementation IprofileVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitial];
    [self fetchUserDetails];
}
#pragma mark - setInitial
-(void)setInitial{
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];

}
#pragma mark - fetchUserDetails
-(void)fetchUserDetails{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,FETCH_USER_DETAILS] withParam:dict success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
        
    }];
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
