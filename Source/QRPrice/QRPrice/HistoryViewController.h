//
//  HistoryViewController.h
//  QRPrice
//
//  Created by Alec Kretch on 4/18/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryTableViewCell.h"

@class HistoryViewController;

@protocol HistoryViewControllerDelegate <NSObject>

- (void)historyView:(HistoryViewController *)controller didSelectISBN:(NSString *)iSBN;

@end

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSArray *arrayHistory;
@property (nonatomic, weak) id<HistoryViewControllerDelegate> delegate;

- (id)initWithHistory:(NSArray *)history delegate:(id)delegate frame:(CGRect)frame;

@end
