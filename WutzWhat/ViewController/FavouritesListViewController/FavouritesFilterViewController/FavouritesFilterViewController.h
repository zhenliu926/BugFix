//
//  FavouritesFilterViewController.h
//  WutzWhat
//
//  Created by Rafay on 12/10/12.
//
//

#import <UIKit/UIKit.h>
#import "DateField.h"
#import "RangeSlider.h"

@interface FavouritesFilterViewController : UIViewController{
    NSString *sliderRangeText;
    
}
-(void)updateRangeLabel:(RangeSlider *)slider;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet DateField *txtStartDate;
@property (strong, nonatomic) IBOutlet DateField *txtEndDate;
@property (nonatomic) NSInteger FilterBy;
@property (nonatomic) float Price;
@property (nonatomic) BOOL Open;
@property (strong, nonatomic) IBOutlet UIView *sliderView;

@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@property (strong, nonatomic) IBOutlet UIButton *openState;
@property(nonatomic,retain) NSString *StartDate;
@property(nonatomic,retain) NSString *EndDate;
@property(nonatomic,retain)UISegmentedControl *switchView;
@property(nonatomic,retain) RangeSlider *slider;
@end


