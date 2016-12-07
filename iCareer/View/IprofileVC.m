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
#import "IprofileSummaryCell.h"
#import "IprofileSummaryNonEditableCell.h"

@interface IprofileVC ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>{
    long selectedHeader;
    NSString *summaryText;
}
@property (strong, nonatomic) NSDictionary *userDict;

@property (strong, nonatomic) NSDictionary *profileDict;
@property (strong, nonatomic) NSArray *experienceArray;
@property (strong, nonatomic) NSArray *skillsArray;
@property (strong, nonatomic) NSArray *projectsArray;
@property (strong, nonatomic) NSArray *awardsArray;
@property (strong, nonatomic) NSMutableArray *titleArray;

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
    selectedHeader = -1;
    summaryText = @"";
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"Summary", @"Experience", @"Skills", @"Projects", @"Awards", nil];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

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
                        if ([[responseDict objectForKey:@"profile"] count] > 0) {
                            self.profileDict = [[responseDict objectForKey:@"profile"] objectAtIndex:0];
                            summaryText = [[[self.profileDict objectForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 ? [self.profileDict objectForKey:@"summary"] : @"Summary";
                        }
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
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = nil;
    float height = 50;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)];
    UIImageView *borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width-19, 40)];
    borderImageView.layer.cornerRadius = 5.0f;
    borderImageView.backgroundColor = [UIColor colorWithRed:95.0/255.0f green:170.0/255.0f blue:145.0/255.0f alpha:1.0f];
    [view addSubview:borderImageView];
    
    UIImageView *verticalDivider1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, borderImageView.bounds.size.height, 1, 10)];
    verticalDivider1.backgroundColor = [UIColor colorWithRed:95.0/255.0f green:170.0/255.0f blue:145.0/255.0f alpha:1.0f];
    [view addSubview:verticalDivider1];
    
    UIImageView *verticalDivider2 = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.bounds.size.width-10, borderImageView.bounds.size.height, 1, 10)];
    verticalDivider2.backgroundColor = [UIColor colorWithRed:95.0/255.0f green:170.0/255.0f blue:145.0/255.0f alpha:1.0f];
    [view addSubview:verticalDivider2];
    
    verticalDivider1.hidden = true;
    verticalDivider2.hidden = true;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tableView.bounds.size.width-40, 40)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0f];;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [self.titleArray objectAtIndex: section];
    [view addSubview:titleLabel];
    
    UIImageView *plusMinusImageView = [[UIImageView alloc] init];
    plusMinusImageView.frame = CGRectMake(borderImageView.bounds.size.width-20, 17, 16, 16);
    if (selectedHeader == section) {
        plusMinusImageView.image = [UIImage imageNamed:@"minus"];
        verticalDivider1.hidden = false;
        verticalDivider2.hidden = false;
    } else {
        plusMinusImageView.image = [UIImage imageNamed:@"plusSmall"];
    }
    [view addSubview:plusMinusImageView];
    
    UIButton *headerButton = [[UIButton alloc] initWithFrame:borderImageView.frame];
    headerButton.tag = section;
    [headerButton addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:headerButton];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (selectedHeader == indexPath.section) {
            if (indexPath.row == 0) {
                return UITableViewAutomaticDimension;
            } else {
                if ([[[self.profileDict objectForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
                    return 0;
                } else {
                    return UITableViewAutomaticDimension;
                }
            }
        }
        return UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}
/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (selectedHeader == indexPath.section) {
            if (indexPath.row == 0) {
                return 200;
            } else {
                if ([[[self.profileDict objectForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
                    return 0;
                }
                return 44;
            }
        }
        if ([[[self.profileDict objectForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            return 0;
        }
        return 44;
    }
    return 0;
}*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row = 0;
    if (section == 0) {
        if (summaryText.length > 0) {
            row = 1;
        }
        if (selectedHeader == section) {
            return row + 1;
        }
        return row;
    }
    
    return row;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){//summary
        if (selectedHeader == indexPath.section) {
            if (indexPath.row == 0) {
                static NSString *cellIdentifier = @"IprofileSummaryCell";
            
                IprofileSummaryCell *cell = (IprofileSummaryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"IprofileSummaryCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.postButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.textView.delegate = self;
                cell.textView.text = summaryText;
                
                if (![summaryText isEqualToString:@"Summary"]) {
                    cell.textView.textColor = [UIColor blackColor];
                } else {
                    cell.textView.textColor = [UIColor lightGrayColor];
                }
                
                [cell setBorderToContentImageView];
            
                return cell;
            } else {
                static NSString *cellIdentifier = @"IprofileSummaryNonEditableCell";
            
                IprofileSummaryNonEditableCell *cell = (IprofileSummaryNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"IprofileSummaryNonEditableCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = [[self.profileDict objectForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                return cell;
            }
        } else {
            static NSString *cellIdentifier = @"IprofileSummaryNonEditableCell";
            
            IprofileSummaryNonEditableCell *cell = (IprofileSummaryNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"IprofileSummaryNonEditableCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = [[self.profileDict objectForKey:@"summary"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            return cell;
        }
    }
    else {//TODO: change the cell below
        static NSString *cellIdentifier = @"IprofileSummaryCell";
        
        IprofileSummaryCell *cell = (IprofileSummaryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"IprofileSummaryCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textView.delegate = self;
        cell.textView.text = summaryText;
        [cell setBorderToContentImageView];
        
        return cell;
    }
}
#pragma mark - headerTapped
-(void)headerTapped:(UIButton*)btn{
    long previousSelectedHeader = selectedHeader;
    if (selectedHeader != btn.tag) {
        if (selectedHeader != -1) {
            selectedHeader = -1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:previousSelectedHeader] withRowAnimation:UITableViewRowAnimationFade];
        }
        selectedHeader = btn.tag;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectedHeader] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        selectedHeader = -1;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:previousSelectedHeader] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - textview
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Summary"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];

    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Summary";
        textView.textColor = [UIColor lightGrayColor];
    } else {
        summaryText = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}
#pragma mark - post
-(void)post:(UIButton*)btn{
    [self.view endEditing:true];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:summaryText forKey:@"summary"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,UPDATE_SUMMARY] withParam:param success:^(NSDictionary *responseDict) {
        NSDictionary *dict = [responseDict objectForKey:@"status"];

        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    [self fetchUserDetails];
                    [self reloadAll];
                } else {
                    [SVProgressHUD dismiss];
                }
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - reloadAll
-(void)reloadAll{
    long previousSelectedHeader = selectedHeader;
    
    selectedHeader = -1;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:previousSelectedHeader] withRowAnimation:UITableViewRowAnimationFade];
}
@end
