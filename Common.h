//
//  Common.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/23/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
CGRect rectFor1PxStroke(CGRect rect);
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
static inline double radians (double degrees) { return degrees * M_PI/180; }
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);
