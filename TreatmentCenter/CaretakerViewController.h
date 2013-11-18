//
//  CaretakerViewController.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExistingClientTableViewController.h"
#import "AddClientViewController.h"

@class CaretakerViewController;

@protocol CaretakerViewControllerDelegate <NSObject>
-(void)caretakerViewControllerDidLogout:(CaretakerViewController *)controller;
@end

@interface CaretakerViewController : UIViewController <ExistingClientTableViewControllerDelegate, AddClientViewControllerDelegate>

@property (nonatomic, weak) id <CaretakerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *existingClientButton;
@property (weak, nonatomic) IBOutlet UIButton *addClientButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyCenterButton;
@property (strong, nonatomic) Caretaker * caretaker;
@property (weak, nonatomic) IBOutlet UILabel *noClientsLabel;

- (IBAction)addClient:(id)sender;
- (IBAction)nearbyCenter:(id)sender;
- (IBAction)existingClient:(id)sender;


@end
