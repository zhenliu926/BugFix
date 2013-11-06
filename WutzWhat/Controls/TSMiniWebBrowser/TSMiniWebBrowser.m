//
//  TSMiniWebBrowser.m
//  TSMiniWebBrowserDemo
//
//  Created by Toni Sala Echaurren on 18/01/12.
//  Copyright 2012 Toni Sala. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TSMiniWebBrowser.h"
#import "DataFetcher.h"
#import "WutzWhatModel.h"
#import "DataModel.h"
#import "PerksProductDetailViewController.h"



@implementation TSMiniWebBrowser

@synthesize delegate;
@synthesize mode;
@synthesize showURLStringOnActionSheetTitle;
@synthesize showPageTitleOnTitleBar;
@synthesize showReloadButton;
@synthesize showActionButton;
@synthesize barStyle;
@synthesize modalDismissButtonTitle;

#define kToolBarHeight  44
#define kTabBarHeight   49

enum actionSheetButtonIndex {
	kSafariButtonIndex,
	kChromeButtonIndex,
};

#pragma mark - Private Methods

-(void)setTitleBarText:(NSString*)pageTitle {
    if (mode == TSMiniWebBrowserModeModal) {
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:pageTitle];
        [lbl setTextColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:91.0/255.0 alpha:1.0]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
        navigationBarModal.topItem.titleView = lbl;
        
    } else if(mode == TSMiniWebBrowserModeNavigation) {
        if(pageTitle) {
         
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setText:pageTitle];
            [lbl setTextColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:91.0/255.0 alpha:1.0]];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
            [[self navigationItem] setTitleView:lbl];
            
        }
        
        
    
    }
}

-(void) toggleBackForwardButtons {
    buttonGoBack.enabled = webView.canGoBack;
    buttonGoForward.enabled = webView.canGoForward;
}

-(void)showActivityIndicators {
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideActivityIndicators {
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void)popViewController
{
    if ( webView.loading ) {
        [webView stopLoading];
    }
    [self.navigationController popViewControllerAnimated:YES];
    

}
-(void) dismissController {
    if ( webView.loading ) {
        [webView stopLoading];
    }
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
    // Notify the delegate
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(tsMiniWebBrowserDidDismiss)]) {
        [delegate tsMiniWebBrowserDidDismiss];
    }
}

//Added in the dealloc method to remove the webview delegate, because if you use this in a navigation controller
//TSMiniWebBrowser can get deallocated while the page is still loading and the web view will call its delegate-- resulting in a crash
-(void)dealloc
{
    [webView setDelegate:nil];
}

#pragma mark - Init

// This method is only used in modal mode
-(void) initTitleBar {
    
    


    
    
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissController)];
    
    
    
    
    UINavigationItem *titleBar = [[UINavigationItem alloc] initWithTitle:@""];
    titleBar.leftBarButtonItem = buttonDone;
    
    CGFloat width = self.view.frame.size.width;
    navigationBarModal = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    //navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    navigationBarModal.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navigationBarModal.barStyle = barStyle;
    [navigationBarModal pushNavigationItem:titleBar animated:NO];
    
    [self.view addSubview:navigationBarModal];
}

