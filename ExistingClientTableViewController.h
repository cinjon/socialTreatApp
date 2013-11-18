//
//  ExistingClientTableViewController.h
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Client.h"
#import "ClientViewController.h"

@class ExistingClientTableViewController;

@protocol ExistingClientTableViewControllerDelegate <NSObject>
-(void)existingClientTableViewControllerDidCancel:(ExistingClientTableViewController *)controller;
@end

@interface ExistingClientTableViewController : UITableViewController <ClientViewControllerDelegate>

@property (nonatomic, weak) id <ExistingClientTableViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) Caretaker *caretaker;
@property (strong, nonatomic) Client *client;
@property (strong, nonatomic) AppDelegate *appDelegate;

-(IBAction)cancel:(id)sender;

@end
