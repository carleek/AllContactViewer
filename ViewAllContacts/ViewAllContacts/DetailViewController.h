//
//  DetailViewController.h
//  ViewAllContacts
//
//  Created by Joshua Bryson on 10/13/13.
//  Copyright (c) 2013 QuickworkAppsLLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
