//
//  ChangePasswordViewController.m
//  WutzWhat
//
//  Created by Rafay on 1/2/13.
//
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    }
- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setAlpha:1.0f];
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_profile.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    if(OS_VERSION>=7)
    {
        self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x,64,self.titleLabel.frame.size.width,self.titleLabel.frame.size.height);
        self.txtNewPassword.frame=CGRectMake(self.txtNewPassword.frame.origin.x,self.txtNewPassword.frame.origin.y+64,self.txtNewPassword.frame.size.width,self.txtNewPassword.frame.size.height);
        
        self.txtOldPassword.frame=CGRectMake(self.txtOldPassword.frame.origin.x,self.txtOldPassword.frame.origin.y+64,self.txtOldPassword.frame.size.width,self.txtOldPassword.frame.size.height);
        
        self.sbtBtn.frame=CGRectMake(self.sbtBtn.frame.origin.x,self.sbtBtn.frame.origin.y+64,self.sbtBtn.frame.size.width,self.sbtBtn.frame.size.height);
        
        self.oldPass.frame=CGRectMake(self.oldPass.frame.origin.x,self.oldPass.frame.origin.y+64,self.oldPass.frame.size.width,self.oldPass.frame.size.height);
        
        self.thenewPass.frame=CGRectMake(self.thenewPass.frame.origin.x,self.thenewPass.frame.origin.y+64,self.thenewPass.frame.size.width,self.thenewPass.frame.size.height);
        
        
        
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSubmit_click:(id)sender {
    
    if (self.txtNewPassword.text.length == 0 || self.txtOldPassword.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"Error!" andMsg:MSG_FILL_FIELDS];
        return;
    }
    if([self.txtOldPassword.text isEqualToString:self.txtNewPassword.text])
    
    {
        [Utiltiy showAlertWithTitle:@"Error!" andMsg:MSG_SAME_PASSWORD];
        return;
    }
    
    else if (self.txtNewPassword.text.length ==0 || self.txtOldPassword.text.length ==0 )
    {
        [Utiltiy showAlertWithTitle:@"Error!" andMsg:MSG_ENTER_PASSWORD];
    }
    else if (self.txtNewPassword.text.length <6 || self.txtOldPassword.text.length <6 ){
        
        [Utiltiy showAlertWithTitle:@"Error!" andMsg:MSG_PASSWORD_SHORT];
    }
    else{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        [params setValue: [CommonFunctions encryptPassword:_txtOldPassword.text] forKey:@"old_password"];
        [params setValue:[CommonFunctions encryptPassword:_txtNewPassword.text] forKey:@"new_password"];
        
        DataFetcher *fetcher  = [[DataFetcher alloc] init];
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,EDIT_PROFILE_URL] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}		

#pragma mark -
#pragma mark Data Fetcher Delegates
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    ////NSLog(@"response=%@",responseData);
    if ([[responseData valueForKey:@"result"] isEqualToString:@"true"])
    {
        [Utiltiy showAlertWithTitle:@"Done" andMsg:MSG_SUCCESS];
//        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES];

        [self.navigationController popViewControllerAnimated:YES];
        NSMutableDictionary *sessionDictionary= [NSMutableDictionary dictionaryWithObjects:@[[[[SharedManager sharedManager] sessionDictionay]  valueForKey:@"IsLoggedInAlready"],[[[SharedManager sharedManager] sessionDictionay]  objectForKey:@"RegisterType"],[[[SharedManager sharedManager] sessionDictionay]  objectForKey:@"Email"],self.txtNewPassword.text] forKeys:@[@"IsLoggedInAlready",@"RegisterType",@"Email",@"Password"]];
        [[SharedManager sharedManager] setSessionDictionay:sessionDictionary];
        [[SharedManager sharedManager] saveSessionToDisk];
        //WutzWhatListViewController
    }
    else if ([[responseData valueForKey:@"result"] isEqualToString:@"false"]){
        [self.navigationController popViewControllerAnimated:YES];
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        //WutzWhatListViewController
    }
    else if ([[responseData valueForKey:@"HTTP_CODE"] integerValue] == 500 || [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 400|| [[responseData valueForKey:@"HTTP_CODE"] integerValue] == 401) {
        [Utiltiy showAlertWithTitle:@"Editing Error" andMsg:MSG_FAILED];
    }
    
}
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
   // //NSLog(@"response=%@",responseData);
}



- (void)viewDidUnload {
    [self setTxtOldPassword:nil];
    [self setTxtNewPassword:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Textfield
#pragma mark -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [ textField resignFirstResponder]; return YES;
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
