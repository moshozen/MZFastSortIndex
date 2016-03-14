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

- (BOOL)isArray:(NSArray *)array validlySortedByKey:(NSString *)key
{
    return [[array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]] isEqualToArray:array];
}

- (void)testInsertionSingleObject
{
    SortableObject *obj = [SortableObject new];
    NSArray *array = @[];
    [array mz_setSortKey:@"index" onObject:obj toLieAtSortedIndex:0];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testInsertionBeforeSingleObject
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj2.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj2];
    [array mz_setSortKey:@"index" onObject:obj toLieAtSortedIndex:0];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testInsertionAfterSingleObject
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj];
    [array mz_setSortKey:@"index" onObject:obj2 toLieAtSortedIndex:1];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)testSortingBetweenExistingObjects
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @0;
    obj3.index = @100;

    NSArray *array = @[obj, obj2, obj3];
    [array mz_setSortKey:@"index" onObject:obj2 toLieAtSortedIndex:1];

    XCTAssertEqualObjects(obj.index, @0);
    XCTAssertEqualObjects(obj2.index, @50);
    XCTAssertEqualObjects(obj3.index, @100);
}

- (void)testSortingBetweenAdjacentObjects
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];
    obj3.index = @([[self numberInIndexWithNumerator:1 andDenominator:2] mz_sortValue] + 1);

    NSArray *array = @[obj, obj2, obj3];
    [array mz_setSortKey:@"index" onObject:obj2 toLieAtSortedIndex:1];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:4 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:5 andDenominator:6]);
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
    [array mz_setSortKey:@"index" onObject:obj3 toLieAtSortedIndex:2];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:4 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:5 andDenominator:6]);
    XCTAssertEqualObjects(obj4.index, [NSNumber mz_maximumSortIndex]);
}

- (void)testSortingBetweenAdjacentObjectsWithNoForwardSortRoomLeftWithCompleteReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj3.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_setSortKey:@"index" onObject:obj2 toLieAtSortedIndex:1];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
    XCTAssertEqualObjects(obj3.index, [NSNumber mz_maximumSortIndex]);
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
    [array mz_setSortKey:@"index" onObject:obj2 toLieAtSortedIndex:1];

    long long base = [[NSNumber mz_minimumSortIndex] longLongValue];
    long long range = ([[NSNumber mz_maximumSortIndex] longLongValue] - 1) - [[NSNumber mz_minimumSortIndex] longLongValue];

    XCTAssertEqualObjects(obj.index,  @(base + range / 3));
    XCTAssertEqualObjects(obj2.index, @(base + range * 2 / 3));
    XCTAssertEqualObjects(obj3.index, @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1));
    XCTAssertEqualObjects(obj4.index, [NSNumber mz_maximumSortIndex]);
}

- (void)testSortingBackwardsBetweenAdjacentObjectsWithMinimalForwardReIndex
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
    [array mz_setSortKey:@"index" onObject:obj4 toLieAtSortedIndex:2];

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
    [array mz_setSortKey:@"index" onObject:obj toLieAtSortedIndex:0];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:6]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingBeforeFirstObjectWithCompleteReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj2.index = [NSNumber mz_minimumSortIndex];
    obj3.index = @([[NSNumber mz_minimumSortIndex] mz_sortValue] + 1);

    NSArray *array = @[obj, obj2, obj3];
    [array mz_setSortKey:@"index" onObject:obj toLieAtSortedIndex:0];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)testSortingAfterLastObjectWithPartialReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];
    obj2.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_setSortKey:@"index" onObject:obj3 toLieAtSortedIndex:2];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:4 andDenominator:6]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:5 andDenominator:6]);
}

- (void)testSortingAfterLastObjectWithCompleteReIndex
{
    SortableObject *obj = [SortableObject new];
    SortableObject *obj2 = [SortableObject new];
    SortableObject *obj3 = [SortableObject new];
    obj.index = @([[NSNumber mz_maximumSortIndex] mz_sortValue] - 1);
    obj2.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj, obj2, obj3];
    [array mz_setSortKey:@"index" onObject:obj3 toLieAtSortedIndex:2];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)testSortingAtStartOfEmptyArray
{
    NSArray *array = @[];
    id index = [array mz_valueForKeyToLieAtStartOfSortedArray:@"index"];

    XCTAssertEqualObjects(index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingAtStartOfNonEmptyArray
{
    SortableObject *obj2 = [SortableObject new];
    obj2.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj2];
    id index = [array mz_valueForKeyToLieAtStartOfSortedArray:@"index"];

    XCTAssertEqualObjects(index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingAtStartOfNonEmptyArrayWithNoSpaceAtStart
{
    SortableObject *obj2 = [SortableObject new];
    obj2.index = [NSNumber mz_minimumSortIndex];

    NSArray *array = @[obj2];
    id index = [array mz_valueForKeyToLieAtStartOfSortedArray:@"index"];

    XCTAssertEqualObjects(index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
}

- (void)testSortingAtEndOfEmptyArray
{
    NSArray *array = @[];
    id index = [array mz_valueForKeyToLieAtEndOfSortedArray:@"index"];

    XCTAssertEqualObjects(index, [self numberInIndexWithNumerator:1 andDenominator:2]);
}

- (void)testSortingAtEndOfNonEmptyArray
{
    SortableObject *obj = [SortableObject new];
    obj.index = [self numberInIndexWithNumerator:1 andDenominator:2];

    NSArray *array = @[obj];
    id index = [array mz_valueForKeyToLieAtEndOfSortedArray:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(index, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)testSortingAtEndOfNonEmptyArrayWithNoSpaceAtEnd
{
    SortableObject *obj = [SortableObject new];
    obj.index = [NSNumber mz_maximumSortIndex];

    NSArray *array = @[obj];
    id index = [array mz_valueForKeyToLieAtEndOfSortedArray:@"index"];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(index, [self numberInIndexWithNumerator:2 andDenominator:3]);
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
    [self.array mz_setSortKey:@"index" onObject:obj2 toLieAtSortedIndex:1];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:3]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:2 andDenominator:3]);
    XCTAssertEqualObjects(obj3.index, [NSNumber mz_maximumSortIndex]);
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
    [self.array mz_setSortKey:@"index" onObject:obj toLieAtSortedIndex:0];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
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
    [self.array mz_setSortKey:@"index" onObject:obj3 toLieAtSortedIndex:2];

    XCTAssertEqualObjects(obj.index, [self numberInIndexWithNumerator:1 andDenominator:4]);
    XCTAssertEqualObjects(obj2.index, [self numberInIndexWithNumerator:1 andDenominator:2]);
    XCTAssertEqualObjects(obj3.index, [self numberInIndexWithNumerator:3 andDenominator:4]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self.array sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
}

@end
