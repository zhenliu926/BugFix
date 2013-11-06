//
//  MyCreditViewController.m
//  WutzWhat
//
//  Created by iPhone Development on 3/19/13.
//
//

#import "MyCreditViewController.h"

#define RECT_CREDITS CGRectMake(6,9,57,21)
#define RECT_CREDIT_TEXT CGRectMake(6,25,57,21)
#define RECT_PRICE CGRectMake(6,50,57,21)
#define RECT_DESCRIPTION CGRectMake(78,6,222,39)
#define RECT_DATE CGRectMake(78,50,222,21)

@interface MyCreditViewController ()

@end

@implementation MyCreditViewController

@synthesize sectionsArray,rows,dataDict;

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
    page = 1;
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
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_credits.png"]];
    [[self navigationItem]setTitleView:titleIV];
    [self calServiceWithURL:GET_CREDIT_BALANCE];
    [self calServiceWithURL:GET_CREDIT_HISTORY];
    
    UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom.png"]];
    self.tblCredit.tableFooterView =imgVew;
    
    if(OS_VERSION>=7)
    {
      
        
        self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x,46,self.titleLabel.frame.size.width,self.titleLabel.frame.size.height);
        
        self.creditImg.frame=CGRectMake(self.creditImg.frame.origin.x,self.creditImg.frame.origin.y+46,self.creditImg.frame.size.width,self.creditImg.frame.size.height);
        
        self.tblCredit.frame=CGRectMake(self.tblCredit.frame.origin.x,self.tblCredit.frame.origin.y+46,self.tblCredit.frame.size.width,self.tblCredit.frame.size.height);
        
        self.lblCreditBalance.frame=CGRectMake(self.lblCreditBalance.frame.origin.x,self.lblCreditBalance.frame.origin.y+46,self.lblCreditBalance.frame.size.width,self.lblCreditBalance.frame.size.height);
        
        self.creditText.frame=CGRectMake(self.creditText.frame.origin.x,self.creditText.frame.origin.y+46,self.creditText.frame.size.width,self.creditText.frame.size.height);
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- Table Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(array!=nil)
    {
        if(array.count>0)
    return [array count];
        
        else
            return 0;
    }
    else
        return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CreditCell";
    
    UITableViewCell *cell = (UITableViewCell*)[self.tblCredit dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    CreditModel *Credits = [array objectAtIndex:indexPath.row];
    
    UILabel *credit = (UILabel*)[cell viewWithTag:1];
    credit.frame = RECT_CREDITS;
    [credit setText:Credits.credit];
    
    UILabel *creditHist = (UILabel*)[cell viewWithTag:3];
    creditHist.frame = RECT_DESCRIPTION;
    [creditHist setText:Credits.creditHistory];
    
    UILabel *date = (UILabel*)[cell viewWithTag:4];
    date.frame = RECT_DATE;
    [date setText:Credits.date];
    
    UILabel *creditText = (UILabel *)[cell viewWithTag:10];
    creditText.frame = RECT_CREDIT_TEXT;
    
    UILabel *price = (UILabel *)[cell viewWithTag:11];
    price.frame = RECT_PRICE;
    [price setText:Credits.transaction_money];
    
    if ([self getTextLinesForUILable:Credits.creditHistory forLable:creditHist] == 1)
    {
        if ([Credits.transaction_money isEqualToString:@""])
        {
            credit.frame = CGRectMake(RECT_CREDITS.origin.x, 21, RECT_CREDITS.size.width, RECT_CREDITS.size.height);
            
            creditText.frame = CGRectMake(RECT_CREDIT_TEXT.origin.x, 37, RECT_CREDIT_TEXT.size.width, RECT_CREDIT_TEXT.size.height);
            
            creditHist.frame = CGRectMake(RECT_DESCRIPTION.origin.x, 19, RECT_DESCRIPTION.size.width, 21);
            
            date.frame = CGRectMake(RECT_DATE.origin.x, 38, RECT_DATE.size.width, RECT_DATE.size.height);
        }
        else
        {
            creditHist.frame = CGRectMake(RECT_DESCRIPTION.origin.x, 12, RECT_DESCRIPTION.size.width, 21);
        }
    }
    else
    {
        if ([Credits.transaction_money isEqualToString:@""])
        {
            credit.frame = CGRectMake(RECT_CREDITS.origin.x, 21, RECT_CREDITS.size.width, RECT_CREDITS.size.height);
            
            creditText.frame = CGRectMake(RECT_CREDIT_TEXT.origin.x, 37, RECT_CREDIT_TEXT.size.width, RECT_CREDIT_TEXT.size.height);
        }
    }
    
    //cell backgrounds
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_clean_dark.png"]];
    [cell setBackgroundView:bgview];
    UIView* bgview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview1.opaque = YES;
    bgview1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_clean_light.png"]];
    
    if (indexPath.row%2==0)
    {
        cell.backgroundView = bgview;
    }
    else
    {
        cell.backgroundView = bgview1;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 67.0;
}


#pragma mark Webservice

- (void) calServiceWithURL:(NSString*)serviceUrl
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    [params setValue:@"1" forKey:@"page"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceUrl] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
}

