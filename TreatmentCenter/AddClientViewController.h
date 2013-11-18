//
//  AddClientViewController.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Client.h"
#import "NextAddClientViewController.h"

@class AddClientViewController;

@protocol AddClientViewControllerDelegate <NSObject>
-(void)addClientViewControllerDidCancel:(AddClientViewController *)controller;
@end

@interface AddClientViewController : UIViewController <NextAddClientViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, weak) id <AddClientViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *birthField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UISwitch *hasChildSwitch;

@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UISwitch *methadoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *history5150Switch;
@property (weak, nonatomic) IBOutlet UIButton *nextBarButton;
@property (weak, nonatomic) IBOutlet UISwitch *employedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dvSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *arsonSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *t90Switch;
@property (weak, nonatomic) IBOutlet UISwitch *detoxSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *englishSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mentalSwitch;
@property (weak, nonatomic) IBOutlet UITextField *roField;
@property (weak, nonatomic) IBOutlet UISwitch *felonySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pregnantSwitch;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (nonatomic, strong) Client * client;
@property (nonatomic, strong) Caretaker * caretaker;

- (IBAction)cancel:(id)sender;
- (IBAction)next:(id)sender;

@end
