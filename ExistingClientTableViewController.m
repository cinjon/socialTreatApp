//
//  ExistingClientTableViewController.m
//  TreatmentCenter
//
//  Created by Cinjon Resnick on 9/20/13.
//  Copyright (c) 2013 Cinjon Resnick. All rights reserved.
//

#import "ExistingClientTableViewController.h"
#import "CustomCellBackground.h"
#import "CustomFooter.h"

@interface ExistingClientTableViewController ()

@end

@implementation ExistingClientTableViewController

@synthesize delegate;
@synthesize selectTableView;
@synthesize backButton;
@synthesize caretaker;
@synthesize client;
@synthesize appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [selectTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationController.toolbarHidden = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Clients";
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg.jpg"]];
    self.tableView.backgroundView = background;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [caretaker.clients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientCell";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (![cell.backgroundView isKindOfClass:[CustomCellBackground class]]) {
        CustomCellBackground * backgroundCell = [[CustomCellBackground alloc] init];
        cell.backgroundView = backgroundCell;
    }
    
    if (![cell.selectedBackgroundView isKindOfClass:[CustomCellBackground class]]) {
        CustomCellBackground * selectedBackgroundCell = [[CustomCellBackground alloc] init];
        selectedBackgroundCell.selected = YES;
        cell.selectedBackgroundView = selectedBackgroundCell;
    }
    
    ((CustomCellBackground *) cell.backgroundView).lastCell = indexPath.row == caretaker.clients.count - 1;
    
    Client *cellClient = [caretaker.clients objectAtIndex:[indexPath row]];
    NSArray *name = [[NSArray alloc] initWithObjects:[cellClient firstName], [cellClient lastName], nil];
    cell.textLabel.text = [name componentsJoinedByString:@" "];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    // Do something to fix this:
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@) %@-%@",[cellClient.phone substringToIndex:3],[[cellClient.phone substringFromIndex:3] substringToIndex:3], [cellClient.phone substringFromIndex:6]];
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Client *deleteClient = [caretaker.clients objectAtIndex:indexPath.row];
        [caretaker.clients removeObjectAtIndex:indexPath.row];
        [appDelegate dbDeleteClient:deleteClient];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        return;
    }
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[CustomFooter alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    client = [caretaker.clients objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"ClientSegue" sender:self];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Client *movingClient = [caretaker.clients objectAtIndex:fromIndexPath.row];
    [caretaker.clients removeObjectAtIndex:fromIndexPath.row];
    [caretaker.clients insertObject:movingClient atIndex:toIndexPath.row];
}

- (IBAction)cancel:(id)sender {
    [self.delegate existingClientTableViewControllerDidCancel:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ClientSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        ClientViewController *clientViewController = [[navigationController viewControllers]objectAtIndex:0];
        clientViewController.delegate = self;
        clientViewController.client = client;
        clientViewController.caretaker = caretaker;
    }
}

- (void)clientViewControllerDidCancel:(ClientViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
