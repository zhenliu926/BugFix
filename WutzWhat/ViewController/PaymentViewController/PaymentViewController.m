//
//  PaymentViewController.m
//  WutzWhat
//
//  Created by Rafay on 3/12/13.
//
//

#import "PaymentViewController.h"

#define VIEW_OPTIONS_Y 111.0f
#define VIEW_TAX_INFO_Y 159.0f
#define VIEW_SHIPPING_ADDRESS_Y 257.0f
#define VIEW_BOTTOM_Y 370.0f

@interface PaymentViewController ()

@end

@implementation PaymentViewController

@synthesize optionsCredits = _optionsCredits, btnConfirmPurchase = _btnConfirmPurchase;

#pragma mark- Controller Life Cycle

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
    
    [self setUpNavigationBar];
    
    quantityArray = [[NSMutableArray alloc] init];
    
    self.optionsString = PAYMENT_OPTION_DEFAULT;
    [_btnConfirmPurchase setImage:[UIImage imageNamed:@"confirmpurchase_c.png"] forState:UIControlStateHighlighted];
    _optionsCredits = TRUE;
    canUserBuyPerk = YES;
    
    if(OS_VERSION>=7)
    {
        self.scroll.frame=CGRectMake(self.scroll.frame.origin.x,self.scroll.frame.origin.y+44,self.scroll.frame.size.width,self.scroll.frame.size.height);
    }
    
   

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self callTaxInfoAPI];
    
    visibleViews = [[NSMutableArray alloc] initWithObjects:self.viewOptions, self.viewTaxInfo, self.viewShippingAddress, self.viewButtom, nil];
    [self setViewFrame:self.viewOptions yAxis:VIEW_OPTIONS_Y];
    [self setViewFrame:self.viewTaxInfo yAxis:VIEW_TAX_INFO_Y];
    [self setViewFrame:self.viewShippingAddress yAxis:VIEW_SHIPPING_ADDRESS_Y];
    [self setViewFrame:self.viewButtom yAxis:VIEW_BOTTOM_Y];
    
    int height = 0;
    for (UIView *v in visibleViews) {
        height += v.frame.size.height;
    }
    
    height += ((UIView *)visibleViews.lastObject).frame.origin.y;
    
    self.scroll.contentSize=CGSizeMake(320, IS_IPHONE_5 ? height : 1050);
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.bounces = false;
    
    self.lblOptions.text = self.optionsString;
    
    [self populatePerksDetailsWithModel:self.perksModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setScroll:nil];
    [self setLblQuantity:nil];
    [self setLblTotalCredit:nil];
    [self setLblTotalPrice:nil];
    [self setLblPayment:nil];
    [self setLblTotalTax:nil];
    [self setLblPerkTitle:nil];
    [self setLblPerkDescription:nil];
    [self setLblPerkCredit:nil];
    [self setImgFavourit:nil];
    [self setLblPrice:nil];
    [self setImgPerkThumbnail:nil];
    [self setViewOptions:nil];
    [self setViewTaxInfo:nil];
    [self setViewShippingAddress:nil];
    [self setViewButtom:nil];
    [self setLblShippingCost:nil];
    [self setLblShippingAddress:nil];
    [self setLblOptions:nil];
    [self setImgLove:nil];
    [self setLblLoveCount:nil];
    [self setLblDistance:nil];
    [super viewDidUnload];
}

-(void)setUpNavigationBar
{
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.size.width, backButton.size.height)];
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"]  ;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    
    [v addSubview:backBtn];
    
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_perks_2.png"]];
    [[self navigationItem]setTitleView:titleIV];
}

#pragma mark- Buttons Actions


- (IBAction)btnCreditOptionsClicked:(id)sender
{
    OptionsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionsViewController"];
    controller.currentSelection = self.optionsString;
    controller.optionsArray = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%d Credits",_perksModel.minCredits], [NSString stringWithFormat:@"No Credits - $%.02f",_perksModel.originalPrice], nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTermsOfUseClicked:(id)sender
{
    
}

- (IBAction)btnOptions_pressed:(id)sender
{
    OptionsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionsViewController"];
    controller.currentSelection = self.optionsString;
    controller.optionsArray = [NSArray arrayWithObjects: PAYMENT_OPTION_SHIPPING, PAYMENT_OPTION_PICKUP, nil];
    controller.isShipping = true;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnQuantity_pressed:(id)sender
{
    [self showActionView];
}

- (IBAction)btnConfirmPurchase_pressed:(id)sender
{

    if ([self.addressID isEqualToString:@""] && self.perksModel.isShipping && [self.lblOptions.text isEqualToString:@"Shipping"])
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_CREATE_SHIPPING_ADDRESS];
        return;
    }
    else if ([self.lblOptions.text isEqualToString:PAYMENT_OPTION_DEFAULT] && self.perksModel.isShipping)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_SELECT_OPTION_FIRST];
        return;
    }
    else if ([self.lblPayment.text isEqualToString:@""] || self.lblPayment.text.length == 0)
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_SELECT_CREDIT_CARD_FIRST];
        return;
    }
    else
    {
        [self callMakePaymentAPI];
    }
}

