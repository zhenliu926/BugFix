//
//  CustomCell.m
//  WutzWhat
//
//  Created by Andrew Apperley on 2013-07-10.
//
//

#import "CustomCell.h"

@implementation CustomCell

- (void) layoutSubviews
{

    [super layoutSubviews];
    CGRect frame = self.backgroundView.frame;
    frame.origin.x = 0;
    frame.size.width = 320;
    self.backgroundView.frame = frame;
    self.selectedBackgroundView.frame = frame;
    frame = self.contentView.frame;
    frame.origin.x = 0;
    frame.size.width  = 320;
    self.contentView.frame = frame;
    
}

@end
