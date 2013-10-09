//
//  SliderMenuController.h
//  SliderMenu
//
//  Created by michael whitehead on 10/6/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderMenuBar.h"
#import "SliderMenuItemDelegate.h"

@interface SliderMenuController : UIViewController <SliderMenuItemDelegate>

@property NSArray *sliderViewControllers;
@property SliderMenuBar *menuBar;

- (id)initWithSliderViewControllers:(NSArray *)sliderViewControllers;

- (void)sliderMenuItemWasTouched:(id)sender;

@end
