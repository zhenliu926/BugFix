//
//  PriceField.h
//  WutzWhat
//
//  Created by Zeeshan on 12/10/12.
//
//

#import <UIKit/UIKit.h>

@interface PriceField : UITextField <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,retain) UIPickerView *priceTextField;
@property (nonatomic,retain) UIToolbar *toolbar;
@property (nonatomic,retain) NSArray *pickerData;
@property (nonatomic,assign) NSInteger selectedRow;
-(IBAction)btnSelect:(id)sender;

- (IBAction)btnCancel:(id)sender;

-(void)apply;
@end
 