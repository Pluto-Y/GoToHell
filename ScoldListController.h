//
//  HellListControllerViewController.h
//  GoToHell
//
//  Created by Pluto-Y on 15/11/14.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "BottomMenuView.h"
#import "ScoldDetail.h"

@interface ScoldListController : UIViewController<BottomMenuViewDelegate, UITableViewDataSource, UITableViewDelegate, ServerUtilDelegate>

-(void)addNewScoldDetail:(ScoldDetail *)detail;

@end
