//
//  DateField.h
//  TradiePoint
//
//  Created by INMM001 on 9/5/12.
//  Copyright (c) 2012 Tkxel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateField : UITextField<UITextFieldDelegate>
{
    BOOL full ;
   
}
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,retain) IBOutlet UIDatePicker *datePick;
@property (nonatomic,retain) UIToolbar *toolbar;

-(IBAction)btnSelect:(id)sender;
-(IBAction)valueChanged:(id)sender;
- (IBAction)btnCancel:(id)sender;

-(void)apply;
-(void)apply_full;
@end
