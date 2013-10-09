//
//  SliderMenuItem.m
//  SliderMenu
//
//  Created by michael whitehead on 10/3/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import "SliderMenuItem.h"
#import "SliderMenuItemDelegate.h"
#import "UIImage+ColorImage.h"

@implementation SliderMenuItem

@synthesize delegate;
@synthesize image = _image;
@synthesize title = _title;

- (id)initWithImage:(UIImage *)image title:(NSString *)title color:(UIColor *)color {

    self = [super init];
    if (self) {
        _image = image;
        _title = title;
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
        if (_image) {
            [self setTitle:title forState:UIControlStateSelected];
            [self setTitle:@"" forState:UIControlStateNormal];
        }
        [self setBackgroundColor:color];
        [self addTarget:delegate action:@selector(sliderMenuItemWasTouched:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.alpha = 1.0f;
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [super setSelected:YES];
        self.imageView.alpha = 0.0f;
    }else{
        if (_image) {
            self.titleLabel.alpha = 0.0f;
        }else {
            self.titleLabel.alpha = 1.0f;
        }
        [self setBackgroundImage:_image forState:UIControlStateNormal];
        [super setSelected:NO];
    }
}

@end
