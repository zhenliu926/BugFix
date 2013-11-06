//
//  CreditCardTypeField.h
//  WutzWhat
//
//  Created by iPhone Development on 2/26/13.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    PopupTypeCountry,
    PopupTypeCreditCard,
    PopupTypeExpiryDate
} PopupType;

@interface CreditCardTypeField : UITextField <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *dataArray;
}

@property (nonatomic,retain) UIPickerView *priceTextField;
@property (nonatomic,retain) UIToolbar *toolbar;
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,assign) NSInteger selectedRowYear;
@property (nonatomic,assign) PopupType type;

-(IBAction)btnSelect:(id)sender;

-(IBAction)btnCancel:(id)sender;

-(void)apply;

@end
