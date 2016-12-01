//
//  QuizVC.m
//  iCareer
//
//  Created by Hitesh on 11/30/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "QuizVC.h"
#import "QuizQuestionCell.h"
#import "QuizMCQCell.h"
#import "QuizOptionsCell.h"
#import "Services.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppHelper.h"

@interface QuizVC ()<UITableViewDelegate, UITableViewDataSource>{
    int questionCounter;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *quizArray;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *questionCounterLabel;
@end

@implementation QuizVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialView];
    [self fetchQuestions];
}
#pragma mark - setInitialView
-(void)setInitialView{
    questionCounter = 0;
    
    self.quizArray = [NSMutableArray new];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark - fetchQuestions
-(void)fetchQuestions{
    int random = arc4random() % 7;
    NSMutableDictionary *loginParam = [NSMutableDictionary new];
    [loginParam setObject:[NSString stringWithFormat:@"%d",random] forKey:@"set_number"];
    [SVProgressHUD showWithStatus:@"Please wait..."];

    [[Services sharedInstance] servicePOSTWithPath:[NSString stringWithFormat:@"%@%@",BASEURL,FETCHQUESTIONS] withParam:loginParam success:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseDict objectForKey:@"status"];
        
        if (![dict isKindOfClass:[NSNull class]] && dict) {
            if (![[dict objectForKey:@"statuscode"] isKindOfClass:[NSNull class]] && [dict objectForKey:@"statuscode"]) {
                if ([[dict objectForKey:@"statuscode"] intValue] == 1) {
                    
                    if (![[responseDict objectForKey:@"question_array"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"question_array"]) {
                        self.quizArray = [responseDict objectForKey:@"question_array"];
                        [self reloadView];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - reloadView
-(void)reloadView{
    if (self.quizArray.count > 0) {
        questionCounter = 0;
        [self.tableView reloadData];
        self.tableView.hidden = false;
        self.nextButton.hidden = false;
    } else {
        self.tableView.hidden = true;
        self.nextButton.hidden = true;
    }
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.quizArray.count > 0) {
        return 2;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }
    else {
        NSDictionary *quizDict = [self.quizArray objectAtIndex:questionCounter];
        if ([[quizDict objectForKey:@"question_type"] isEqualToString:@"option"]) {
            NSArray *optionsArray;
            if (![[quizDict objectForKey:@"question"] isKindOfClass:[NSNull class]] && [quizDict objectForKey:@"question"]) {
                optionsArray = [[quizDict objectForKey:@"question"] componentsSeparatedByString:@"|"];
            }
            if (optionsArray.count > 0) {
                return optionsArray.count-1;
            }
            return 0;
        }
        
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return UITableViewAutomaticDimension;
    } else {
        NSDictionary *quizDict = [self.quizArray objectAtIndex:questionCounter];
        if ([[quizDict objectForKey:@"question_type"] isEqualToString:@"option"]) {
            return 90;
        }
        return 400;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *quizDict = [self.quizArray objectAtIndex:questionCounter];
    
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"QuizQuestionCell";
    
        QuizQuestionCell *cell = (QuizQuestionCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QuizQuestionCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *optionsArray;
        if (![[quizDict objectForKey:@"question"] isKindOfClass:[NSNull class]] && [quizDict objectForKey:@"question"]) {
            optionsArray = [[quizDict objectForKey:@"question"] componentsSeparatedByString:@"|"];
        }
        NSString *que = @"";
        if (optionsArray.count > 0) {
            que = [[optionsArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        cell.questionLabel.text = que;
        return cell;
    } else {
        if ([[quizDict objectForKey:@"question_type"] isEqualToString:@"option"]) {
            static NSString *cellIdentifier = @"QuizOptionsCell";
            
            QuizOptionsCell *cell = (QuizOptionsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QuizOptionsCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *optionsArray;
            if (![[quizDict objectForKey:@"question"] isKindOfClass:[NSNull class]] && [quizDict objectForKey:@"question"]) {
                optionsArray = [[quizDict objectForKey:@"question"] componentsSeparatedByString:@"|"];
            }
            
            cell.optionLabel.text = @"";
            if (optionsArray.count > 0) {
                cell.optionLabel.text = [[optionsArray objectAtIndex:indexPath.row+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            return cell;
        } else {
            static NSString *cellIdentifier = @"QuizMCQCell";
    
            QuizMCQCell *cell = (QuizMCQCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QuizMCQCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            [cell assignValueWithDictionary:quizDict];
        
            return cell;
        }
        
    }
}
#pragma mark - next
- (IBAction)next:(id)sender {
    NSLog(@"Q->%d",questionCounter);
    if (questionCounter < 6){
        ++questionCounter;
        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];

    } else {
        [self performSegueWithIdentifier:@"ResultVC" sender:nil];
    }
}

@end
