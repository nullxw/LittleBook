//
//  ReadListViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBReadViewController.h"
#import "LBFileBrowserViewController.h"
#import "LBReadFileFileManager.h"
#import "LBDocumentListCell.h"
#import "LBReadFileManager.h"
#import "LBDocumentManager.h"
#import "LBExportManager.h"

@interface LBReadViewController () <UITableViewDataSource ,UITableViewDelegate, HPCallBackProtocol>
{
    NSMutableArray *_dataSource;
    ReadFile *_selectedFile;
    LBExportManager *_exportManager;
    
    BOOL _isSearching;
    NSMutableArray *_searchResult;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LBReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _dataSource = [LBReadFileManager findAll].mutableCopy;
    
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect frame = _tableView.frame;
    frame.size.height = CGRectGetHeight(self.view.bounds) - frame.origin.y;
    _tableView.frame = frame;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openFileBrowserPage"]) {
        LBFileBrowserViewController *dvc = segue.destinationViewController;
        dvc.readFile = _selectedFile;
    }
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
    
    ReadFile *readFile = _isSearching ? _searchResult[indexPath.row] : _dataSource[indexPath.row];
    cell.readFile  = readFile;
    cell.tableView = tableView;
    cell.delegate  = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearching) {
        _selectedFile = _searchResult[indexPath.row];
    } else {
        _selectedFile = _dataSource[indexPath.row];
    }
    [self performSegueWithIdentifier:@"openFileBrowserPage" sender:self];
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
    [_searchBar resignFirstResponder];
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
    
    ReadFile *readFile = cell.readFile;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSInteger tag = ((UIButton *)actionInfo).tag;
    
    if (tag == 0) {
        
        if (!_exportManager) {
            _exportManager =[[LBExportManager alloc] init];
        }
        
        NSString *filePath = [[LBReadFileFileManager defaultManager] pathForReadFileImage:readFile.fileID];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        [_exportManager openDocImage:image withHolder:self];
        
    } else if (tag == 1) {
        
        readFile.favourite = @(!readFile.favourite.boolValue);
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        
    } else if (tag == 2) {
        ReadFile *file = _dataSource[indexPath.row];
        [_dataSource removeObject:file];
        [LBReadFileManager deleteReadFile:file];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
