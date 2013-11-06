//
//  TermsofServiceViewController.m
//  WutzWhat
//
//  Created by Rafay on 1/29/13.
//
//

#import "TermsofServiceViewController.h"

@interface TermsofServiceViewController ()

@end

@implementation TermsofServiceViewController

@synthesize scrollview = _scrollview;

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
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    
    if(OS_VERSION>=7)
    {
        self.lblTermsOfServices.frame=CGRectMake(self.lblTermsOfServices.frame.origin.x,self.lblTermsOfServices.frame.origin.y+46,self.lblTermsOfServices.frame.size.width,self.lblTermsOfServices.frame.size.height);
        
        
    }
    
    [self setDynamicLabelHeight:self.lblTermsOfServicesDescription withString:self.termsOfServices];
   
}

- (void) backBtnTapped:(id)sender
{    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setLblTermsOfServices:nil];
    [super viewDidUnload];
}


#pragma mark- Dynamic Height Issue

-(void)setDynamicLabelHeight:(UILabel *)label withString:(NSString *)string
{
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize = [string sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    CGRect newFrame = label.frame;
    
    newFrame.size.height = expectedLabelSize.height;
    
    label.frame = newFrame;
    
   
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    
    label.text = string;
    
    [label sizeToFit];
    
    _scrollview.contentSize = CGSizeMake(newFrame.size.width, newFrame.size.height);
    
   
    if(OS_VERSION>=7)
    {
        
    _scrollview.frame=CGRectMake(_scrollview.frame.origin.x,_scrollview.frame.origin.y+46,_scrollview.frame.size.width,_scrollview.frame.size.height);
    }
    else
     _scrollview.frame = CGRectMake(20, 88, 280, 450);
}

@end
