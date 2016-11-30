//
//  WelcomVC.m
//  iCareer
//
//  Created by Hitesh on 11/30/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "WelcomVC.h"

@interface WelcomVC ()

@end

@implementation WelcomVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark - goAhead
- (IBAction)goAhead:(id)sender {
    [self performSegueWithIdentifier:@"QuizVC" sender:nil];
}


@end