-(void) initToolBar {
    if (mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = barStyle;
    }
    
    CGSize viewSize = self.view.frame.size;
    if (mode == TSMiniWebBrowserModeTabBar) {
        
        if(OS_VERSION>=7)
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height-88, viewSize.width, kToolBarHeight)];
            else
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, viewSize.width, kToolBarHeight)];
    } else {
        
        if(OS_VERSION>=7)
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height-188, viewSize.width, kToolBarHeight)];
            else
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height-kToolBarHeight, viewSize.width, kToolBarHeight)];
    }
    
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [toolBar setBackgroundImage:[UIImage imageNamed:@"bottombar_black"] forToolbarPosition:originalBarStyle barMetrics:normal];
    [self.view addSubview:toolBar];
    
    buttonGoBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 10;
    
    buttonGoForward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonTouchUp:)];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *buttonReload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonTouchUp:)];
    
    UIBarButtonItem *fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace2.width = 5;
    
    UIBarButtonItem *fixedSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace3.width = 2;
    
    UIImage *link = [UIImage imageNamed:@"buttonlink.png"];
    UIButton *linkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, link.size.width-15, link.size.height)];
    [linkButton setImage:link forState:UIControlStateNormal];
    buttonLink = [[UIBarButtonItem alloc] initWithCustomView:linkButton];
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, link.size.width-15-20, link.size.height-10)];
    linkLabel.text = [urlToLoad absoluteString];
    linkLabel.textColor = [UIColor grayColor];
    linkLabel.backgroundColor = [UIColor clearColor];
    linkLabel.font = [UIFont systemFontOfSize:13];
    [linkButton addSubview:linkLabel];
    [buttonLink setEnabled:NO];
    
    
    UIBarButtonItem *buttonAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonActionTouchUp:)];

    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(11, 7, 10, 10);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43, 33)];
    [containerView addSubview:activityIndicator];
    
    // Add butons to an array
    NSMutableArray *toolBarButtons = [[NSMutableArray alloc] init];
    [toolBarButtons addObject:buttonGoBack];
    [toolBarButtons addObject:fixedSpace];
    [toolBarButtons addObject:buttonGoForward];
    

    if (showReloadButton) {
        [toolBarButtons addObject:fixedSpace2];
        [toolBarButtons addObject:buttonReload];
    }
    
    [toolBarButtons addObject:fixedSpace3];
    [toolBarButtons addObject:buttonLink];
    
    if (showActionButton) {
        [toolBarButtons addObject:flexibleSpace];
        [toolBarButtons addObject:buttonAction];
    }
    
    // Set buttons to tool bar
    [toolBar setItems:toolBarButtons animated:YES];
    
}

-(void) initWebView {
    CGSize viewSize = self.view.frame.size;
    if (mode == TSMiniWebBrowserModeModal) {
        
        if(OS_VERSION>=7)
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kToolBarHeight+44, viewSize.width, viewSize.height-kToolBarHeight*2)];
            else
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kToolBarHeight, viewSize.width, viewSize.height-kToolBarHeight*2)];
    } else if(mode == TSMiniWebBrowserModeNavigation) {
        
        if(OS_VERSION>=7)
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, viewSize.width, viewSize.height-kToolBarHeight)];
        else
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-kToolBarHeight)];
        
        
    } else if(mode == TSMiniWebBrowserModeTabBar) {
        
        
        self.view.backgroundColor = [UIColor redColor];
        
        if(OS_VERSION>=7)
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kToolBarHeight-1+44, viewSize.width, viewSize.height-kToolBarHeight+1)];
        
        else
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kToolBarHeight-1, viewSize.width, viewSize.height-kToolBarHeight+1)];
        
    }
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
    
    webView.scalesPageToFit = YES;
    
    webView.delegate = self;
    
    // Load the URL in the webView
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlToLoad];
    [webView loadRequest:requestObj];
}

#pragma mark -

- (id)initWithUrl:(NSURL*)url {
    self = [self init];
    if(self)
    {
        urlToLoad = url;
       
        // Defaults
        mode = TSMiniWebBrowserModeNavigation;
        showURLStringOnActionSheetTitle = YES;
        showPageTitleOnTitleBar = YES;
        showReloadButton = YES;
        showActionButton = YES;
        modalDismissButtonTitle = NSLocalizedString(@"Done", nil);
        forcedTitleBarText = nil;
        barStyle = UIBarStyleDefault;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    // Main view frame.
    if (mode == TSMiniWebBrowserModeTabBar) {
        CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - kTabBarHeight;
        if (![UIApplication sharedApplication].statusBarHidden) {
            viewHeight -= [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        
    }
    
    // Store the current navigationBar bar style to be able to restore it later.
    if (mode == TSMiniWebBrowserModeNavigation) {
        originalBarStyle = self.navigationController.navigationBar.barStyle;
    }
    
    // Init tool bar
    [self initToolBar];
    
    // Init web view
    [self initWebView];
    
    // Init title bar if presented modally
    if (mode == TSMiniWebBrowserModeModal) {
        [self initTitleBar];
    }
    if(mode == TSMiniWebBrowserModeNavigation)
    {
        
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
        else if(self.postTypeID == MYFINDS_ID_FOR_REVIEW)
        {
            
            UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_myfinds.png"]];
            [[self navigationItem]setTitleView:titleIV];
        }

        UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
        UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
        [backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:backButton forState:UIControlStateNormal];
        [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
        [v addSubview:backBtn];
        UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
        [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
        
        
        
        // Status bar style
        [[UIApplication sharedApplication] setStatusBarStyle:UIBarStyleBlack animated:YES];
    }
    
    
    // UI state
    buttonGoBack.enabled = NO;
    buttonGoForward.enabled = NO;
    if (forcedTitleBarText != nil) {
        [self setTitleBarText:forcedTitleBarText];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Restore navigationBar bar style.
    if (mode == TSMiniWebBrowserModeNavigation) {
        self.navigationController.navigationBar.barStyle = originalBarStyle;
    }
    
    // Restore Status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIBarStyleBlack animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/* Fix for landscape + zooming webview bug.
 * If you experience perfomance problems on old devices ratation, comment out this method.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat ratioAspect = webView.bounds.size.width/webView.bounds.size.height;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            // Going to Portrait mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview 
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale/ratioAspect) animated:YES];
                }
            }
            break;
        default:
            // Going to Landscape mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview 
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale *ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale *ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale*ratioAspect) animated:YES];
                }
            }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Sheet

