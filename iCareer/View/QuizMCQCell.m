//
//  QuizMCQCell.m
//  iCareer
//
//  Created by Hitesh on 11/30/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "QuizMCQCell.h"

@implementation QuizMCQCell

-(void)assignValueWithDictionary:(NSDictionary *)quizDict{
    NSArray *optionsArray;
    if (![[quizDict objectForKey:@"question"] isKindOfClass:[NSNull class]] && [quizDict objectForKey:@"question"]) {
        optionsArray = [[quizDict objectForKey:@"question"] componentsSeparatedByString:@"|"];
    }
    
    self.option0Label.text = @"";
    self.option1Label.text = @"";
    
    if (optionsArray.count > 0) {
        self.option0Label.text = [[optionsArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.option1Label.text = [[optionsArray objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
    self.slider.transform = trans;
    [self.slider setMinimumTrackTintColor:[UIColor orangeColor]];
    [self.slider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    self.slider.value = 5.0f;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
#pragma mark - sliderValueChanged
-(void)sliderValueChanged:(UISlider*)sender{
    NSLog(@"---- slider value = %f", sender.value);
    [self.delegate changedSliderValue:sender.value];
}
@end
