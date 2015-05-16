//
//  LBDocumentViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentViewController.h"
#import "LBDocumentEditViewController.h"
#import "LBDocumentListCell.h"
#import "LBDocumentManager.h"

@interface LBDocumentViewController () <UITableViewDataSource ,UITableViewDelegate, HPCallBackProtocol>
{
    NSMutableArray *_dataSource;
    Document *_selectedDocument;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBDocumentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataSource = [LBDocumentManager findAll].mutableCopy;
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openEditPage"]) {
        LBDocumentEditViewController *dvc = segue.destinationViewController;
        dvc.doc = _selectedDocument;
    }
}

#pragma mark - button events

- (IBAction)editButtonClicked:(id)sender
{
    _selectedDocument = nil;
    [self performSegueWithIdentifier:@"openEditPage" sender:self];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBDocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDocumentListCell"];
    cell.document = _dataSource[indexPath.row];
    cell.tableView = tableView;
    cell.delegate  = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedDocument = _dataSource[indexPath.row];
    [self performSegueWithIdentifier:@"openEditPage" sender:self];
}

#pragma mark - HPCallBackProtocol

- (void)obj:(id)obj respondsToAction:(id)actionInfo
{
    LBDocumentListCell *cell = obj;
    
    Document *doc = cell.document;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSInteger tag = ((UIButton *)actionInfo).tag;
    
    if (tag == 0) {
        
    } else if (tag == 1) {
    
        doc.favourite = @(!doc.favourite.boolValue);
        
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        
    } else if (tag == 2) {
        [_dataSource removeObject:doc];
        [LBDocumentManager deleteDocument:doc];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    

}
@end
