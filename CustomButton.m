//
//  CustomButton.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/23/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _hue = 0.5;
        _saturation = 0.5;
        _brightness = 0.5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * color = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, self.bounds);
}

-(void) setHue:(CGFloat)hue
{
    _hue = hue;
    [self setNeedsDisplay];
}

-(void) setSaturation:(CGFloat)saturation
{
    _saturation = saturation;
    [self setNeedsDisplay];
}

-(void) setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setNeedsDisplay];
}

@end