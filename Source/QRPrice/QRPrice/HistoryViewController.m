//
//  HistoryViewController.m
//  QRPrice
//
//  Created by Alec Kretch on 4/18/16.
//  Copyright © 2016 Alec Kretch. All rights reserved.
//

#import "HistoryViewController.h"

@implementation HistoryViewController

- (id)initWithHistory:(NSArray *)history delegate:(id)delegate frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.clipsToBounds = YES;
        self.view.frame = frame;
        self.delegate = delegate;
        self.arrayHistory = history;
        [self setTable];
        [self setBottomLine];
    }
    return self;
    
}

- (void)setTable {
    //create table view controller
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tableViewController];
    
    //create table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = 50;
    tableViewController.tableView = self.tableView;
    [self.view addSubview:tableViewController.tableView];

}

- (void)setBottomLine {
    //create line
    UIBezierPath *pathLine = [UIBezierPath bezierPath];
    [pathLine moveToPoint:CGPointMake(0, self.view.frame.size.height-1)];
    [pathLine addLineToPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height-1)];
    
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = [pathLine CGPath];
    line.strokeColor = [self.tableView.separatorColor CGColor];
    line.lineWidth = 1.0;
    [self.view.layer addSublayer:line];
    
}

- (void)onTapButtonCell:(UIButton *)sender {
    NSDictionary *history = [self.arrayHistory objectAtIndex:sender.tag];
    NSString *iSBN = [history objectForKey:@"ISBN"];
    [self.delegate historyView:self didSelectISBN:iSBN];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(self.arrayHistory.count, 1);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (self.arrayHistory.count == 0)
    {
        [cell performClearCell];
        [cell setNoHistory];
    }
    else
    {
        [cell performClearCell];
        NSDictionary *history = [self.arrayHistory objectAtIndex:self.arrayHistory.count-1-indexPath.row];
        [cell setWithHistory:history];
        cell.btnCell.tag = self.arrayHistory.count-1-indexPath.row;
        [cell.btnCell addTarget:self action:@selector(onTapButtonCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}

//this method is to remove table view's separator auto inset
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //remove separator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    //prevent cell from inheriting the table view's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    //set cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@end
