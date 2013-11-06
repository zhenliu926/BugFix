//
//  AddTalkViewController.m
//  WutzWhat
//
//  Created by Rafay on 11/19/12.
//
//

#import "AddTalkViewController.h"
#import "Utiltiy.h"
#import "TalkSingletonManager.h"

#define VIEW_EVENT_DATES_Y 429.0f
#define VIEW_BOTTOM_Y 553.0f

#define TXT_TITILE_OFFSET_Y 0
#define TXT_SHORT_DESCRIPTION_OFFSET_Y 170
#define TXT_LOGN_DESCRIPTION_OFFSET_Y 256
#define TXT_PRICE_OFFSET_Y 530
#define TXT_ADDRESS_OFFSET_Y 615
#define TXT_PHONE_OFFSET_Y 745
#define TXT_WEBSITE_OFFSET_Y 835
#define TXT_FROM_DATE_OFFSET_Y 945
#define TXT_TO_DATE_OFFSET_Y 945

#define ADD_IMAGES_VIEW_FRAME CGRectMake(0, 420, 320, 100)
#define BELOW_VIEW_FRAME CGRectMake(0, 521, 320, 819)

@interface AddTalkViewController ()

@end

@implementation AddTalkViewController

@synthesize categoryIndex;
@synthesize ViewBelow;
@synthesize btnAddImages;
@synthesize ViewImages;
@synthesize uiPickerView, pickerActionSheet;
@synthesize delegate = _delegate;
@synthesize talkID = _talkID;
@synthesize detailModel = _detailModel;
@synthesize editMode = _editMode;
@synthesize newlyAddedImages = _newlyAddedImages;
@synthesize deletedImages = _deletedImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MapDrop"])
    {
        [NSThread detachNewThreadSelector:@selector(showTintView) toTarget:self withObject:nil];
       
        self.btnSearchMap.selected  = YES;
        self.btnCurrentLocation.selected  = NO;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLatitude"] doubleValue] longitude:[[[NSUserDefaults standardUserDefaults] valueForKey:@"MapDropLongitude"] doubleValue]];
        [self getAddressFromCoordinates:location];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{        
    self.txtWebSiteAddress.delegate = self;
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"MapDrop"];
    UIImage *backButton = [UIImage imageNamed:@"top_back.png"] ;
    UIImage *backButtonPressed = [UIImage imageNamed:@"top_back_c.png"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, backButton.size.width, backButton.size.height)];
    [backBtn addTarget:self action:@selector(backBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:backButton forState:UIControlStateNormal];
    [backBtn setImage:backButtonPressed forState:UIControlStateHighlighted];
    [v addSubview:backBtn];
    UIBarButtonItem *backbtnItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    [[self navigationItem]setLeftBarButtonItem:backbtnItem ];
        
    UIImageView *titleIV = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"top_addmyfind.png"]];
    [[self navigationItem]setTitleView:titleIV];
    
    imageCount=0;
    oldImagesID = 1;
    
    self.deletedImages = [[NSMutableArray alloc] init];
    self.newlyAddedImages = [[NSMutableArray alloc] init];
    
    self.btnAddImages.frame=CGRectMake(20, 30, 65, 65);
    self.btnAddImages.contentMode=UIViewContentModeScaleAspectFill;
    if(OS_VERSION>=7)
    {
        if(IS_IPHONE_5)
        self.scrollInputData.frame=CGRectMake(0,44,320,530);
        else
            self.scrollInputData.frame=CGRectMake(0,44,320,440);
            
    }
    self.btnAddImages.layer.masksToBounds = YES;
    self.scrollInputData.contentSize=CGSizeMake(320, 1400);
    
    imageArray = [[NSMutableArray alloc] initWithObjects:self.btnAddImages, nil];
    
    [self.btnCategory setTitle:@"Food" forState:UIControlStateNormal];
    [self hideEventDates:YES];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)] ;
    [self.scrollInputData addGestureRecognizer:tapRecognizer];
    
    [self performSelectorInBackground:@selector(applyControlToDateField) withObject:nil];
    
    if (self.talkID && self.editMode)
    {
        [self applyEditTalk];
    }
    
    sizeofscroll = self.scrollInputData.contentSize;
    fetcher = [[AddMyFindDataFetcer alloc] init];
    
}

-(void)applyControlToDateField
{
    [self.txtStaartDate apply_full];
    [self.txtEndingDate apply_full];
    [self.txtStaartDate setPlaceholder:@"Date"];
    [self.txtEndingDate setPlaceholder:@"Date"];
    [self.txtStaartDate setDelegate:self];
    [self.txtEndingDate setDelegate:self];
    [self.txtStaartDate setTextAlignment:NSTextAlignmentCenter];
    [self.txtEndingDate setTextAlignment:NSTextAlignmentCenter];
    self.btnPrice.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [self.txtPhone setKeyboardType:UIKeyboardTypePhonePad];
}


