//
//  QuizMCQCell.h
//  iCareer
//
//  Created by Hitesh on 11/30/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QuizSliderDelegate <NSObject>
@optional
-(void)changedSliderValue:(float)value;
@end

@interface QuizMCQCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *option0Label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *option1Label;
@property (weak, nonatomic) id <QuizSliderDelegate> delegate;
-(void)assignValueWithDictionary:(NSDictionary*)quizDict;
@end
