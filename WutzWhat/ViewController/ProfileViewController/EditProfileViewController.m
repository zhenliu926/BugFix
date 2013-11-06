//
//  EditProfileViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/16/12.
//
//

#import "EditProfileViewController.h"
#import "Utiltiy.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize resultDictionary;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CityViaModal"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"CityViaModal" forKey:@"CityViaModal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)showPasswordScreen:(id)sender
{
    ChangePasswordViewController *evc=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    
        
    [self.navigationController pushViewController:evc animated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cityselected"]);
    [_btnSelectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    resultDictionary = appDelegate.facebookData;
    _lblUsername.text =  [appDelegate.facebookData objectForKey:@"username"];
    [_btnSelectCity setTitle:[resultDictionary objectForKey:@"city"] forState:UIControlStateNormal];
    [_btnSelectCity setTitle:[resultDictionary objectForKey:@"city"] forState:UIControlEventTouchUpInside];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    if(OS_VERSION>=7)
    {
        self.lblEditTitle.frame=CGRectMake(self.lblEditTitle.frame.origin.x,64,self.lblEditTitle.frame.size.width,self.lblEditTitle.frame.size.height);
        self.line1.frame=CGRectMake(self.line1.frame.origin.x,self.line1.frame.origin.y+64,self.line1.frame.size.width,self.line1.frame.size.height);
        
        self.line2.frame=CGRectMake(self.line2.frame.origin.x,self.line2.frame.origin.y+64,self.line2.frame.size.width,self.line2.frame.size.height);
        
        self.lblTextInfo.frame=CGRectMake(self.lblTextInfo.frame.origin.x,self.lblTextInfo.frame.origin.y+64,self.lblTextInfo.frame.size.width,self.lblTextInfo.frame.size.height);
        
        self.lblUsername.frame=CGRectMake(self.lblUsername.frame.origin.x,self.lblUsername.frame.origin.y+64,self.lblUsername.frame.size.width,self.lblUsername.frame.size.height);
        
        self.btnSave.frame=CGRectMake(self.btnSave.frame.origin.x,self.btnSave.frame.origin.y+64,self.btnSave.frame.size.width,self.btnSave.frame.size.height);
        
        self.btnChangePass.frame=CGRectMake(self.btnChangePass.frame.origin.x,self.btnChangePass.frame.origin.y+64,self.btnChangePass.frame.size.width,self.btnChangePass.frame.size.height);
        
        self.btnImgSelect.frame=CGRectMake(self.btnImgSelect.frame.origin.x,self.btnImgSelect.frame.origin.y+64,self.btnImgSelect.frame.size.width,self.btnImgSelect.frame.size.height);
        
        
        
        
    }

    
    
        
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
   
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_profile.png"]];
    [[self navigationItem]setTitleView:titleIV];

    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    resultDictionary = appDelegate.facebookData;
    
	[_btnSelectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:@"Select City" forKey:@"cityselected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    resultDictionary = appDelegate.facebookData;
    
    if ( [resultDictionary objectForKey:@"profilePicture"] != nil)
    {
        [self getProfileImage];
        
    }
    else
    {
        [self getFBImage];
    }
    
    UITapGestureRecognizer *oneFingerTwoTaps =[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector (btnImgSelect_click:)];
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    [self.btnImgSelect addGestureRecognizer:oneFingerTwoTaps];

    _btnImgSelect.layer.cornerRadius = 6.0f;
    _btnImgSelect.clipsToBounds=YES;
    
    self.btnSave.enabled = false;
}

- (IBAction)btnImageSelect_Pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnImgSelect_click:(UIGestureRecognizer *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnEditProfilePicture_clicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    
    [actionSheet showInView:self.view];
}

- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) doneBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCancel_Clicked:(id)sender {
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(!selectedImage)
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.btnSave.enabled = (selectedImage != self.btnImgSelect.imageView.image);
    
    [self.btnImgSelect setImage:selectedImage forState:UIControlStateNormal];
    [self.btnImgSelect setImage:selectedImage forState:UIControlStateSelected];
    [self.btnImgSelect setImage:selectedImage forState:UIControlStateHighlighted];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(){}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	switch (buttonIndex) {
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(AppDelegate*)getAppDelegateInstance
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

-(IBAction)btnSave_click:(id)sender
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];

    [params setValue:_btnSelectCity.titleLabel.text forKey:@"baseCity"];
    
    UIImage *img = [_btnImgSelect imageForState:UIControlStateNormal];
    NSLog(@"w: %f, h: %f",img.size.width, img.size.height);
    
    CGSize newSize = CGSizeZero;
    float scaleWidth = (img.size.width - 300) / img.size.width;
    float scaleHeight = (img.size.height - 300) / img.size.height;
    
    if(scaleWidth > scaleHeight)
        newSize = CGSizeMake(img.size.width*scaleHeight,img.size.height*scaleHeight);
    else
        newSize = CGSizeMake(img.size.width*scaleWidth,img.size.height*scaleWidth);
    
    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
     NSLog(@"w: %f, h: %f",img.size.width, img.size.height);
    NSData *imageData = UIImageJPEGRepresentation(img, 0.4f);
    NSString *encodedString = [Base64 encode:imageData];
   
    [params setValue:encodedString forKey:@"profilePicture"];
    
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_PROFILE_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] showTintView];
}

