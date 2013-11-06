//
//  GoogleAddressAPIResultViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 4/8/13.
//
//

#import "GoogleAddressAPIResultViewController.h"

@interface GoogleAddressAPIResultViewController ()

@end

@implementation GoogleAddressAPIResultViewController

@synthesize googleAddressSuggestions = _googleAddressSuggestions;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

#pragma mark - Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad]; [Crittercism leaveBreadcrumb:[NSString stringWithFormat:@"User Loaded the %@ , %@ , %@", self.description, [NSDate date], [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]]];
    
    [self.tblGoogleAddressResults setDelegate:self];
    [self.tblGoogleAddressResults setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTblGoogleAddressResults:nil];
    [super viewDidUnload];
}

#pragma mark - Table View Delegate Methods


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tblGoogleAddressResults dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    GoogleLocationAPIModel *model = [[GoogleLocationAPIModel alloc] init];
    
    model = [self.googleAddressSuggestions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.formattedAddress ;
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.googleAddressSuggestions.count;
}


-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate)
    {
        GoogleLocationAPIModel *model = [[GoogleLocationAPIModel alloc] init];
        
        model = [self.googleAddressSuggestions objectAtIndex:indexPath.row];
        
        [self.delegate userSelectNewAddress:model.formattedAddress WithLat:model.latitude longitude:model.longitude];
    }
    
    [self dismissViewControllerAnimated:NO completion:^(){}];
}


#pragma mark - Button Actions

- (IBAction)btnCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^(){}];
}


@end

