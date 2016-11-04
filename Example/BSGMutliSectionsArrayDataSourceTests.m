//
//  BSGMutliSectionsArrayDataSourceTests.m
//  BSGUtilities
//
//  Created by Mickaël Floc'hlay on 26/05/2016.
//  Copyright © 2016 Mickaël Floc'hlay. All rights reserved.
//

#import <XCTest/XCTest.h>
@import BSGUtilities;


@interface BSGMutliSectionsArrayDataSourceTests : XCTestCase

@property(nonatomic, strong) NSArray *array;
@property(nonatomic, strong) BSGMultiSectionsArrayDataSource *dataSource;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation BSGMutliSectionsArrayDataSourceTests

- (void)setUp {
    [super setUp];

    self.array = @[ @{ @"sectionTitle": @"Group A", @"objects": @[ @{ @"title": @"France" }, @{ @"title": @"Angleterre" }, @{ @"title": @"Italie" }]}, @{ @"sectionTitle": @"Group B", @"objects": @[ @{ @"title": @"Espagne" }]}];

    self.dataSource = [[BSGMultiSectionsArrayDataSource alloc] initWithItems:_array cellIdentifier:@"toto" configureCellBlock:^(id cell, id item) {
        // Do nothing
    }];

    self.tableView = [[UITableView alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasic {
    XCTAssertNotNil(_dataSource, @"Data source shouldn't be nil");

    XCTAssertEqual([_dataSource numberOfSectionsInTableView:_tableView], 2);
    XCTAssertEqual([_dataSource tableView:_tableView numberOfRowsInSection:0], 3);
    XCTAssertEqual([_dataSource tableView:_tableView numberOfRowsInSection:1], 1);

    NSString *section0HeaderTitle = [_dataSource tableView:_tableView titleForHeaderInSection:0];
    XCTAssertEqualObjects(section0HeaderTitle, @"Group A");

    NSString *section1HeaderTitle = [_dataSource tableView:_tableView titleForHeaderInSection:1];
    XCTAssertEqualObjects(section1HeaderTitle, @"Group B");

    NSDictionary *item = [_dataSource itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    XCTAssertEqualObjects([item objectForKey:@"title"], @"Italie");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
