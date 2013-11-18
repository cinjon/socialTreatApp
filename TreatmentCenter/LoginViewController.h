//
//  LoginViewController.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "AppDelegate.h"
#import "Caretaker.h"
#import "CaretakerViewController.h"
#import "Reachability.h"
#import "CustomButton.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, CaretakerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) AppDelegate * appDelegate;
@property (strong, nonatomic) Caretaker *caretaker;
@property (weak, nonatomic) NSMutableData *loginData;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) NSString *sessionToken;

- (IBAction)tryLogin:(id)sender;

@end
