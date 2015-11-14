//
//  HellListControllerViewController.m
//  GoToHell
//
//  Created by Pluto-Y on 15/11/14.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "ScoldListController.h"
#import "ScoldTextInputView.h"
#import "ScoldVoiceView.h"

@interface ScoldListController ()

@end

@implementation ScoldListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Go To Hell";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Start Scold Btn Click
 *
 *  @param sender
 */
- (IBAction)startScoldClick:(id)sender {
    NSLog(@"Start Scold Btn Click");
    NSMutableArray *menuName = [[NSMutableArray alloc] initWithArray:@[@"Text", @"Voice"]];
    BottomMenuView *menuView = [[BottomMenuView alloc] initWithMenus:menuName delegate:self];
    [[[UIApplication sharedApplication].delegate window] addSubview:menuView];
}

/**
 *  Menu Click
 *
 *  @param menuView
 *  @param indexPath
 */
-(void)csBottomMenuView:(BottomMenuView *)menuView didClickAt:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            NSLog(@"Text Click");
            [ScoldTextInputView showScoldTextInputView];
            break;
        case 1:
            NSLog(@"Voice Click");
            [ScoldVoiceView showScoldVoiceView];
            break;
    }
}

@end