- (IBAction)btnShippingAddress_pressed:(id)sender
{
    ShippingViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ShippingViewController"];
    controller.infoModel = taxInfoModel;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnCreditCard_pressed:(id)sender
{
    CreditCardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnTermsOfServicsClicked:(id)sender
{
    TermsofServiceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsofServiceViewController"];
    controller.termsOfServices = self.termsOfServices;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark- Bussiness Logic

-(void)populateTaxInfoFieldsWithModel:(TaxInfoModel *)infoModel
{
    self.addressID = infoModel.addressID;
    self.lblQuantity.text = userSelectedQuantity != 0 ? [NSString stringWithFormat:@"%d", userSelectedQuantity] : @"1";
    self.lblTotalCredit.text = self.optionsCredits ? [NSString stringWithFormat:@"%d Credits",_perksModel.minCredits] : @"0 Credits";
    self.lblPrice.text = self.optionsCredits ? [NSString stringWithFormat:@"$%.02f",_perksModel.discountPrice] : [NSString stringWithFormat:@"$%.02f",_perksModel.originalPrice];
    
    self.lblShippingAddress.text = infoModel.streetAddress;
    self.lblPayment.text = infoModel.creditCardModel.cardNumber;
    
    int maxQty = [infoModel.quantity intValue];
    
    for (int i = 1; i <= maxQty; i++)
    {
        [quantityArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

-(void)populatePerksDetailsWithModel:(PerksModel *)perksModel
{
    self.lblPerkTitle.text = perksModel.title;
    self.lblPerkDescription.text = perksModel.shortDescription;
    self.lblLoveCount.text = [NSString stringWithFormat:@"%d", perksModel.likeCount];
    self.lblDistance.text = [CommonFunctions getDistanceStringInCountryUnitForCell:perksModel.distance];
    if (perksModel.isLiked)
    {
        [self.imgLove setImage:[UIImage imageNamed:@"icon_loveit_c.png"]];
    }
    else
    {
        [self.imgLove setImage:[UIImage imageNamed:@"icon_loveit.png"]];
    }
    if (self.perksModel.minCredits == 0)
    {
        self.lblPrice.text = [NSString stringWithFormat:@"$%.02f",perksModel.discountPrice];
        [self.lblPerkCredit setText:@"0"];
    }
    else
    {
        if (self.perksModel.isCreditsRequired)
        {
            if (self.perksModel.userCredits >= self.perksModel.minCredits)
            {
                canUserBuyPerk = YES;
            }
            else
            {
                canUserBuyPerk = NO;
            }
            self.lblPrice.text = [NSString stringWithFormat:@"$%.02f",perksModel.originalPrice];
        }
        else
        {
            if (self.perksModel.userCredits >= self.perksModel.minCredits)
            {
                self.lblPrice.text = [NSString stringWithFormat:@"$%.02f",perksModel.discountPrice];
            }
            else
            {
                self.lblPrice.text = [NSString stringWithFormat:@"$%.02f",perksModel.originalPrice];
            }
        }
        [self.lblPerkCredit setText:[NSString stringWithFormat:@"%d",perksModel.minCredits]];
    }
    
    self.imgFavourit.hidden = !perksModel.isFavourited;
    
    [[self.imgPerkThumbnail layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.imgPerkThumbnail layer] setBorderWidth:0.8];
    [[self.imgPerkThumbnail layer] setCornerRadius:5];
    self.imgPerkThumbnail.ClipsToBounds= YES;
    
    if ( ![perksModel.thumbnailURL isKindOfClass:[NSNull class]] && ![perksModel.thumbnailURL isEqualToString:@""] )
    {
        [self.imgPerkThumbnail setImageWithURL:[NSURL URLWithString:perksModel.thumbnailURL]];
    }
    else
    {
        [self.imgPerkThumbnail setImage:[UIImage imageNamed:@"list_thumbnail.png"]];
    }
    
    if (!self.perksModel.isShipping)
    {
        [self hideView:self.viewOptions];
        [self hideView:self.viewShippingAddress];
    }
    else if (self.perksModel.isShipping && ![self.optionsString isEqualToString:PAYMENT_OPTION_SHIPPING])
    {
        [self hideView:self.viewShippingAddress];
    }
}


#pragma mark- API Calls, API Delegate

-(void)callTaxInfoAPI
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:self.perksModel.postId forKey:@"perk_id"];
    [params setObject:[NSNumber numberWithInt:self.perksModel.baseCityID] forKey:@"city_id"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TAX_INFO] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}

-(void)callMakePaymentAPI
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *dict = appDelegate.facebookData;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:self.perksModel.postId forKey:@"perk_id"];
    [params setValue:taxInfoModel.creditCardModel.cardToken forKey:@"card_token"];
    [params setValue:self.lblQuantity.text forKey:@"qty"];
    [params setValue:[self.lblTotalPrice.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] forKey:@"total_amount"];
    [params setValue:[self.lblTotalTax.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] forKey:@"total_tax"];
    
    [params setValue:[NSString stringWithFormat:@"%.02f",([[self.lblTotalPrice.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] floatValue] - [[self.lblTotalTax.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] floatValue] - [[self.lblShippingCost.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] floatValue])] forKey:@"amount"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:MM"];
    [params setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"purchase_time"];
    
    dateFormatter = nil;
    
    if ([dict objectForKey:@"country_code"])
    {
        [params setValue:[dict objectForKey:@"country_code"] forKey:@"country"];
    }
    else
    {
        [params setValue:@"CA" forKey:@"country"];
    }
    
    
    if (self.perksModel.isShipping && [self.lblOptions.text isEqualToString:PAYMENT_OPTION_SHIPPING] && self.addressID.length > 0)
    {
        [params setValue:[NSNumber numberWithBool:YES] forKey:@"isShipping"];
        [params setValue:self.addressID forKey:@"addr_id"];
        [params setValue:[self.lblShippingCost.text stringByReplacingOccurrencesOfString:@"$ " withString:@""] forKey:@"shipping_amount"];
        [params setValue:![taxInfoModel.country isEqualToString:@"Canada"] ? (![taxInfoModel.shippingRateUSA isEqualToString:@"USA"] ? @"ship_rate_intl" : @"ship_rate_us") : @"ship_rate_can" forKey:@"shipping_to_country"];
    }
    else
    {
        [params setValue:[NSNumber numberWithBool:NO] forKey:@"isShipping"];
    }
    
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
    
    DataFetcher *fetcher  = [[DataFetcher alloc] init];
    [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,MAKE_PAYMENT] andDelegate:self andRequestType:@"POST" andPostDataDict:params];
    
    [[ProcessingView instance] forceShowTintView];
}

- (void) dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString*)url
{
    [[ProcessingView instance] forceHideTintView];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TAX_INFO]])
    {
        BOOL isSuccess = NO;
        
        if (![[responseData objectForKey:@"result"] isKindOfClass:[NSNull class]])
        {
            isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        }
        
        if (isSuccess)
        {
            _btncreditsOptions.userInteractionEnabled = !((PerksModel *)_perksModel).isCreditsRequired;
            if(!((PerksModel *)_perksModel).isCreditsRequired)
                _btncreditsOptions.userInteractionEnabled = (!((PerksModel *)_perksModel).minCredits <= 0);
            _btnConfirmPurchase.enabled = _btnConfirmPurchase.userInteractionEnabled = !(((PerksModel *)_perksModel).userCredits < ((PerksModel *)_perksModel).minCredits);
            
            NSArray *infoArray = [responseData objectForKey:@"data"];
            taxInfoModel = [TaxInfoModel parseTaxInfoFromDictionary:[infoArray objectAtIndex:0]];
            [self populateTaxInfoFieldsWithModel:taxInfoModel];
            if (userSelectedQuantity != 0)
            {
                [self calculateAndShowTaxes:userSelectedQuantity];
            }
            else
            {
                [self calculateAndShowTaxes:1];
            }
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:[NSString stringWithFormat:@"%@ %@",[responseData objectForKey:@"message"], [responseData objectForKey:@"error"]]];
            self.addressID = @"";
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,MAKE_PAYMENT]])
    {
        BOOL isSuccess = NO;
        
        if (![[responseData objectForKey:@"result"] isKindOfClass:[NSNull class]])
        {
            isSuccess = [[responseData objectForKey:@"result"] isEqualToString:@"true"];
        }
        if (isSuccess)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PerkPurchased" object:nil];
        }
        else
        {
            [Utiltiy showAlertWithTitle:@"Failed" andMsg:[responseData objectForKey:@"error"]];
        }
    }
}

