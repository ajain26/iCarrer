//
//  ResultVC.m
//  iCareer
//
//  Created by Hitesh on 12/1/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "ResultVC.h"
#import "HCSStarRatingView.h"

@interface ResultVC ()
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;

@end

@implementation ResultVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.starView.maximumValue = 5;
    self.starView.minimumValue = 1;
    self.starView.value = 0;
    self.starView.tintColor = [UIColor colorWithRed:255.0/255.0 green:151.0/255.0 blue:61.0/255.0 alpha:1.0f];
    self.starView.allowsHalfStars = true;
    self.starView.accurateHalfStars = true;
    self.starView.value = 3.3f;
}
- (IBAction)explore:(id)sender {
    
}

@end
