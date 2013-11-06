//
//  TourSingleViewController.m
//  WutzWhat
//
//  Created by Zeeshan on 4/25/13.
//
//

#import "TourSingleViewController.h"

@interface TourSingleViewController ()

@end

@implementation TourSingleViewController

@synthesize delegate = _delegate;
@synthesize index = _index;

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
    
    [self.imgTour.layer setCornerRadius:5.0f];
    self.imgTour.clipsToBounds = YES;
    
    NSString *imageName = [NSString stringWithFormat:@"tour_iphone_%d", self.index + 1];
    
    self.imgTour.image = [UIImage imageNamed:imageName];
    
    [self setupViewHeight];
    
    if (self.index != 4)
    {
        [self.btnLastButton setHidden:YES];
    }
}

-(void)setupViewHeight
{
    if (IS_IPHONE_5)
    {
        self.btnClose.frame = CGRectMake(268, 47, 40, 40);
        self.btnLastButton.frame = CGRectMake(20, 435, 280, 40);
    }
    else
    {
        self.btnLastButton.frame = CGRectMake(40, 355, 240, 40);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Button Actions
#pragma mark -

- (IBAction)btnClose_Pressed:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(exitTours)])
    {
        [self.delegate exitTours];
    }
}

- (IBAction)btnLastButtonClicked:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(exitTours)])
    {
        [self.delegate exitTours];
    }
}


- (void)viewDidUnload
{
    [self setImgTour:nil];
    [self setBtnClose:nil];
    [self setBtnLastButton:nil];
    [super viewDidUnload];
}


@end
