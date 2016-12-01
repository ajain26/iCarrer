//
//  QuizMCQCell.h
//  iCareer
//
//  Created by Hitesh on 11/30/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizMCQCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *option0Label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *option1Label;
-(void)assignValueWithDictionary:(NSDictionary*)quizDict;
@end
