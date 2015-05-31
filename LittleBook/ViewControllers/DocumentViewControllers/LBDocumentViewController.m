//
//  LBDocumentViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentViewController.h"
#import "LBDocumentEditViewController.h"
#import "LBReadFileFileManager.h"
#import "LBDocumentListCell.h"
#import "LBDocumentManager.h"
#import "LBExportManager.h"

@interface LBDocumentViewController () <UITableViewDataSource ,UITableViewDelegate, HPCallBackProtocol, UISearchBarDelegate>
{
    NSMutableArray *_dataSource;
    Document *_selectedDocument;
    
    LBExportManager *_exportManager;
    
    BOOL _isSearching;
    NSMutableArray *_searchResult;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

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
    if (_isSearching) {
        return _searchResult.count;
    } else {
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBDocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDocumentListCell"];
    if (_isSearching) {
        cell.document = _searchResult[indexPath.row];
    } else {
        cell.document = _dataSource[indexPath.row];
    }
    cell.tableView = tableView;
    cell.delegate  = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearching) {
        _selectedDocument = _searchResult[indexPath.row];
    } else {
        _selectedDocument = _dataSource[indexPath.row];
    }

    [self performSegueWithIdentifier:@"openEditPage" sender:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchResult = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (!searchText || searchText.length < 1) {
        _isSearching = FALSE;
        [_tableView reloadData];
    } else {
        _isSearching = TRUE;
        _searchResult = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < _dataSource.count; i++) {
            Document *doc = _dataSource[i];
            
            if ([doc.title.lowercaseString rangeOfString:searchText.lowercaseString].length > 0) {
                [_searchResult addObject:doc];
            }
        }
        [_tableView reloadData];
    }
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text && searchBar.text.length > 0) {
        _isSearching = TRUE;
        [_tableView reloadData];
    } else {
        _isSearching = FALSE;
        [_tableView reloadData];
    }
}


#pragma mark - HPCallBackProtocol

- (void)obj:(id)obj respondsToAction:(id)actionInfo
{
    LBDocumentListCell *cell = obj;
    
    Document *doc = cell.document;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSInteger tag = ((UIButton *)actionInfo).tag;
    
    if (tag == 0) {
        if (!_exportManager) {
            _exportManager =[[LBExportManager alloc] init];
        }
        NSString *filePath = [[LBReadFileFileManager defaultManager] pathForReadFileImage:doc.documentID];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        [_exportManager openDocImage:image withHolder:self];
        
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
