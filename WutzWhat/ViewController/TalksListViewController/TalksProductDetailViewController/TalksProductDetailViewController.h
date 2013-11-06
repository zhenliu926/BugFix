//
//  TalksProductDetailViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import <UIKit/UIKit.h>
#import "TalksModel.h"
#import "MapViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TSMiniWebBrowser.h"
#import <EventKit/EventKit.h>
#import "DummyLandscapViewController.h"
#import "IIViewDeckController.h"
#import "AFImageViewer.h"
#import "Utiltiy.h"
#import "TalkSingletonManager.h"
#import "SharedManager.h"
#import "Constants.h"
#import "DataFetcher.h"
#import "GPPShare.h"
#import "BDKNotifyHUD.h"
#import "ProcessingView.h"
#import "CommonFunctions.h"
#import "MWPhotoBrowser.h"
#import "MapViewController.h"
#import "AddTalkViewController.h"
#import "MoviePlayerController.h"
#import "ImagesURLModel.h"

@class AFImageViewer;

@protocol TalksProductDetailViewControllerDelegate <NSObject>

-(void)successfullyDeletedTalk;
-(void)successfullyEditTalk;

@end

@interface TalksProductDetailViewController : UIViewController
<
DataFetcherDelegate,
ABNewPersonViewControllerDelegate,
TSMiniWebBrowserDelegate,
UIActionSheetDelegate,
GPPShareDelegate,
UIAlertViewDelegate,
MWPhotoBrowserDelegate,
AddTalkViewControllerDelegate,
AFImageViewerDelegate
>
{
    NSMutableArray *visibleViews;
    NSString *callno;
    NSString *title;
    NSString *shortDesc;
    NSString *strAddress;
    NSString *startingdate;
    NSString *endingDate;
    GPPShare *share_;
    NSArray *imageUrlsForPhotoGallery;
}
@property (nonatomic, assign) id <TalksProductDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) CommonFunctions *sender;
@property (weak, nonatomic) BDKNotifyHUD *notify;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UIImageView *imgTumbnailProductImage;
@property (weak, nonatomic) IBOutlet AFImageViewer *imgMainProductImage;
@property (strong, nonatomic) NSArray *imageUrlsForGallery;
@property (nonatomic,strong) TalksModel *menu;
@property (nonatomic,strong) NSMutableArray *rows;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic) int type;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UILabel *lblShortDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblHeadline;
@property (weak, nonatomic) IBOutlet UILabel *lblPosttime;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceCell;

@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblWutzwhatFactor;
@property (weak, nonatomic) IBOutlet UILabel *lblCuration;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UIButton *btnTaxi;
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
@property (nonatomic,strong) NSString *strWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imgInfoBarView;

@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;

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
@property (weak, nonatomic) IBOutlet UIView *viewPurchase;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet UIImageView *imgLongDescLine;

@property (nonatomic) int categoryType;

@property (strong, nonatomic) MoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSArray *imagesURLModelArray;

@property (strong, nonatomic)UIImage *imageForSharing;

@end
