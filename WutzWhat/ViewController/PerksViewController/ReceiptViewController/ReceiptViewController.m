//
//  ReceiptViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 4/15/13.
//
//

#import "ReceiptViewController.h"
#import "AFFPDFUtil.h"
@interface ReceiptViewController ()

@end

@implementation ReceiptViewController

@synthesize perkID = _perkID;
@synthesize pdfID = _pdfID;
@synthesize activityIndicator = _activityIndicator;
@synthesize activityIndicatorView = _activityIndicatorView;

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

    UIImage *backButton = [UIImage imageNamed:@"top_back.png"];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"];    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    
    UIImage *optionButtonImage = [UIImage imageNamed:@"top_more.png"] ;
    UIImage *optionButtonImagePressed = [UIImage imageNamed:@"top_more_c.png"];
    
    UIButton *optionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, optionButtonImage.size.width, optionButtonImage.size.height)];
    [optionBtn addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [optionBtn setImage:optionButtonImage forState:UIControlStateNormal];
    [optionBtn setImage:optionButtonImagePressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *optionBtnItem = [[UIBarButtonItem alloc] initWithCustomView:optionBtn];
    [[self navigationItem]setRightBarButtonItem:optionBtnItem];
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    self.webViewPDFReceiptViewer.delegate = self;
    self.webViewPDFReceiptViewer.scrollView.showsVerticalScrollIndicator = self.webViewPDFReceiptViewer.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.webViewPDFReceiptViewer.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
    
    if(OS_VERSION>=7)
    {
        self.webViewPDFReceiptViewer.frame = CGRectMake(0, 44, self.webViewPDFReceiptViewer.frame.size.width , self.webViewPDFReceiptViewer.frame.size.height);
        
        
    }
    else
    self.webViewPDFReceiptViewer.frame = CGRectMake(0, self.webViewPDFReceiptViewer.frame.size.height, self.webViewPDFReceiptViewer.frame.size.width , self.webViewPDFReceiptViewer.frame.size.height);
    
    
    [self calServiceWithURL:GET_PDF_RECEIPT];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setWebViewPDFReceiptViewer:nil];
    [super viewDidUnload];
}


#pragma mark - Buttons Action

-(void)backBtnTapped:(id)sender
{    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)optionsButtonTapped:(id)sender
{
    if (self.fileURL)
    {        
        if (self.docInteractionController == nil)
        {
            self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:self.fileURL];
            self.docInteractionController.delegate = self;
        }
        else
        {
            self.docInteractionController.URL = self.fileURL;
        }
        
        [self.docInteractionController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
    }
}

#pragma mark - Web API Calling Methods

- (void) calServiceWithURL:(NSString*)serviceUrl
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:self.pdfID forKey:@"pdf_id"];
    [params setValue:self.perkID forKey:@"perk_id"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    NSLog(@"%@%@",BASE_URL,serviceUrl);
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] showTintViewWithUserInteractionEnabled];
}


#pragma mark - Data Fetcher Delegate Methods

-(void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString *)url
{
    [[ProcessingView instance] hideTintView];
    
    [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
//-(void)dataFetchedSuccessfully:(NSDictionary *)responseData
{
    
//    NSString *filePath = [responseData objectForKey:@"link"];
    
    NSURL *fileUrl = [NSURL URLWithString:[responseData objectForKey:@"pdf_link"]];
    NSURL *fileUrl_nonPDF = [NSURL URLWithString:[responseData objectForKey:@"non_pdf_link"]];
    
    self.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/receipt_01.pdf",[FileIOManager getDocumentDirectoryPath]]];
        
    NSURLRequest *resquest = [NSURLRequest requestWithURL:fileUrl];
    non_pdf = [NSURLRequest requestWithURL:fileUrl_nonPDF];
    [self.webViewPDFReceiptViewer loadRequest:resquest];
    self.webViewPDFReceiptViewer.hidden=TRUE;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.webViewPDFReceiptViewer.scalesPageToFit = savedPDF;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!webView.loading && !savedPDF){
        self.webViewPDFReceiptViewer.userInteractionEnabled = false;
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            origViewFrame = self.webViewPDFReceiptViewer.frame;
            
           if(OS_VERSION>=7)
           {
               self.webViewPDFReceiptViewer.frame = CGRectMake(self.webViewPDFReceiptViewer.frame.origin.x, self.webViewPDFReceiptViewer.frame.origin.y+44, self.webViewPDFReceiptViewer.scrollView.contentSize.width*1.5, self.webViewPDFReceiptViewer.scrollView.contentSize.height);
               
           }
            else
            {
            self.webViewPDFReceiptViewer.frame = CGRectMake(self.webViewPDFReceiptViewer.frame.origin.x, self.webViewPDFReceiptViewer.frame.origin.y, self.webViewPDFReceiptViewer.scrollView.contentSize.width*1.5, self.webViewPDFReceiptViewer.scrollView.contentSize.height);
            }
            [AFFPDFUtil createPDFFileFromWebView:self.webViewPDFReceiptViewer andName:@"receipt_01.pdf"];
            self.webViewPDFReceiptViewer.frame = origViewFrame;
            savedPDF = TRUE;
            [self.webViewPDFReceiptViewer loadRequest:non_pdf];
            [[ProcessingView instance] hideTintView];
        });
    } else {
        
        self.webViewPDFReceiptViewer.hidden=FALSE;
        self.webViewPDFReceiptViewer.userInteractionEnabled = true;
        [UIView animateWithDuration:0.4f animations:^(){
            
            if(OS_VERSION>=7)
            {
                self.webViewPDFReceiptViewer.frame = CGRectMake(0,44, self.webViewPDFReceiptViewer.frame.size.width, self.webViewPDFReceiptViewer.frame.size.height);
                
            }
            else
            {
            self.webViewPDFReceiptViewer.frame = CGRectMake(0, 0, self.webViewPDFReceiptViewer.frame.size.width, self.webViewPDFReceiptViewer.frame.size.height);
            }
        }];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([request.URL.scheme isEqualToString:@"tel"])
        [[UIApplication sharedApplication] openURL:request.URL];
    
    return true;
}

#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
