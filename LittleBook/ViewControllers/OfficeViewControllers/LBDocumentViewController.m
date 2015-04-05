//
//  LBDocumentViewController.m
//  LittleBook
//
//  Created by hupeng on 15/3/4.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "LBDocumentViewController.h"
#import "LBReadListCell.h"

@interface LBDocumentViewController () <UITableViewDataSource ,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LBDocumentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)editButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"openEditPage" sender:self];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBReadListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBReadListCell"];
    
    return cell;
}
@end
