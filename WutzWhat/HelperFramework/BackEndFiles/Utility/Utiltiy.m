//
//  Utiltiy.m
//  Swella
//
//  Created by Yunas Qazi on 3/24/12.
//  Copyright (c) 2012 Style360. All rights reserved.
//

#import "Utiltiy.h"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};


@implementation Utiltiy

@synthesize notifySuccess=_notifySuccess;
@synthesize notifyFail=_notifyFail;

+ (BDKNotifyHUD *)notifySuccess{return nil;}
+ (BDKNotifyHUD *)notifyFail{return  nil;}
+ (void)displayNotification : (BOOL)isSuccessfull{}

+(BOOL)isNumeric :(NSString *)str
{

	
	BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:str];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;

}

+(BOOL)isPhoneNumber :(NSString *)str
{
	
	BOOL isValid = NO;

    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:str];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    
	if ([str hasPrefix:@"."]) {
		isValid = NO;
	}

	return isValid;
	
}

+ (NSString *)stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}

+ (void) showAlertWithTitle:(NSString *)title andMsg:(NSString*)msg
{
    UIAlertView *av =  [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
    return;
}

+ (void) showInternetConnectionErrorAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message != nil ? message : MSG_NO_INTERNET_CONNECTIVITY delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    return;
}

#pragma mark -
#pragma mark HUD
#pragma mark -

-(BDKNotifyHUD *)notifySuccess:(UIView *)containerView
{
    if (_notifySuccess != nil) return _notifySuccess;
    _notifySuccess = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@""] text:@"Thank you for signing up! Enjoy Wutzwhat"];
    _notifySuccess.center = CGPointMake(containerView.center.x, containerView.center.y - 20);
    return _notifySuccess;
}

- (BDKNotifyHUD *)notifyFail:(UIView *)containerView
{
    if (_notifyFail != nil) return _notifyFail;
    _notifyFail = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
    _notifyFail.center = CGPointMake(containerView.center.x, containerView.center.y - 20);
    return _notifyFail;
}

+ (void)displayNotification:(BOOL)isSuccessfull forView:(UIView *)containerView
{
    Utiltiy *utilities = [[Utiltiy alloc] init];
    
    if (isSuccessfull)
    {
        if ([[utilities notifySuccess:containerView] isAnimating]) return;
        
        [containerView addSubview:self.notifySuccess];
        [self.notifySuccess presentWithDuration:1.0f speed:0.5f inView:containerView completion:^
        {
            [self.notifySuccess removeFromSuperview];
        }];
    }
    else
    {
        if (self.notifyFail.isAnimating) return;
        
        [containerView addSubview:self.notifyFail];
        [self.notifyFail presentWithDuration:1.0f speed:0.5f inView:containerView completion:^
        {
            [self.notifyFail removeFromSuperview];
        }];
    }
    
}


#pragma mark - UINavigation Bar Customization

+(void)setupAppNavigationBarStyle
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0f],UITextAttributeTextColor,
                                               [UIColor whiteColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                               [UIFont fontWithName:HELVETIC_NEUE_BOLD size:21], UITextAttributeFont, nil];
    
    NSDictionary *barButtonNormalTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0f],UITextAttributeTextColor,
                                                        [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                        [UIFont fontWithName:HELVETIC_NEUE_BOLD size:13], UITextAttributeFont, nil];
    
    NSDictionary *barButtonHighlightedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0f],UITextAttributeTextColor,
                                                             [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                             [UIFont fontWithName:HELVETIC_NEUE_BOLD size:13], UITextAttributeFont, nil];
    
    
    NSDictionary *barButtonDisabledTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0f],UITextAttributeTextColor,
                                                          [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:HELVETIC_NEUE_BOLD size:13], UITextAttributeFont, nil];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0f]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonNormalTitleTextAttributes forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonHighlightedTitleTextAttributes forState:UIControlStateHighlighted];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonDisabledTitleTextAttributes forState:UIControlStateDisabled];
}

+(void)setupMoviePlayerNavigationBarStyle
{
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               nil,UITextAttributeTextColor,
                                               [UIColor whiteColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                               [UIFont fontWithName:HELVETIC_NEUE_BOLD size:21], UITextAttributeFont, nil];
    
    NSDictionary *barButtonNormalTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        nil,UITextAttributeTextColor,
                                                        [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                        [UIFont fontWithName:HELVETIC_NEUE_BOLD size:13], UITextAttributeFont, nil];
    
    NSDictionary *barButtonHighlightedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             nil,UITextAttributeTextColor,
                                                             [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                             [UIFont fontWithName:HELVETIC_NEUE_BOLD size:13], UITextAttributeFont, nil];
    
    
    NSDictionary *barButtonDisabledTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          nil,UITextAttributeTextColor,
                                                          [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:HELVETIC_NEUE_BOLD size:13], UITextAttributeFont, nil];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    [[UINavigationBar appearance] setTintColor:nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonNormalTitleTextAttributes forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonHighlightedTitleTextAttributes forState:UIControlStateHighlighted];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barButtonDisabledTitleTextAttributes forState:UIControlStateDisabled];
}

@end
