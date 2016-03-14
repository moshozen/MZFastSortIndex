//
//  NSArray+SortIndexTests.m
//
//  Created by Mat Trudel on 03/11/2016.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

@import XCTest;

#import "NSArray+SortIndex.h"
#import "NSNumber+SortIndex.h"
#import "SortableObject.h"

@interface NSArraySortIndexTests : XCTestCase
@end

@implementation NSArraySortIndexTests

- (NSNumber *)numberInIndexWithNumerator:(NSInteger)numerator andDenominator:(NSInteger)denominator
{
    long long base = [[NSNumber mz_minimumSortIndex] longLongValue];
    long long range = [[NSNumber mz_maximumSortIndex] longLongValue] - [[NSNumber mz_minimumSortIndex] longLongValue];
    return @(base + range * numerator / denominator);
}

- (void)testSortingSingleObject
{
    SortableObject *obj = [SortableObject new];
    NSArray *array = @[obj];
    [array mz_sortObject:obj toBeBetween:nil and:nil withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBeforeSingleObject
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj2.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj, obj2];
    [array mz_sortObject:obj toBeBetween:nil and:obj2 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingAfterSingleObject
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj, obj2];
    [array mz_sortObject:obj2 toBeBetween:obj and:nil withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBetweenExistingObjects
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @0;
    obj3.index = @100;

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj2 toBeBetween:obj and:obj3 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, @0);
    XCTAssertEqualObjects(obj2.index, @50);
    XCTAssertEqualObjects(obj3.index, @100);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBetweenAdjacentObjects
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];
    obj3.index = @([[self numberInIndexWithNumerator:1 andDenominator:2] mz_sortValue] + 1);

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj2 toBeBetween:obj and:obj3 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:4 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:5 andDenominator:6]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBetweenAdjacentObjectsWithNoForwardSortRoomLeftWithPartialReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    SortableObject *obj4 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];
    obj2.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj4.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3, obj4];
    [array mz_sortObject:obj3 toBeBetween:obj2 and:obj4 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:4 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:5 andDenominator:6]);
    XCTAssertEqualObjects(obj4.index, [NSNumber mz_maximumSortIndex]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBetweenAdjacentObjectsWithNoForwardSortRoomLeftWithCompleteReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj3.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj2 toBeBetween:obj and:obj3 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
    XCTAssertEqualObjects(obj3.index, [NSNumber mz_maximumSortIndex]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBeforeMultipleObjectsWithNoForwardSortRoomLeft
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    SortableObject *obj4 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 2);
    obj3.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj4.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3, obj4];
    [array mz_sortObject:obj2 toBeBetween:obj and:obj3 withSortKey:@"index"];

    long long base = [[NSNumber mz_minimumSortIndex] longLongValue];
    long long range = ([[NSNumber mz_maximumSortIndex] longLongValue] - 1) - [[NSNumber mz_minimumSortIndex] longLongValue];

    XCTAssertEqualObjects(obj.index,  @(base + range / 3));
    XCTAssertEqualObjects(obj2.index, @(base + range * 2 / 3));
    XCTAssertEqualObjects(obj3.index, @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1));
    XCTAssertEqualObjects(obj4.index, [NSNumber mz_maximumSortIndex]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBetweenAdjacentObjectsWithMinimalForwardReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    SortableObject *obj4 = [SortableObject new];
    SortableObject *obj5 = [SortableObject new];
    SortableObject *obj6 = [SortableObject new];
    obj.index = @1;
    obj2.index = @2;
    obj3.index = @3;
    obj4.index = @4;
    obj5.index = @5;
    obj6.index = @7;

    NSArray *array = @[obj, obj2, obj3, obj4, obj5, obj6];
    [array mz_sortObject:obj4 toBeBetween:obj2 and:obj3 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, @1);
    XCTAssertEqualObjects(obj2.index, @2);
    XCTAssertEqualObjects(obj4.index, @3);
    XCTAssertEqualObjects(obj3.index, @4);
    XCTAssertEqualObjects(obj5.index, @5);
    XCTAssertEqualObjects(obj6.index, @7);
}

