//
//  IFLPresent.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "IFLPresent.h"
#import <objc/runtime.h>
#import "IFLCellModel.h"

@implementation IFLPresent

- (instancetype)init {
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

- (int)operate:(int)opt indexPath:(NSIndexPath *)indexPath {
    if (opt == 0) { // -
        return --((IFLCellModel *)self.dataArray[indexPath.row]).num;
    }
    if (opt == 1) { // +
        return ++((IFLCellModel *)self.dataArray[indexPath.row]).num;
    }
    return 0;
}

- (void)loadData {
    NSArray *mArray = @[
        @{
          @"avatar": @"https://randomuser.me/api/portraits/thumb/women/83.jpg",
          @"name": @"Jason Taylor",
          @"num": @59
        },
        @{
          @"avatar": @"https://randomuser.me/api/portraits/thumb/women/22.jpg",
          @"name": @"Kevin Moore",
          @"num": @78
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/55.jpg",
            @"name": @"William Young",
            @"num": @45
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/78.jpg",
            @"name": @"Brian Clark",
            @"num": @51
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/97.jpg",
            @"name": @"Eric Robinson",
            @"num": @93
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/84.jpg",
            @"name": @"David Wilson",
            @"num": @92
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/67.jpg",
            @"name": @"Deborah Jackson",
            @"num": @98
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/74.jpg",
            @"name": @"Michael Miller",
            @"num": @94
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/69.jpg",
            @"name": @"Jessica Brown",
            @"num": @20
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/92.jpg",
            @"name": @"Paul Garcia",
            @"num": @49
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/58.jpg",
            @"name": @"Ruth Anderson",
            @"num": @22
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/88.jpg",
            @"name": @"Brenda White",
            @"num": @75
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/99.jpg",
            @"name": @"Kevin Martin",
            @"num": @37
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/39.jpg",
            @"name": @"Kimberly Brown",
            @"num": @90
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/55.jpg",
            @"name": @"Sandra Brown",
            @"num": @71
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/41.jpg",
            @"name": @"Brenda Lee",
            @"num": @24
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/90.jpg",
            @"name": @"Jennifer Thomas",
            @"num": @84
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/39.jpg",
            @"name": @"Carol Allen",
            @"num": @78
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/30.jpg",
            @"name": @"Michael Davis",
            @"num": @84
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/38.jpg",
            @"name": @"Kevin Allen",
            @"num": @35
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/55.jpg",
            @"name": @"Edward Martin",
            @"num": @70
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/38.jpg",
            @"name": @"Donald Moore",
            @"num": @71
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/79.jpg",
            @"name": @"Robert Jones",
            @"num": @100
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/62.jpg",
            @"name": @"Carol Gonzalez",
            @"num": @37
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/32.jpg",
            @"name": @"Matthew Robinson",
            @"num": @58
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/62.jpg",
            @"name": @"Robert White",
            @"num": @53
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/79.jpg",
            @"name": @"Mary Davis",
            @"num": @91
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/59.jpg",
            @"name": @"Daniel Perez",
            @"num": @48
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/41.jpg",
            @"name": @"Timothy Anderson",
            @"num": @52
        },
        @{
            @"avatar": @"https://randomuser.me/api/portraits/thumb/women/91.jpg",
            @"name": @"Richard Anderson",
            @"num": @25
        }
    ];
    
    self.dataArray = [NSMutableArray array];
    
    NSMutableArray *nArray = [NSMutableArray arrayWithCapacity:1];
    
    unsigned int mCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([IFLCellModel class], &mCount);
    for (int i = 0; i < mCount; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
//        const char *attributes = property_getAttributes(property);
//        NSLog(@"name = %s, attributes = %s", name, attributes);
        
        [nArray addObject:[NSString stringWithFormat:@"%s", name]];
    }
    free(propertyList);
    
    for (int i = 0; i < [mArray count]; i++) {
        id model = [[IFLCellModel alloc] init];
        for (int j = 0; j < [nArray count]; j++) {
            [model setValue:mArray[i][nArray[j]] forKey:nArray[j]];
        }
        [self.dataArray addObject:model];
    }
    
}

@end
