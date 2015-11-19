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
#import "ScoldCell.h"
#import "ScoldDetailController.h"
#import "MJRefresh.h"

@interface ScoldListController () {
    NSMutableArray *scoldArr;
    ScoldBusiness *business;
}
@property (strong, nonatomic) IBOutlet UITableView *yScoldTableView;
@property (strong, nonatomic) IBOutlet UILabel *yNewFlagView;

@end

@implementation ScoldListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Go To Hell";
    [self initAll];
}
#pragma mark - custom functions
-(void)initAll {
    NSLog(@"ScoldListController -> initAll");
    _yScoldTableView.delegate = self;
    _yScoldTableView.dataSource = self;
    _yScoldTableView.estimatedRowHeight = 80;
    business = [[ScoldBusiness alloc] initWithDelegate:self];
    scoldArr = [[NSMutableArray alloc] init];
    


    [business getScoldes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessagew) name:@"GET_NEW_ARTICLE" object:nil];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [scoldArr removeAllObjects];
        [business getScoldes];
    }];
    _yScoldTableView.header = header;
}
#pragma mark - callback functions
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

-(void)getNewMessagew{
    _yNewFlagView.hidden = NO;
    
}


- (IBAction)gotoDetail:(id)sender {
    _yNewFlagView.hidden = YES;
    ScoldDetailController *controller = [[ScoldDetailController alloc] init];
    controller.isModel = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
            [ScoldTextInputView showScoldTextInputView:self];
            break;
        case 1:
            NSLog(@"Voice Click");
            [ScoldVoiceView showScoldVoiceView:self];
            break;
    }
}

#pragma mark - Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return scoldArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoldCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ScoldCell" owner:self options:nil] firstObject];
    }
    ScoldDetail *detail = [scoldArr objectAtIndex:indexPath.row];
    [cell setContent:detail];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoldDetail *detail = [scoldArr objectAtIndex:indexPath.row];
    if (![detail.sender.userName isEqualToString:GLOBAL_NICKNAME]) {
        ScoldDetailController *controller = [[ScoldDetailController alloc] init];
        controller.isFirst =  YES;
        controller.firstDetail = detail;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)requestFinished:(ServerResult *)info suffix:(NSString *)suffix {
    NSArray *result = [RMMapper arrayOfClass:[ScoldDetail class] fromArrayOfDictionary:info.data];
    if (result.count > 0) {
        [scoldArr removeAllObjects];
    }
    for (ScoldDetail *detail in result) {
        [scoldArr addObject:detail];
    }
    [_yScoldTableView.header endRefreshing];
    if (scoldArr.count > 0) {
        [_yScoldTableView reloadData];
    }

}

-(void)addNewScoldDetail:(ScoldDetail *)detail {
    [scoldArr insertObject:detail atIndex:0];
    [_yScoldTableView reloadData];
}

-(void)requestFailed:(NSString *)suffix {
    
}

@end
