//
//  SideMenuCell.h
//  iCareer
//
//  Created by Hitesh on 12/3/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)assignTitle:(NSString *)title andIcon:(NSString*)icon;
@end