- (void)testSortingBeforeFirstObjectWithPartialReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj2.index = [NSNumber mz_minimumSortIndex];
    obj3.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj toBeBetween:nil and:obj2 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:6]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBeforeFirstObjectWithCompleteReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj2.index = [NSNumber mz_minimumSortIndex];
    obj3.index = @([[NSNumber mz_minimumSortIndex] mz_sortValue] + 1);

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj toBeBetween:nil and:obj2 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingAfterLastObjectWithPartialReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];
    obj2.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj3 toBeBetween:obj2 and:nil withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:4 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:5 andDenominator:6]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingAfterLastObjectWithCompleteReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj2.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_sortObject:obj3 toBeBetween:obj2 and:nil withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingAtStartOfEmptyArray
{
    SortableObject *obj = [SortableObject new];

    NSArray *array = @[];
    [array mz_sortObject:obj toStartOfArrayWithSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingAtStartOfNonEmptyArray
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj2.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj2];
    [array mz_sortObject:obj toStartOfArrayWithSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingAtStartOfNonEmptyArrayWithNoSpaceAtStart
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj2.index = [NSNumber mz_minimumSortIndex];

    NSArray *array = @[obj2];
    [array mz_sortObject:obj toStartOfArrayWithSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
}

- (void)testSortingAtEndOfEmptyArray
{
    SortableObject *obj = [SortableObject new];

    NSArray *array = @[];
    [array mz_sortObject:obj toEndOfArrayWithSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingAtEndOfNonEmptyArray
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj];
    [array mz_sortObject:obj2 toEndOfArrayWithSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)testSortingAtEndOfNonEmptyArrayWithNoSpaceAtEnd
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj];
    [array mz_sortObject:obj2 toEndOfArrayWithSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
}

@end

@interface NSArraySortIndexTestsOnLiveArray : NSArraySortIndexTests
@property NSMutableArray *array;
@end

@implementation NSArraySortIndexTestsOnLiveArray

- (void)testSortingBetweenAdjacentObjectsWithNoForwardSortRoomLeftWithCompleteReIndexOnLiveArray
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj3.index = [NSNumber mz_maximumSortIndex];

    self.array = [@[obj, obj2, obj3] mutableCopy];
    [self.array addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.array.count)] forKeyPath:@"index" options:0 context:0];
    [self.array mz_sortObject:obj2 toBeBetween:obj and:obj3 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
    XCTAssertEqualObjects(obj3.index, [NSNumber mz_maximumSortIndex]);
    XCTAssertTrue([self.array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingBeforeFirstObjectWithCompleteReIndexOnLiveArray
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj2.index = [NSNumber mz_minimumSortIndex];
    obj3.index = @([[NSNumber mz_minimumSortIndex] mz_sortValue] + 1);

    self.array = [@[obj, obj2, obj3] mutableCopy];
    [self.array addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.array.count)] forKeyPath:@"index" options:0 context:0];
    [self.array mz_sortObject:obj toBeBetween:nil and:obj2 withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
    XCTAssertTrue([self.array mz_isValidlySortedByKey:@"index"]);
}

- (void)testSortingAfterLastObjectWithCompleteReIndexOnLiveArray
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj2.index = [NSNumber mz_maximumSortIndex];

    self.array = [@[obj, obj2, obj3] mutableCopy];
    [self.array addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.array.count)] forKeyPath:@"index" options:0 context:0];
    [self.array mz_sortObject:obj3 toBeBetween:obj2 and:nil withSortKey:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
    XCTAssertTrue([self.array mz_isValidlySortedByKey:@"index"]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self.array sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
}

@end


@interface IsValidlySortedTests : XCTestCase
@end

@implementation IsValidlySortedTests

- (void)testIsValidlySortedPositiveTest
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @1;
    obj2.index = @2;
    obj3.index = @3;

    NSArray *array = @[obj, obj2, obj3];

    XCTAssertTrue([array mz_isValidlySortedByKey:@"index"]);
}

- (void)testIsValidlySortedNegativeTest
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @1;
    obj2.index = @2;
    obj3.index = @3;

    NSArray *array = @[obj3, obj2, obj];

    XCTAssertFalse([array mz_isValidlySortedByKey:@"index"]);
}

@end
