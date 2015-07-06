//
//  OptionControl.m
//  OptionColtroller
//
//  Created by zm on 15/7/2.
//  Copyright (c) 2015年 zm. All rights reserved.
//

#import "OptionControl.h"

#import "zmDefine.h"

#define SELECT_LINE_HEIGHT 5.f
#define MOVE_ANIMATION_DURATION 0.2f

@interface OptionControl ()

@property (nonatomic, strong) UIView *selectLine;

@property (nonatomic, strong) NSMutableArray *arrItemsChangedWidth;//改变宽度的记录

@property (nonatomic, assign) CGFloat normalWidth;//正常宽度

@property (nonatomic, strong) UIImageView *imgViewBottomSeparator;

@property (nonatomic, assign, getter=isShowBottomSeparator) BOOL showBottomSeparator;

@end

@implementation OptionControl

- (id)initWithItems:(NSArray *)items
 andSelectLineColor:(UIColor *)color
andselectLineHeight:(CGFloat)height
andIsShowBottomSeparator:(BOOL)showBottomSeparator
{
    self = [self initWithItems:items];
    if (self) {
        self.selectLineColor = color;
        self.selectLineHeight = height;
        
        self.showBottomSeparator = showBottomSeparator;
        
        if (self.isShowBottomSeparator) {
            self.imgViewBottomSeparator.hidden = NO;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.showBottomSeparator = NO;
    
    self.clipsToBounds = NO;
    
    [self setDividerImage:[zmTools imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1.f, 1.f)]
      forLeftSegmentState:UIControlStateNormal
        rightSegmentState:UIControlStateNormal
               barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:[zmTools imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1.f, 1.f)]
                    forState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
    
    self.imgViewBottomSeparator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.imgViewBottomSeparator.hidden = YES;
    [self addSubview:self.imgViewBottomSeparator];
    
    [self addTarget:self action:@selector(changeSelectIndex:) forControlEvents:UIControlEventValueChanged];
    
    self.selectLineColor = [UIColor redColor];
    self.selectLineHeight = SELECT_LINE_HEIGHT;
}

#pragma mark - UIControlEventValueChanged
- (void)changeSelectIndex:(UISegmentedControl *)segmentedControl
{
    self.selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
}

#pragma mark - override

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment
{
    [super setWidth:width forSegmentAtIndex:segment];
    
    [self addToItemsChangedWidth:width andIndex:segment];
    
    [self refresh];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithTitle:title atIndex:segment animated:animated];
    
    [self refresh];
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithImage:image atIndex:segment animated:animated];
    
    [self refresh];
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super removeSegmentAtIndex:segment animated:animated];
    
    [self removeFromItemsChangedWidthAtIndex:segment];
    
    [self refresh];
}

#pragma mark - setter

- (void)setSelectLineHeight:(CGFloat)selectLineHeight
{
    _selectLineHeight = selectLineHeight;
    
    self.selectLine.frame = CGRectMake(CGRectGetMinX(self.selectLine.frame), CGRectGetHeight(self.frame) - selectLineHeight, CGRectGetWidth(self.selectLine.frame), selectLineHeight);
}

- (void)setSelectLineColor:(UIColor *)selectLineColor
{
    _selectLineColor = selectLineColor;
    
    self.selectLine.backgroundColor = selectLineColor;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.numberOfSegments != 0) {
        CGFloat width = CGRectGetWidth(frame) / (CGFloat)self.numberOfSegments;
        if (self.selectLine != nil) {
            self.selectLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - self.selectLineHeight, width, self.selectLineHeight);
        }
        else{
            self.selectLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - self.selectLineHeight, width, self.selectLineHeight)];
            self.selectLine.backgroundColor = self.selectLineColor;
            [self addSubview:self.selectLine];
            
        }
        
        [self refresh];
    }
    
    self.imgViewBottomSeparator.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.imgViewBottomSeparator.frame));
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    [super setSelectedSegmentIndex:selectedSegmentIndex];
    
    [self moveSelectLineToIndex:selectedSegmentIndex andAnimation:YES];
}

#pragma mark - getter

- (CGFloat)normalWidth
{
    CGFloat changedWidth = 0.f;//改变的宽度和
    
    for (NSDictionary *dic in self.arrItemsChangedWidth) {
        changedWidth += [[dic objectForKey:@"width"] floatValue];
    }
    
    if (self.numberOfSegments != 0) {
        _normalWidth = ceilf((CGRectGetWidth(self.frame) - changedWidth) / (self.numberOfSegments - self.arrItemsChangedWidth.count));// 平均宽度
    }
    else{
        _normalWidth = 0.f;
    }
    return _normalWidth;
}

#pragma mark - other
- (void)moveSelectLineToIndex:(NSInteger)index andAnimation:(BOOL)animation
{
    CGFloat moveTox = 0.f;
    
    if (self.arrItemsChangedWidth == nil) {//没有改过 宽度
        moveTox = index * CGRectGetWidth(self.selectLine.frame);
    }
    else{
        for (NSInteger i = 0; i < index; i++) {
            moveTox += [self getItemWidthAtIndex:i];
        }
    }
    
    if (animation) {
        [UIView animateWithDuration:MOVE_ANIMATION_DURATION
                         animations:^{
                             CGRect selectLineFrame = self.selectLine.frame;
                             selectLineFrame.origin.x = moveTox;
                             selectLineFrame.size.width = [self getItemWidthAtIndex:index];
                             self.selectLine.frame = selectLineFrame;
                             //                             zmLog_Frame(selectLineFrame);
                         }];
    }
    else{
        CGRect selectLineFrame = self.selectLine.frame;
        selectLineFrame.origin.x = moveTox;
        selectLineFrame.size.width = [self getItemWidthAtIndex:index];
        self.selectLine.frame = selectLineFrame;
    }
}

- (CGFloat)getItemWidthAtIndex:(NSInteger)index
{
    CGFloat itemWidth = self.numberOfSegments == 0 ? self.numberOfSegments : self.normalWidth;
    
    if (index >= 0) {
        CGFloat tempItemWidth = [self widthForSegmentAtIndex:index];
        
        itemWidth = tempItemWidth == 0 ? itemWidth : tempItemWidth;
    }
    return itemWidth;
}

- (void)addToItemsChangedWidth:(CGFloat)width andIndex:(NSInteger)segment
{
    if (self.arrItemsChangedWidth == nil) {
        self.arrItemsChangedWidth = [[NSMutableArray alloc] init];
    }
    
    [self removeFromItemsChangedWidthAtIndex:segment];
    
    NSDictionary *dic = @{
                          @"index" : [NSNumber numberWithInteger:segment],
                          @"width" : [NSNumber numberWithFloat:width]
                          };
    
    [self.arrItemsChangedWidth addObject:dic];
}

- (void)removeFromItemsChangedWidthAtIndex:(NSInteger)segment
{
    if (self.arrItemsChangedWidth != nil) {
        for (NSDictionary *dic in self.arrItemsChangedWidth) {
            if ([[dic objectForKey:@"index"] integerValue] == segment) {
                [self.arrItemsChangedWidth removeObject:dic];
            }
        }
    }
}

- (void)refresh
{
    self.selectedSegmentIndex = self.selectedSegmentIndex >= 0 ? self.selectedSegmentIndex : 0;
}
@end
