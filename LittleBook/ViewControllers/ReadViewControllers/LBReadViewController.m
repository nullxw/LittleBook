//
//  ReadListViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/3.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBReadViewController.h"
#import "LBDocumentListCell.h"
#import "LBReadFileManager.h"
#import "LBDocumentManager.h"

@interface LBReadViewController () <UITableViewDataSource ,UITableViewDelegate, HPCallBackProtocol>
{
    NSMutableArray *_dataSource;
    ReadFile *_selectedFile;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBDocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBDocumentListCell"];
    
    ReadFile *readFile = _dataSource[indexPath.row];
    
    Document *doc = [LBDocumentManager findByID:readFile.fileID];
    
    cell.document = doc;
    cell.tableView = tableView;
    cell.delegate  = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedFile = _dataSource[indexPath.row];
    [self performSegueWithIdentifier:@"openFileBrowserPage" sender:self];
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
        ReadFile *file = _dataSource[indexPath.row];
        [_dataSource removeObject:file];
        [LBReadFileManager deleteReadFile:file];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    
}

@end
