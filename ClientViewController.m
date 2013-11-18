//
//  ClientViewController.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "ClientViewController.h"

@interface ClientViewController ()

@end

@implementation ClientViewController

@synthesize delegate;
@synthesize client;
@synthesize nameLabel;
@synthesize birthdayLabel;
@synthesize genderLabel;
@synthesize zipcodeLabel;
@synthesize phoneLabel;
@synthesize residentialOutpatientLabel;
@synthesize hasChildrenLabel;
@synthesize detoxLabel;
@synthesize felonyLabel;
@synthesize pregnantLabel;
@synthesize t90Label;
@synthesize methadoneLabel;
@synthesize arsonLabel;
@synthesize employedLabel;
@synthesize englishLabel;
@synthesize dvLabel;
@synthesize whichCentersButton;
@synthesize submitClientButton;
@synthesize homeButton;
@synthesize caretaker;
@synthesize submitCenterLabel;
@synthesize submitTherapistLabel;
@synthesize insuranceLabel;
@synthesize h5150Label;
@synthesize mentalConcernsLabel;

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
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", client.firstName, client.lastName];
    birthdayLabel.text = [NSString stringWithFormat:@"%@/%@/%@",[client.birthday substringToIndex:2],[[client.birthday substringFromIndex:2] substringToIndex:2], [client.birthday substringFromIndex:4]];
    genderLabel.text = client.gender;
    zipcodeLabel.text = client.zipcode;
    phoneLabel.text = [NSString stringWithFormat:@"(%@) %@-%@", [client.phone substringToIndex:3], [[client.phone substringFromIndex:3] substringToIndex:3], [client.phone substringFromIndex:6]];
    
    hasChildrenLabel.text = [NSString stringWithFormat:@"%d", client.children.count];
    felonyLabel.text = [self boolToLabel:client.felonyBool];
    pregnantLabel.text = [self boolToLabel:client.pregnant];
    residentialOutpatientLabel.text = client.residentialOutpatient;
    detoxLabel.text = [self boolToLabel:client.detox];
    t90Label.text = [self boolToLabel:client.t90];
    methadoneLabel.text = [self boolToLabel:client.methadone];
    arsonLabel.text = [self boolToLabel:client.arson];
    employedLabel.text = [self boolToLabel:client.employed];
    englishLabel.text = [self boolToLabel:client.english];
    dvLabel.text = [self boolToLabel:client.dv];
    insuranceLabel.text = client.insurance;
    h5150Label.text = [self boolToLabel:client.h5150];
    mentalConcernsLabel.text = [self boolToLabel:client.mentalBool];
}

- (NSString *)boolToLabel:(BOOL)b
{
    if (b) {
        return @"Yes";
    } else {
        return @"No";
    }
}

- (NetworkStatus)getNetworkStatus {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    [reachability stopNotifier];
    return status;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideLabels
{
    submitTherapistLabel.hidden = YES;
    submitCenterLabel.hidden = YES;
}

- (IBAction)whichCenters:(id)sender
{
    [self hideLabels];
}

- (IBAction)submitClientCenter:(id)sender
{
    [self hideLabels];
    NSArray *query = [self queryServerSubmitClient];
    if ([[query objectAtIndex:0] intValue] == 1)
    {
        submitCenterLabel.text = @"Success, Check Your Phone";
    } else {
        submitCenterLabel.text = @"Failure, Please Try Again";
    }
    submitCenterLabel.hidden = NO;
}

- (IBAction)submitClientTherapist:(id)sender
{
    
}

- (NSArray *)queryServerSubmitClient
{
    NetworkStatus status = [self getNetworkStatus];
    if (!(status == ReachableViaWiFi) && !(status == ReachableViaWWAN)) {
        return [NSArray arrayWithObjects:FALSE, @"No Connection", nil];
    }

    NSString *url = @"http://socialtreatment.herokuapp.com/submit_client";
    //Fix with caretaker_password at some pt
    //Also, just take this into its own file too like reachability is
    NSString *postString = [NSString stringWithFormat:@"caretaker_email=%@&client_name=%@&client_phone=%@", caretaker.email, [NSString stringWithFormat:@"%@ %@", client.firstName, client.lastName], client.phone];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSError        *error = nil;
    NSURLResponse  *response = nil;
    NSData *tryResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response  error:&error];
    if (error) {
        NSLog(@"error is %@", error);
    }
    NSError *jsonParsingError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:tryResponse options:NSJSONReadingMutableLeaves error:&jsonParsingError];
    return [NSArray arrayWithObjects:[jsonDict objectForKey:@"success"], [jsonDict objectForKey:@"msg"], nil];
}

- (IBAction)back:(id)sender
{
    [self.delegate clientViewControllerDidCancel:self];
}

@end
