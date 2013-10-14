//
//  ContactCell.h
//  ViewAllContacts
//
//  Created by Joshua Bryson on 10/13/13.
//  Copyright (c) 2013 QuickworkAppsLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@end
