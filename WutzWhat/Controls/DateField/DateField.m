//
//  DateField.m
//  TradiePoint
//
//  Created by INMM001 on 9/5/12.
//  Copyright (c) 2012 Tkxel. All rights reserved.
//

#import "DateField.h"

@implementation DateField

@synthesize datePicker = _datePicker;
@synthesize toolbar = _toolbar;
@synthesize delegate;
-(UIDatePicker *)datePicker
{
    if (_datePicker == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DateFieldFull" owner:self options:nil];
        _datePicker = [objects objectAtIndex:1];
    }
    
    return _datePicker;
}


-(IBAction)valueChanged:(id)sender
{
    if (full)
    {
        UIDatePicker *dPicker = (UIDatePicker*)sender;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:ADD_MY_FIND_DATE_FORMATE];
        self.text = [dateFormatter stringFromDate:dPicker.date];
    }else
    {
        UIDatePicker *dPicker = (UIDatePicker*)sender;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        self.text = [dateFormatter stringFromDate:dPicker.date];
    }
}



-(IBAction)btnSelect:(id)sender
{
    if (full)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:ADD_MY_FIND_DATE_FORMATE];
        NSLog(@"Integer : %@", self.datePicker.date);
        self.text = [dateFormatter stringFromDate:self.datePicker.date];
        [self resignFirstResponder];
    }
    else
    {
        [self resignFirstResponder];
    }
}

- (IBAction)btnCancel:(id)sender {
    self.text=@"";
    [self resignFirstResponder];
}

-(void)apply
{
    full=NO;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DateField" owner:self options:nil];
    UIDatePicker *dPicker = [objects objectAtIndex:1];
    
    UIToolbar *tBar = [objects objectAtIndex:2];

    self.inputView = dPicker;
    self.inputAccessoryView = tBar;
    
}

-(void)apply_full
{
    full=YES;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"DateFieldFull" owner:self options:nil];

    UIToolbar *tBar = [objects objectAtIndex:2];
    self.inputView = self.datePicker;
    self.inputAccessoryView = tBar;
    
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}



@end
