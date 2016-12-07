//
//  ResultVC.m
//  iCareer
//
//  Created by Hitesh on 12/1/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "ResultVC.h"
#import "HCSStarRatingView.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "ResultCell.h"

@interface ResultVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (strong, nonatomic) NSDictionary *ratingDict;
@property (weak, nonatomic) IBOutlet UILabel *skillSetLabel;
@property (strong, nonatomic) NSDictionary *otherRatingDict;
@property (strong, nonatomic) NSMutableArray *otherArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ResultVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialView];
    
}
#pragma mark - setInitialView
-(void)setInitialView{
    NSLog(@"%@",[AppHelper userDefaultsDictionary:@"skill"]);
    self.ratingDict = [AppHelper userDefaultsDictionary:@"skill"];
    self.otherRatingDict = [AppHelper userDefaultsDictionary:@"traitRating"];
    
    if (![[self.otherRatingDict objectForKey:@"trait_rating"] isKindOfClass:[NSNull class]] && [self.otherRatingDict objectForKey:@"trait_rating"]) {
        self.otherArray = [NSMutableArray arrayWithArray:[self.otherRatingDict objectForKey:@"trait_rating"]];
        [self.otherArray removeObject:self.ratingDict];
    }
    
    self.starView.maximumValue = 5;
    self.starView.minimumValue = 1;
    self.starView.value = 0;
    self.starView.tintColor = [UIColor colorWithRed:255.0/255.0 green:151.0/255.0 blue:61.0/255.0 alpha:1.0f];
    self.starView.allowsHalfStars = true;
    self.starView.accurateHalfStars = true;
    self.starView.value = [[self.ratingDict objectForKey:@"rating"] floatValue];//3.3f;
    
    self.skillSetLabel.text = [self.ratingDict objectForKey:@"skill_set"];
}
#pragma mark - explore
- (IBAction)explore:(id)sender {
    [[AppDelegate getAppDelegate] setupSideMenu];
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.otherArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ResultCell";
    
    ResultCell *cell = (ResultCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = @"";
    
    cell.starView.maximumValue = 5;
    cell.starView.minimumValue = 1;
    cell.starView.value = 0;
    cell.starView.tintColor = [UIColor colorWithRed:255.0/255.0 green:151.0/255.0 blue:61.0/255.0 alpha:1.0f];
    cell.starView.allowsHalfStars = true;
    cell.starView.accurateHalfStars = true;
    cell.starView.value = [[[self.otherArray objectAtIndex:indexPath.row] objectForKey:@"rating"] floatValue];
    
    cell.titleLabel.text = [[self.otherArray objectAtIndex:indexPath.row] objectForKey:@"skill_set"];

    
    return cell;
}
#pragma mark - share
- (IBAction)share:(id)sender {
    NSString *shareString = @"Thought you might enjoy reading this: www.icareer.com";
    NSArray *trait = [self.otherRatingDict objectForKey:@"trait_rating"];
    for (NSDictionary *dict in trait) {
        shareString = [NSString stringWithFormat:@"%@\nTrait: %@ Rating: %@",shareString,[dict objectForKey:@"skill_set"], [dict objectForKey:@"rating"]];
    }
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[shareString]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];
}
@end
