//
//  MasterViewController.m
//  ViewAllContacts
//
//  Created by Joshua Bryson on 10/13/13.
//  Copyright (c) 2013 QuickworkAppsLLC. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "ContactCell.h"
#import <AddressBook/AddressBook.h>
@interface MasterViewController () {
    NSMutableArray *_objects;
    ABAddressBookRef _addressBook;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    CFErrorRef error;
    _addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    [self checkAddressBookAccess];

    _objects = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(_addressBook);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            _objects = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(_addressBook);
            [self.tableView reloadData];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:{
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts. Please grant permission by going to \nSettings->Privacy->Contacts and enabling Whozoo to access your contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
            break;
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (granted)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                     });
                                                 }
                                             });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];

    ABRecordRef ref = (__bridge ABRecordRef)_objects[indexPath.row];
    cell.nameLabel.text =(__bridge  NSString*) ABRecordCopyCompositeName(ref);

    NSString *phoneNumber = @"";
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    if(ABMultiValueGetCount(phoneNumbers)>0){
    phoneNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    cell.phoneLabel.text = phoneNumber;

    NSString *email= @"";
    ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
    if(ABMultiValueGetCount(emails)>0){
        email= (__bridge NSString *) ABMultiValueCopyValueAtIndex(emails, 0);
    }
    cell.emailLabel.text = email;
    

    
    return cell;
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
