//
//  ScoldDetailController.h
//  GoToHell
//
//  Created by ChipSea on 15/11/14.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoldDetail.h"

@interface ScoldDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ServerUtilDelegate>

@property (strong, nonatomic) IBOutlet UITableView *yScoldDetailTableView;
@property (strong, nonatomic) IBOutlet UIButton *yChangeModeBtn;
@property (strong, nonatomic) IBOutlet UITextField *yContentTf;
@property (strong, nonatomic) IBOutlet UIButton *yVoiceBtn;
@property (assign, nonatomic) BOOL isFirst;
@property (retain, nonatomic) ScoldDetail *firstDetail;

@end
