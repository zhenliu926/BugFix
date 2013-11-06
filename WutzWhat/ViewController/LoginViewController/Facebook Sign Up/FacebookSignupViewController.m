//
//  FacebookSignupViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 16/11/2012.
//
//
#define kFormInvalidIndicatorViewSize 16.0f
#define MAX_USER_NAME_LENGTH 32

#import "FacebookSignupViewController.h"
#import "Utiltiy.h"
#import "WutzWhatListViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FacebookSignupViewController ()

@end

@implementation FacebookSignupViewController

@synthesize resultDictionary = _resultDictionary;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CityViaModal"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"CityViaModal" forKey:@"CityViaModal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    [_btnSelectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnSelectCity setTitle:@"Toronto" forState:UIControlStateNormal];
    [_btnSelectCity setTitle:@"Toronto" forState:UIControlEventTouchUpInside];
    [[NSUserDefaults standardUserDefaults] setObject:@"Toronto" forKey:@"cityselected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    _btnImgSelect.clipsToBounds=YES;
    _btnImgSelect.layer.cornerRadius = 5;
    
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_wutzwhat.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    resultDictionary = appDelegate.facebookData;
    
	UITapGestureRecognizer *oneFingerTwoTaps =[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector (btnImgSelect_click:)];
    
    
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    [self.btnImgSelect addGestureRecognizer:oneFingerTwoTaps];
    
    int length = [[resultDictionary objectForKey:@"id"] length];
    if (length>0)
    {
        NSString *string=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=105&height=109",[resultDictionary objectForKey:@"id"]];
        NSURL *url = [NSURL URLWithString:string];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        UIImage *tmpImage = [[UIImage alloc] initWithData:data];
        
        [_btnImgSelect setImage:tmpImage forState:UIControlStateNormal];
    }
    
    _txtUsername.text=[resultDictionary objectForKey:@"username"];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signupfb_bg"]]];
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"]);
    [_btnSelectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnSelectCity setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"] forState:UIControlStateNormal];
    [_btnSelectCity setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"] forState:UIControlEventTouchUpInside];
    
    [self checkUserAvailablity];
    
//    timer= [NSTimer scheduledTimerWithTimeInterval:0.1
//                                            target:self
//                                          selector:@selector(updateViewsForFormValidity)
//                                          userInfo:nil
//                                           repeats:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Button Actions
#pragma mark -


- (IBAction)btnSelectCityClicked:(id)sender
{
    CityViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    controller.isFromMainMenu = NO;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnImgSelect_click:(UIGestureRecognizer*)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}


- (IBAction)btnEditProfilePicture_clicked:(id)sender
{
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
        
        [actionSheet showInView:self.view];
    }
}


- (void) checkUserAvailablity
{
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@",BASE_URL,USERNAME_AVAILABILITY_URL,_txtUsername.text] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
}

- (IBAction)btnSignUp_click:(id)sender
{
    [self registerUserAPICall];
}

-(void)registerUserAPICall
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    UIImage *img = [_btnImgSelect imageForState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    encodedString = [Base64 encode:imageData];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [params setValue:[resultDictionary objectForKey:@"email"] forKey:@"user_email"];
    [params setValue:_txtUsername.text forKey:@"user_name"];
    [params setValue:[appDelegate.facebookData valueForKey:@"first_name"]==nil?@"":[appDelegate.facebookData valueForKey:@"first_name"] forKey:@"first_name"];
    [params setValue:[appDelegate.facebookData valueForKey:@"last_name"]==nil?@"":[appDelegate.facebookData valueForKey:@"last_name"] forKey:@"last_name"];
    [params setValue:[appDelegate.facebookData valueForKey:@"birth_date"] forKey:@"birth_date"];
    [params setValue:encodedString forKey:@"profilePicture"];
    [params setValue:@"facebook" forKey:@"register_type"];
    [params setValue:_btnSelectCity.titleLabel.text forKey:@"baseCity"];
    [params setValue:_referral_field.text forKey:@"referral_id"];
    
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    
    [params setValue:fbAccessToken forKey:@"facebook_token"];
    
    [params setValue:[CommonFunctions getDeviceUUID] forKey:@"deviceID"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,REGISTER_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}


#pragma mark -
#pragma mark Webservice Call back
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@%@",BASE_URL,USERNAME_AVAILABILITY_URL,_txtUsername.text]])
    {
        if ([[responseData objectForKey:@"result"] isEqualToString:@"true"] && self.txtUsername.text.length <= 20)
        {
            isUserNameAvailable = YES;
        }
        else
        {
            isUserNameAvailable = NO;
            [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_USERNAME_EXIST];
        }
    }
    else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400)
    {
        [Utiltiy showAlertWithTitle:@"Registration Error" andMsg:MSG_FAILED];
    }
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,REGISTER_URL]])
    {
        if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 200 && [[responseData valueForKey:@"result"] isEqualToString:@"true"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[responseData objectForKey:@"message"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            
            [self dialogCompleteWithUrl:nil];
        }
    }
    [self updateViewsForFormValidity];
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
}

