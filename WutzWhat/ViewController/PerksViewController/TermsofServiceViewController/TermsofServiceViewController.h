//
//  TermsofServiceViewController.h
//  WutzWhat
//
//  Created by Rafay on 1/29/13.
//
//

#import <UIKit/UIKit.h>

@interface TermsofServiceViewController : UIViewController
{
}


@property (strong, nonatomic) IBOutlet UILabel *lblTermsOfServices;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsOfServicesDescription;
@property (strong, nonatomic) NSString *termsOfServices;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end