-(void) showTintView
{
    [[ProcessingView instance] showTintViewWithUserInteractionEnabled];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{    
    [self setTxtTitle:nil];
    [self setTxtShrtDescription:nil];
    [self setTxtLongDescription:nil];
    [self setBtnPrice:nil];
    [self setTxtAddress:nil];
    [self setTxtPhone:nil];
    [self setTxtStaartDate:nil];
    [self setTxtEndingDate:nil];
    [self setBtnSubmit:nil];
    [self setScrollInputData:nil];
    [self setViewBelow:nil];
    [self setViewImages:nil];
    [self setBtnAddImages:nil];
    [self setBtnCategory:nil];
    [self setBtnCurrentLocation:nil];
    [self setViewEventDate:nil];
    [self setViewBottom:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Button Actions
#pragma mark -
- (IBAction)btnCategory_pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Category" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Food",@"Shopping",@"Events",@"Services",@"Nightlife",@"Concierge",nil];
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
}

- (IBAction)btnPrice_pressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Price Range" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"$",@"$$",@"$$$",@"$$$$",nil];
    actionSheet.tag=5;
    [actionSheet showInView:self.view];
}


- (IBAction)btnShowCurrentLocation_Pressed:(id)sender
{
    self.btnSearchMap.selected  = NO;
    self.btnCurrentLocation.selected  = YES;
    
    [[ProcessingView instance] forceShowTintView];
    
    [self getAddressFromCoordinates:[CommonFunctions getUserCurrentLocation]];
    [[self txtAddress] resignFirstResponder];
}

- (IBAction)btnSearchAddress_Pressed:(id)sender
{
    UIButton *button = (id) sender;
    button.selected=YES;
    
    ChangeLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeLocationViewController"];
    [vc setType:NSStringFromClass([self class])];
    
    [self.navigationController pushViewController:vc animated:YES];
    [[self txtAddress] resignFirstResponder];
}

- (IBAction)btnAddImage_Pressed:(id)sender
{    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library",@"From Camera", nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
}

    
-(void)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self setTxtTitle:nil];
    [self setTxtShrtDescription:nil];
    [self setTxtLongDescription:nil];
    [self setBtnPrice:nil];
    [self setTxtAddress:nil];
    [self setTxtPhone:nil];
    [self setTxtStaartDate:nil];
    [self setTxtEndingDate:nil];
    [self setBtnSubmit:nil];
    [self setScrollInputData:nil];
    [self setViewBelow:nil];
    [self setViewImages:nil];
    [self setBtnAddImages:nil];
    [self setBtnCategory:nil];
    [self setBtnCurrentLocation:nil];
    [self setViewEventDate:nil];
    [self setViewBottom:nil];
    [self setBtnSearchMap:nil];
    [self setTxtWebSiteAddress:nil];
    fetcher = nil;
    fetcher.delegate = nil;
    oldImagesID = 0;
    
}

- (IBAction)btnSubmit_Pressed:(id)sender
{
    BOOL isValid;
    
    if(self.txtTitle.text.length <=0)
    {
        [Utiltiy showAlertWithTitle:@"Error" andMsg:MSG_FILL_FIELDS];
        [self.txtTitle becomeFirstResponder];
        isValid = NO;
        return;
    }
    if (self.txtTitle.text.length > 20)
    {
        isValid = NO;
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_MY_FIND_TITLE_LIMIT];
        [self.txtTitle becomeFirstResponder];
        return;
    }
    if (self.txtTitle.text.length <= 20 ||self.txtTitle.text.length>0)
    {
        isValid = YES;
//        if (![self validateString:self.txtTitle.text withRegXString:ALPHA_NUMERIC_REGULAR_EXPRESSION] )
//        {
//            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALPHA_NUMERIC];
//            [self.txtTitle becomeFirstResponder];
//            isValid = NO;
//            return;
//        }
//        else
//        {
//            isValid = YES;
//        }
    } else {
        isValid = NO;
    }
