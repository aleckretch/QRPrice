//
//  HistoryTableViewCell.h
//  QRPrice
//
//  Created by Alec Kretch on 4/18/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *btnCell;

- (void)setNoHistory;
- (void)setWithHistory:(NSDictionary *)history;
- (void)performClearCell;

@end
