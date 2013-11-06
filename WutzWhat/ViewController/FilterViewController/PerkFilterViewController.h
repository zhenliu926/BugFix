//
//  PerkFilterViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 2/1/13.
//
//

#import <UIKit/UIKit.h>
#import "DateField.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreLocation/CoreLocation.h"
#import "IIViewDeckController.h"
#import "FilterModel.h"
#import "PriceField.h"

@protocol PerkFilterDelegate <NSObject>

-(void)filterListUsingFilterSetting:(FilterModel *)filterModel;
-(void)clearFilterSettings;

@end

@interface PerkFilterViewController : UIViewController<UITextFieldDelegate>
{
    NSString *sliderRangeText;
    
    int PRICE_MAX;
    int PRICE_MIN;
    
    CLLocationCoordinate2D location;
}

@property (strong, nonatomic)id<PerkFilterDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet DateField *txtStartDate;
@property (strong, nonatomic) IBOutlet DateField *txtEndDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgtxtStartDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgtxtEndDate;
@property (strong, nonatomic) IBOutlet PriceField *txtMinPrice;
@property (strong, nonatomic) IBOutlet PriceField *txtMaxPrice;

@property (strong, nonatomic) FilterModel *savedFilter;
@property (nonatomic) NSInteger FilterBy;
@property (nonatomic) float Price;

@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *openState;

@property(nonatomic,retain) NSString *StartDate;
@property(nonatomic,retain) NSString *EndDate;
@property(nonatomic,retain)UISegmentedControl *switchView;
@property(nonatomic,retain)NSString *location;

@property (strong, nonatomic) IBOutlet UIButton *btnLatestSortBy;
@property (strong, nonatomic) IBOutlet UIButton *btnDistanceSortBy;
@property (strong, nonatomic) IBOutlet UIButton *btnEventDateSortBy;
@property (strong, nonatomic) IBOutlet UIButton *btnDefault;

- (IBAction)btnDefaultClick:(id)sender;
- (IBAction)btnLatestSortByClicked:(id)sender;
- (IBAction)btnDistanceSortByClicked:(id)sender;
- (IBAction)btnEventDateSortByClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnOpenNowOnly;

- (IBAction)btnChangePinLocationClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblCurrentLocation;
@property (strong, nonatomic) FilterModel *filterModel;

@property (assign, nonatomic) int categoryType;
@property (strong, nonatomic) NSString *moduleType;

@property (strong, nonatomic) IBOutlet UIView *viewEventDates;
@property (strong, nonatomic) IBOutlet UIView *viewButtom;


@end

