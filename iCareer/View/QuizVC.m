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
#import "Services.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppHelper.h"

@interface QuizVC ()<UITableViewDelegate, UITableViewDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
                if ([[dict objectForKey:@"statuscode"] intValue] == 0) {
                    [AppHelper showToastCenterError:[dict objectForKey:@"msg"] parentView:self.view];
                }
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"QuizQuestionCell";
    
        QuizQuestionCell *cell = (QuizQuestionCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QuizQuestionCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.questionLabel.text = @"the quick brown fox jumps over the lazy dog; the quick brown fox jumps over the lazy dog; the quick brown fox jumps over the lazy dog;";
        return cell;
    } else {
        static NSString *cellIdentifier = @"QuizMCQCell";
    
        QuizMCQCell *cell = (QuizMCQCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"QuizMCQCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.option0Label.text = @"this is 0 option";
        cell.option1Label.text = @"working with a great company and with a great family by your side";
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
        cell.slider.transform = trans;
        [cell.slider setMinimumTrackTintColor:[UIColor orangeColor]];
        [cell.slider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        return cell;
    }
    
}
@end