- (void)dataFetchedFailure:(NSDictionary *)responseData forUrl:(NSString*)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TAX_INFO]])
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,MAKE_PAYMENT]])
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_FAILED];
    }
}


#pragma mark- Dynamic View Hide

-(void)hideView:(UIView *)viewToBeHide
{
    if ([visibleViews containsObject:viewToBeHide])
    {
        [viewToBeHide setHidden:YES];
        
        int viewToBeHideIndex = [visibleViews indexOfObject:viewToBeHide];
        
        CGFloat viewToBeHideYAxis = viewToBeHide.frame.origin.y;
        
        [self setViewFrame:[visibleViews objectAtIndex:viewToBeHideIndex + 1] yAxis:viewToBeHideYAxis];
        
        for (int i = viewToBeHideIndex + 1; i < [visibleViews count]; i ++)
        {
            UIView *upperView = (UIView *)[visibleViews objectAtIndex:i];
            
            CGFloat yAxis = upperView.frame.origin.y;
            CGFloat heigth = upperView.frame.size.height;
            
            if (i + 1 != [visibleViews count])
            {
                [self setViewFrame:[visibleViews objectAtIndex:i + 1] yAxis:yAxis + heigth];
            }
        }
        
        [visibleViews removeObject:viewToBeHide];
        
        self.scroll.contentSize = CGSizeMake(self.scroll.contentSize.width, self.scroll.contentSize.height - viewToBeHide.frame.size.height);
    }
}