#pragma mark -
#pragma mark Data Fetcher Delegates
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] hideTintView];
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_PROFILE_URL]])
    {
        
        if ([[responseData valueForKey:@"result"] isEqualToString:@"true"]){
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            resultDictionary = appDelegate.facebookData;
             NSString *Email=[appDelegate.facebookData  objectForKey:@"email"];
            if (Email==nil)
                {
                Email=@"";
                }
            resultDictionary = @{
                                 @"username": [resultDictionary objectForKey:@"username"],
                                 @"city":[resultDictionary objectForKey:@"city"],
                                 @"profilePicture":[[responseData objectForKey:@"params"] objectForKey:@"profilePicture"],
                                 @"id":@"",@"email":Email
                                 };
            
            appDelegate.facebookData = resultDictionary;
            
            [self getProfileImage];
            [self.navigationController popViewControllerAnimated:YES];
            [Utiltiy showAlertWithTitle:@"Done" andMsg:MSG_SUCCESS];
        }
        else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400|| [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 401)
        {
            [Utiltiy showAlertWithTitle:@"Editing Error" andMsg:MSG_FAILED];
        }
    }
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] hideTintView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnImgSelect:nil];
   
    [self setBtnSelectCity:nil];
    [self setBtnSave:nil];
    [self setBtnCancel:nil];
    [self setLblUsername:nil];
    [super viewDidUnload];
}

-(void) getProfileImage
{
    if (resultDictionary!=nil && ![resultDictionary isKindOfClass:[NSNull class]] && resultDictionary.count>0 && [resultDictionary objectForKey:@"profilePicture"]!=nil && ![[resultDictionary objectForKey:@"profilePicture" ] isKindOfClass:[NSNull class]]&&
        ![[resultDictionary objectForKey:@"profilePicture"] isEqualToString:@""])
    {
        int length = [[resultDictionary objectForKey:@"profilePicture"] length];
        
        if (length > 1000)
        {
            NSData *imgData = [Base64 decode:[resultDictionary objectForKey:@"profilePicture"]];
           
            [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
            [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateHighlighted];
            [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateSelected];
        }
        else if (length > 0)
        {
            dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
            
            dispatch_async(downloadQueue, ^{
                
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[resultDictionary objectForKey:@"profilePicture"]]];
                if(!imgData){
                    [_btnImgSelect setImage:[UIImage imageNamed:@"profile_c.png"] forState:UIControlStateNormal];
                    [_btnImgSelect setImage:[UIImage imageNamed:@"profile_c.png"] forState:UIControlStateHighlighted];
                    [_btnImgSelect setImage:[UIImage imageNamed:@"profile_c.png"] forState:UIControlStateSelected];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                        [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateHighlighted];
                        [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateSelected];
                    });
                }
            });
        }
    }
}

- (void) getFBImage
{
    NSString *facebookID = @"";
    
    if (![resultDictionary objectForKey:@"username"] && ![[resultDictionary objectForKey:@"username"] isEqualToString:@""])
    {
        facebookID = [resultDictionary objectForKey:@"username"];
    }
    else if ([resultDictionary objectForKey:@"id"] && ![[resultDictionary objectForKey:@"id"] isEqualToString:@""])
    {
        facebookID = [resultDictionary objectForKey:@"id"];
    }
    
    if ([facebookID isEqualToString:@""])
    {
        return;
    }
    else
    {
        NSString *string=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=105&height=109",facebookID];

        NSURL *url = [NSURL URLWithString:string];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        
        dispatch_async(downloadQueue, ^{
            
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateHighlighted];
                [_btnImgSelect setImage:[UIImage imageWithData:imgData] forState:UIControlStateSelected];
            });
        });
    }
}

- (IBAction)btnSelectCityClicked:(id)sender
{
}

- (void) dealloc
{
    [self setBtnImgSelect:nil];
    [self setLblUsername:nil];
    [self setBtnSelectCity:nil];
    [self setBtnSave:nil];
    [self setBtnCancel:nil];
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}

@end
