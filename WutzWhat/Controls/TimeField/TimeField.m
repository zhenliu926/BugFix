//
//  DateField.m
//  FRST
//
//  Created by hassan waheed on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeField.h"

@implementation TimeField

@synthesize datePicker = _datePicker;
@synthesize toolbar = _toolbar;

+(TimeField*)createDateField
{    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TimeField" owner:self options:nil];
    TimeField *dateField = [objects objectAtIndex:0];
    [dateField.datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    dateField.toolbar = [objects objectAtIndex:2];
    
    dateField.inputView = dateField.datePicker;
    dateField.inputAccessoryView = dateField.toolbar;
    return dateField;
}

-(IBAction)valueChanged:(id)sender {
    
    UIDatePicker *dPicker = (UIDatePicker*)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh a"];
    self.text = [dateFormatter stringFromDate:dPicker.date];
}


-(IBAction)btnSelect:(id)sender {
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TimeField" owner:self options:nil];
    UIDatePicker *dPicker = [objects objectAtIndex:1];
   dPicker.datePickerMode=UIDatePickerModeTime;
    
    [self resignFirstResponder];
}

-(void)apply {
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TimeField" owner:self options:nil];
    UIDatePicker *dPicker = [objects objectAtIndex:1];
//     dPicker.maximumDate = [NSDate date];
    dPicker.datePickerMode=UIDatePickerModeTime;
    UIToolbar *tBar = [objects objectAtIndex:2];
    
    self.inputView = dPicker;
    self.inputAccessoryView = tBar;
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}
@end
