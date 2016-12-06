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
@property (strong, nonatomic) NSArray *experienceArray;
@property (strong, nonatomic) NSArray *skillsArray;
@property (strong, nonatomic) NSArray *projectsArray;
@property (strong, nonatomic) NSArray *awardsArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,FETCH_USER_DETAILS] withParam:dict success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    if (![[responseDict objectForKey:@"profile"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"profile"]) {
                        self.profileDict = [responseDict objectForKey:@"profile"];
                    }
                    if (![[responseDict objectForKey:@"cert_award_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"cert_award_array"]) {
                        self.awardsArray = [responseDict objectForKey:@"cert_award_array"];
                    }
                    if (![[responseDict objectForKey:@"experience_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"experience_array"]) {
                        self.experienceArray = [responseDict objectForKey:@"experience_array"];
                    }
                    if (![[responseDict objectForKey:@"skill_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"skill_array"]) {
                        self.skillsArray = [responseDict objectForKey:@"skill_array"];
                    }
                    if (![[responseDict objectForKey:@"proj_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"proj_array"]) {
                        self.projectsArray = [responseDict objectForKey:@"proj_array"];
                    }
                    
                    [self.tableView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
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
