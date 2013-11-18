//
//  AddClientViewController.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "AddClientViewController.h"

@interface AddClientViewController ()

@end

@implementation AddClientViewController

@synthesize delegate;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize phoneField;
@synthesize birthField;
@synthesize zipcodeField;
@synthesize hasChildSwitch;
@synthesize genderField;
@synthesize methadoneSwitch;
@synthesize employedSwitch;
@synthesize dvSwitch;
@synthesize arsonSwitch;
@synthesize t90Switch;
@synthesize detoxSwitch;
@synthesize mentalSwitch;
@synthesize roField;
@synthesize felonySwitch;
@synthesize client;
@synthesize appDelegate;
@synthesize caretaker;
@synthesize msgLabel;
@synthesize pregnantSwitch;
@synthesize englishSwitch;
@synthesize nextBarButton;
@synthesize history5150Switch;

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
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.phoneField.delegate = self;
    self.birthField.delegate = self;
    self.zipcodeField.delegate = self;
    self.genderField.delegate = self;
    self.roField.delegate = self;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger tag = textField.tag;
    if (tag == 0 || tag == 1)
    {
        return [self nameTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if(tag == 2) {
        return [self phoneTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if(tag == 3) {
        return [self zipcodeTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if(tag == 4) {
        return [self genderTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if(tag == 5) {
        return [self birthdayTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if(tag == 6) {
        return [self roTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)zipcodeTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self notInTextFieldMembership:string forSet:[NSCharacterSet characterSetWithCharactersInString:@"01234567890"]])
    {
        return NO;
    }
    
    if([textField.text length] == 5 && range.length == 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)nameTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self notInTextFieldMembership:[string lowercaseString] forSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"]])
    {
        return NO;
    }
    return YES;
}

- (BOOL)numberTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self notInTextFieldMembership:string forSet:[NSCharacterSet characterSetWithCharactersInString:@"01234567890"]])
    {
        return NO;
    }
    if ([textField.text length] == 2 && range.length == 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)_charTextFieldHelper:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string charSet:(NSCharacterSet *)charSet
{
    if ([self notInTextFieldMembership:[string lowercaseString] forSet:charSet] || ([textField.text length] == 1 && range.length == 0))
    {
        return NO;
    }
    return YES;
}

- (BOOL)roTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self _charTextFieldHelper:textField shouldChangeCharactersInRange:range replacementString:string charSet:[NSCharacterSet characterSetWithCharactersInString:@"ro"]];
}

- (BOOL)genderTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self _charTextFieldHelper:textField shouldChangeCharactersInRange:range replacementString:string charSet:[NSCharacterSet characterSetWithCharactersInString:@"mft"]];
}

- (BOOL)phoneTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self notInTextFieldMembership:string forSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]])
    {
        return NO;
    }
    
    int length = [self getMobileLength:textField.text];
    if(length == 10 && range.length == 0)
    {
        return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatMobileNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0) {
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
    } else if(length == 6) {
        NSString *num = [self formatMobileNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0) {
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    return YES;
}

- (BOOL)birthdayTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self notInTextFieldMembership:string forSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]])
    {
        return NO;
    }
    
    int length = [self getBirthdayLength:textField.text];
    if(length == 8 && range.length == 0)
    {
        return NO;
    }
    
    if(length == 2)
    {
        NSString *month = [self formatBirthdayNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"%@/", month];
        if (range.length > 0)
        {
            textField.text = [NSString stringWithFormat:@"%@", [month substringToIndex:2]];
        }
    } else if(length == 4) {
        NSString *num = [self formatBirthdayNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"%@/%@/",[num  substringToIndex:2],[num substringFromIndex:2]];
        if(range.length > 0) {
            textField.text = [NSString stringWithFormat:@"%@/%@",[num substringToIndex:2],[num substringFromIndex:2]];
        }
    }
    return YES;
}

- (BOOL)notInTextFieldMembership:(NSString *)str forSet:(NSCharacterSet *)charSet
{
    for (int i = 0; i < [str length]; i++) {
        unichar c = [str characterAtIndex:i];
        if (![charSet characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)formatMobileNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}

-(NSString *)formatBirthdayNumber:(NSString *)birthdayNumber
{
    birthdayNumber = [birthdayNumber stringByReplacingOccurrencesOfString:@"/" withString:@""];
    birthdayNumber = [birthdayNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    int length = (int)[birthdayNumber length];
    if (length > 8) {
        birthdayNumber = [birthdayNumber substringFromIndex:length - 8];
    }
    return birthdayNumber;
}


-(int)getMobileLength:(NSString*)mobileNumber
{
    mobileNumber = [self formatMobileNumber:mobileNumber];
    return (int)[mobileNumber length];
}

- (int)getBirthdayLength:(NSString *)birthday
{
    return (int)[[self formatBirthdayNumber:birthday] length];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate addClientViewControllerDidCancel:self];
}

- (void)nextAddClientViewControllerDidCancel:(NextAddClientViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:nil];
    client = controller.client;
    caretaker = controller.caretaker;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self paintView];
}

