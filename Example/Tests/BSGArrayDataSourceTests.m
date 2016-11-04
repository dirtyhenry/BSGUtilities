//
//  BSGArrayDataSourceTests.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 26/08/2015.
//  Copyright (c) 2015 Mickaël Floc'hlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
@import BSGUtilities;

@interface BSGArrayDataSourceTests : XCTestCase

@property (strong, nonatomic) BSGArrayDataSource *arrayDataSource;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation BSGArrayDataSourceTests

- (void)setUp {
    [super setUp];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    self.arrayDataSource = [[BSGArrayDataSource alloc] initWithItems:@[ @"0" ] cellIdentifier:@"cellIdentifier" configureCellBlock:^(id cell, id item) {

    }];
}

- (void)tearDown {
    self.arrayDataSource = nil;
    [super tearDown];
}

- (void)testNumberOfSectionsInTableView {
    XCTAssert([self.arrayDataSource numberOfSectionsInTableView:self.tableView] == 1);
}

@end
