//
//  WutzWhatProductDetailViewController.h
//  WutzWhat
//
//  Created by Zeeshan Haider on 11/18/12.
//
//

#import <UIKit/UIKit.h>
#import "WutzWhatModel.h"
#import "MapViewController.h"
#import "TSMiniWebBrowser.h"
#import "AFImageViewer.h"
#import "SharedManager.h"
#import "WutzWhatOtherLocation.h"
#import "ReviewViewController.h"
#import "AddCommentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "NearbyPlacesRequestResult.h"
#import "PostCheckinRequestResult.h"
#import "DataFetcher.h"
#import "HardCodedResponse.h"
#import "BDKNotifyHUD.h"
#import "EventDateModel.h"
#import "CommonFunctions.h"
#import "MWPhotoBrowser.h"
#import "DummyPortraitViewController.h"
#import "DummyLandscapViewController.h"
#import "MoviePlayerController.h"
#import "ImagesURLModel.h"

@class AFImageViewer;

@protocol WutzWhatProductDetailViewDelegate <NSObject>

-(void)searchListWithTagString:(NSString *)tagString;

@end

@interface WutzWhatProductDetailViewController : UIViewController
<
TSMiniWebBrowserDelegate,
MWPhotoBrowserDelegate,
UIActionSheetDelegate,
DataFetcherDelegate,
UIAlertViewDelegate,
AFImageViewerDelegate
>
{
    NSMutableArray *visibleViews;
    NSMutableArray *imageUrlsForPhotoGallery;
    NearbyPlacesRequestResult *nearbyPlacesRequestResult;
    PostCheckinRequestResult *postCheckinRequestResult;
    NSString *taxiName;
    UILabel* titleLabelReview;
    UIImageView *imageCountReview;
    UITapGestureRecognizer *oneFingerTwoTaps;
    BOOL gettingUserCurrentLocation;

}
@property (nonatomic, assign) id <WutzWhatProductDetailViewDelegate> delegate;
@property (strong, nonatomic) CommonFunctions *sender;
@property (weak, nonatomic) BDKNotifyHUD *notifySuccess;
@property (weak, nonatomic) BDKNotifyHUD *notifyFail;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UIImageView *imgTumbnailProductImage;
@property (weak, nonatomic) IBOutlet AFImageViewer *imgMainProductImage;

@property (nonatomic,strong) WutzWhatModel *menu;
@property (nonatomic,assign) NSMutableArray *rows;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UIButton *btn_likeit;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) int type;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UILabel *lblShortDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblLoveCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceCell;
@property (weak, nonatomic) IBOutlet UILabel *lblPerk;

@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblCuration;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UILabel *lblLongDescription;
@property (weak, nonatomic) IBOutlet UITextView *txtvLongDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnReview;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UIButton *btnLoveIt;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnAddtoCalender;
@property (weak, nonatomic) IBOutlet UIButton *btnFlag;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherLocations;
@property (weak, nonatomic) IBOutlet UIImageView *img_Perkbanner;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckin;
@property (nonatomic,strong) NSString *strWebsite;

@property (weak, nonatomic) IBOutlet UIView *addressTaxiView;
@property (weak, nonatomic) IBOutlet UILabel *addressTaxiLabel;
@property (weak, nonatomic) IBOutlet UIView *longDescriptionView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *calView;
@property (weak, nonatomic) IBOutlet UILabel *calLabel;
@property (weak, nonatomic) IBOutlet UIView *otherLocationView;
@property (weak, nonatomic) IBOutlet UILabel *otherLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *taxiButton;

//Blank Section

@property (weak, nonatomic) IBOutlet UIView *viewLongDesc;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIView *viewCall;
@property (weak, nonatomic) IBOutlet UIView *viewOtherLocation;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIView *viewWebSite;
@property (weak, nonatomic) IBOutlet UIView *viewEvents;
@property (weak, nonatomic) IBOutlet UIView *viewTopReviews;
@property (weak, nonatomic) IBOutlet UIView *viewTags;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIView *viewPerksBanner;
@property (strong, nonatomic) IBOutlet UIImageView *imgInfoBar;


//Asad Ali
@property (weak, nonatomic) IBOutlet UILabel *lblWebsiteAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblEvents;


@property (weak, nonatomic) IBOutlet UIImageView *imgIsPerk;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsFavourite;
@property (weak, nonatomic) IBOutlet UIImageView *imgIsHotPick;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalReviewCount;

@property (weak, nonatomic) IBOutlet UIImageView *imgLongDescLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgEventTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgTagsBottomLine;

@property (assign, nonatomic) BOOL shouldDisableMerchantBanner;

@property (nonatomic) int sectionType;
@property (nonatomic) int categoryType;

@property (strong, nonatomic) MoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSArray *imagesURLModelArray;

@property (strong, nonatomic)UIImage *imageForSharing;

@end