- (void)paintView
{
    phoneField.text = [NSString stringWithFormat:@"(%@) %@-%@",[client.phone substringToIndex:3],[[client.phone substringFromIndex:3] substringToIndex:3], [client.phone substringFromIndex:6]];
    firstNameField.text = client.firstName;
    lastNameField.text = client.lastName;
    birthField.text = [NSString stringWithFormat:@"%@/%@/%@",[client.birthday substringToIndex:2],[[client.birthday substringFromIndex:2] substringToIndex:4], [client.birthday substringFromIndex:4]];
    zipcodeField.text = client.zipcode;
    genderField.text = client.gender;
    roField.text = client.residentialOutpatient;
    hasChildSwitch.on = client.hasChild;
    methadoneSwitch.on = client.methadone;
    employedSwitch.on = client.employed;
    dvSwitch.on = client.dv;
    arsonSwitch.on = client.arson;
    t90Switch.on = client.arson;
    detoxSwitch.on = client.detox;
    englishSwitch.on = client.english;
    mentalSwitch.on = client.mentalBool;
    felonySwitch.on = client.felonyBool;
    pregnantSwitch.on = client.pregnant;
    history5150Switch.on = client.h5150;
    msgLabel.hidden = YES;
}

- (BOOL)isFieldEmpty:(UITextField *)textField
{
    return [textField.text length] == 0;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    msgLabel.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger tag = textField.tag;
    if (tag == 5 || tag == 0 || tag == 6)
    {
        textField.text = [[[textField.text substringToIndex:1] uppercaseString] stringByAppendingString:[textField.text substringFromIndex:1]];
    }
}

- (BOOL)isAgeFieldIncomplete
{
    NSString *birthday = [self formatBirthdayNumber:birthField.text];
    if (!((int)[birthday length] == 8)) {
        NSLog(@"age field not long enough");
        return YES;
    }
    
    int month = [[birthday substringToIndex:2] intValue];
    if (month < 1 || month > 12) {
        NSLog(@"age field not right month");
        return YES;
    }
    
    int day = [[[birthday substringFromIndex:2] substringToIndex:2] intValue];
    if (day < 1 || day > 31) {
        NSLog(@"age field not right day");
        return YES;
    }
    
    int year = [[birthday substringFromIndex:4] intValue];
    if (year > 2013 || year < 1900) {
        NSLog(@"age field not right year");
        return YES;
    }
    
    NSLog(@"reached end of age field");
    return NO;
}

- (BOOL)isGenderFieldIncomplete
{
    unichar c = [[[genderField.text lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] characterAtIndex:0];
    return ![[NSCharacterSet characterSetWithCharactersInString:@"mft"] characterIsMember:c];
}

- (BOOL)isPhoneFieldIncomplete
{
    NSLog(@"ph inc: %d", !([self getMobileLength:phoneField.text] == 10));
    return !([self getMobileLength:phoneField.text] == 10);
}

- (BOOL)requiredFieldsCompleted
{
    BOOL notRetValue = [self isFieldEmpty:lastNameField] || [self isFieldEmpty:firstNameField] || [self isPhoneFieldIncomplete] || [self isFieldEmpty:zipcodeField] || [self isGenderFieldIncomplete] || [self isFieldEmpty:roField] || [self isAgeFieldIncomplete];
    return !(notRetValue);
}

- (BOOL)enterClient
{
//    will input client into online db as well.
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:[self formatBirthdayNumber:birthField.text] forKey:@"birthday"];
    [data setValue:zipcodeField.text forKey:@"zipcode"];
    [data setValue:firstNameField.text forKey:@"firstName"];
    [data setValue:lastNameField.text forKey:@"lastName"];
    [data setValue:genderField.text forKey:@"gender"];
    [data setValue:roField.text forKey:@"residentialOutpatient"];
    [data setValue:[self formatMobileNumber:phoneField.text] forKey:@"phone"];

    [data setValue:[NSNumber numberWithBool:pregnantSwitch.isOn] forKey:@"pregnant"];
    [data setValue:[NSNumber numberWithBool:hasChildSwitch.isOn] forKey:@"hasChild"];
    [data setValue:[NSNumber numberWithBool:employedSwitch.isOn] forKey:@"employed"];
    [data setValue:[NSNumber numberWithBool:dvSwitch.isOn] forKey:@"dv"];
    [data setValue:[NSNumber numberWithBool:detoxSwitch.isOn] forKey:@"detox"];
    [data setValue:[NSNumber numberWithBool:englishSwitch.isOn] forKey:@"english"];
    [data setValue:[NSNumber numberWithBool:methadoneSwitch.isOn] forKey:@"methadone"];
    [data setValue:[NSNumber numberWithBool:felonySwitch.isOn] forKey:@"felonyBool"];
    [data setValue:[NSNumber numberWithBool:t90Switch.isOn] forKey:@"t90"];
    [data setValue:[NSNumber numberWithBool:history5150Switch.isOn] forKey:@"h5150"];
    [data setValue:[NSNumber numberWithBool:arsonSwitch.isOn] forKey:@"arson"];
    [data setValue:[NSNumber numberWithBool:mentalSwitch.isOn] forKey:@"mentalBool"];
    
    if (client && client.firstName && ![client.firstName isEqualToString:@""]) {
        return [appDelegate modifyClient:client modify:data];
    }
    
    client = [appDelegate insertClient:caretaker data:data];
    if (client) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (IBAction)next:(id)sender
{
    if ([self requiredFieldsCompleted]) {
        if ([self enterClient]) {
            [self performSegueWithIdentifier:@"NextSegue" sender:self];
        }
    } else {
        msgLabel.text = @"Please complete all fields";
        msgLabel.hidden = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NextSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        NextAddClientViewController *nextAddClientViewController =[[navigationController viewControllers]objectAtIndex:0];
        nextAddClientViewController.delegate = self;
        nextAddClientViewController.client = client;
        nextAddClientViewController.caretaker = caretaker;
    }
}

@end