//    if (self.txtShrtDescription.text.length > 0)
//    {
//        isValid = YES;
//        if (self.txtShrtDescription.text.length > 25 )
//        {
//            isValid = NO;
//            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_SHORT_DESCRIPTION_LIMIT];
//            [self.txtShrtDescription becomeFirstResponder];
//            return;
//        }
////        }else
////        {
////            isValid = YES;
////            if(![self validateString:self.txtShrtDescription.text withRegXString:ALPHA_NUMERIC_REGULAR_EXPRESSION])
////            {
////                [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALPHA_NUMERIC];
////                [self.txtShrtDescription becomeFirstResponder];
////                isValid = NO;
////                return;
////            }
////            else
////            {
////                isValid = YES;
////            }
////        }
//    }else {
//        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FILL_FIELDS];
//        [self.txtShrtDescription becomeFirstResponder];
//        isValid = NO;
//        return;
//        
//    }
//
//    if (self.txtLongDescription.text.length > 0)
//    {
//        isValid = YES;
////        if (![self validateString:self.txtLongDescription.text withRegXString:ALPHA_NUMERIC_REGULAR_EXPRESSION])
////        {
////            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_ALPHA_NUMERIC];
////            [self.txtLongDescription becomeFirstResponder];
////            isValid = NO;
////            return;
////        }
////        else
////        {
////            isValid = YES;
////        }
//    } else {
//        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FILL_FIELDS];
//        [self.txtLongDescription becomeFirstResponder];
//        isValid = NO;
//        return;
//
//    }
//    if (self.btnPrice.titleLabel.text.length > 0)
//       isValid = YES;
//    else {
//        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ERROR_WITH_PRICE];
//        [self.btnPrice becomeFirstResponder];
//        isValid = NO;
//        return;
//    }
//    if (self.txtPhone.text.length > 0)
//    {
//        isValid = YES;
//        if (![self validateString:self.txtPhone.text withRegXString:NUMERIC_REGULAR_EXPRESSION])
//        {
//            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_NUMBERS];
//            [self.txtPhone becomeFirstResponder];
//            isValid = NO;
//            return;
//        }
//        else
//        {
//            isValid = YES;
//        }
//    } else {
//        
//        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ENTER_NUMBERS];
//        [self.txtPhone becomeFirstResponder];
//        isValid = NO;
//        return;
//    }
//    
//    if (self.txtStaartDate.text.length <= 0 && self.txtEndingDate.text.length <= 0)
//    {
//        isValid = YES;
//        if (![self validateStartEndDates:self.txtStaartDate.text endDate:self.txtEndingDate.text])
//        {
//            [Utiltiy showAlertWithTitle:@"" andMsg:MSG_START_DATE_GREATER_THEN_END_DATE];
//            isValid = NO;
//            [self.txtStaartDate becomeFirstResponder];
//            return;
//        }
//        else
//        {
//            isValid = YES;
//        }
//    }else
//    {
//        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_START_END_DATE_INVALID];
//        isValid = NO;
//        [self.txtStaartDate becomeFirstResponder];
//        return;
//        
//    }
//    if (self.txtAddress.text.length > 0)
//    {
//        isValid = YES;
//    } else {
//        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_ADDRESS_INVALID];
//        isValid = NO;
//        [self.txtAddress becomeFirstResponder];
//        return;
//    }
    
    
    if (isValid)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forKey:@"access_token"];
        [params setValue:self.txtTitle.text forKey:@"title"];
        if (self.editMode)
        {
            [params setObject:self.talkID forKey:@"postId"];
        }
        else
        {
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"cityselected"] forKey:@"baseCity"];
        }
        
        if (self.txtAddress.text.length > 0)
        {
            [params setValue:self.txtAddress.text forKey:@"address"];
        }
        if (self.txtShrtDescription.text.length > 0)
        {
            [params setValue:self.txtShrtDescription.text forKey:@"info"];
        }
        if (self.txtLongDescription.text.length > 0)
        {
            [params setValue:self.txtLongDescription.text forKey:@"description"];
        }
        if (self.btnPrice.titleLabel.text.length > 0)
        {
            [params setValue:[NSNumber numberWithInt:self.btnPrice.tag] forKey:@"price"];
        }
        if (self.txtPhone.text.length > 0)
        {
            [params setValue:self.txtPhone.text forKey:@"pnumber"];
        }
        if (self.txtWebSiteAddress.text.length > 0)
        {
            [params setValue:self.txtWebSiteAddress.text forKey:@"link"];
        }
        if ([self.btnCategory.titleLabel.text isEqualToString:@"Events"])
        {
            if (self.txtStaartDate.text.length > 4)
            {
                [params setValue:self.txtStaartDate.text forKey:@"start_date"];
            }
            if (self.txtEndingDate.text.length > 4)
            {
                [params setValue:self.txtEndingDate.text forKey:@"end_date"];
            }
        }
        
        NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
        NSMutableArray *imagesArrayNewlyAdded = [[NSMutableArray alloc] init];
        
        for (id view in imageArray)
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                UIImageView *image_= view;
                
                UIImage *img = image_.image;
                
                [imagesArray addObject:img];
            }
        }
        
        for (id view in self.newlyAddedImages)
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                UIImageView *image_= view;
                
                UIImage *img = image_.image;
                
                [imagesArrayNewlyAdded addObject:img];
            }
        }

        
        NSString *urlString;
        
        if ([_btnCategory.titleLabel.text isEqualToString:@"Food"])
        {
            urlString = self.editMode ? EDIT_FOOD_TALK : ADD_FOOD_TALK;
        }
        else if([_btnCategory.titleLabel.text isEqualToString:@"Shopping"])
        {
            urlString = self.editMode ? EDIT_SHOPPING_TALK : ADD_SHOPPING_TALK;
        }
        else if([_btnCategory.titleLabel.text isEqualToString:@"Events"])
        {
            urlString = self.editMode ? EDIT_EVENT_TALK : ADD_EVENT_TALK;
        }
        else if([_btnCategory.titleLabel.text isEqualToString:@"Services"])
        {
            urlString = self.editMode ? EDIT_SERVICE_TALK : ADD_SERVICE_TALK;
        }
        else if([_btnCategory.titleLabel.text isEqualToString:@"Night life"])
        {
            urlString = self.editMode ? EDIT_NIGHTLIFE_TALK : ADD_NIGHTLIFE_TALK;
        }
        else if([_btnCategory.titleLabel.text isEqualToString:@"Concierge"])
        {
            urlString = self.editMode ? EDIT_CONCIERGE_TALK : ADD_CONCIERGE_TALK;
        }
        
        fetcher.editMode = NO;
        
        if (self.editMode && self.detailModel)
        {
            fetcher.editMode = YES;
            fetcher.oldImagesCount = self.detailModel.imagesArray.count;
            fetcher.newlyAddedImagesArray = imagesArrayNewlyAdded;
            fetcher.deletedImagesIDs = self.deletedImages;
        }
        
        [fetcher fetchDataForUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,urlString] andDelegate:self postDataDict:params UIImagesArray:imagesArray];
    }
    else
    {
        
    }
}

