//
//  IprofileSummaryCell.h
//  iCareer
//
//  Created by Hitesh on 12/6/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IprofileSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
-(void)setBorderToContentImageView;
@end