-(void)dragLowerViewToUpperSide:(float)difference
{
    for (int i = 1; i < [visibleViews count]; i++)
    {
        UIView *view = [visibleViews objectAtIndex:i];
        [self setNewFrameOfView:view difference:difference];
    }
}

-(void)setNewFrameOfView:(UIView *)view difference:(float)difference
{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + difference, view.frame.size.width, view.frame.size.height);
}

-(void)setNewHeightOfView:(UIView *)view difference:(float)difference
{
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + difference);
}

-(void)setViewFrame:(UIView *)view yAxis:(CGFloat)yAxis
{
    [view setHidden:NO];
    view.frame = CGRectMake(view.frame.origin.x, yAxis, view.frame.size.width, view.frame.size.height);
}

#pragma mark- UIPickerView Delegate Methods

-(void)showActionView
{
    self.uiPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 300)];
    self.uiPickerView.delegate = self;
    self.uiPickerView.dataSource = self;
    self.uiPickerView.showsSelectionIndicator = YES;
    
    self.actionSheet =  [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(selectRowFromPickerView) forControlEvents:UIControlEventValueChanged];
    [doneButton setTag:4];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    
    cancelButton.momentary = YES;
    cancelButton.frame = CGRectMake(15, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    cancelButton.tintColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(closeStatePicker) forControlEvents:UIControlEventValueChanged];
    [cancelButton setTag:2];
    
    [self.actionSheet addSubview:doneButton];
    [self.actionSheet addSubview:cancelButton];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet addSubview:self.uiPickerView];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, self.view.frame.size.width, 488)];
}

-(void)closeStatePicker
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)selectRowFromPickerView
{
    NSInteger index = [self.uiPickerView selectedRowInComponent:0];
    
    self.lblQuantity.text = [quantityArray objectAtIndex:index];
    
    userSelectedQuantity = [[quantityArray objectAtIndex:index] intValue];
    
    [self calculateAndShowTaxes:[self.lblQuantity.text intValue]];
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [quantityArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [quantityArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //do nothing here.. :D
}


#pragma mark- Bussiness Logic

-(void)calculateAndShowTaxes:(int)perkQuantity
{
    float shippingCost = 0;
    float perItemCost = 0;
    if(_optionsCredits)
        perItemCost = [[self.lblPrice.text stringByReplacingOccurrencesOfString:@"$" withString:@""] floatValue];
    else
        perItemCost = _perksModel.originalPrice;
    
    float hsTax = [taxInfoModel.hst floatValue];
    float gsTax = [taxInfoModel.gst floatValue];
    
    float totalItemCost = perkQuantity * perItemCost;
    
    if (!self.viewShippingAddress.hidden)
    {
        if ([taxInfoModel.country isEqualToString:@"Canada"])
        {
            shippingCost = [taxInfoModel.shippingRateCanada floatValue];
        }
        else if ([taxInfoModel.country isEqualToString:@"USA"])
        {
            shippingCost = [taxInfoModel.shippingRateUSA floatValue];
        }
        else
        {
            shippingCost = [taxInfoModel.shippingRateInternational floatValue];
        }
        
        shippingCost = shippingCost * perkQuantity;
        
        self.scroll.contentSize = CGSizeMake(self.scroll.contentSize.width, self.scroll.contentSize.height + self.viewShippingAddress.frame.size.height/3);//...thanks virtace for ruining everything, how about you do view handling correctly next time
        
    }
    
    float totalTaxCost = (totalItemCost + shippingCost) * (hsTax + gsTax) / 100;
    
    float totalCalculatedCost = shippingCost + totalItemCost + totalTaxCost;
    
    self.lblTotalTax.text = [NSString stringWithFormat:@"$ %0.2f", totalTaxCost];
    self.lblShippingCost.text = [NSString stringWithFormat:@"$ %0.2f", shippingCost];
    self.lblTotalPrice.text = [NSString stringWithFormat:@"$ %0.2f", totalCalculatedCost];
}

@end
