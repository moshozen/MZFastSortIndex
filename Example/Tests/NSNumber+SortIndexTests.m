//
//  NSNumber+SortIndexTests.m
//
//  Created by Mat Trudel on 2016-03-11.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

@import XCTest;

#import "NSNumber+SortIndex.h"

@interface SortIndexTests : XCTestCase
@end

@implementation SortIndexTests

- (NSNumber *)numberInIndexWithNumerator:(NSInteger)numerator andDenominator:(NSInteger)denominator
{
    long long base = [[NSNumber mz_minimumSortIndex] longLongValue];
    long long range = [[NSNumber mz_maximumSortIndex] longLongValue] - [[NSNumber mz_minimumSortIndex] longLongValue];
    return @(base + ((range * numerator) / denominator));
}

- (void)testWithNoBeforeOrAfter {
    NSNumber *result = [NSNumber mz_sortIndexBetween:nil and:nil];
    XCTAssertEqualObjects(result, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testWithNoBefore {
    NSNumber *result = [NSNumber mz_sortIndexBetween:nil and:[self numberInIndexWithNumerator:1 andDenominator:2]];
    XCTAssertEqualObjects(result, [self numberInIndexWithNumerator:1 andDenominator:4]);
}

- (void)testWithNoBeforeAfterAtMin {
    NSNumber *result = [NSNumber mz_sortIndexBetween:nil and:[NSNumber mz_minimumSortIndex]];
    XCTAssertEqualObjects(result, nil);
}

- (void)testWithNoBeforeAfterNotQuiteAtMin {
    NSNumber *result = [NSNumber mz_sortIndexBetween:nil and:@([[NSNumber mz_minimumSortIndex] mz_sortValue] + 1)];
    XCTAssertEqualObjects(result, [NSNumber mz_minimumSortIndex]);
}

- (void)testWithNoAfter {
    NSNumber *result = [NSNumber mz_sortIndexBetween:[self numberInIndexWithNumerator:2 andDenominator:4] and:nil];
    XCTAssertEqualObjects(result, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)testWithNoAfterBeforeAtMax {
    NSNumber *result = [NSNumber mz_sortIndexBetween:[NSNumber mz_maximumSortIndex] and:nil];
    XCTAssertEqualObjects(result, nil);
}

- (void)testBetweenTwoDistantValues {
    NSNumber *result = [NSNumber mz_sortIndexBetween:@100 and:@200];
    XCTAssertEqualObjects(result, @150);
}

- (void)testBetweenTwoAdjacentValues {
    NSNumber *result = [NSNumber mz_sortIndexBetween:@100 and:@101];
    XCTAssertEqualObjects(result, nil);
}

@end

@interface IndexEqualityTests : XCTestCase
@end

@implementation IndexEqualityTests

- (void)testMinimumIndexPositive {
    XCTAssertEqual([[NSNumber mz_minimumSortIndex] mz_isMinimumSortIndex], YES);
}

- (void)testMinimumIndexNegative {
    XCTAssertEqual([@([[NSNumber mz_minimumSortIndex] mz_sortValue] + 1) mz_isMinimumSortIndex], NO);
}

- (void)testMaximumIndexPositive {
    XCTAssertEqual([[NSNumber mz_maximumSortIndex] mz_isMaximumSortIndex], YES);
}

- (void)testMaximumIndexNegative {
    XCTAssertEqual([@([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1) mz_isMaximumSortIndex], NO);
}

@end
