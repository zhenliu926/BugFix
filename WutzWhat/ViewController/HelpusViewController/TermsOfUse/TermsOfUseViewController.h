//
//  TermsOfUseViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 5/7/13.
//
//

#import <UIKit/UIKit.h>
#import "CommonFunctions.h"

@interface TermsOfUseViewController : UIViewController <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>
{
    
}

@property (strong, nonatomic) CommonFunctions *commonFunction;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;

- (IBAction)btnTermsOfServiceSiteClicked:(id)sender;
- (IBAction)btnPrivacySiteClicked:(id)sender;
- (IBAction)btnEmailUsClicked:(id)sender;


@end
