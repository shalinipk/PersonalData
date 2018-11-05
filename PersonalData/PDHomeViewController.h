//
//  PDHomeViewController.h
//  PersonalData
//
//  Created by Shalini Kamala on 10/26/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) NSArray *cellItems;

@end

