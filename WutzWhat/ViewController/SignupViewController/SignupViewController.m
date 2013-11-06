//
//  SignupViewController.m
//  WutzWhat
//
//  Created by My Mac on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "SignupViewController.h"
#import "Utiltiy.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize notifyFail=_notifyFail;
@synthesize resultDictionary;

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
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    isEmailAvailable = NO;
    isUserNameAvailable = NO;
    
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
    
    _btnImgSelect.clipsToBounds=YES;
    _btnImgSelect.layer.cornerRadius = 5;
    
    
    [_btnCityName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_btnCityName setTitle:@"Toronto" forState:UIControlStateNormal];
    [_btnCityName setTitle:@"Toronto" forState:UIControlStateHighlighted];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Toronto" forKey:@"cityselected"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [_btnImgSelect setImage:[UIImage imageNamed:@"signup_pic.png"] forState:UIControlStateNormal];
    
    if(OS_VERSION>=7)
    {
        self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x,self.scrollView.frame.origin.y+46,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        
    
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"]);
    
    [_btnCityName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCityName setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"] forState:UIControlStateNormal];
    [_btnCityName setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"] forState:UIControlEventTouchUpInside];
    
    imageofButton=_btnImgSelect.currentImage;
    
//    timer= [NSTimer scheduledTimerWithTimeInterval:0.1
//                                            target:self
//                                          selector:@selector(updateViewsForFormValidity)
//                                          userInfo:nil
//                                           repeats:YES];
}
#pragma mark -
#pragma mark Button Action
#pragma mark -
- (IBAction)btnImageSelect_Pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnImgSelect_click:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnSignup_click:(id)sender
{    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:_txtEmail.text forKey:@"user_email"];
    [params setValue:[CommonFunctions encryptPassword:_txtPassword.text] forKey:@"user_password"];
    [params setValue:_txtUsername.text forKey:@"user_name"];
    [params setValue:_txtReferralCode.text forKey:@"referral_id"];
    
     if(![imageofButton isEqual:[UIImage imageNamed:@"signup_pic.png"]])
     {
         UIImage *img = [_btnImgSelect imageForState:UIControlStateNormal];
         NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
         NSString *encodedString = [Base64 encode:imageData];
         [params setValue:encodedString forKey:@"profilePicture"];
     }

    [params setValue:@"email" forKey:@"register_type"];
    [params setValue:self.btnCityName.titleLabel.text forKey:@"baseCity"];
    [params setValue:@"00-26-08-C8-F7-D9" forKey:@"deviceID"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,REGISTER_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] showTintView];
}

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSelectCity_click:(id)sender
{
    CityViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    cvc.isFromMainMenu = NO;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)btnEditProfilePicture_clicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}


#pragma mark -
#pragma mark Image Picker Delegates
#pragma mark -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (selectedImage.imageOrientation != UIImageOrientationUp)
    {
        UIGraphicsBeginImageContextWithOptions(selectedImage.size, NO, selectedImage.scale);
        [selectedImage drawInRect:(CGRect){0, 0, selectedImage.size}];
        selectedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    }
    [self.btnImgSelect setImage:selectedImage forState:UIControlStateNormal];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark -
#pragma mark Actionsheet Delegates
#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
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
            [self.navigationController presentViewController:picker animated:YES completion:^(){}];
			break;
		}
	}
}

