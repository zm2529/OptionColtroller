//
//  OptionController.m
//  OptionColtroller
//
//  Created by zm on 15/7/1.
//  Copyright (c) 2015年 zm. All rights reserved.
//

#import "OptionControl.h"

#import "zmDefine.h"

#define ZM_TAG 1000
#define SELECT_LINE_HEIGHT 5.f
#define MOVE_ANIMATION_DURATION 0.2f

@interface OptionControl ()

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UIView *selectLine;

@property (nonatomic, strong) NSMutableArray *arrItemsButton;

@end

@implementation OptionControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithItem:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.f)];
    if (self) {
        self.items = items;
        [self setupWithItem:items];
    }
    return self;
}

- (void)setupWithItem:(NSArray *)items
{
    NSInteger itemsCount = items.count;
    CGFloat itemWidth = CGRectGetWidth(self.frame) / itemsCount;
    
    for (NSInteger i = 0; i < itemsCount; i++) {
        
        NSString *strTitle = items[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, CGRectGetHeight(self.frame))];
        button.tag = ZM_TAG + i;
        [button setTitle:strTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonActionUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self.arrItemsButton addObject:button];
    }
    
    self.selectLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - SELECT_LINE_HEIGHT, itemWidth, SELECT_LINE_HEIGHT)];
    self.selectLine.backgroundColor = [UIColor redColor];
    [self addSubview:self.selectLine];
}


- (void)fitAllViewFrame
{
    NSInteger itemsCount = self.items.count;
    CGFloat itemWidth = CGRectGetWidth(self.frame) / itemsCount;
    
    for (NSInteger i = 0; i < itemsCount; i++) {
        UIButton *button = self.arrItemsButton[i];
        button.frame = CGRectMake(i * itemWidth, 0, itemWidth, CGRectGetHeight(self.frame));
    }
    
    self.selectLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - SELECT_LINE_HEIGHT, itemWidth, SELECT_LINE_HEIGHT);

}

- (void)buttonActionUp:(UIButton *)button
{
    [self moveSelectLintToButtonBottom:button andAnimation:YES];
}

- (void)moveSelectLintToButtonBottom:(UIButton *)button andAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:MOVE_ANIMATION_DURATION
                         animations:^{
                             CGRect selectLineFrame = self.selectLine.frame;
                             selectLineFrame.origin.x = CGRectGetMinX(button.frame);
                             self.selectLine.frame = selectLineFrame;
                         }];
    }
    else{
        CGRect selectLineFrame = self.selectLine.frame;
        selectLineFrame.origin.x = CGRectGetMinX(button.frame);
        self.selectLine.frame = selectLineFrame;
    }
}

- (void)moveSelectLineToIndex:(NSInteger)index andAnimation:(BOOL)animation
{
    if (self.arrItemsButton.count < index) {
        UIButton *button = self.arrItemsButton[index];
        
        [self moveSelectLintToButtonBottom:button andAnimation:animation];
    }
}

@end