-(void)hideEventDates:(BOOL)hide
{
    self.viewEventDate.hidden = hide;
    
    if (self.viewEventDate.hidden)
    {
        self.viewBottom.frame = CGRectMake(0, VIEW_EVENT_DATES_Y, 320, self.viewBottom.frame.size.height);
        
        if (self.scrollInputData.contentSize.height > 1350)
        {
            self.scrollInputData.contentSize = CGSizeMake(320, self.scrollInputData.contentSize.height - self.viewEventDate.frame.size.height + 50);
        }
    }
    else
    {
        self.viewBottom.frame = CGRectMake(0, VIEW_BOTTOM_Y, 320, self.viewBottom.frame.size.height);
        self.viewEventDate.frame = CGRectMake(0, VIEW_EVENT_DATES_Y, 320, self.viewEventDate.frame.size.height);
        if (self.scrollInputData.contentSize.height < 1350)
        {
            self.scrollInputData.contentSize = CGSizeMake(320, self.scrollInputData.contentSize.height + self.viewEventDate.frame.size.height);
        }
    }
}


#pragma mark Action sheet


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{	
    if (actionSheet.tag==1)
    {
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
	switch (buttonIndex)
        {            
        case 0:
		{
            [self.btnCategory setTitle:@"Food" forState:UIControlStateNormal];
            [self hideEventDates:YES];
            break;
		}
		case 1:
		{
            [self.btnCategory setTitle:@"Shopping" forState:UIControlStateNormal];
            [self hideEventDates:YES];            
            break;
		}
        case 2:
		{
			[self.btnCategory setTitle:@"Events" forState:UIControlStateNormal];
            [self hideEventDates:NO];
            break;
		}
        case 3:
		{
			[self.btnCategory setTitle:@"Services" forState:UIControlStateNormal];
            [self hideEventDates:YES];
            break;
		}
        case 4:
		{
			[self.btnCategory setTitle:@"Night life" forState:UIControlStateNormal];
            [self hideEventDates:YES];            
            break;
		}
        case 5:
		{
			[self.btnCategory setTitle:@"Concierge" forState:UIControlStateNormal];
            [self hideEventDates:YES];            
            break;
		}
    }
    }
    
    else if(actionSheet.tag==2)
    {
        if (buttonIndex == actionSheet.cancelButtonIndex)
        {
            return;
        }
        
        switch (buttonIndex)
        {
        case 0:
                {
                    if ([imageArray count]<=10)
                    {
                        self.btnAddImages.enabled = YES;
                        self.btnAddImages.alpha = 1.0f;
                        UIImagePickerController *navigator = [[UIImagePickerController alloc] init];
                        navigator.allowsEditing = NO;
                        navigator.delegate = self;
                        if ([imageArray count]==10)
                        {
                            self.btnAddImages.enabled = NO;
                            self.btnAddImages.alpha = 0.9f;
                        }
                        [self.navigationController presentViewController:navigator animated:YES completion:^(){}];
                    }
                    else
                    {
                        self.btnAddImages.enabled = NO;
                        self.btnAddImages.alpha = 0.9f;
                    }
                    break;
                }
                    
                case 1:
                {
                    if ([imageArray count]<=10)
                    {
                        self.btnAddImages.enabled = YES;
                        self.btnAddImages.alpha = 1.0f;
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.delegate = self;
                        if ([imageArray count]==10)
                        {
                            self.btnAddImages.enabled = NO;
                            self.btnAddImages.alpha = 0.9f;
                        }
                        
                        [self.navigationController presentViewController:picker animated:YES completion:^(){}];
                    }
                    else
                    {
                        self.btnAddImages.enabled = NO;
                        self.btnAddImages.alpha = 0.9f;
                    }
                    break;
                }
        }
	} else if (actionSheet.tag == 5)
    {
        if(buttonIndex == actionSheet.cancelButtonIndex)
            return;
        self.btnPrice.tag = (buttonIndex + 1);
        switch (buttonIndex) {
            case 0:
                [self.btnPrice setTitle:@"$" forState:UIControlStateNormal];
                break;
            case 1:
                [self.btnPrice setTitle:@"$$" forState:UIControlStateNormal];
                break;
            case 2:
                [self.btnPrice setTitle:@"$$$" forState:UIControlStateNormal];
                break;
            case 3:
                [self.btnPrice setTitle:@"$$$$" forState:UIControlStateNormal];
                break;
        }
    }
}



