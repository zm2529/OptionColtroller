//
//  OptionControl.h
//  OptionColtroller
//
//  Created by zm on 15/7/2.
//  Copyright (c) 2015年 zm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionControl : UISegmentedControl

@property (nonatomic, strong) UIColor *selectLineColor;

@property (nonatomic, assign) CGFloat selectLineHeight;

/**
 *  @author zm, 15-07-06 14:07:05
 *
 *  init
 *
 *  @param items               选项 数组
 *  @param color               选中标示线 颜色
 *  @param height              选中标示线 高度
 *  @param showBottomSeparator 是否显示最下面的分割线
 *
 *  @return id
 */
- (id)initWithItems:(NSArray *)items
 andSelectLineColor:(UIColor *)color
andselectLineHeight:(CGFloat)height
andIsShowBottomSeparator:(BOOL)showBottomSeparator;

@end
