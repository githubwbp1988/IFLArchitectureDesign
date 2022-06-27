//
//  IFLBaseAdapter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLBaseAdapter.h"

@interface IFLBaseAdapter ()

@property(nonatomic, strong)NSMutableArray *array;

@end

@implementation IFLBaseAdapter

- (instancetype)init {
    if (self = [super init]) {
        _array = [NSMutableArray new];
    }
    return self;
}

- (void)configData:(NSArray *)modelArray {
    if (!_array) {
        _array = [NSMutableArray arrayWithCapacity:4];
    } else {
        [_array removeAllObjects];
    }
    [_array addObjectsFromArray:modelArray];
}

- (id)getModel:(NSInteger)index {
    if (!_array || index >= [_array count]) {
        return nil;
    }
    return _array[index];
}
- (NSInteger)dataCount {
    if (!_array) {
        return 0;
    }
    return _array.count;
}

- (void)needRefresh {
    self.refresh = @"1";
}

#pragma mark UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cellModel = self.array[indexPath.row];
    
//    CCSuppressPerformSelectorLeakWarning();  - Implicit declaration of function 'CCSuppressPerformSelectorLeakWarning' is invalid in C99
    NSArray *args = @[tableView, cellModel, indexPath];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    // performSelect 参数超过3个，就用字典聚合传参，如果通过Foundation - NSInvocation，不会纳入释放池管理，返回值并没有计入arc管理，需要自己处理
//    UITableViewCell *cell = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"tableView:cellFor%@:indexPath:", [cellModel class]])
//                      withObjects:args];
    UITableViewCell *cell = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"tableView:cellFor%@Dic:", [cellModel class]])
                                       withObject:tableView
                                       withObject:@{@"cellModel": cellModel, @"indexPath": indexPath}];
#pragma clang diagnostic pop
    
    return cell;
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    id res = nil;
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (!signature) {
        @throw [NSException exceptionWithName:@"selector undefined error" reason:@"method not found." userInfo:nil];
        return res;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    // remove arg: self(target) _cmd(selector)
    // 参数个数 取 argsCount 和 arrCount 中的最小值
    NSUInteger argsCount = signature.numberOfArguments - 2;
    NSUInteger arrCount = objects.count;
    
    NSUInteger mCount = MIN(argsCount, arrCount);
    for (int i = 0; i < mCount; i++) {
        id obj = objects[i];
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        [invocation setArgument:&obj atIndex:i + 2];
    }
    
    [invocation invoke];
    
    if (signature.methodReturnLength != 0) {
        [invocation getReturnValue:&res];
    }
    return res;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
