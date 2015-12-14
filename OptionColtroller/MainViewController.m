//
//  MainViewController.m
//  OptionColtroller
//
//  Created by zm on 15/7/1.
//  Copyright (c) 2015年 zm. All rights reserved.
//

#import "MainViewController.h"

#import "zmDefine.h"
#import "OptionControl.h"

@interface MainViewController ()

@property (nonatomic, strong) OptionControl *optionControl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor greenColor];
    
    self.optionControl = [[OptionControl alloc] initWithItems:@[@"a", @"b", @"c", @"d"]];
    self.optionControl.frame = CGRectMake(0, 100, SCREEN_WIDTH, 100);
    [self.optionControl addTarget:self action:@selector(optionControlAction:) forControlEvents:UIControlEventValueChanged];
    self.optionControl.tintColor = [UIColor yellowColor];
    [self.optionControl setWidth:10.f forSegmentAtIndex:2];
    [self.optionControl setTitleTextAttributes:@{
                                                 NSFontAttributeName : [UIFont systemFontOfSize:30.f]
                                                 }
                                      forState:UIControlStateNormal];
    [self.optionControl setTitle:@"adfasfasdfdfadfasdfdsaf" forSegmentAtIndex:1];
    [self.view addSubview:self.optionControl];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 300.f, 50.f, 50.f)];
    button.backgroundColor = [UIColor magentaColor];
    [button addTarget:self action:@selector(buttonActionUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *buttont = [[UIButton alloc] initWithFrame:CGRectMake(100, 300.f, 50.f, 50.f)];
    buttont.backgroundColor = [UIColor purpleColor];
    [buttont addTarget:self action:@selector(buttontActionUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttont];
    
    NSLog(@"%@", NSStringFromCGRect(button.frame));
    zmLog_Frame(button.frame);
    zmLog_Size(button.frame.size)
}

- (void)buttonActionUp
{
    [self.optionControl insertSegmentWithTitle:@"234" atIndex:3 animated:YES];
    
    [self.optionControl setWidth:100.f forSegmentAtIndex:2];
}

- (void)buttontActionUp
{
    [self.optionControl removeSegmentAtIndex:2 animated:YES];
}

- (void)optionControlAction:(OptionControl *)optionControl
{
    zmLog(@"%d", optionControl.selectedSegmentIndex);
}
@end
