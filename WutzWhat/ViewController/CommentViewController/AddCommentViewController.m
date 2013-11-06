//
//  AddCommentViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import "AddCommentViewController.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

@synthesize postid;
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    if(OS_VERSION>=7)
    {
        self.scrollView.frame=CGRectMake(self.scrollView.frame.origin.x,self.scrollView.frame.origin.y+46,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        
    }
    self.scrollView.contentSize = CGSizeMake(320.0f, 490.0f);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"] ;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    if(self.postTypeID == WUTZWHAT_ID_FOR_REVIEW)
    {
        
        UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_wutzwhat.png"]];
        [[self navigationItem]setTitleView:titleIV];
        
    }
    else if(self.postTypeID == PERK_ID_FOR_REVIEW)
    {
        
        UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks_2.png"]];
        [[self navigationItem]setTitleView:titleIV];
    }
    else if(self.postTypeID == HOTPICKS_ID_FOR_REVIEW)
    {
        
        UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_hotpicks.png"]];
        [[self navigationItem]setTitleView:titleIV];
    }
    
    
    [[self.txtComment layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.txtComment layer] setBorderWidth:0.5];
    [[self.txtComment layer] setCornerRadius:10];
    self.txtComment.ClipsToBounds= YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
    [self.view sendSubviewToBack:_scrollView];

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    
//    return YES;
//}
#pragma mark- Buttons Method

- (IBAction)btnSubmit_Pressed:(id)sender {
    if (self.txtComment.text.length ==0) {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_FEEDBACK];
        
        //[message show];

    }else
    {
        if (![[SharedManager sharedManager] isNetworkAvailable])
        {
            //        UIAlertView *av =  [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Network not available at the moment. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //        [av show];
            
        }
        else
        {
            [[ProcessingView instance] showTintView];
            [self calServiceWithURL:WUTZWHAT_FEEDBACK];
            
        }
    }
}

- (void) backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Webservice
#pragma mark -
- (void) calServiceWithURL:(NSString*)serviceUrl {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setValue:self.txtComment.text forKey:@"feedback_text"];
    [params setValue:postid forKey:@"post_id"];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}
#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_FEEDBACK]])
    {
       // NSDictionary *dict = [responseData objectForKey:@"addFeedBackResult"];
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess) {
            [Utiltiy showAlertWithTitle:@"Done" andMsg:MSG_SUCCESS];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        }
    }
}
- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,WUTZWHAT_FEEDBACK]]) {
        
    }
}
- (void)viewDidUnload {
    [self setTxtComment:nil];
    [self setBtnDone:nil];
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.scrollView endEditing:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.scrollView.contentSize = CGSizeMake(320.0f, 650.0f);
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.scrollView.contentSize = CGSizeMake(320.0f, 490.0f);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [textView setInputAccessoryView:toolbar];
    return YES;
}

-(void)dismissKeyboard
{    
    if([self.txtComment isFirstResponder])
    {
        [self.txtComment resignFirstResponder];
    }
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


