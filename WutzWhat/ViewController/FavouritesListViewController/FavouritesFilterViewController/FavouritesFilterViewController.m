//
//  FavouritesFilterViewController.m
//  WutzWhat
//
//  Created by Rafay on 12/10/12.
//
//

#import "FavouritesFilterViewController.h"
#import "RangeSlider.h"

@interface FavouritesFilterViewController ()
@end

@implementation FavouritesFilterViewController
@synthesize FilterBy=_FilterBy;
@synthesize Price=_Price;
@synthesize Open=_Open;
//@synthesize slidePrice=_slidePrice;
@synthesize txtEndDate=_txtEndDate;
@synthesize txtStartDate=_txtStartDate;
@synthesize StartDate=_StartDate,EndDate=_EndDate;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
    }
    return self;
}
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
    [super viewDidLoad];
	self.scroll.contentSize=CGSizeMake(320, 900);
    [self.txtEndDate apply];
    [self.txtStartDate apply];
    
    
    BOOL OPEN= [[NSUserDefaults standardUserDefaults] boolForKey:@"Open"];
    _openState.selected=OPEN;
    _StartDate=[[NSUserDefaults standardUserDefaults] stringForKey:@"StartDate"];
    self.txtStartDate.text=_StartDate;
    _EndDate=[[NSUserDefaults standardUserDefaults] stringForKey:@"EndDate"];
    self.txtEndDate.text=_EndDate;
    
    
    //UISegmented Control
    
    _switchView=[[UISegmentedControl alloc] initWithItems:@[@"Latest",@"Distance",@"Event Date"]];
    [_switchView setFrame:CGRectMake(40,43,78*3,35)];
    _switchView.selectedSegmentIndex=1;
    _switchView.segmentedControlStyle=UISegmentedControlStyleBar;
    [_switchView setImage:[UIImage imageNamed:@"filter_sort_1.png"] forSegmentAtIndex:0];   // set icon for when selected
    [_switchView setImage:[UIImage imageNamed:@"filter_sort_2_c.png"] forSegmentAtIndex:1];  // set icon for when selected
    [_switchView setImage:[UIImage imageNamed:@"filter_sort_3.png"] forSegmentAtIndex:2];
    [_switchView addTarget:self action:@selector(checkOnOffState:) forControlEvents:UIControlEventValueChanged];
    NSInteger FilterBY = [[NSUserDefaults standardUserDefaults] integerForKey:@"FilterBy"];
    _switchView.selectedSegmentIndex=FilterBY;
    [self.scroll addSubview:_switchView];
    
    
    //Slider Control
    _slider=  [[RangeSlider alloc] initWithFrame:_sliderView.bounds];
    _slider.minimumValue = 1;
    _slider.selectedMinimumValue = 2;
    _slider.maximumValue = 10;
    _slider.selectedMaximumValue = 8;
    _slider.minimumRange = 2;
    float PRICE_MAX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PriceMax"] floatValue];
    float PRICE_MIN = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PriceMin"] floatValue];
    _slider.selectedMinimumValue=PRICE_MIN;
    _slider.selectedMinimumValue=PRICE_MAX;
    [_slider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    [_sliderView addSubview:_slider];
    
    
    
    
    
    
}
- (IBAction)btnSwitch_click:(id)sender {
    
    if (_openState.selected==YES)
    {
        _openState.selected=NO;
    }
    else if(_openState.selected==NO)
    {
        _openState.selected=YES;
        
    }
}

-(void)updateRangeLabel:(RangeSlider *)slider{
    NSLog(@"Slider Range: %f - %f", slider.selectedMinimumValue, slider.selectedMaximumValue);
    
}




-(IBAction)checkOnOffState:(id)sender
{
    UISegmentedControl* tempSeg=(UISegmentedControl *)sender;
    [tempSeg setFrame:CGRectMake(40,43,78*3,35)];
    if(_switchView.selectedSegmentIndex==0)
    {
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_1_c.png"] forSegmentAtIndex:0];   // set icon for when selected
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_2.png"] forSegmentAtIndex:1];  // set icon for when selected
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_3.png"] forSegmentAtIndex:2];
    }
    else if (_switchView.selectedSegmentIndex==1)
        
    {
        //your codes
        
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_1.png"] forSegmentAtIndex:0];   // set icon for when selected
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_2_c.png"] forSegmentAtIndex:1];  // set icon for when selected
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_3.png"] forSegmentAtIndex:2];    }
    else if (_switchView.selectedSegmentIndex==2){
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_1.png"] forSegmentAtIndex:0];   // set icon for when selected
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_2.png"] forSegmentAtIndex:1];  // set icon for when selected
        [tempSeg setImage:[UIImage imageNamed:@"filter_sort_3_c.png"] forSegmentAtIndex:2];
    }
    
}



-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnDone:(id)sender {
    float PRICE_MAX=_slider.selectedMaximumValue;
    float PRICE_MIN=_slider.selectedMinimumValue;
    
    _FilterBy = _switchView.selectedSegmentIndex;
    //    _Price=_slidePrice.value;
    _Open=_openState.selected;
    _StartDate=_txtStartDate.text;
    _EndDate=_txtEndDate.text;
    [[NSUserDefaults standardUserDefaults] setInteger:_FilterBy forKey:@"FilterBy"];
    [[NSUserDefaults standardUserDefaults] setFloat:PRICE_MAX forKey:@"PriceMax"];
    [[NSUserDefaults standardUserDefaults] setFloat:PRICE_MIN forKey:@"PriceMin"];
    [[NSUserDefaults standardUserDefaults] setBool:_Open forKey:@"Open"];
    [[NSUserDefaults standardUserDefaults] setObject:_StartDate forKey:@"StartDate"];
    [[NSUserDefaults standardUserDefaults] setObject:_EndDate forKey:@"EndDate"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnCancel_click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnClearFilter_click:(id)sender {
    _switchView.selectedSegmentIndex=0;
    [self checkOnOffState:_switchView];
    //    self.slidePrice.value=0.0f;
    _openState.selected=NO;
    self.txtStartDate.text=@"";
    self.txtEndDate.text=@"";
    
    
}


- (void)viewDidUnload {
    [self setScroll:nil];
    [self setTxtStartDate:nil];
    [self setTxtStartDate:nil];
    [self setTxtEndDate:nil];
    
    [self setFilterBy:nil];
    [self setBtnDone:nil];
    
    //    [self setSlidePrice:nil];
    [self setOpen:nil];
    //[self setSlider:nil];
    [self setSliderView:nil];
    [super viewDidUnload];
}
@end

