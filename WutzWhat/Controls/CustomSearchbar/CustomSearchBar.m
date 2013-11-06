#import "CustomSearchBar.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomSearchBar
@synthesize delegate;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delegate = self;
        
        [self setBackgroundImage:[[UIImage imageNamed:@"black_1px.png"] stretchableImageWithLeftCapWidth:320.0 topCapHeight:1.0]];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
//        [[UITextField appearanceWhenContainedIn:[self class], nil] setSize:CGSizeMake(265, 30)];
        [[UITextField appearanceWhenContainedIn:[self class], nil] setBackgroundColor:[UIColor clearColor]];
        [[UITextField appearanceWhenContainedIn:[self class], nil] setBackground:[UIImage imageNamed:@"input_box.png"]];
        [[UITextField appearanceWhenContainedIn:[self class], nil] setBorderStyle:UITextBorderStyleNone];
        [[UITextField appearanceWhenContainedIn:[self class], nil] setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    }
    return self;
} 

-(void)drawRect:(CGRect)rect
{    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.autoresizesSubviews = YES;
    
    for (UIView *txt in self.subviews)
    {
        if ([txt isKindOfClass:[UITextField class]])
        {
            UITextField *txtSearch = (UITextField *)txt;
            [txtSearch addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        }
    }
    
    customBackButtom = [[UIButton alloc] initWithFrame:CGRectMake(245, 2, 75, 40)];
    
    [customBackButtom addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [customBackButtom setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
    [customBackButtom setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"searchbarBackgroundImage.png"]]];
    [self addSubview:customBackButtom];
    
    [self addShadow];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [textField setInputAccessoryView:toolbar];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate searchBarSearchButtonClicked:self];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.text = @"";
    
    return [self textFieldShouldReturn:nil];
}

-(void)cancelAction
{
    [self.delegate searchBarCancelButtonClicked:self];
}

-(void)textChanged
{
    [self.delegate searchBar:self textDidChange:self.text];
}

-(void)dealloc
{
}

-(void)resignKeyboard
{
    for (UIView *txt in self.subviews)
    {
        if ([txt isKindOfClass:[UITextField class]])
        {
            UITextField *txtSearch = (UITextField *)txt;
            [txtSearch resignFirstResponder];
        }
    }
}

-(void)addShadow
{
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.layer.shadowRadius = 1.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}


@end