- (void)viewDidUnload
{
    [timer invalidate];
    timer = nil;
    [self setBtnImgSelect:nil];
    [self setBtnCityName:nil];
    [self setTxtPassword:nil];
    [self setTxtUsername:nil];
    [self setTxtEmail:nil];
    [self setBtnSignUp:nil];
    [self setImgUserEmailValidator:nil];
    [self setImgUserNameValidator:nil];
    [self setImgUserPasswordValidator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Data Fetcher Delegates
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{    
    [[ProcessingView instance] hideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,REGISTER_URL]])
    {
        if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
        {
             [Utiltiy showAlertWithTitle:@"" andMsg:MSG_SIGNUP_SUCCESS];
             [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if ([[responseData objectForKey:@"error"] isEqualToString:@"username taken"])
        {
            [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_USERNAME_EXIST];
        }
        else if ([[responseData objectForKey:@"error"] isEqualToString:@"email taken"])
        {
            [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_EMAIL_ALREADY_EXIST];
        }
        else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400 || [[responseData valueForKey:@"result"] isEqualToString:@"false"])
        {
            [Utiltiy showAlertWithTitle:@"Registration Error" andMsg:MSG_FAILED];
        } else {
            [Utiltiy showAlertWithTitle:@"Registration Error" andMsg:MSG_FAILED_SERVER];
        }
    }
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
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@%@",BASE_URL,EMAIL_AVAILABILITY_URL,self.txtEmail.text]])
    {
        if ([[responseData objectForKey:@"result"] isEqualToString:@"true"])
        {
            isEmailAvailable = YES;
        }
        else
        {
            isEmailAvailable = NO;
            [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_EMAIL_ALREADY_EXIST];
        }
    }
    [self updateViewsForFormValidity];
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] hideTintView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)updateViewsForFormValidity
{
    if ([self isFormValid])
    {
        self.btnSignUp.enabled = YES;
        self.btnSignUp.alpha = 1.0f;
    }
    else
    {
        self.btnSignUp.enabled = NO;
        self.btnSignUp.alpha = 0.4f;
    }
}

-(BOOL)isFormValid
{
    [self applyValidationOnView];
    
    return isUserNameAvailable && isEmailAvailable && [CommonFunctions isEmailValid:self.txtEmail.text] && [self spacesValidatorForType:0] && [self spacesValidatorForType:1];
}

-(void)applyValidationOnView
{
    [self setValidationImage:self.imgUserNameValidator isCorrect:[self spacesValidatorForType:0] && isUserNameAvailable];
    
    [self setValidationImage:self.imgUserEmailValidator isCorrect:isEmailAvailable && [CommonFunctions isEmailValid:self.txtEmail.text]];
    
    [self setValidationImage:self.imgUserPasswordValidator isCorrect:[self spacesValidatorForType:1]];
}

- (BOOL)spacesValidatorForType:(int)ltype
{
    BOOL valid = FALSE;
    
    if(ltype == 0){
        self.txtUsername.text = [self.txtUsername.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        valid = self.txtUsername.text.length >= 3 ? TRUE : FALSE;
    } else {
        self.txtPassword.text = [self.txtPassword.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        valid = self.txtPassword.text.length >= 6 ? TRUE : FALSE;
    }
    
    return valid;
}

-(void)setValidationImage:(UIImageView *)imageView isCorrect:(BOOL)isCorrect
{
    [imageView setImage:[UIImage imageNamed: isCorrect ? @"login_correct.png" : @"login_wrong.png"]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CityViaModal"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"CityViaModal" forKey:@"CityViaModal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark TextField Delegate
#pragma mark -

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _txtUsername && textField.text.length >= 5)
    {
        [self checkUserNameAvailability];
    }
    else if (textField == self.txtEmail && [CommonFunctions isEmailValid:textField.text])
    {
        [self checkEmailAddressAvailability];
    }
    [self updateViewsForFormValidity];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtEmail)
    {
        if ([CommonFunctions isEmailValid:textField.text])
            [self checkEmailAddressAvailability];

        [self.txtUsername becomeFirstResponder];
    }
    else if (textField == self.txtUsername)
    {
        if (textField.text.length >= 5)
            [self checkUserNameAvailability];
        
        [self.txtPassword becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    [self updateViewsForFormValidity];
    
    return YES;
}

-(void)checkUserNameAvailability
{
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    fetcher.delegate=self;
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@",BASE_URL,USERNAME_AVAILABILITY_URL,_txtUsername.text] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
}

-(void)checkEmailAddressAvailability
{
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    fetcher.delegate=self;
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@%@",BASE_URL,EMAIL_AVAILABILITY_URL,self.txtEmail.text] andDelegate:self andRequestType:@"GET" andPostDataDict:nil];
}

#pragma mark -
#pragma mark Alert View Delegate
#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==500)
    {
        _txtUsername.text=@"";
        [_txtUsername becomeFirstResponder];
    }
}

- (IBAction)btnSelectCityClicked:(id)sender
{
    CityViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CityViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
