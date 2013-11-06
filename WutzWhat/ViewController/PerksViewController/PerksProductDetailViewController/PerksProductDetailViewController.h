//
//  PerksProductDetailViewController.h
//  WutzWhat
//
//  Created by Zeeshan on 12/11/12.
//
//

#import <UIKit/UIKit.h>
#import "PerksModel.h"
#import "MapViewController.h"
#import "DummyLandscapViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TSMiniWebBrowser.h"
#import "AFImageViewer.h"
#import "SharedManager.h"
#import "WutzWhatOtherLocation.h"
#import "ReviewViewController.h"
#import "AddCommentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "NearbyPlacesRequestResult.h"
#import "PostCheckinRequestResult.h"
#import "RelatedPerksViewController.h"
#import "BDKNotifyHUD.h"
#import "PaymentViewController.h"
#import "EventDateModel.h"
#import "CommonFunctions.h"
#import "PaymentViewController.h"
#import "MWPhotoBrowser.h"
#import "MoviePlayerController.h"
#import "ImagesURLModel.h"

@class CommonFunctions;
@class WutzWhatProductDetailViewController;

@protocol PerksProductDetailViewDelegate <NSObject>

-(void)searchListWithTagString:(NSString *)tagString;

@end

@interface PerksProductDetailViewController : UIViewController
<
ABNewPersonViewControllerDelegate,
TSMiniWebBrowserDelegate,
UIActionSheetDelegate,
DataFetcherDelegate,
AFImageViewerDelegate,
MWPhotoBrowserDelegate
>
{
    NSMutableArray *visibleViews;
    NSMutableArray *imageUrlsForPhotoGallery;
    NearbyPlacesRequestResult *nearbyPlacesRequestResult;
    PostCheckinRequestResult *postCheckinRequestResult;
    UIImageView *imageCountReview;
    UILabel* titleLabelReview;
}
@property (nonatomic, assign) id <PerksProductDetailViewDelegate> delegate;
@property (strong, nonatomic) CommonFunctions *sender;
@property (strong, nonatomic) BDKNotifyHUD *notify;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *imgTumbnailProductImage;
@property (strong, nonatomic) IBOutlet AFImageViewer *imgMainProductImage;
@property (nonatomic,retain) PerksModel *menu;
@property (nonatomic,retain) NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblCredits;
@property (strong, nonatomic) IBOutlet UIImageView *imgisFav;
@property (strong, nonatomic) IBOutlet UIButton *btn_likeit;
@property (strong, nonatomic) NSArray *imageUrlsForGallery;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) int type;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTag;
@property (strong, nonatomic) IBOutlet UIImageView *imgType;
@property (strong, nonatomic) IBOutlet UIButton *btnMyCredits;
@property (strong, nonatomic) IBOutlet UILabel *lblShortDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblHeadline;
@property (strong, nonatomic) IBOutlet UILabel *lblLoveCount;
@property (strong, nonatomic) IBOutlet UILabel *lblReviewCount;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceCell;
@property (strong, nonatomic) IBOutlet UILabel *lblPerk;
@property (strong, nonatomic) IBOutlet UILabel *lblActualPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblMyCredits;
@property (strong, nonatomic) IBOutlet UIView *viewPerkBanner;

@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblCuration;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UILabel *lblLongDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtvLongDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnWebsite;
@property (strong, nonatomic) IBOutlet UIButton *btnEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnReview;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong, nonatomic) IBOutlet UIButton *btnLoveIt;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnAddtoCalender;
@property (strong, nonatomic) IBOutlet UIButton *btnFlag;
@property (strong, nonatomic) IBOutlet UIImageView *img_Perkbanner;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckin;
@property (nonatomic,retain) NSString *strWebsite;
@property (strong, nonatomic) IBOutlet UIButton *btnOtherLocations;
@property (strong, nonatomic) IBOutlet UIView *addressTaxiView;
@property (strong, nonatomic) IBOutlet UILabel *addressTaxiLabel;

@property (strong, nonatomic) IBOutlet UIView *longDescriptionView;

@property (strong, nonatomic) IBOutlet UIView *priceView;

@property (strong, nonatomic) IBOutlet UIView *calView;
@property (strong, nonatomic) IBOutlet UILabel *calLabel;

@property (strong, nonatomic) IBOutlet UIView *otherLocationView;
@property (strong, nonatomic) IBOutlet UILabel *otherLocationLabel;

@property (strong, nonatomic) NSString *termsOfServices;

@property (weak, nonatomic) IBOutlet UIButton *taxiButton;

//Blank Section

@property (strong, nonatomic) IBOutlet UIView *viewLongDesc;
@property (strong, nonatomic) IBOutlet UIView *viewPrice;
@property (strong, nonatomic) IBOutlet UIView *viewMap;
@property (strong, nonatomic) IBOutlet UIView *viewCall;
@property (strong, nonatomic) IBOutlet UIView *viewOtherLocation;
@property (strong, nonatomic) IBOutlet UIView *viewTime;
@property (strong, nonatomic) IBOutlet UIView *viewWebSite;
@property (strong, nonatomic) IBOutlet UIView *viewEvents;
@property (strong, nonatomic) IBOutlet UIView *viewTopReviews;
@property (strong, nonatomic) IBOutlet UIView *viewTags;
@property (strong, nonatomic) IBOutlet UIView *viewPurchase;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIButton *btnPurchase;
@property (strong, nonatomic) IBOutlet UIButton *btnPerkPurchase;
@property (strong, nonatomic) IBOutlet UIImageView *imgInfoBarView;


//Asad Ali
@property (strong, nonatomic) IBOutlet UILabel *lblWebsiteAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblEvents;


@property (strong, nonatomic) IBOutlet UILabel *lblTotalReviewCount;

@property (strong, nonatomic) IBOutlet UIImageView *imgLongDescLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgEventTime;

@property (assign, nonatomic) BOOL shouldDisableMerchantBanner;

- (IBAction)btnPurchase_pressed:(id)sender;
@property (nonatomic) int categoryType;

@property (strong, nonatomic) MoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSArray *imagesURLModelArray;

@property (strong, nonatomic)UIImage *imageForSharing;

@end
