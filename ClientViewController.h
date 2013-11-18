//
//  ClientViewController.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Client.h"
#import "Reachability.h"

@class ClientViewController;

@protocol ClientViewControllerDelegate <NSObject>
-(void)clientViewControllerDidCancel:(ClientViewController *)controller;
@end

@interface ClientViewController : UIViewController

@property (nonatomic, weak) id <ClientViewControllerDelegate> delegate;
@property (strong, nonatomic) Client *client;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *residentialOutpatientLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasChildrenLabel;
@property (weak, nonatomic) IBOutlet UILabel *detoxLabel;
@property (weak, nonatomic) IBOutlet UILabel *felonyLabel;
@property (weak, nonatomic) IBOutlet UILabel *pregnantLabel;
@property (weak, nonatomic) IBOutlet UILabel *t90Label;
@property (weak, nonatomic) IBOutlet UILabel *methadoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *arsonLabel;
@property (weak, nonatomic) IBOutlet UILabel *employedLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *dvLabel;
@property (weak, nonatomic) IBOutlet UIButton *whichCentersButton;
@property (weak, nonatomic) IBOutlet UIButton *submitClientButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) Caretaker *caretaker;
@property (weak, nonatomic) IBOutlet UILabel *submitTherapistLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitCenterLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *h5150Label;
@property (weak, nonatomic) IBOutlet UILabel *mentalConcernsLabel;

-(IBAction)whichCenters:(id)sender;
-(IBAction)submitClientCenter:(id)sender;
-(IBAction)submitClientTherapist:(id)sender;
-(IBAction)back:(id)sender;

@end
