//
//  DateField.h
//  FRST
//
//  Created by hassan waheed on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeField : UITextField

@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,retain) UIToolbar *toolbar;

-(IBAction)btnSelect:(id)sender;
-(IBAction)valueChanged:(id)sender;

+(TimeField*)createDateField;
-(void)apply;

@end
