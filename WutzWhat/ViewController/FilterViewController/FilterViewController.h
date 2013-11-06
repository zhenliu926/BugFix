//
//  FilterViewController.m
//  WutzWhat
//
//  Created by Asad Ali on 01/22/13.
//
//
//

#import <UIKit/UIKit.h>
#import "DateField.h"
#import "RangeSlider.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreLocation/CoreLocation.h"
#import "FilterModel.h"

@protocol FilterDelegate <NSObject>

-(void)filterListUsingFilterSetting:(FilterModel *)filterModel;
-(void)clearFilterSettings;

@end

@interface FilterViewController : UIViewController<UITextFieldDelegate>
{
    NSString *sliderRangeText;
    
    float PRICE_MAX;
    float PRICE_MIN;
    
    CLLocationCoordinate2D location;
}

@property (strong, nonatomic)id<FilterDelegate> delegate;

-(void)updateRangeLabel:(RangeSlider *)slider;

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIImageView *imgtxtStartDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgtxtEndDate;
@property (strong, nonatomic) IBOutlet DateField *txtStartDate;
@property (strong, nonatomic) IBOutlet DateField *txtEndDate;

@property (nonatomic) NSInteger FilterBy;
@property (nonatomic) float Price;
@property (nonatomic) BOOL Open;
@property (strong, nonatomic) FilterModel *savedFilter;

@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *openState;

@property(nonatomic,retain) NSString *StartDate;
@property(nonatomic,retain) NSString *EndDate;
@property(nonatomic,retain)UISegmentedControl *switchView;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain) RangeSlider *slider;

@property (strong, nonatomic) IBOutlet UIButton *btnLatestSortBy;
@property (strong, nonatomic) IBOutlet UIButton *btnDistanceSortBy;
@property (strong, nonatomic) IBOutlet UIButton *btnEventDateSortBy;

- (IBAction)btnLatestSortByClicked:(id)sender;
- (IBAction)btnDistanceSortByClicked:(id)sender;
- (IBAction)btnEventDateSortByClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnOpenNowOnly;

- (IBAction)btnChangePinLocationClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentLocation;

@property (strong, nonatomic) FilterModel *filterModel;

@property (assign, nonatomic) int categoryType;
@property (assign, nonatomic) int sectionType;
@property (strong, nonatomic) NSString *moduleType;


@property (strong, nonatomic) IBOutlet UIView *viewEventDates;
@property (strong, nonatomic) IBOutlet UIView *viewButtom;

//New Filter Slider

@property (strong, nonatomic) IBOutlet UIButton *lblPrice1;
@property (strong, nonatomic) IBOutlet UIButton *lblPrice2;
@property (strong, nonatomic) IBOutlet UIButton *lblPrice3;
@property (strong, nonatomic) IBOutlet UIButton *lblPrice4;

- (IBAction)btnPrice1Clicked:(id)sender;
- (IBAction)btnPrice2Clicked:(id)sender;
- (IBAction)btnPrice3Clicked:(id)sender;
- (IBAction)btnPrice4Clicked:(id)sender;


@end