#pragma mark - FBRequest Invite Friends

- (void)sendRequest
{
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Check out this awesome app. http://wutzwhat.com" title:@"Wutzwhat" parameters:nil handler:nil];
    
    [[ProcessingView instance] hideTintView];
}

// Handle the request call back
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.facebookData=@{
                               @"username": _txtUsername.text,
                               @"city":_btnSelectCity.titleLabel.text,
                               @"profilePicture":encodedString,
                               @"email":[resultDictionary objectForKey:@"email"]
                               };
    [[NSUserDefaults standardUserDefaults] setObject:_btnSelectCity.titleLabel.text forKey:@"cityselected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@YES,@"facebook",[resultDictionary objectForKey:@"email"],@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
    [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
    [[SharedManager sharedManager] saveSessionToDisk];
    
    [self sendRequest];
    
    InitialViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)updateViewsForFormValidity
{
    if ([self isFormValid])
    {
        self.signupFBButton.enabled = YES;
        self.signupFBButton.alpha = 1.0f;
    }
    else
    {
        self.signupFBButton.enabled = NO;
        self.signupFBButton.alpha = 0.4f;
    }
}

-(BOOL)isFormValid
{
    [self applyValidationOnView];
    
    return isUserNameAvailable && self.txtUsername.text.length >= 5;
}

-(void)applyValidationOnView
{
    [self setValidationImage:self.imgUserNameValidator isCorrect:isUserNameAvailable && self.txtUsername.text.length >= 5];
}

-(void)setValidationImage:(UIImageView *)imageView isCorrect:(BOOL)isCorrect
{
    [imageView setImage:[UIImage imageNamed: isCorrect ? @"login_correct.png" : @"login_wrong.png"]];
}

#pragma mark -
#pragma mark TextField Delegate
#pragma mark -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtUsername && textField.text.length >= 5)
    {
        [self checkUserAvailablity];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark Picker Controller
#pragma mark -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.btnImgSelect setImage:selectedImage forState:UIControlStateNormal];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(){}];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
	
    switch (buttonIndex)
    {
		case 0:
		{
            UIImagePickerController *navigator = [[UIImagePickerController alloc] init];
            navigator.allowsEditing = YES;
            navigator.delegate = self;
            [self.navigationController presentViewController:navigator animated:YES completion:^(){}];
			break;
		}
		case 1:
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^(){}];
			break;
		}
            
	}
}


- (void) backBtnTapped:(id)sender
{
    NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[@NO,@"",@"",@""] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
    [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
    [[SharedManager sharedManager] saveSessionToDisk];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [self setBtnSelectCity:nil];
    [self setImgUserNameValidator:nil];
    [super viewDidUnload];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
