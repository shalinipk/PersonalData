//
//  PDHomeViewController.m
//  PersonalData
//
//  Created by Shalini Kamala on 10/26/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import "PDHomeViewController.h"
#import "cell/PDCollectionViewCell.h"
#import "cell/PDHeaderCollectionViewCell.h"
#import "xml/PDXMLFeedParserHelper.h"
#import "PDDetailsViewController.h"
#import "Item.h"

#define PD_URL @"https://www.personalcapital.com/blog/feed/?cat=3,891,890,68,284"

@interface PDHomeViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate, UICollectionViewDataSource, PDXMLFeedParserHelperDelegate, UICollectionViewDelegateFlowLayout> {
    bool collectionViewSizeChanged;

}
@property UIActivityIndicatorView* spinner;
@end

@implementation PDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    collectionViewSizeChanged = false;
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[PDCollectionViewCell class] forCellWithReuseIdentifier:@"PDCollectionViewCell"];
    
    [self.collectionView registerClass:[PDHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"PDHeaderCollectionViewCell"];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"               style:UIBarButtonItemStylePlain target:self action:@selector(onRefresh:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    self.spinner.center = self.view.center;
    
    [self fetchFeed];
    
}
- (BOOL)automaticallyAdjustsScrollViewInsets;
{
    return NO;
}
-(IBAction)onRefresh:(id)sender
{
    [self fetchFeed];
}
-(void) fetchFeed {
    
    [self.spinner startAnimating];
    
    NSURL *url = [NSURL URLWithString:PD_URL];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              // 4: Handle response here
                                              if(error == nil && data!=nil) {
                                                  [self parseXMLFeed:data];
                                              } else {
                                                  
                                              }
                                          }];
    
    [downloadTask resume];
    
}

-(void) parseXMLFeed : (NSData*) data {
    PDXMLFeedParserHelper* parserHelper = [[PDXMLFeedParserHelper alloc] initWithData:data];
    [parserHelper setDelegate:self];
    [parserHelper startParsing];
    
}

-(void) setItems:(NSArray*) items {
    _cellItems = items;
    dispatch_async(dispatch_get_main_queue(), ^{
         [_collectionView reloadData];
        [self.spinner stopAnimating];
    });
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UICollectionViewDatasource - required implementation
- (Item *)itemAtIndexPath:(NSIndexPath *)indexPath;
{
    return _cellItems[indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _cellItems.count;
}




// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Item *pdItem = _cellItems[indexPath.row];
    if([indexPath row] == 0) {
        PDHeaderCollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"PDHeaderCollectionViewCell" forIndexPath:indexPath];
        cell.pdItem = pdItem;
        [cell updateImageForItem:pdItem];
        return cell;
    }else {
        PDCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PDCollectionViewCell" forIndexPath:indexPath];
        cell.pdItem = pdItem;
        [cell updateImageForItem:pdItem];
        return cell;
    }


}

#pragma mark - Delegate

- (void)loadThumbnailsForVisibleCells:(UICollectionView *)collectionView;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *visibleCells = (NSArray *)[collectionView visibleCells];
        [visibleCells enumerateObjectsUsingBlock:^(PDCollectionViewCell *  obj, NSUInteger idx, BOOL *  stop) {
            [obj updateImageForItem:obj.pdItem];
        }];
    });
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Item *selectedItem = _cellItems[indexPath.row];

    //launch webview
    PDDetailsViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pdDetailsViewController"];
    [viewController setPdItem:selectedItem];
    [self.navigationController pushViewController:viewController animated:YES];

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewFlowLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    

    double spacing = collectionViewLayout.minimumInteritemSpacing;
    double widthPerItem;
    if([indexPath row] == 0) {//show only one cell in top most row
        widthPerItem = self.view.bounds.size.width;
    } else {
         if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
             widthPerItem = (self.view.bounds.size.width  - spacing * 2)/ 3;
         } else {
             widthPerItem = (self.view.bounds.size.width  - spacing * 2)/ 2;
         }
    }
    return CGSizeMake(widthPerItem, widthPerItem);

    
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

-(void) viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator: coordinator];
    
    collectionViewSizeChanged = true;
}

-(void) viewWillLayoutSubview {
    [super viewWillLayoutSubviews];
    
    if(collectionViewSizeChanged) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(collectionViewSizeChanged) {
        collectionViewSizeChanged = false;
        [self.collectionView performBatchUpdates:^{} completion:nil];
    }
}
@end
