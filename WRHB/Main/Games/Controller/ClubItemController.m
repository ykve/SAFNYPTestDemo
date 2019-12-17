//
//  ClubItemController.m
//  WRHB
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubItemController.h"
#import "GamesTypeModel.h"

@interface ClubItemController ()

@end

@implementation ClubItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    GamesTypeModel *model = [[GamesTypeModel alloc] init];
    model.title = @"俱乐部";
    model.url = @"url";
    model.avatar = @"411";
    
    [itemArray addObject:model];
    self.dataArray = [itemArray copy];
    
}



@end
