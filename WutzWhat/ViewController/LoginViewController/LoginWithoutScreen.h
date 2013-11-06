//
//  LoginWithoutScreen.h
//  WutzWhat
//
//  Created by Andy Khatter on 2013-10-15.
//
//

#import <Foundation/Foundation.h>

@interface LoginWithoutScreen : UIViewController
<
DataFetcherDelegate,
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    NSString *access_token;
    NSDictionary *facebookUserData;
    BOOL isFacebookLogin;
    BOOL reActivation;
    NSString *emailString;
}
@property (nonatomic,retain) NSString *user_email;
@property (nonatomic,retain) NSString *access_token;

-(void)Login;
@end