- (void)showActionSheet {
    NSString *urlString = @"";
    if (showURLStringOnActionSheetTitle)
    {
        NSURL* url = [webView.request URL];
        urlString = [url absoluteString];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = urlString;
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", nil)];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]])
    {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Chrome", nil)];
    }
    
    [actionSheet addButtonWithTitle:@"Copy Website Link"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    if (mode == TSMiniWebBrowserModeTabBar)
    {
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else if (mode == TSMiniWebBrowserModeNavigation && self.navigationController.tabBarController != nil) {
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
    else {
        [actionSheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) return;
    
    NSURL *theURL = [webView.request URL];
    
    if (theURL == nil || [theURL isEqual:[NSURL URLWithString:@""]])
    {
        theURL = urlToLoad;
    }
    
    if (buttonIndex == kSafariButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:theURL];
    }
    else if (buttonIndex == kChromeButtonIndex && [[actionSheet buttonTitleAtIndex:kChromeButtonIndex] isEqualToString:@"Open in Chrome"])
    {
        NSString *scheme = theURL.scheme;
        NSString *chromeScheme = nil;
        if ([scheme isEqualToString:@"http"])
        {
            chromeScheme = @"googlechrome";
        }
        else if ([scheme isEqualToString:@"https"])
        {
            chromeScheme = @"googlechromes";
        }
        if (chromeScheme)
        {
            NSString *absoluteString = [theURL absoluteString];
            NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
            NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
            NSString *chromeURLString = [chromeScheme stringByAppendingString:urlNoScheme];
            NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
            
            [[UIApplication sharedApplication] openURL:chromeURL];
        }
    }
    else if (buttonIndex==1)
    {
        [CommonFunctions copyTextToClipboard:[urlToLoad URLStringWithoutQuery]];
    }
}

#pragma mark - Actions

- (void)backButtonTouchUp:(id)sender {
    [webView goBack];
    
    [self toggleBackForwardButtons];
}

- (void)forwardButtonTouchUp:(id)sender {
    [webView goForward];
    
    [self toggleBackForwardButtons];
}

- (void)reloadButtonTouchUp:(id)sender {
    [webView reload];
    
    [self toggleBackForwardButtons];
}

- (void)buttonActionTouchUp:(id)sender {
    [self showActionSheet];
}

#pragma mark - Public Methods

- (void)setFixedTitleBarText:(NSString*)newTitleBarText {
    forcedTitleBarText = newTitleBarText;
    showPageTitleOnTitleBar = NO;
}

- (void)loadURL:(NSURL*)url {
    [webView loadRequest: [NSURLRequest requestWithURL: url]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] hasPrefix:@"sms:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    if ([[request.URL absoluteString] hasPrefix:@"http://www.youtube.com/v/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://itunes.apple.com/"] ||
        [[request.URL absoluteString] hasPrefix:@"http://phobos.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self toggleBackForwardButtons];
    
    [self showActivityIndicators];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    // Show page title on title bar?
    if (showPageTitleOnTitleBar) {
        NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self setTitleBarText:pageTitle];
    }
    
    [self hideActivityIndicators];
    
    [self toggleBackForwardButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivityIndicators];
    
    // To avoid getting an error alert when you click on a link
    // before a request has finished loading.
    if ([error code] == NSURLErrorCancelled) {
        return;
    }

    // Show error alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not load page", nil)
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];
}

@end
