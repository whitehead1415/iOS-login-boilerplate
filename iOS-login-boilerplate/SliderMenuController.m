//
//  SliderMenuController.m
//  SliderMenu
//
//  Created by michael whitehead on 10/6/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SliderMenuController.h"
#import "SliderViewController.h"

@interface SliderMenuController ()

@end

@implementation SliderMenuController

@synthesize sliderViewControllers = _sliderViewControllers;
@synthesize menuBar = _menuBar;

- (id)initWithSliderViewControllers:(NSArray *)sliderViewControllers {
    self = [super init];
    if (self) {
        _sliderViewControllers = sliderViewControllers;
        _menuBar = [[SliderMenuBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 80) viewControllers:_sliderViewControllers];
        [self.view addSubview:_menuBar];
        //[self.view addSubview:[[sliderViewControllers objectAtIndex:0] view]];
        SliderViewController *newContent = [_sliderViewControllers objectAtIndex:0];
        
        [self addChildViewController:newContent];
        newContent.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
        [self.view addSubview:newContent.view];
        [newContent didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sliderMenuItemWasTouched:(SliderMenuItem *)sender {
    SliderViewController *oldContent = [_sliderViewControllers objectAtIndex:_menuBar.active];
    [oldContent willMoveToParentViewController:nil];
    [oldContent.view removeFromSuperview];
    [oldContent removeFromParentViewController];
    
    SliderViewController *newContent = [_sliderViewControllers objectAtIndex:[sender tag] -1];
    [self addChildViewController:newContent];
    newContent.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
    [self.view addSubview:newContent.view];
    [newContent didMoveToParentViewController:self];
    
    
    SliderMenuItem *activeItem = [_menuBar.sliderMenuItems objectAtIndex:_menuBar.active];
    if (activeItem.tag == sender.tag) {
        return;
    }
    [[_menuBar.sliderMenuItems objectAtIndex:_menuBar.active] setSelected:NO];
    [[_menuBar.sliderMenuItems objectAtIndex:sender.tag-1] setSelected:YES];

    _menuBar.active = sender.tag-1;
    
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {[self sizeSliderItems];}
                     completion: nil];
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self sizeSliderItems];
}

- (void)sizeSliderItems {
    int count = _menuBar.sliderMenuItems.count;
    for (int i = 0; i < count; i++) {
        CGRect frame = [_menuBar getItemFrame:_menuBar.frame itemCount:count itemIndex:i];
        [[_menuBar.sliderMenuItems objectAtIndex:i] setFrame: frame];
    }
};


@end
