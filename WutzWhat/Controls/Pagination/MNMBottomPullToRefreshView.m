/*
 * Copyright (c) 2012 Mario Negro Martín
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */

#import "MNMBottomPullToRefreshView.h"

/*
 * Defines the localized strings table
 */
#define MNM_BOTTOM_PTR_LOCALIZED_STRINGS_TABLE                          @"MNMBottomPullToRefresh"

/*
 * Texts to show in different states
 */
#define MNM_BOTTOM_PTR_PULL_TEXT_KEY @"Pull to get more..."
#define MNM_BOTTOM_PTR_RELEASE_TEXT_KEY  @"Release now!"
#define MNM_BOTTOM_PTR_LOADING_TEXT_KEY @"Loading"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]


@interface MNMBottomPullToRefreshView()

/*
 * View that contains all controls
 */
@property (nonatomic, readwrite, strong) UIView *containerView;


/*
 * Activiry indicator to show while loading
 */
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *loadingActivityIndicator;

/*
 * Label to set state message
 */
@property (nonatomic, readwrite, strong) UILabel *messageLabel;

/*
 * Current state of the control
 */
@property (nonatomic, readwrite, assign) MNMBottomPullToRefreshViewState state;

/*
 * YES to apply rotation to the icon while view is in MNMBottomPullToRefreshViewStatePull state
 */
@property (nonatomic, readwrite, assign) BOOL rotateIconWhileBecomingVisible;

@end

@implementation MNMBottomPullToRefreshView

@synthesize containerView = containerView_;
@synthesize loadingActivityIndicator = loadingActivityIndicator_;
@synthesize messageLabel = messageLabel_;
@synthesize state = state_;
@synthesize rotateIconWhileBecomingVisible = rotateIconWhileBecomingVisible_;
@dynamic isLoading;
@synthesize fixedHeight = fixedHeight_;

#pragma mark -
#pragma mark Initialization

/*
 * Initializes and returns a newly allocated view object with the specified frame rectangle.
 *
 * @param aRect: The frame rectangle for the view, measured in points.
 * @return An initialized view object or nil if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
            
        self.frame=CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame));
       
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor]CGColor], (id)[[UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f] CGColor], nil];
//        [self.layer insertSublayer:gradient atIndex:0];
        
                
        loadingActivityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingActivityIndicator_ setFrame:CGRectMake(145.0f, frame.size.height - 38.0f, 20.0f, 20.0f)];
        [loadingActivityIndicator_ setHidesWhenStopped:YES];
        [loadingActivityIndicator_ setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        
        [self addSubview:loadingActivityIndicator_];
               
        messageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        messageLabel_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		messageLabel_.font = [UIFont boldSystemFontOfSize:13.0f];
		messageLabel_.textColor = TEXT_COLOR;
		messageLabel_.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		messageLabel_.shadowOffset = CGSizeMake(0.0f, 1.0f);
		messageLabel_.backgroundColor = [UIColor clearColor];
		messageLabel_.textAlignment = NSTextAlignmentCenter;
                
        
        fixedHeight_ = CGRectGetHeight(frame);
        rotateIconWhileBecomingVisible_ = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        [self changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
    }
    
    return self;
}

#pragma mark -
#pragma mark Visuals

/*
 * Lays out subviews.
 */
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    CGSize messageSize = [[messageLabel_ text] sizeWithFont:[messageLabel_ font]];
    
    CGRect frame = [messageLabel_ frame];
    frame.size.width = messageSize.width;
    [messageLabel_ setFrame:frame];
    
    frame = [self frame];
    frame.size.width = CGRectGetMaxX([messageLabel_ frame]);
    [self setFrame:frame];
}

/*
 * Changes the state of the control depending on state_ value
 */
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state offset:(CGFloat)offset {
    
    state_ = state;
    
    CGFloat height = fixedHeight_;
    
    switch (state_) {
        
        case MNMBottomPullToRefreshViewStateIdle: {
            [loadingActivityIndicator_ stopAnimating];
            
            [messageLabel_ setText:MNM_BOTTOM_PTR_PULL_TEXT_KEY];
            
            break;
            
        }
        case MNMBottomPullToRefreshViewStatePull: {
            [loadingActivityIndicator_ startAnimating];
            [messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            height = fixedHeight_ + fabs(offset);
            
            break;
            
        } case MNMBottomPullToRefreshViewStateRelease: {
            [loadingActivityIndicator_ startAnimating];
            [messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            height = fixedHeight_ + fabs(offset);
            
            break;
            
        }
        case MNMBottomPullToRefreshViewStateLoading: {
            
            [loadingActivityIndicator_ startAnimating];
            
            [messageLabel_ setText:MNM_BOTTOM_PTR_LOADING_TEXT_KEY];
            
            height = fixedHeight_ + fabs(offset);
            
            break;
            
        } default:
            break;
    }
    
    CGRect frame = [self frame];
    frame.size.height = height;
    [self setFrame:frame];
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Properties

/*
 * Returns state of activity indicator
 */
- (BOOL)isLoading {
    
    return [loadingActivityIndicator_ isAnimating];
}

@end