#pragma mark -
#pragma mark Data fetcher
#pragma mark -

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_CREDIT_BALANCE]])
    {
        [[ProcessingView instance] hideTintView];
        
        BOOL isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        if (isSuccess)
        {
            if ( ![[responseData objectForKey:@"message"] isKindOfClass:[NSNull class]] && [responseData objectForKey:@"message"]!=nil && ![[responseData objectForKey:@"message"] isEqualToString:@""] )
            {
                self.lblCreditBalance.text = [responseData objectForKey:@"message"];
                
                [[NSUserDefaults standardUserDefaults]setObject:self.lblCreditBalance.text forKey:@"message"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
    }
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_CREDIT_HISTORY]])
    {
        [[ProcessingView instance] hideTintView];
        NSMutableArray *dataArray;
        if([responseData objectForKey:@"data"] != [NSNull null])
        {
            dataArray =[[NSMutableArray alloc] init];
            dataArray=[responseData objectForKey:@"data"] ;
            
        }
        
        
        array = [[NSMutableArray alloc] init];
        
        NSLog(@"%@",dataArray);
         NSLog(@"%d",dataArray.count);
        if(dataArray!=nil)
        {
        
        for (NSDictionary *dic in dataArray)
        {
            for (NSDictionary *dic in dataArray)
            {
                CreditModel *credits = [[CreditModel alloc] init];
                
                [credits setCredit:[NSString stringWithFormat:@"%@",[dic objectForKey:@"credit"]]];
                [credits setType:[dic valueForKey:@"credit_type"]];
                [credits setCreditHistory:[dic valueForKey:@"text"]];
                [credits setTransaction_money:[CommonFunctions isValueExist:[dic valueForKey:@"transaction_money"]] ? [NSString stringWithFormat:@"$%@", [dic valueForKey:@"transaction_money"]] : @""];
                [credits setDate:[self getDateStringFromTimeStamp:[dic valueForKey:@"time"]]];
                
                [array addObject:credits];
            }
        }
        }
        [self.tblCredit reloadData];
    }
}

- (void) dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_CREDIT_BALANCE]])
    {
        NSLog(@"%@",responseData);
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_CREDIT_HISTORY]])
    {
                NSLog(@"%@",responseData);
    }
}


-(NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp
{
    NSString *postTime = @"";
    if (timeStamp)
    {
        postTime = [timeStamp stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        postTime = [postTime stringByReplacingOccurrencesOfString:@")/" withString:@""];
        NSArray *timeArray = [postTime componentsSeparatedByString:@"-"];
        double postTimeLong = [[timeArray objectAtIndex:0] doubleValue];
        
        postTimeLong = (postTimeLong/1000);
        
        NSDate *tr = [NSDate dateWithTimeIntervalSince1970:postTimeLong];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM d, yyyy h:mm aa"];
        postTime = [formatter stringFromDate:tr];
    }
    return postTime;
}


- (void)viewDidUnload
{
    [self setTblCredit:nil];
    [self setLblCreditBalance:nil];
    [super viewDidUnload];
}

- (void) backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(int)getTextLinesForUILable:(NSString *)text forLable:(UILabel *)lable
{
    int lines = [lable.text sizeWithFont:lable.font
                       constrainedToSize:lable.frame.size
                           lineBreakMode:NSLineBreakByWordWrapping].height /lable.font.pointSize;
    return lines;
}

#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end