#pragma mark Image Picker Delegates

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"width: %f height: %f",selectedImage.size.width, selectedImage.size.height);
    
    CGSize size = CGSizeMake(1920, 1080);
    
    if(selectedImage.size.width >= size.width || selectedImage.size.height >= size.height) {
    
        CGFloat aspect = selectedImage.size.width / selectedImage.size.height;
        if (size.width / aspect <= size.height)
        {
            selectedImage = [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect) fromImage:selectedImage];
        }
        else
        {
            selectedImage = [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height) fromImage:selectedImage];
        }
    
        NSLog(@"width: %f height: %f",selectedImage.size.width, selectedImage.size.height);
    
    }
        
    imageCount++;
    
    [self performSelector:@selector(AddImages:) withObject:selectedImage];
    selectedImage = nil;
    
}

- (UIImage *)imageScaledToSize:(CGSize)size fromImage:(UIImage *)image
{
    if (CGSizeEqualToSize(image.size, size))
        return image;
    
	UIGraphicsBeginImageContextWithOptions(size, TRUE, 0.0f);
    
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
	image = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return image;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{    
    [self.navigationController dismissViewControllerAnimated:YES completion:^(){}];
}


#pragma mark Adding Images

NSInteger const BtnAddImages_W =65;
NSInteger const BtnAddImages_H =65;
NSInteger const Padding_X =8;
NSInteger const Padding_Y =8;

-(void)AddImages:(id)image
{
    CGRect rect = [[imageArray objectAtIndex:[imageArray count]-1] frame];
    rect.size.width=64;
    rect.size.height=64;
    if ([imageArray count]<=10)
    {
        UIImageView *imageSelected;
        
        if ([image isKindOfClass:[NSString class]])
        {
            imageSelected = [[UIImageView alloc ] init];
            [imageSelected setImageWithURL:[NSURL URLWithString:image]];
            imageSelected.accessibilityHint = [NSString stringWithFormat:@"%d", oldImagesID];
            oldImagesID += 1;
        }
        else
        {
            imageSelected = [[UIImageView alloc ] initWithImage:image];
            
            imageSelected.accessibilityHint = @"new";
            
            [self.newlyAddedImages addObject:imageSelected];
        }
        
        imageSelected.contentMode=UIViewContentModeScaleAspectFill;
        imageSelected.tag=imageCount+100;
        imageSelected.backgroundColor = [UIColor blackColor];
        [imageSelected setFrame:rect];

        imageSelected.userInteractionEnabled = YES;
        imageSelected.layer.cornerRadius = 4.5;
        imageSelected.layer.masksToBounds = YES;
        [self.ViewImages addSubview:imageSelected];
        
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.accessibilityHint = [imageSelected.accessibilityHint isEqualToString:@"new"] ? @"new" : @"old";
        [aButton setImage:[UIImage imageNamed:@"detail_cell_delete.png"] forState:UIControlStateNormal];
        aButton.frame = CGRectMake(imageSelected.frame.origin.x+imageSelected.frame.size.width-15, imageSelected.frame.origin.y-9, 25, 25);
        [aButton addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
        aButton.tag = [imageArray count]+200;

        [self.ViewImages addSubview:aButton];
        [self.ViewImages bringSubviewToFront:aButton];
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
        
        if ([imageArray count]>=1 && [imageArray count]<4)
        {
            self.btnAddImages.frame= CGRectMake(BtnAddImages_W + self.btnAddImages.frame.origin.x +Padding_X, self.btnAddImages.frame.origin.y, BtnAddImages_W, BtnAddImages_H);
        }
        else if (self.btnAddImages.frame.origin.x+BtnAddImages_W+20 >= 288 && [imageArray count]==4)
        {
            self.btnAddImages.frame= CGRectMake(20, self.btnAddImages.frame.origin.y+Padding_Y+BtnAddImages_H, BtnAddImages_W, BtnAddImages_H);
            
            self.ViewImages.frame = CGRectMake(self.ViewImages.frame.origin.x, self.ViewImages.frame.origin.y, self.ViewImages.frame.size.width, 166);
            self.ViewBelow.frame = CGRectMake(self.ViewBelow.frame.origin.x, self.ViewImages.frame.origin.y+166, self.ViewBelow.frame.size.width, self.ViewBelow.frame.size.height);
            self.scrollInputData.contentSize = CGSizeMake(self.scrollInputData.contentSize.width, self.scrollInputData.contentSize.height+87);
        }
        else if ([imageArray count]>4 && [imageArray count]<8)
        {
            self.btnAddImages.frame= CGRectMake(BtnAddImages_W + self.btnAddImages.frame.origin.x +Padding_X, self.btnAddImages.frame.origin.y, BtnAddImages_W, BtnAddImages_H);
        }
        else if ([imageArray count]==8)
        {
            self.btnAddImages.frame= CGRectMake(20, self.btnAddImages.frame.origin.y+Padding_Y+BtnAddImages_H, BtnAddImages_W, BtnAddImages_H);
            self.ViewImages.frame = CGRectMake(self.ViewImages.frame.origin.x, self.ViewImages.frame.origin.y, self.ViewImages.frame.size.width, 166+87);
            self.ViewBelow.frame = CGRectMake(self.ViewBelow.frame.origin.x, self.ViewImages.frame.origin.y+166+87, self.ViewBelow.frame.size.width, self.ViewBelow.frame.size.height);
            self.scrollInputData.contentSize = CGSizeMake(self.scrollInputData.contentSize.width, self.scrollInputData.contentSize.height+87);
        }
        else if ([imageArray count]>=9 && [imageArray count]<=10)
        {
            self.btnAddImages.frame= CGRectMake(BtnAddImages_W + self.btnAddImages.frame.origin.x +Padding_X, self.btnAddImages.frame.origin.y, BtnAddImages_W, BtnAddImages_H);
        }
        UIView *viewButton = [imageArray objectAtIndex:[imageArray count]-1];
        [imageArray removeObjectAtIndex:[imageArray count]-1];
        [imageArray addObject:imageSelected];
        [imageArray addObject:viewButton];
        [UIView commitAnimations];
    }
}


-(IBAction)btnDelete:(UIButton*)sender
{
    NSLog(@"imageArray.count %d",imageArray.count);
    int index = sender.tag-201;
    UIView * currentView = [imageArray objectAtIndex:index];
    CGRect frame = currentView.frame;
    int btnToDeleteTag = sender.tag;
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    if ([sender.accessibilityHint isEqualToString:@"new"])
    {
        [self.newlyAddedImages removeObject:currentView];
    }
    else
    {
        NSString *deletedImageID = currentView.accessibilityHint;
        [self.deletedImages addObject:deletedImageID];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [currentView removeFromSuperview];
    [sender removeFromSuperview];
    for (int i = 0 ; i <[imageArray count]; i++)
    {
        if (i == index) {
            break;
        }
        UIView *view = [imageArray objectAtIndex:i];
        [newArray addObject:view];
    }
    
    
    for (int i = index+1 ; i <[imageArray count]; i++)
    {
        
        UIView *view = [imageArray objectAtIndex:i];
        
        CGRect tmpFrame = view.frame;
        view.frame = frame;
        view.tag -=1;
        frame = tmpFrame;
        [newArray addObject:view];
        
        UIButton *btnToDelete =  (UIButton*)[self.view viewWithTag:btnToDeleteTag+1];
        btnToDelete.frame = CGRectMake(view.frame.origin.x+view.frame.size.width-18, view.frame.origin.y-7, 25, 25);
        btnToDelete.tag  -=1;
        btnToDeleteTag++;
        
    }
    [UIView commitAnimations];

    imageArray = newArray;
    NSLog(@"newarray %d",newArray.count);
    
    if ([imageArray count]==4)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.ViewImages.frame = ADD_IMAGES_VIEW_FRAME;
        self.ViewBelow.frame = BELOW_VIEW_FRAME;
        self.scrollInputData.contentSize = sizeofscroll;
        
        [UIView commitAnimations];
    }
    else if ([imageArray count]==8)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.ViewImages.frame = CGRectMake(self.ViewImages.frame.origin.x, self.ViewImages.frame.origin.y, self.ViewImages.frame.size.width, self.ViewImages.frame.size.height - 87);
        self.ViewBelow.frame = CGRectMake(self.ViewBelow.frame.origin.x, self.ViewBelow.frame.origin.y - 87, self.ViewBelow.frame.size.width, self.ViewBelow.frame.size.height);
        self.scrollInputData.contentSize = CGSizeMake(self.scrollInputData.contentSize.width, self.scrollInputData.contentSize.height - 40);
        
        [UIView commitAnimations];
    }
    if ([imageArray count]<=10)
    {
        self.btnAddImages.enabled = YES;
        self.btnAddImages.alpha = 1.0f;
    }
    else
    {
        self.btnAddImages.enabled = NO;
        self.btnAddImages.alpha = 0.9f;
    }
}


#pragma mark Data Fetcher

-(void)dataFetchedSuccessfully:(NSDictionary *)responseData forUrl:(NSString *)url
{
    if ([[responseData objectForKey:@"result"] isEqualToString:@"true"])
    {
        int categoryType = 1;
       
        if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.editMode ? EDIT_FOOD_TALK : ADD_FOOD_TALK]])
        {
            categoryType = 1;
        }
        else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.editMode ? EDIT_SHOPPING_TALK : ADD_SHOPPING_TALK]])
        {
            categoryType = 2;
        }
        else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.editMode ? EDIT_EVENT_TALK : ADD_EVENT_TALK]])
        {
            categoryType = 3;
        }
        else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.editMode ? EDIT_NIGHTLIFE_TALK : ADD_NIGHTLIFE_TALK]])
        {
            categoryType = 4;
        }
        else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.editMode ? EDIT_SERVICE_TALK : ADD_SERVICE_TALK]])
        {
            categoryType = 5;
        }
        else if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.editMode ? EDIT_CONCIERGE_TALK : ADD_CONCIERGE_TALK]])
        {
            categoryType = 6;
        }
    
        [self displayNotification:YES];
        
        if (self.delegate && !self.editMode)
        {
            [self.delegate successfullyAddedNewTalkForCategory:categoryType];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.editMode && self.delegate)
        {
            NSArray *controllersArray = self.navigationController.viewControllers;
            
            [self.delegate successfullyEditedTalkForCategory:categoryType];
            
            [self.navigationController popToViewController:[controllersArray objectAtIndex:controllersArray.count - 3] animated:YES];
        }
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"Failed" andMsg:MSG_ADD_TALK_FAILED];
    }
}

