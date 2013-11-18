//
//  CaretakerViewController.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "CaretakerViewController.h"
#import "ExistingClientTableViewController.h"
#import "AddClientViewController.h"
#import "Caretaker.h"
#import "QuartzCore/QuartzCore.h"

@interface CaretakerViewController ()

@end

@implementation CaretakerViewController

@synthesize welcomeLabel;
@synthesize existingClientButton;
@synthesize addClientButton;
@synthesize nearbyCenterButton;
@synthesize caretaker;
@synthesize delegate;
@synthesize noClientsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = caretaker.name;
    [self buttonBorder:addClientButton];
    [self buttonBorder:existingClientButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setNumClients];
    welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", caretaker.name];
}

- (void)setNumClients
{
    int c = caretaker.clients.count;
    if (c == 0) {
        noClientsLabel.text = @"No Clients Found";
    } else if (c == 1) {
        noClientsLabel.text = @"1 Client";
    } else {
        noClientsLabel.text = [NSString stringWithFormat:@"%d Clients", c];
    }
}

- (void)buttonBorder:(UIButton *)button
{
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nearbyCenter:(id)sender
{
    [self performSegueWithIdentifier:@"NearbyCenterSegue" sender:self];
}

- (IBAction)existingClient:(id)sender
{
    if ([caretaker.clients count] > 0)
    {
        [self performSegueWithIdentifier:@"ExistingClientSegue" sender:self];
    }
}

- (void)existingClientTableViewControllerDidCancel:(ExistingClientTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addClient:(id)sender
{
    [self performSegueWithIdentifier:@"AddClientSegue" sender:self];
}

- (void)addClientViewControllerDidCancel:(AddClientViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ExistingClientSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ExistingClientTableViewController *existingClientTableViewController = [[navigationController viewControllers]objectAtIndex:0];
        existingClientTableViewController.delegate = self;
        existingClientTableViewController.caretaker = caretaker;
    } else if([segue.identifier isEqualToString:@"AddClientSegue"]) {
        NSLog(@"in addclientsegue");
        UINavigationController *navigationController = segue.destinationViewController;
        NSLog(@"past uinav");
        AddClientViewController *addViewController = [[navigationController viewControllers] objectAtIndex:0];
        NSLog(@"past addclientview");
        addViewController.delegate = self;
        NSLog(@"past setting addview delegate");
        addViewController.caretaker = caretaker;
        NSLog(@"got the caretaker too");
    }
    
}
@end
