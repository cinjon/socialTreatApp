//
//  NextAddClientViewController.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 10/17/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "NextAddClientViewController.h"

@interface NextAddClientViewController ()

@end

@implementation NextAddClientViewController

@synthesize delegate;
@synthesize client;
@synthesize caretaker;
@synthesize appDelegate;
@synthesize felonyField;
@synthesize activePsychField;
@synthesize axisOneField;
@synthesize axisTwoField;
@synthesize insuranceField;
@synthesize phoneLabel;
@synthesize zipcodeLabel;
@synthesize genderLabel;
@synthesize msgLabel;
@synthesize birthdayLabel;
@synthesize roLabel;

@synthesize childAgeField1;
@synthesize childAgeField2;
@synthesize childAgeField3;
@synthesize childNeedsField1;
@synthesize childNeedsField2;
@synthesize childNeedsField3;
@synthesize childrenInfoView;
@synthesize mentalHealthView;
@synthesize felonyView;
@synthesize insuranceView;

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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self paintView];
}

- (void)paintView
{
    self.phoneLabel.text = [NSString stringWithFormat:@"(%@) %@-%@", [client.phone substringToIndex:3], [[client.phone substringFromIndex:3] substringToIndex:3], [client.phone substringFromIndex:6]];
    self.zipcodeLabel.text = client.zipcode;
    self.genderLabel.text = client.gender;
    self.birthdayLabel.text = [NSString stringWithFormat:@"%@/%@/%@",[client.birthday substringToIndex:2],[[client.birthday substringFromIndex:2] substringToIndex:2], [client.birthday substringFromIndex:4]];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", client.firstName, client.lastName];
    [self setDependentFields];
}

- (void)setDependentFields
{
    [self fillText:client.insurance forField:insuranceField];
    
    if (!client.felonyBool) {
        felonyField.text = @"NA";
//        [self adjustPosition:[felonyView frame].origin.y view:mentalHealthView];
    } else {
        [self fillText:client.felonyDesc forField:felonyField];
    }
    
    if (!client.mentalBool) {
        axisOneField.text = @"NA";
        axisTwoField.text = @"NA";
        activePsychField.text = @"NA";
//        [self adjustPosition:[mentalHealthView frame].origin.y view:childrenInfoView];
    } else {
        [self fillText:client.axisOne forField:axisOneField];
        [self fillText:client.axisTwo forField:axisTwoField];
        [self fillText:client.activePsych forField:activePsychField];
    }
    
    if (!client.hasChild || [client.children count] > 0) {
        childrenInfoView.hidden = YES;
    } else {
        childNeedsField1.delegate = self;
        childNeedsField2.delegate = self;
        childNeedsField3.delegate = self;
        childAgeField1.delegate = self;
        childAgeField1.delegate = self;
        childAgeField1.delegate = self;
    }
}

- (void)fillText:(NSString *)text forField:(UITextField *)field
{
    field.delegate = self;
    if (![text isEqualToString:@""]) {
        field.text = text;
    }
}

- (void)adjustPosition:(int)y view:(UIView *)view
{
    CGRect fieldView = [view frame];
    fieldView.origin.y = y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 9) {
        [self animateMentalView:YES];
    } else if (textField.tag >= 3) {
        [self animateChildView:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 9) {
        [self animateMentalView:NO];
    } else if (textField.tag >= 3) {
        [self animateChildView:NO];
    }
}

- (void)animateMentalView:(BOOL)up
{
    [self animateView:mentalHealthView up:up distance:76];
    insuranceView.hidden = up;
    felonyView.hidden = up;
}

- (void)animateChildView:(BOOL)up
{
    [self animateView:childrenInfoView up:up distance:189];
    insuranceView.hidden = up;
    felonyView.hidden = up;
    mentalHealthView.hidden = up;
}

- (void) animateView:(UIView *)view up:(BOOL)up distance:(int)distance
{
    const int movementDistance = distance; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ClientSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ClientViewController *clientViewController = [[navigationController viewControllers]objectAtIndex:0];
        clientViewController.delegate = self;
        clientViewController.client = client;
        clientViewController.caretaker = caretaker;
    }
}

- (void)clientViewControllerDidCancel:(ClientViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:nil];
    client = controller.client;
    caretaker = controller.caretaker;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self paintView];
}

