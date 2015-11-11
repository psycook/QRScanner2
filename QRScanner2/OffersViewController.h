//
//  OffersViewController.h
//  QRScanner2
//
//  Created by Simon Cook on 10/11/2015.
//  Copyright © 2015 Simon Cook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface OffersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableViewCell *tableCell;
@property (weak, nonatomic) IBOutlet UITableView *offersTable;
- (IBAction)refresh:(id)sender;

@end