- (void) dataFetchedFailureForUrl:(NSString*)url
{
    NSLog(@"Fails request... ");
}



#pragma mark Text Field Validations

-(BOOL)validateStartEndDates:(NSString *)startDateString endDate:(NSString *)endDateString
{
    if (![self.btnCategory.titleLabel.text isEqualToString:@"Events"])
    {
        return YES;
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:ADD_MY_FIND_DATE_FORMATE];
        
        NSDate *startDate = [dateFormatter dateFromString:startDateString];
        NSDate *endDate = [dateFormatter dateFromString:endDateString];

        NSComparisonResult result = [startDate compare:endDate];
        
        if (result == NSOrderedSame || result == NSOrderedAscending)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

-(BOOL)validateString:(NSString *)string withRegXString:(NSString *)regxString
{
    if (string.length == 0)
    {
        return NO;
    }
    
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[cd] %@", regxString];
    
    return [regexPredicate evaluateWithObject:string];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtTitle)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 20) ? NO : YES;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int padding = [self getPaddingForYOffSet];
    
    if (textField == self.txtTitle)
    {
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_TITILE_OFFSET_Y) animated:YES];
    }
    else if (textField == self.txtShrtDescription)
    {
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_SHORT_DESCRIPTION_OFFSET_Y) animated:YES];
    }
    else if (textField == self.txtAddress)
    {
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_ADDRESS_OFFSET_Y + padding) animated:YES];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init] ;
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
        
        NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
        
        [toolbar setItems:itemsArray];
        
        [textField setInputAccessoryView:toolbar];
    }
    else if (textField == self.txtPhone)
    {
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_PHONE_OFFSET_Y + padding) animated:YES];
    }
    else if (textField == self.txtStaartDate || textField == self.txtEndingDate)
    {
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_FROM_DATE_OFFSET_Y + padding) animated:YES];
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == self.txtLongDescription)
    {
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_LOGN_DESCRIPTION_OFFSET_Y) animated:YES];
    }
    else if (textView == self.txtWebSiteAddress)
    {
        int padding = [self getPaddingForYOffSet];
        
        [self.scrollInputData setContentOffset:CGPointMake(0, TXT_WEBSITE_OFFSET_Y + padding) animated:YES];
    }
    
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboardTextView)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [textView setInputAccessoryView:toolbar];
    
    return YES;
}

