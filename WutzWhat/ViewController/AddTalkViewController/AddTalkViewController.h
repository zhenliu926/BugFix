//
//  AddTalkViewController.h
//  WutzWhat
//
//  Created by Rafay on 11/19/12.
//
//

#import <UIKit/UIKit.h>
#import "AddMyFindDataFetcer.h"
#import "Constants.h"
#import "TimeField.h"
#import "DateField.h"
#import <QuartzCore/QuartzCore.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "ProcessingView.h"
#import "BDKNotifyHUD.h"
#import "Base64.h"
#import "GoogleAddressAPI.h"
#import "GoogleLocationAPIModel.h"
#import "ChangeLocationViewController.h"
#import "GoogleAddressAPIResultViewController.h"
#import "TalksDetailModel.h"
#import "TalksDetailAPIManager.h"
#import "ImagesURLModel.h"

@protocol AddTalkViewControllerDelegate <NSObject>
@optional
-(void)successfullyAddedNewTalkForCategory:(int)category;
-(void)successfullyEditedTalkForCategory:(int)category;

@end

@interface AddTalkViewController : UIViewController
<
AddMyFindDataFetcerDelegate,
UITextViewDelegate,
UITextFieldDelegate,
UIImagePickerControllerDelegate,
MKMapViewDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
GoogleAddressAPIDelegate,
GoogleAddressAPIResultViewDelegate,
TalksDetailAPIManagerDelegate,
UINavigationControllerDelegate
>
{
    int imageCount;
    int oldImagesID;
    NSMutableArray *imageArray;
    CGSize sizeofscroll;
    NSArray *googleAddressSuggestions;
    AddMyFindDataFetcer *fetcher;
   __strong GoogleAddressAPI *addressSuggestions;
}

@property (assign, nonatomic) id <AddTalkViewControllerDelegate> delegate;

@property (strong, nonatomic) BDKNotifyHUD *notifySuccess;
@property (strong, nonatomic) BDKNotifyHUD *notifyFail;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollInputData;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtShrtDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtLongDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;

@property (strong, nonatomic) IBOutlet UIButton *btnPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;

@property (strong, nonatomic) IBOutlet UIButton *btnSearchMap;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;

@property (strong, nonatomic) IBOutlet DateField *txtStaartDate;

@property (nonatomic, retain)UIActionSheet *pickerActionSheet;
@property (nonatomic, retain)UIPickerView *uiPickerView;

@property (nonatomic, strong) NSString *talkID;

@property (strong, nonatomic) IBOutlet DateField *txtEndingDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (readwrite, nonatomic) int categoryIndex;

@property (strong, nonatomic) IBOutlet UIView *ViewBelow;
@property (strong, nonatomic) IBOutlet UIButton *btnAddImages;
@property (strong, nonatomic) IBOutlet UIScrollView *ViewImages;

//-(BOOL) passesValidationtextView:(UITextView *)textView regexString:(NSString *)regexString;
//-(BOOL) passesValidation:(UITextField *)textField regexString:(NSString *)regexString;

@property (strong, nonatomic) IBOutlet UIView *viewEventDate;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;

@property (strong, nonatomic) IBOutlet UITextView *txtWebSiteAddress;

@property (strong, nonatomic) TalksDetailModel *detailModel;
@property (assign, nonatomic) BOOL editMode;

@property (strong, nonatomic) NSMutableArray *newlyAddedImages;
@property (strong, nonatomic) NSMutableArray *deletedImages;

@end
