//
//  ResultCell.h
//  iCareer
//
//  Created by Hitesh Kumar Singh on 07/12/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
