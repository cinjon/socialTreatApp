//
//  LoginViewController.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomButton.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize emailField;
@synthesize passwordField;
@synthesize appDelegate;
@synthesize caretaker;
@synthesize loginData;
@synthesize msgLabel;
@synthesize loginButton;
@synthesize sessionToken;

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
    emailField.delegate = self;
    passwordField.delegate = self;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    msgLabel.hidden = YES;
//    [appDelegate deleteModel];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)caretakerViewControllerDidLogout:(CaretakerViewController *)controller
{
    //Do something to log them out
}

- (void)deleteCaretakerFromKeychainWithEmail:(NSString *)email
{
    [self deleteKeychainValue:email];
}

- (void)insertCaretakerIntoKeychainWithEmail:(NSString *)email withPass:(NSString *)password
{
    [self createKeychainValue:password forIdentifier:email];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    msgLabel.hidden = YES;
}

- (IBAction)tryLogin:(id)sender
{
//    [appDelegate deleteAllObjects:@"Caretaker"];
//    [appDelegate deleteAllObjects:@"Client"];
    
    NSString *email = emailField.text;
    NSString *password = passwordField.text;
    if ([email length] == 0 || [password length] == 0) {
        msgLabel.text = @"Enter Email and Password";
        msgLabel.hidden = NO;
        return;
    }
    
    caretaker = [appDelegate dbRetrieveCaretaker:email];
    if (caretaker)
    {
        NSData *keychainMatch = [self searchKeychainCopyMatching:email];
        NSString *keychainPassword = [[NSString alloc] initWithData:keychainMatch encoding:NSUTF8StringEncoding];
        if ([keychainPassword isEqualToString:password]) {
            [self performSegueWithIdentifier:@"LoginAction" sender:self];
        } else {
            msgLabel.text = @"Incorrect Password";
            msgLabel.hidden = NO;
        }
    } else {
        NSArray *query = [self queryServerForCaretaker:email withPassword:password];
        if ([[query objectAtIndex:0] intValue] == 1)
        {
            caretaker = [appDelegate insertCaretaker:email withName:[query objectAtIndex:1]];
            sessionToken = [query objectAtIndex:2]; //For use with submitting
            [self insertCaretakerIntoKeychainWithEmail:caretaker.email withPass:password];
            [self performSegueWithIdentifier:@"LoginAction" sender:self];
        } else {
            msgLabel.text = [query objectAtIndex:3];
            msgLabel.hidden = NO;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginAction"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CaretakerViewController *caretakerViewController = [[navigationController viewControllers]objectAtIndex:0];
        caretakerViewController.delegate = self;
        caretakerViewController.caretaker = caretaker;
    }
}

// KeyChain Access //

static NSString *serviceName = @"com.cinjon.TreatmentCenter";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)email {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [email dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)email {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:email];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef result;
    NSData *passData = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
    passData = (__bridge_transfer NSData *)result;
    return passData;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (void)deleteKeychainValue:(NSString *)email {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:email];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

/*
 POST Request
 */

- (NetworkStatus)getNetworkStatus {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    [reachability stopNotifier];
    return status;
}

- (NSArray *)queryServerForCaretaker:(NSString *)email withPassword:(NSString *)password
{
    NetworkStatus status = [self getNetworkStatus];
    if (!(status == ReachableViaWiFi) && !(status == ReachableViaWWAN)) {
        return [NSArray arrayWithObjects:FALSE, @"No Connection", nil];
    }
    
    NSString *url = @"https://socialtreatment.herokuapp.com/login_request";
    NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
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

    return [NSArray arrayWithObjects:[jsonDict objectForKey:@"success"], [jsonDict objectForKey:@"caretaker"], [jsonDict objectForKey:@"token"], [jsonDict objectForKey:@"msg"], nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    NSLog(@"in can authenticate");
    NSLog([NSString stringWithFormat:@"%@", [protectionSpace authenticationMethod]]);
    if([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        return YES;
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"hi in willsendrequestforauthchallenge");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.loginData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.loginData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *logOutput = [@"Connection failed: " stringByAppendingString:[error description]];
    NSLog(@"connection to server request failed: %@", logOutput);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}


@end
