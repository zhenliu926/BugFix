//
//  PriceField.m
//  WutzWhat
//
//  Created by Zeeshan on 12/10/12.
//
//

#import "PriceField.h"

@implementation PriceField

@synthesize toolbar = _toolbar;
@synthesize selectedRow = _selectedRow;
@synthesize pickerData=_pickerData;


-(IBAction)btnSelect:(id)sender
{
    
    self.text = [self.pickerData objectAtIndex:self.selectedRow];
    
    [self resignFirstResponder];
    
}
- (IBAction)btnCancel:(id)sender
{
    self.text=@"";
    [self resignFirstResponder];
}

-(void)apply
{
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PriceField" owner:self options:nil];
    
    self.pickerData=[[NSArray alloc] initWithObjects:@"$ 1", @"$ 2", @"$ 3", @"$ 4", @"$ 5", @"$ 10", @"$ 15", @"$ 20", @"$ 30", @"$ 40", @"$ 50", @"$ 60", @"$ 70", @"$ 80", @"$ 90", @"$ 100", @"$ 120", @"$ 140", @"$ 160", @"$ 180", @"$ 200", @"$ 250", @"$ 300", @"$ 400", @"$ 500", @"$ 600", @"$ 800", @"$ 1000", @"$ 1500", @"$ 2000", @"$ 2500", @"$ 3000", nil];
    
    UIPickerView *dPicker = [objects objectAtIndex:2];

    UIToolbar *tBar = [objects objectAtIndex:1];
    [dPicker setDataSource:self];
    [dPicker setDelegate:self];
    self.inputView = dPicker;
    self.inputAccessoryView = tBar;
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView
    		 titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerData objectAtIndex:row%[self.pickerData count]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text =[self.pickerData objectAtIndex:row%[self.pickerData count]];
    self.selectedRow = row;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}
@end
