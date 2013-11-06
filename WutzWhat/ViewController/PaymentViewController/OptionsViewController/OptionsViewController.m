//
//  OptionsViewController.m
//  WutzWhat
//
//  Created by Rafay on 3/12/13.
//
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

@synthesize tblOptions = _tblOptions, optionsArray = _optionsArray, isShipping = _isShipping;

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
    
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks_2.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    self.tblOptions.showsHorizontalScrollIndicator = NO;
    self.tblOptions.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTblOptions:nil];
    _optionsArray = nil;
    [super viewDidUnload];
}

#pragma mark- Button Actions

-(void)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Table View Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OptionsCell";
    UITableViewCell *cell;
    
    cell= (UITableViewCell*)[self.tblOptions dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *optionTitle = (UILabel *) [cell viewWithTag:1];
    optionTitle.text = [_optionsArray objectAtIndex:indexPath.row];
    
    UILabel *optionDesc = (UILabel *) [cell viewWithTag:2];
    optionDesc.text = [_optionsArray objectAtIndex:indexPath.row];
    
    if ([self.currentSelection isEqualToString:[_optionsArray objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UIImageView* imgDark = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_clean_light_plain.png"] stretchableImageWithLeftCapWidth:320.0 topCapHeight:1.0]];
    
    cell.backgroundView = imgDark;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = self.navigationController.viewControllers.count - 2;
    
    PaymentViewController *controller = (PaymentViewController *)[self.navigationController.viewControllers objectAtIndex:index];
    if(_isShipping)
        controller.optionsString = [_optionsArray objectAtIndex:indexPath.row];
    else
        controller.optionsCredits = !indexPath.row;
    
    [self.navigationController popToViewController:controller animated:YES];
}

@end
