//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Mal Curtis on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RangeSlider.h"

@interface RangeSlider (PrivateMethods)
-(float)xForValue:(float)value;
-(float)valueForX:(float)x;
-(void)updateTrackHighlight;
@end

@implementation RangeSlider

@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minThumbOn = false;
        _maxThumbOn = false;
        _padding = 20;
        
        _trackBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pricebar.png"]];
        _trackBackground.center = self.center;
        [self addSubview:_trackBackground];
        
        _track = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pricebar_on.png"]];
        _track.center = self.center;
        [self addSubview:_track];
        
        _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pricebar_slider.png"] highlightedImage:[UIImage imageNamed:@"pricebar_slider.png"]];
        _minThumb.frame = CGRectMake(0,0, self.frame.size.height + 5,self.frame.size.height + 5);
        _minThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_minThumb];
        
        _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pricebar_slider.png"] highlightedImage:[UIImage imageNamed:@"pricebar_slider.png"]];
        _maxThumb.frame = CGRectMake(0,0, self.frame.size.height + 5,self.frame.size.height + 5);
        _maxThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_maxThumb];
    }
    
    return self;
}

-(void)changeSliderValuesTo:(CGFloat)xAxis
{
    _minThumb.center = CGPointMake(xAxis, _minThumb.center.y);
    selectedMinimumValue = [self valueForX:_minThumb.center.x] - self.minimumRange/2;
    _maxThumb.center = CGPointMake(xAxis, _maxThumb.center.y);
    selectedMaximumValue = [self valueForX:_maxThumb.center.x] + self.minimumRange/2;
    
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if (!(location.x < self.frame.origin.x || location.x > self.frame.size.width))
    {
        
        if (location.x < _minThumb.center.x)
        {
            _minThumb.center = CGPointMake(location.x, _minThumb.center.y);
            selectedMinimumValue = [self valueForX:_minThumb.center.x];
        }
        
        else if (location.x > _maxThumb.center.x)
        {
            _maxThumb.center = CGPointMake(location.x, _maxThumb.center.y);
            selectedMaximumValue = [self valueForX:_maxThumb.center.x];
        }
        else
        {
            _minThumb.center = CGPointMake(location.x, _minThumb.center.y);
            selectedMinimumValue = [self valueForX:_minThumb.center.x];
            _maxThumb.center = CGPointMake(location.x, _maxThumb.center.y);
            selectedMaximumValue = [self valueForX:_maxThumb.center.x];
        }
        
        
        [self updateTrackHighlight];
        [self setNeedsLayout];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-(void)layoutSubviews
{
    // Set the initial state
    _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], self.center.y);
    
    _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], self.center.y);
    
//    UITapGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
//    [self addGestureRecognizer:tabGesture];
    
    [self updateTrackHighlight];
    
    
}

-(float)xForValue:(float)value{
    return (self.frame.size.width-(_padding*2))*((value - minimumValue) / (maximumValue - minimumValue))+_padding;
}

-(float) valueForX:(float)x{
    return minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) * (maximumValue - minimumValue);
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if(_minThumbOn){
        _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x - distanceFromCenter, [self xForValue:selectedMaximumValue - minimumRange])), _minThumb.center.y);
        selectedMinimumValue = [self valueForX:_minThumb.center.x];
        
    }
    if(_maxThumbOn){
        _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x - distanceFromCenter, [self xForValue:selectedMinimumValue + minimumRange])), _maxThumb.center.y);
        selectedMaximumValue = [self valueForX:_maxThumb.center.x];
    }
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = true;
        distanceFromCenter = touchPoint.x - _minThumb.center.x;
    }
    else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = true;
        distanceFromCenter = touchPoint.x - _maxThumb.center.x;
        
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _minThumbOn = false;
    _maxThumbOn = false;
}

-(void)updateTrackHighlight{
	_track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

@end
