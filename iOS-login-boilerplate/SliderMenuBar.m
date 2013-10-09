//
//  SliderMenuBar.m
//  SliderMenu
//
//  Created by michael whitehead on 10/3/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SliderMenuBar.h"
#import "SliderViewController.h"

@implementation SliderMenuBar

@synthesize sliderMenuItems;
@synthesize active;


- (id)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:viewControllers.count];
        int count = viewControllers.count;
        active = 0;
        [[[viewControllers objectAtIndex:0] sliderMenuItem] setSelected:YES];
        for (int i = 0; i < count; i++) {
            SliderViewController *vc = [viewControllers objectAtIndex:i];
            if (vc.sliderMenuItem) {
                CGRect itemFrame = [self getItemFrame:frame itemCount:viewControllers.count itemIndex:i];
                [self appendSliderItemToArray:vc items:items frame:itemFrame itemIndex:i];
            }else {
                [items addObject:[[SliderMenuItem alloc] initWithImage:nil title:nil color:nil]];
            }
        }
        sliderMenuItems = [items copy];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = YES;
        
    }
    return self;
}

- (void)appendSliderItemToArray:(SliderViewController *)vc items:(NSMutableArray *)items frame:(CGRect)frame itemIndex:(int)itemIndex {
    [items addObject:vc.sliderMenuItem];
    [[items objectAtIndex:itemIndex] setDelegate:self.superview];
    [[items objectAtIndex:itemIndex] setFrame:frame];
    [[items objectAtIndex:itemIndex] setTag:itemIndex+1];
    [self addSubview:[items objectAtIndex:itemIndex]];
}

- (CGRect)getItemFrame:(CGRect)frame itemCount:(int)itemCount itemIndex:(int)itemIndex {
    //Don't divide by 0
    float split = (itemCount -1 == 0) ? 1 : itemCount - 1 ;
    
    float x;
    float w;
    float h = frame.size.height;
    //Make sure if it is only one view that the width is 100% not 150%
    float activeSize = (itemCount == 1) ? frame.size.width : frame.size.width / itemCount * 1.5;
    float inactiveSize = (frame.size.width - activeSize) / split;

    if (itemIndex == active) {
        w = activeSize;
        x = itemIndex * inactiveSize;
    }else {
        w = inactiveSize;
        if (itemIndex < active) {
            x = itemIndex * inactiveSize;
        }else {
            x = activeSize + (itemIndex - 1) * inactiveSize;
        }
    }
    return CGRectMake(x, 0, w, h);
}

@end