-(void)resignKeyboard
{
    [self.txtAddress resignFirstResponder];
    
    if (self.txtAddress.text.length > 0)
    {
        addressSuggestions  = [[GoogleAddressAPI alloc] init];
        
        addressSuggestions.delegate = self;
        
        [addressSuggestions getGoogleAddressSuggestion:self.txtAddress.text];
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"MapDrop"];
        
        [[ProcessingView instance] forceShowTintView];
    }
}

-(void)resignKeyboardTextView
{
    [self.txtLongDescription resignFirstResponder];
    [self.txtWebSiteAddress resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtAddress)
    {
        [self resignKeyboard];
    }
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark HUD

-(BDKNotifyHUD *)notifySuccess
{
    if (_notifySuccess != nil) return _notifySuccess;
    _notifySuccess = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
    _notifySuccess.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notifySuccess;
}

- (BDKNotifyHUD *)notifyFail
{
    if (_notifyFail != nil) return _notifyFail;
    _notifyFail = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:HUD_IMAGE] text:@""];
    _notifyFail.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notifyFail;
}

- (void)displayNotification : (BOOL)isSuccessfull
{
    if (isSuccessfull)
    {
        if (self.notifySuccess.isAnimating) return;
        
        [self.view addSubview:self.notifySuccess];
        [self.notifySuccess removeFromSuperview];
    }
    else
    {
        if (self.notifyFail.isAnimating) return;
        
        [self.view addSubview:self.notifyFail];
        [self.notifyFail removeFromSuperview];
    }
    
}


#pragma mark- GoogleAddressSuggestion Delegate Methods

-(void)didFindAddress:(NSArray *)addressArray
{
    [[ProcessingView instance] forceHideTintView];
    
    googleAddressSuggestions = [[NSArray alloc] initWithArray:addressArray];
    
    if (googleAddressSuggestions.count > 0)
    {
        [self showActionView];
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
        self.txtAddress.text = @"";
    }
    
}

