//
//  OptionController.h
//  OptionColtroller
//
//  Created by zm on 15/7/1.
//  Copyright (c) 2015年 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionControl : UIControl

- (id)initWithItem:(NSArray *)items;

- (void)insertOptionWithTitle:(NSString *)title atIndex:(NSUInteger)option animated:(BOOL)animated; // insert before option number. 0..#option. value pinned
- (void)insertSegmentWithImage:(UIImage *)image  atIndex:(NSUInteger)option animated:(BOOL)animated;
- (void)removeSegmentAtIndex:(NSUInteger)option animated:(BOOL)animated;
- (void)removeAllSegments;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)option;      // can only have image or title, not both. must be 0..#segments - 1 (or ignored). default is nil
- (NSString *)titleForSegmentAtIndex:(NSUInteger)option;

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)option;       // can only have image or title, not both. must be 0..#segments - 1 (or ignored). default is nil
- (UIImage *)imageForSegmentAtIndex:(NSUInteger)option;

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)option;         // set to 0.0 width to autosize. default is 0.0
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)option;

@end
