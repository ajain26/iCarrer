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
#import "EducationNonEditableCell.h"
#import "EducationCell.h"
#import "ExperienceNonEditableCell.h"
#import "ExperienceCell.h"
#import "AwardsCell.h"

@interface IprofileVC ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate>{
    long selectedHeader;
    NSString *summaryText;
}
@property (strong, nonatomic) NSDictionary *userDict;

@property (strong, nonatomic) NSDictionary *profileDict;
@property (strong, nonatomic) NSArray *experienceArray;
@property (strong, nonatomic) NSArray *educationArray;
@property (strong, nonatomic) NSArray *awardsArray;
@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) NSMutableDictionary *educationDict;
@property (strong, nonatomic) NSMutableDictionary *experienceDict;
@property (strong, nonatomic) NSMutableDictionary *awardDict;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation IprofileVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitial];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.userDict = [AppHelper userDefaultsDictionary:@"user"];
    [self fetchUserDetails];
    [self setUserDetails];
}
-(void)setUserDetails{
    self.userNameLabel.text = [self.userDict objectForKey:@"username"];
    self.designationLabel.text = [self.userDict objectForKey:@"short_title"];
    self.addressLabel.text = [self.userDict objectForKey:@"address"];
}
#pragma mark - setInitial
-(void)setInitial{
    selectedHeader = -1;
    summaryText = @"";
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"Summary", @"Education", @"Experience", @"Awards", nil];
    
    self.educationDict = [NSMutableDictionary new];
    self.experienceDict = [NSMutableDictionary new];
    self.awardDict = [NSMutableDictionary new];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    /* Add notification to keyboard appear/disappear */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    /*************************************************/
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
                    if (![[responseDict objectForKey:@"education_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"education_array"]) {
                        self.educationArray = [responseDict objectForKey:@"education_array"];
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
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];;
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
    
    return UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row = 0;
    if (section == 0) {//summary
        if (summaryText.length > 0) {
            row = 1;
        }
        if (selectedHeader == section) {
            return row + 1;
        }
        return row;
    } else if (section == 1){//education
        if (selectedHeader == section) {
            return self.educationArray.count + 1;
        } else {
            return self.educationArray.count;
        }
    } else if (section == 2){//experience
        if (selectedHeader == section) {
            return self.experienceArray.count + 1;
        } else {
            return self.experienceArray.count;
        }
    } else {//awards
        if (selectedHeader == section) {
            return self.awardsArray.count + 1;
        } else {
            return self.awardsArray.count;
        }
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
    } else if (indexPath.section == 1){ //education
        if (selectedHeader == indexPath.section) {
            if (indexPath.row == 0) {
                static NSString *cellIdentifier = @"EducationCell";
                
                EducationCell *cell = (EducationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EducationCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.degreeTextField.text = @"";
                cell.universityTextField.text = @"";
                cell.universityAddressTextField.text = @"";
                cell.startYearTextField.text = @"";
                cell.endYearTextField.text = @"";
                
                cell.degreeTextField.delegate = self;
                cell.universityTextField.delegate = self;
                cell.universityAddressTextField.delegate = self;
                cell.startYearTextField.delegate = self;
                cell.endYearTextField.delegate = self;
                
                UIDatePicker *datePicker = [[UIDatePicker alloc]init];
                [datePicker setDate:[NSDate date]];
                datePicker.datePickerMode = UIDatePickerModeDate;
                [datePicker addTarget:self action:@selector(startDateTextField:) forControlEvents:UIControlEventValueChanged];
                [cell.startYearTextField setInputView:datePicker];
                
                UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
                toolbar.barStyle = UIBarStyleDefault;
                UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissYearTextField)];
                [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
                cell.startYearTextField.inputAccessoryView = toolbar;
                
                
                UIDatePicker *datePicker2 = [[UIDatePicker alloc]init];
                [datePicker2 setDate:[NSDate date]];
                datePicker2.datePickerMode = UIDatePickerModeDate;
                [datePicker2 addTarget:self action:@selector(endDateTextField:) forControlEvents:UIControlEventValueChanged];
                [cell.endYearTextField setInputView:datePicker2];
                
                cell.endYearTextField.inputAccessoryView = toolbar;
                
                [cell.submitButton addTarget:self action:@selector(submitEducation) forControlEvents:UIControlEventTouchUpInside];
                
                if ([self.educationDict objectForKey:@"degree_title"]) {
                    cell.degreeTextField.text = [self.educationDict objectForKey:@"degree_title"];
                }
                if ([self.educationDict objectForKey:@"university"]) {
                    cell.universityTextField.text = [self.educationDict objectForKey:@"university"];
                }
                if ([self.educationDict objectForKey:@"university_address"]) {
                    cell.universityAddressTextField.text = [self.educationDict objectForKey:@"university_address"];
                }
                if ([self.educationDict objectForKey:@"start_year"]) {
                    cell.startYearTextField.text = [self.educationDict objectForKey:@"start_year"];
                }
                if ([self.educationDict objectForKey:@"end_year"]) {
                    cell.endYearTextField.text = [self.educationDict objectForKey:@"end_year"];
                }
                
                
                [cell setBorder];
                
                return cell;
            } else {
                static NSString *cellIdentifier = @"EducationNonEditableCell";
                
                EducationNonEditableCell *cell = (EducationNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EducationNonEditableCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.degreeLabel.text = @"";
                cell.universityLabel.text = @"";
                cell.universityAddressLabel.text = @"";
                cell.durationLabel.text = @"";
                
                NSDictionary *dict = [self.educationArray objectAtIndex:indexPath.row-1];
                cell.degreeLabel.text = [dict objectForKey:@"degree_title"];
                cell.universityLabel.text = [dict objectForKey:@"university"];
                cell.universityAddressLabel.text = [dict objectForKey:@"university_address"];
                cell.durationLabel.text = [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"start_year"],[dict objectForKey:@"end_year"]];
                
                return cell;
            }
        } else {
            static NSString *cellIdentifier = @"EducationNonEditableCell";
            
            EducationNonEditableCell *cell = (EducationNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EducationNonEditableCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.degreeLabel.text = @"";
            cell.universityLabel.text = @"";
            cell.universityAddressLabel.text = @"";
            cell.durationLabel.text = @"";
            
            NSDictionary *dict = [self.educationArray objectAtIndex:indexPath.row];
            cell.degreeLabel.text = [dict objectForKey:@"degree_title"];
            cell.universityLabel.text = [dict objectForKey:@"university"];
            cell.universityAddressLabel.text = [dict objectForKey:@"university_address"];
            cell.durationLabel.text = [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"start_year"],[dict objectForKey:@"end_year"]];
            
            return cell;
        }
    } else if (indexPath.section == 2){//experience
        if (selectedHeader == indexPath.section) {
            if (indexPath.row == 0) {
                static NSString *cellIdentifier = @"ExperienceCell";
                
                ExperienceCell *cell = (ExperienceCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ExperienceCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell setBorder];
                
                cell.designationTextField.text = @"";
                cell.companyTextField.text = @"";
                cell.companAddressTextField.text = @"";
                cell.startYearTextField.text = @"";
                cell.endYearTextField.text = @"";
                cell.jobDescTextField.text = @"";
                
                cell.designationTextField.delegate = self;
                cell.companyTextField.delegate = self;
                cell.companAddressTextField.delegate = self;
                cell.startYearTextField.delegate = self;
                cell.endYearTextField.delegate = self;
                cell.jobDescTextField.delegate = self;

                UIDatePicker *datePicker = [[UIDatePicker alloc]init];
                [datePicker setDate:[NSDate date]];
                datePicker.datePickerMode = UIDatePickerModeDate;
                [datePicker addTarget:self action:@selector(startDateExpTextField:) forControlEvents:UIControlEventValueChanged];
                [cell.startYearTextField setInputView:datePicker];
                
                UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
                toolbar.barStyle = UIBarStyleDefault;
                UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissYearTextField)];
                [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
                cell.startYearTextField.inputAccessoryView = toolbar;
                
                
                UIDatePicker *datePicker2 = [[UIDatePicker alloc]init];
                [datePicker2 setDate:[NSDate date]];
                datePicker2.datePickerMode = UIDatePickerModeDate;
                [datePicker2 addTarget:self action:@selector(endDateExpTextField:) forControlEvents:UIControlEventValueChanged];
                [cell.endYearTextField setInputView:datePicker2];
                
                cell.endYearTextField.inputAccessoryView = toolbar;
                
                [cell.submitButton addTarget:self action:@selector(submitExperience) forControlEvents:UIControlEventTouchUpInside];
                
                if ([self.experienceDict objectForKey:@"exp_title"]) {
                    cell.designationTextField.text = [self.experienceDict objectForKey:@"exp_title"];
                }
                if ([self.experienceDict objectForKey:@"company_name"]) {
                    cell.companyTextField.text = [self.experienceDict objectForKey:@"company_name"];
                }
                if ([self.experienceDict objectForKey:@"company_address"]) {
                    cell.companAddressTextField.text = [self.experienceDict objectForKey:@"company_address"];
                }
                if ([self.experienceDict objectForKey:@"start_year"]) {
                    cell.startYearTextField.text = [self.experienceDict objectForKey:@"start_year"];
                }
                if ([self.experienceDict objectForKey:@"end_year"]) {
                    cell.endYearTextField.text = [self.experienceDict objectForKey:@"end_year"];
                }
                if ([self.experienceDict objectForKey:@"job_desc"]) {
                    cell.jobDescTextField.text = [self.experienceDict objectForKey:@"job_desc"];
                }

                
                return cell;
            } else {
                static NSString *cellIdentifier = @"ExperienceNonEditableCell";
                
                ExperienceNonEditableCell *cell = (ExperienceNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ExperienceNonEditableCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.designationLabel.text = @"";
                cell.companyLabel.text = @"";
                cell.addressLabel.text = @"";
                cell.durationLabel.text = @"";
                cell.descLabel.text = @"";
                
                NSDictionary *dict = [self.experienceArray objectAtIndex:indexPath.row-1];
                cell.designationLabel.text = [dict objectForKey:@"exp_title"];
                cell.companyLabel.text = [dict objectForKey:@"company_name"];
                cell.addressLabel.text = [dict objectForKey:@"company_address"];
                cell.durationLabel.text = [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"start_year"],[dict objectForKey:@"end_year"]];
                cell.descLabel.text = [dict objectForKey:@"job_desc"];
                
                return cell;
            }
        } else {
            static NSString *cellIdentifier = @"ExperienceNonEditableCell";
            
            ExperienceNonEditableCell *cell = (ExperienceNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ExperienceNonEditableCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.designationLabel.text = @"";
            cell.companyLabel.text = @"";
            cell.addressLabel.text = @"";
            cell.durationLabel.text = @"";
            cell.descLabel.text = @"";
            
            NSDictionary *dict = [self.experienceArray objectAtIndex:indexPath.row];
            cell.designationLabel.text = [dict objectForKey:@"exp_title"];
            cell.companyLabel.text = [dict objectForKey:@"company_name"];
            cell.addressLabel.text = [dict objectForKey:@"company_address"];
            cell.durationLabel.text = [NSString stringWithFormat:@"%@ to %@",[dict objectForKey:@"start_year"],[dict objectForKey:@"end_year"]];
            cell.descLabel.text = [dict objectForKey:@"job_desc"];

            return cell;
        }
    } else { //awards
        if (selectedHeader == indexPath.section) {
            if (indexPath.row == 0) {
                static NSString *cellIdentifier = @"AwardsCell";
                
                AwardsCell *cell = (AwardsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AwardsCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.awardNameTextField.text = @"";
                cell.awardDescriptionTextField.text = @"";
                cell.organisationTextField.text = @"";
                cell.yearTextField.text = @"";
                
                cell.awardNameTextField.delegate = self;
                cell.awardDescriptionTextField.delegate = self;
                cell.organisationTextField.delegate = self;
                cell.yearTextField.delegate = self;
                
                
                UIDatePicker *datePicker = [[UIDatePicker alloc]init];
                [datePicker setDate:[NSDate date]];
                datePicker.datePickerMode = UIDatePickerModeDate;
                [datePicker addTarget:self action:@selector(startDateExpTextField:) forControlEvents:UIControlEventValueChanged];
                [cell.yearTextField setInputView:datePicker];
                
                UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
                toolbar.barStyle = UIBarStyleDefault;
                UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissYearTextField)];
                [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
                cell.yearTextField.inputAccessoryView = toolbar;
                
                
                [cell.submitButton addTarget:self action:@selector(submitAwards) forControlEvents:UIControlEventTouchUpInside];
                
                if ([self.awardDict objectForKey:@"ca_title"]) {
                    cell.awardNameTextField.text = [self.awardDict objectForKey:@"ca_title"];
                }
                if ([self.awardDict objectForKey:@"ca_desc"]) {
                    cell.awardDescriptionTextField.text = [self.awardDict objectForKey:@"ca_desc"];
                }
                if ([self.awardDict objectForKey:@"ca_organization"]) {
                    cell.organisationTextField.text = [self.awardDict objectForKey:@"ca_organization"];
                }
                if ([self.awardDict objectForKey:@"ca_year"]) {
                    cell.yearTextField.text = [self.awardDict objectForKey:@"ca_year"];
                }
                
                
                [cell setBorder];
                
                return cell;
            } else {
                static NSString *cellIdentifier = @"EducationNonEditableCell";
                
                EducationNonEditableCell *cell = (EducationNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil){
                    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EducationNonEditableCell" owner:self options:nil];
                    cell = [arr objectAtIndex:0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.degreeLabel.text = @"";
                cell.universityLabel.text = @"";
                cell.universityAddressLabel.text = @"";
                cell.durationLabel.text = @"";
                
                NSDictionary *dict = [self.awardsArray objectAtIndex:indexPath.row-1];
                cell.degreeLabel.text = [dict objectForKey:@"ca_title"];
                cell.universityLabel.text = [dict objectForKey:@"ca_organization"];
                cell.universityAddressLabel.text = [dict objectForKey:@"ca_desc"];
                cell.durationLabel.text = [dict objectForKey:@"ca_year"];
                
                return cell;
            }
        } else {
            static NSString *cellIdentifier = @"EducationNonEditableCell";
            
            EducationNonEditableCell *cell = (EducationNonEditableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"EducationNonEditableCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.degreeLabel.text = @"";
            cell.universityLabel.text = @"";
            cell.universityAddressLabel.text = @"";
            cell.durationLabel.text = @"";
            
            NSDictionary *dict = [self.awardsArray objectAtIndex:indexPath.row];
            cell.degreeLabel.text = [dict objectForKey:@"ca_title"];
            cell.universityLabel.text = [dict objectForKey:@"ca_organization"];
            cell.universityAddressLabel.text = [dict objectForKey:@"ca_desc"];
            cell.durationLabel.text = [dict objectForKey:@"ca_year"];
            
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
}
#pragma mark - headerTapped
-(void)headerTapped:(UIButton*)btn{
    [self.view endEditing:true];
    
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
    CGRect sectionRect = [self.tableView rectForSection:0];
    [self.tableView scrollRectToVisible:sectionRect animated:YES];
    
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
#pragma mark - updateUserExperience
-(void)updateUserExperience{
    [self.view endEditing:true];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
    [param setObject:summaryText forKey:@"summary"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,UPDATE_USER_EXPERIENCE] withParam:param success:^(NSDictionary *responseDict) {
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
#pragma mark - keyboardWillShow
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:.3 animations:^(void){
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
}
#pragma mark - keyboardWillHide
-(void)keyboardWillHide:(NSNotification*)notification{
    [UIView animateWithDuration:.3 animations:^(void){
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.section == 1) { //education
        [self setEducationValues:textField];
    } else if (indexPath.section == 2){ //experience
        [self setExperienceValues:textField];
    } else if (indexPath.section == 3){ //awards
        [self setAwardsValues:textField];
    }
    
    [textField resignFirstResponder];
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                              toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.section == 1) { //education
        [self setEducationValues:textField];
    } else if (indexPath.section == 2){ //experience
        [self setExperienceValues:textField];
    } else if (indexPath.section == 3){ //awards
        [self setAwardsValues:textField];
    }

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 200;
}
-(void)setEducationValues:(UITextField*)textF{
    switch (textF.tag) {
        case 0://degree
            [self.educationDict setObject:textF.text forKey:@"degree_title"];
            break;
        case 1://university
            [self.educationDict setObject:textF.text forKey:@"university"];
            break;
        case 2://university address
            [self.educationDict setObject:textF.text forKey:@"university_address"];
            break;
        case 3://start year
            [self.educationDict setObject:textF.text forKey:@"start_year"];
            break;
        case 4://end year
            [self.educationDict setObject:textF.text forKey:@"end_year"];
            break;
        default:
            break;
    }
}
-(void)setExperienceValues:(UITextField*)textF{
    switch (textF.tag) {
        case 0://title
            [self.experienceDict setObject:textF.text forKey:@"exp_title"];
            break;
        case 1://company name
            [self.experienceDict setObject:textF.text forKey:@"company_name"];
            break;
        case 2://company address
            [self.experienceDict setObject:textF.text forKey:@"company_address"];
            break;
        case 3://start year
            [self.experienceDict setObject:textF.text forKey:@"start_year"];
            break;
        case 4://end year
            [self.experienceDict setObject:textF.text forKey:@"end_year"];
            break;
        case 5://job desc
            [self.experienceDict setObject:textF.text forKey:@"job_desc"];
            break;
        default:
            break;
    }
}
-(void)setAwardsValues:(UITextField*)textF{
    if ([textF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
        switch (textF.tag) {
            case 0://title
                [self.awardDict setObject:textF.text forKey:@"ca_title"];
                break;
            case 1://desc
                [self.awardDict setObject:textF.text forKey:@"ca_desc"];
                break;
            case 2://organization
                [self.awardDict setObject:textF.text forKey:@"ca_organization"];
                break;
            case 3://year
                [self.awardDict setObject:textF.text forKey:@"ca_year"];
                break;
            default:
                break;
        }
    }
}
#pragma mark - submitAwards
-(void)submitAwards{
    if ([[self.awardDict allKeys] count] == 4) {
        [self.awardDict setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
        
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,SET_USER_AWARDS] withParam:self.awardDict success:^(NSDictionary *responseDict) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseDict objectForKey:@"status"];
            
            if (![dict isKindOfClass:[NSNull class]] && dict) {
                if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                    if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                        [self.awardDict removeAllObjects];
                        selectedHeader = -1;
                        [self fetchUserDetails];
                    }
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        [AppHelper showToast:ALL_FIELDS_MANDATORY shakeView:nil parentView:self.view];
    }
}
#pragma mark - submitExperience
-(void)submitExperience{
    if ([[self.experienceDict allKeys] count] == 6) {
        [self.experienceDict setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
        
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,SUBMIT_USER_EXPERIENCE] withParam:self.experienceDict success:^(NSDictionary *responseDict) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseDict objectForKey:@"status"];
            
            if (![dict isKindOfClass:[NSNull class]] && dict) {
                if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                    if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                        [self.experienceDict removeAllObjects];
                        selectedHeader = -1;
                        [self fetchUserDetails];
                    }
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        [AppHelper showToast:ALL_FIELDS_MANDATORY shakeView:nil parentView:self.view];
    }
}
#pragma mark - submitEducation
-(void)submitEducation{
    if ([[self.educationDict allKeys] count] == 5) {
        [self.educationDict setObject:[self.userDict objectForKey:@"user_id"] forKey:@"user_id"];
        
        [SVProgressHUD showWithStatus:@"Please wait..."];
        [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,SET_USER_EDUCATION] withParam:self.educationDict success:^(NSDictionary *responseDict) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseDict objectForKey:@"status"];
            
            if (![dict isKindOfClass:[NSNull class]] && dict) {
                if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                    if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                        [self.educationDict removeAllObjects];
                        selectedHeader = -1;
                        [self fetchUserDetails];
                    }
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        [AppHelper showToast:ALL_FIELDS_MANDATORY shakeView:nil parentView:self.view];
    }
}
#pragma mark - startDateTextField
-(void)startDateTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)sender;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    [self.educationDict setObject:dateString forKey:@"start_year"];
}
#pragma mark - endDateTextField
-(void)endDateTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)sender;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    [self.educationDict setObject:dateString forKey:@"end_year"];
}
#pragma mark - dismissYearTextField
-(void)dismissYearTextField{
    [self.tableView reloadData];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:selectedHeader] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - startDateExpTextField
-(void)startDateExpTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)sender;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    [self.experienceDict setObject:dateString forKey:@"start_year"];
}
#pragma mark - endDateExpTextField
-(void)endDateExpTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)sender;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    [self.experienceDict setObject:dateString forKey:@"end_year"];
}
#pragma mark - editProfile
- (IBAction)editProfile:(id)sender {
    [self performSegueWithIdentifier:@"EditProfileVC" sender:nil];
}
@end
