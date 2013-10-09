//
//  SliderMenuItem.h
//  SliderMenu
//
//  Created by michael whitehead on 10/3/13.
//  Copyright (c) 2013 michael whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderMenuItem : UIButton

@property (nonatomic, retain) id delegate;
@property UIImage *image;
@property NSString *title;

- (id)initWithImage:(UIImage *)image title:(NSString *)title color:(UIColor *)color;

@end
