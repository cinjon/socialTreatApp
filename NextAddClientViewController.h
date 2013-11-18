//
//  NextAddClientViewController.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/17/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ClientViewController.h"

@class NextAddClientViewController;

@protocol NextAddClientViewControllerDelegate <NSObject>
-(void)nextAddClientViewControllerDidCancel:(NextAddClientViewController *)controller;
@end

@interface NextAddClientViewController : UIViewController <ClientViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <NextAddClientViewControllerDelegate> delegate;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) Client * client;
@property (nonatomic, strong) Caretaker * caretaker;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *roLabel;
@property (weak, nonatomic) IBOutlet UITextField *insuranceField;
@property (weak, nonatomic) IBOutlet UITextField *felonyField;
@property (weak, nonatomic) IBOutlet UITextField *axisOneField;
@property (weak, nonatomic) IBOutlet UITextField *axisTwoField;
@property (weak, nonatomic) IBOutlet UITextField *activePsychField;
@property (weak, nonatomic) IBOutlet UITextField *childAgeField1;
@property (weak, nonatomic) IBOutlet UITextField *childAgeField2;
@property (weak, nonatomic) IBOutlet UITextField *childAgeField3;
@property (weak, nonatomic) IBOutlet UITextField *childNeedsField1;
@property (weak, nonatomic) IBOutlet UITextField *childNeedsField2;
@property (weak, nonatomic) IBOutlet UITextField *childNeedsField3;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIView *felonyView;
@property (weak, nonatomic) IBOutlet UIView *insuranceView;
@property (weak, nonatomic) IBOutlet UIView *mentalHealthView;
@property (weak, nonatomic) IBOutlet UIView *childrenInfoView;

-(IBAction)back:(id)sender;
-(IBAction)submit:(id)sender;

@end