-(void)failToFindAddress
{
    [[ProcessingView instance] forceHideTintView];
    [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
}
#pragma mark -
#pragma mark return
#pragma mark -
-(void)userSelectNewAddress:(NSString *)address
{
    [self.txtAddress setText:address];
}
-(void)userSelectNewAddress:(NSString *)address WithLat:(NSString *)userLatitude longitude:(NSString *)userLongitude
{
    [self.txtAddress setText:address];
}
#pragma mark- UIPickerView Delegate Methods

-(void)showActionView
{
    if (googleAddressSuggestions.count > 0)
    {
        GoogleAddressAPIResultViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoogleAddressAPIResultViewController"];
        
        controller.delegate = self;
        controller.googleAddressSuggestions = googleAddressSuggestions;
        
        [self.navigationController presentViewController:controller animated:NO completion:^(){}];
    }
    else
    {
        [Utiltiy showAlertWithTitle:@"" andMsg:MSG_FAILED];
    }
}

#pragma mark- Location Manager Delegates and Methods


-(void)getAddressFromCoordinates:(CLLocation *)aLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSMutableString * result = [[NSMutableString alloc] init];
    
    [geocoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         [[ProcessingView instance] forceHideTintView];
         
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if (placemarks.count == 1)
                            {
                                CLPlacemark *place = [placemarks objectAtIndex:0];
                                
                                NSArray *FormattedAddressLines = [place.addressDictionary objectForKey:@"FormattedAddressLines"];
                                
                                for (NSObject * obj in FormattedAddressLines)
                                {
                                    [result appendString:[NSString stringWithFormat:@" %@",[obj description]]];
                                }
                                self.txtAddress.text = result;
                            }
                            else
                            {
                                [result appendString:@"Not found"];
                                self.txtAddress.text = result;
                            }
                        });
     }];
}



- (void)tapAction:(UITapGestureRecognizer*)sender
{
    [self.scrollInputData endEditing:YES];
}

-(int)getPaddingForYOffSet
{
    int padding = 0;
    
    if (imageArray.count >= 8)
    {
        padding = 128;
    }
    else if (imageArray.count >= 4)
    {
        padding = 64;
    }
    return padding;
}


#pragma mark - Edit My Find Methods

-(void)applyEditTalk
{
    TalksDetailAPIManager *apiManager = [[TalksDetailAPIManager alloc] init];
    
    apiManager.delegate = self;
    
    [apiManager callTalksDetailAPIForID:self.talkID];
    
    [[ProcessingView instance] showTintViewWithUserInteractionEnabled];
}

-(void)disableNonChangeableFieldsForEditMode
{
    [self.btnCategory setEnabled:NO];
}

-(void)setCategoryTitle:(int)category
{
    NSString *categoryTitle = @"Food";
    
    if (category == 1)
    {
        categoryTitle = @"Food";
    }
    else if (category == 2)
    {
        categoryTitle = @"Shopping";
    }
    else if (category == 3)
    {
        categoryTitle = @"Events";
        [self hideEventDates:NO];
    }
    else if (category == 5)
    {
        categoryTitle = @"Services";
    }
    else if (category == 4)
    {
        categoryTitle = @"Night life";
    }
    else if (category == 6)
    {
        categoryTitle = @"Concierge";
    }
    
    [self.btnCategory setTitle:categoryTitle forState:UIControlStateNormal];
}

-(void)showImagesInView:(NSArray *)imagesArray
{
    if (imagesArray.count < 1)
    {
        return;
    }
    
    for (ImagesURLModel *imageURLModel in imagesArray)
    {
        [self AddImages:[imageURLModel.thumbnailImageURL isEqualToString:@""] ? imageURLModel.smallImageURL : imageURLModel.thumbnailImageURL];
    }
}

-(void)populateFieldsFromDetailModel
{
    [self setCategoryTitle:self.categoryIndex];
    
    self.txtAddress.text = self.detailModel.address;
    self.txtLongDescription.text = self.detailModel.description;
    self.txtShrtDescription.text = self.detailModel.info;
    self.txtTitle.text = self.detailModel.title;
    self.txtPhone.text = self.detailModel.pnumber;
     [self.btnPrice setTitle:[self.detailModel.price intValue] == 4 ? @"$$$$" : [self.detailModel.price intValue] == 3 ? @"$$$" : [self.detailModel.price intValue] == 2 ? @"$$" : [self.detailModel.price intValue] == 1 ? @"$" : @"$" forState:UIControlStateNormal];

    self.txtWebSiteAddress.text = self.detailModel.webLink;
    
    self.txtEndingDate.text = [self.detailModel.endDate isEqualToString:@""] ? @"" : [CommonFunctions getDateStringInFormat:ADD_MY_FIND_DATE_FORMATE date:[CommonFunctions getDateFromUnixTimeStamp:self.detailModel.endDate]];
    self.txtStaartDate.text = [self.detailModel.startDate isEqualToString:@""] ? @"" : [CommonFunctions getDateStringInFormat:ADD_MY_FIND_DATE_FORMATE date:[CommonFunctions getDateFromUnixTimeStamp:self.detailModel.startDate]];
    
    [self showImagesInView:self.detailModel.imagesArray];
    
    [self disableNonChangeableFieldsForEditMode];
}

-(void)successfullyReceivedServerResponse:(TalksDetailModel *)model
{
    [[ProcessingView instance] hideTintView];
    
    self.detailModel = [[TalksDetailModel alloc] init];
    
    self.detailModel = model;
    
    [self populateFieldsFromDetailModel];
}

-(void)failToReceivedServerResponse:(NSString *)errorMessage
{
    [[ProcessingView instance] hideTintView];
    
    NSLog(@"Error is : %@", errorMessage);
    
    [Utiltiy showAlertWithTitle:@"" andMsg:errorMessage];
}


#pragma Internet Connectivity Error Handling

-(void)internetNotAvailable:(NSString *)errorMessage
{
    [Utiltiy showInternetConnectionErrorAlert:errorMessage];
}


@end


