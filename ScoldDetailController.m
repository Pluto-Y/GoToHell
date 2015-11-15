//
//  ScoldDetailController.m
//  GoToHell
//
//  Created by ChipSea on 15/11/14.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "ScoldDetailController.h"
#import "ScoldDetailOtherCell.h"
#import "ScoldDetailMineCell.h"
#import "ScoldDetail.h"
#import "AudioUtil.h"
#import "ScoldBusiness.h"

@interface ScoldDetailController () {
    NSMutableArray *scoldDetails;
    BOOL textModeFlag;
    ScoldBusiness *business;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yViewBottom;
@property (strong, nonatomic) IBOutlet UIView *yTalkingView;
@property (strong, nonatomic) IBOutlet UILabel *yTalkingViewTipLbl;

@end

@implementation ScoldDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFirst) {
        [scoldDetails addObject:_firstDetail];
        [_yScoldDetailTableView reloadData];
    }
    if (scoldDetails.count >1) {
        [self.yScoldDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scoldDetails.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - custom functions
-(void)initAll {
    NSLog(@"ScoldDetailController -> initAll");
    textModeFlag = YES;
    business = [[ScoldBusiness alloc] initWithDelegate:self];
    scoldDetails = [[NSMutableArray alloc] init];
//    ScoldDetail *detail;
//    for (int i = 0 ; i < 10; i++) {
//        detail = [[ScoldDetail alloc] init];
//        if (i % 2 == 0) {
//            detail.contentType = @"text";
//            detail.text = @"";
//            for (int j = 0; j < i + 1; j++) {
//                detail.text = [detail.text stringByAppendingString:@"Fuck you!Son of bitch!"];
//            }
//            detail.time = 1447506927501 + i * 1000;
//            detail.sender = [[UserInfo alloc] init];
//            detail.sender.userName = @"HelloKitty";
//        } else {
////            detail.contentType = @"voice";
//            detail.contentType = @"text";
//            detail.text = @"";
//            for (int j = 0; j < i + 1; j++) {
//                detail.text = [detail.text stringByAppendingString:@"Son of bitch!Fuck you!"];
//            }
//            detail.time = 1447506927501 + i * 1000;
//            detail.sender = [[UserInfo alloc] init];
//            detail.sender.userName = @"HelloWorld";
//        }
//        [scoldDetails addObject:detail];
//    }
    
    _yScoldDetailTableView.estimatedRowHeight = 60;
    _yScoldDetailTableView.rowHeight = UITableViewAutomaticDimension;
    
    _yContentTf.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)leaveEditMode
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height);
    }completion:^(BOOL finished){}];
    
    [_yContentTf resignFirstResponder];
}

#pragma mark - Keyboard Observe
- (void)keyboardWillShow:(NSNotification *)notification {
//    NSDictionary *info = [notification userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
    
    static CGFloat normalKeyboardHeight = 216;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
    if (distanceToMove == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height-216);
        }completion:^(BOOL finished){
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-distanceToMove);
        }completion:^(BOOL finished){
        }];
    }
    if (scoldDetails.count >1) {
        [self.yScoldDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scoldDetails.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - callback functions
- (IBAction)changeModeClick:(id)sender {
    NSLog(@"Change Mode Click");
    textModeFlag = !textModeFlag;
    if (textModeFlag) {
        [_yChangeModeBtn setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
        _yContentTf.hidden = NO;
        _yVoiceBtn.hidden = YES;
    } else {
        [self leaveEditMode];
        [_yChangeModeBtn setBackgroundImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateNormal];
        _yContentTf.hidden = YES;
        _yVoiceBtn.hidden = NO;
    }
}

/**
 *  Press to talk and create the wav file
 */
- (IBAction)recordVoiceBegin:(id)sender {
    NSLog(@"recordVoiceBegin");
    _yTalkingView.hidden = NO;
    _yTalkingViewTipLbl.text = @"Talking";
    NSURL *wavFileURL = [AudioUtil beginTalk];
    NSLog(@"wavFileURL:%@", wavFileURL);
}

/**
 *  The operation of the finish record.
 *  Then will send the voice and refresh this view
 */
- (IBAction)finishRecodVoiceAndSend:(id)sender {
    NSLog(@"finishRecodVoiceAndSend");
    _yTalkingView.hidden = YES;
    AVAudioPlayer *player = [AudioUtil finishTalk];
    if (player.duration > 1) { //Audio must be more than 1s
        ScoldDetail *detail = [ScoldDetail new];
        detail.contentType = @"voice";
        detail.sender = [UserInfo new];
        detail.sender.userName = @"HelloWorld";
        detail.time = [[NSDate date] timeIntervalSince1970] * 1000;
        [scoldDetails addObject:detail];
        [_yScoldDetailTableView reloadData];
    } else {
        _yTalkingViewTipLbl.text = @"Too short";
    }
    [UIView transitionWithView:_yTalkingView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        _yTalkingView.hidden = NO;
    }completion:^(BOOL finished){
        _yTalkingView.hidden = YES;
    }];
    if (scoldDetails.count >1) {
        [self.yScoldDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scoldDetails.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    ScoldDetail *detail = [ScoldDetail new];
    if (textField.text.length >= 1) {
        if (_isFirst) {
            detail.topicId = [NSString stringWithFormat:@"%@_%@", _firstDetail.id, GLOBAL_NICKNAME];
        } else {
            detail.topicId = ((ScoldDetail *)[scoldDetails objectAtIndex:scoldDetails.count -2]).topicId;
        }
        detail.contentType = @"text";
        detail.text = textField.text;
        detail.sender = [UserInfo new];
        detail.sender.userName = GLOBAL_NICKNAME;
        detail.time = [[NSDate date] timeIntervalSince1970] * 1000;
        detail.to = [UserInfo new];
        detail.to.userName = GLOBAL_OTHER_NICKNAME;
        [scoldDetails addObject:detail];
        [_yScoldDetailTableView reloadData];
    }
    textField.text = @"";
    if (scoldDetails.count >1) {
        [self.yScoldDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scoldDetails.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [business scoldToSomeone:detail];
    return YES;
}



#pragma mark - Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return scoldDetails.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoldDetail *detail = [scoldDetails objectAtIndex:indexPath.row];
    if (![detail.sender.userName isEqualToString:GLOBAL_NICKNAME]) {
        ScoldDetailOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoldDetailOtherCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ScoldDetailOtherCell" owner:self options:nil] firstObject];
        }
        [cell setContent:detail];
        return cell;
    } else {
        ScoldDetailMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoldDetailMineCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ScoldDetailMineCell" owner:self options:nil] firstObject];
        }
        [cell setContent:detail];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)requestFinished:(ServerResult *)info suffix:(NSString *)suffix {
    
}


-(void)requestFailed:(NSString *)suffix {
    
}

@end
