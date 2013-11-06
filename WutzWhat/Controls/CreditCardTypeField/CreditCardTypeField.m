//
//  CreditCardTypeField.m
//  WutzWhat
//
//  Created by iPhone Development on 2/26/13.
//
//

#define YEARS_ARRAY [NSArray arrayWithObjects: @"2013", @"2014", @"2015", @"2016", @"2017", @"2018", @"2019", @"2020", @"2021", @"2022", @"2023", @"2024", @"2025", @"2026", @"2027", @"2028", @"2029", @"2030", @"2031", @"2032", @"2033", @"2034", @"2035", @"2036", nil]

#define MONTHS_ARRAY [NSArray arrayWithObjects: @"01",@"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil]

#import "CreditCardTypeField.h"

@implementation CreditCardTypeField

@synthesize toolbar = _toolbar;
@synthesize selectedRow = _selectedRow;
@synthesize type = _type;
@synthesize selectedRowYear = _selectedRowYear;


-(IBAction)btnSelect:(id)sender
{
    if (self.type == PopupTypeExpiryDate)
    {
        self.text = [NSString stringWithFormat:@"%@/%@",[dataArray objectAtIndex:self.selectedRow], [YEARS_ARRAY objectAtIndex:self.selectedRowYear]];
    }
    else
    {
         self.text = [dataArray objectAtIndex:self.selectedRow];
    }
    
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
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Payment" ofType:@"plist"];
    
    if (self.type == PopupTypeCountry)
    {
        dataArray = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"CountryList"];
    }
    else if (self.type == PopupTypeCreditCard)
    {
        dataArray = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"CardTypes"];
    }
    else
    {
        dataArray = MONTHS_ARRAY;
    }
    
    UIPickerView *dPicker = [objects objectAtIndex:2];
    
    UIToolbar *tBar = [objects objectAtIndex:1];

    [dPicker setDataSource:self];
    [dPicker setDelegate:self];
    
    self.inputView = dPicker;
    self.inputAccessoryView = tBar;
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == PopupTypeExpiryDate)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1)
    {
        return [YEARS_ARRAY count];
    }
    else
    {
        return [dataArray count];
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 1)
    {
        return [YEARS_ARRAY objectAtIndex:row%[YEARS_ARRAY count]];
    }
    else
    {
        return [dataArray objectAtIndex:row%[dataArray count]];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1)
    {
        self.selectedRowYear = row;
    }
    else
    {
         self.selectedRow = row;
    }
    
    if (self.type == PopupTypeExpiryDate)
    {
        self.text = [NSString stringWithFormat:@"%@/%@",[dataArray objectAtIndex:self.selectedRow%[dataArray count]], [YEARS_ARRAY objectAtIndex:self.selectedRowYear%[YEARS_ARRAY count]]];
    }
    else
    {
        self.text =[dataArray objectAtIndex:row%[dataArray count]];
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


@end


