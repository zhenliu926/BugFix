//
//  GoogleAddressAPIResultViewController.h
//  WutzWhat
//
//  Created by iPhone Development on 4/8/13.
//
//

#import <UIKit/UIKit.h>
#import "GoogleLocationAPIModel.h"

@protocol GoogleAddressAPIResultViewDelegate <NSObject>

-(void)userSelectNewAddress:(NSString *)address WithLat:(NSString *)latitude longitude:(NSString *)longitude;
@optional
-(void)userSelectNewAddress:(NSString *)address;
@end

@interface GoogleAddressAPIResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (assign, nonatomic) id<GoogleAddressAPIResultViewDelegate> delegate;

@property (strong, nonatomic) NSArray *googleAddressSuggestions;

@property (strong, nonatomic) IBOutlet UITableView *tblGoogleAddressResults;

- (IBAction)btnCancelClicked:(id)sender;


@end
