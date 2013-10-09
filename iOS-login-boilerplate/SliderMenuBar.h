//
//  SliderMenuBar.h
//  SliderMenu
//
//  Created by michael whitehead on 10/3/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderMenuItem.h"

@interface SliderMenuBar : UIView

@property NSArray *sliderMenuItems;
@property int active;

- (id)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers;
- (CGRect)getItemFrame:(CGRect)frame itemCount:(int)itemCount itemIndex:(int)itemIndex;

@end
