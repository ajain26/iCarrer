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

@interface QuizVC ()<UITableViewDelegate, UITableViewDataSource, QuizSliderDelegate>{
    int questionCounter;
    float sliderValue;
    int optionValue;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *questionCounterLabel;

@property (strong, nonatomic) NSArray *quizArray;

/**** QUIZ LOGIC RELATED ****/
@property (strong, nonatomic) NSMutableArray *traitArray;
@property (strong, nonatomic) NSMutableArray *question1;
@property (strong, nonatomic) NSMutableArray *question2;
@property (strong, nonatomic) NSMutableArray *question3;
@property (strong, nonatomic) NSMutableArray *question4;
@property (strong, nonatomic) NSMutableArray *question5;
@property (strong, nonatomic) NSMutableArray *question6;
@property (strong, nonatomic) NSMutableArray *question7;

@property (strong, nonatomic) NSMutableArray *traitValueArray;
@property (strong, nonatomic) NSMutableArray *avgTraitValueArray;
@property (strong, nonatomic) NSMutableArray *traitCounterArray;

/****************************/
@end

@implementation QuizVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setQuestions];
    [self setInitialView];
    [self fetchQuestions];
}
#pragma mark - setQuestions
-(void)setQuestions{
    self.traitArray = [[NSMutableArray alloc] initWithObjects:@"money", @"balance", @"confidence", @"enterpreneurial", @"interpersonal", @"analytical", @"street", @"pressure", @"sales", nil];
    self.question1 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.question2 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.question3 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.question4 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.question5 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.question6 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.question7 = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];

    self.traitValueArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.avgTraitValueArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];
    self.traitCounterArray = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil];

}
#pragma mark - setInitialView
-(void)setInitialView{
    questionCounter = 0;
    sliderValue = 5;
    
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
        [self calculateTrait];
        ++questionCounter;
        sliderValue = 5;
        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];

    } else {
        [self performSegueWithIdentifier:@"ResultVC" sender:nil];
    }
}
#pragma mark - quizSliderDelegate
-(void)changedSliderValue:(float)value{
    sliderValue = value;
}
#pragma mark - traitCalculator
-(void)traitCalculator{
    NSDictionary *questionDict = [self.quizArray objectAtIndex:questionCounter];
    int traitsCount = 0;
    if (![[questionDict objectForKey:@"no_of_traits"] isKindOfClass:[NSNull class]] && [questionDict objectForKey:@"no_of_traits"]) {
        traitsCount = [[questionDict objectForKey:@"no_of_traits"] intValue];
    }
    for (int i = 0; i < traitsCount; i++) {
        NSInteger index = [self.traitArray indexOfObject:[questionDict objectForKey:[NSString stringWithFormat:@"trait%d",i]]];
        
        if ([[questionDict objectForKey:@"question_type"] isEqualToString:@"slide"]) {
            if (questionCounter == 0) {
                self.question1[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question1[i] floatValue]];
            } else if (questionCounter == 1) {
                self.question2[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question2[i] floatValue]];
            } else if (questionCounter == 2) {
                self.question3[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question3[i] floatValue]];
            } else if (questionCounter == 3) {
                self.question4[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question4[i] floatValue]];
            } else if (questionCounter == 4) {
                self.question5[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question5[i] floatValue]];
            } else if (questionCounter == 5) {
                self.question6[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question6[i] floatValue]];
            } else if (questionCounter == 6) {
                self.question7[index] = [NSString stringWithFormat:@"%f",sliderValue+[self.question7[i] floatValue]];
            }
        } else if ([[questionDict objectForKey:@"question_type"] isEqualToString:@"slide"]){
            
        }
    }
}
#pragma mark - calculateTrait
-(void)calculateTrait{
    //call traitCalculator()
    [self traitCalculator];
    for (int i = 0; i < self.avgTraitValueArray.count; i++){
        NSString *traitVal = self.traitValueArray[i];
        NSString *ques;
        NSString *traitCount = self.traitCounterArray[i];
        
        if (![self.question1[i] isEqualToString:@"0"]) {
            ques = self.question1[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
        if (![self.question2[i] isEqualToString:@"0"]) {
            ques = self.question2[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
        if (![self.question3[i] isEqualToString:@"0"]) {
            ques = self.question3[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
        if (![self.question4[i] isEqualToString:@"0"]) {
            ques = self.question4[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
        if (![self.question5[i] isEqualToString:@"0"]) {
            ques = self.question5[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
        if (![self.question6[i] isEqualToString:@"0"]) {
            ques = self.question6[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
        if (![self.question7[i] isEqualToString:@"0"]) {
            ques = self.question7[i];
            self.traitValueArray[i] = [NSString stringWithFormat:@"%d",traitVal.intValue + ques.intValue];
            self.traitCounterArray[i] = [NSString stringWithFormat:@"%d",traitCount.intValue+1];
        }
    }
    NSLog(@"%@",self.traitValueArray);
    for (int i = 0; i < self.traitArray.count; i++) {
        if (![self.traitValueArray[i] isEqualToString:@"0"]) {
            NSString *traitVal = self.traitValueArray[i];
            NSString *traitCount = self.traitCounterArray[i];
            self.avgTraitValueArray[i] = [NSString stringWithFormat:@"%.2f",traitVal.floatValue/traitCount.floatValue];
        } else {
            self.avgTraitValueArray[i] = @"0";
        }
    }
    NSLog(@"==========");
    NSLog(@"money: %@",self.avgTraitValueArray[0]);
    NSLog(@"balance: %@",self.avgTraitValueArray[1]);
    NSLog(@"confidence: %@",self.avgTraitValueArray[2]);
    NSLog(@"entrepreneurial: %@",self.avgTraitValueArray[3]);
    NSLog(@"interpersonal: %@",self.avgTraitValueArray[4]);
    NSLog(@"analytical: %@",self.avgTraitValueArray[5]);
    NSLog(@"street: %@",self.avgTraitValueArray[6]);
    NSLog(@"pressure: %@",self.avgTraitValueArray[7]);
    NSLog(@"sales: %@",self.avgTraitValueArray[8]);
    NSLog(@"==========");

}
@end