- (IBAction)back:(id)sender
{
    [self.delegate nextAddClientViewControllerDidCancel:self];
}

- (IBAction)submit:(id)sender
{
    if ([self requiredFieldsCompleted]) {
        if ([self enterClientInfo]) {
            [self performSegueWithIdentifier:@"ClientSegue" sender:self];
        } else {
            NSLog(@"entering client failure");
        }
    } else {
        msgLabel.hidden = NO;
    }
}

- (BOOL)requiredFieldsCompleted
{
    if (client.felonyBool && [self isFieldEmpty:felonyField]) {
        return FALSE;
    }
    if (client.mentalBool && ([self isFieldEmpty:activePsychField] || [self isFieldEmpty:axisOneField] || [self isFieldEmpty:axisTwoField])) {
        return FALSE;
    }
    if (client.hasChild && ([self isFieldEmpty:childAgeField1] || [self isFieldEmpty:childNeedsField1])) {
        return FALSE;
    }
    return TRUE;
}
                              
- (BOOL)isFieldEmpty:(UITextField *)textField
    {
        return [textField.text length] == 0;
    }

- (NSString *)trim:(NSString *)str
{
   return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)enterClientInfo
{
    NSMutableDictionary *modify = [[NSMutableDictionary alloc] init];
    
    if ([[self trim:insuranceField.text] isEqualToString:@""]) {
        [modify setValue:@"None" forKey:@"insurance"];
    } else {
        [modify setValue:insuranceField.text forKey:@"insurance"];
    }
    
    if (client.felonyBool) {
        [modify setValue:[self trim:felonyField.text] forKey:@"felonyDesc"];
    }
    
    if (client.mentalBool) {
        [modify setValue:[self trim:axisOneField.text] forKey:@"axisOne"];
        [modify setValue:[self trim:axisTwoField.text] forKey:@"axisTwo"];
        [modify setValue:[self trim:activePsychField.text] forKey:@"activePsych"];
    }
    
    if (client.hasChild && [client.children count] == 0) {
        [appDelegate insertChild:client age:[childAgeField1.text intValue] needs:childNeedsField1.text];
        [self makeChild:childAgeField2 needs:childNeedsField2];
        [self makeChild:childAgeField3 needs:childNeedsField3];
    }
    
    if ([appDelegate modifyClient:client modify:modify]) {
        return [self queryServerEnterClient];
    } else {
        return FALSE;
    }
}

- (NetworkStatus)getNetworkStatus {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    [reachability stopNotifier];
    return status;
}

- (BOOL)queryServerEnterClient
{
    NetworkStatus status = [self getNetworkStatus];
    if (!(status == ReachableViaWiFi) && !(status == ReachableViaWWAN)) {
        msgLabel.text = @"Can't connect";
        msgLabel.hidden = NO;
    }
    
    NSString *url = @"http://socialtreatment.herokuapp.com/add_client";
    //Fix with caretaker_password at some pt
    //Also, just take this into its own file too like reachability is
    
    NSString *postString = [NSString stringWithFormat:@"caretaker_email=%@", caretaker.email];
    for (NSString *key in [[client entity] attributesByName]) {
        if ([key isEqualToString:@"children"] || [key isEqualToString:@"caretaker"]) {
            continue;
        }
        postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [client valueForKey:key]]];
    }
    NSLog(@"poststring: %@", postString);
//    NSString *postString = [NSString stringWithFormat:@"caretaker_email=%@&name=%@&phone=%@&zipcode=%@&arson=%@&axisOne=%@", caretaker.email, [NSString stringWithFormat:@"%@ %@", client.firstName, client.lastName], client.phone, client.zipcode];
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
    if ([[jsonDict objectForKey:@"success"] intValue] == 1) {
        return YES;
    } else if (jsonParsingError) {
        NSLog(@"error in parsing is %@", error);
    } else {
        NSLog(@"bah, jsondict: %@", [jsonDict objectForKey:@"success"]);
    }
    return NO;
}

- (void)makeChild:(UITextField *)age needs:(UITextField *)needs
{
    if (![self isFieldEmpty:age] && ![self isFieldEmpty:needs]) {
        [appDelegate insertChild:client age:[age.text intValue] needs:needs.text];
    }
}




@end
