//
//  IFLKVOViewController.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "IFLKVOViewController.h"
#import "IFLKVOObject.h"
#import <objc/runtime.h>

@interface IFLKVOViewController ()

@property(nonatomic, strong)IFLKVOObject *mObj;

@end

static void *KVOObjectName = &KVOObjectName;
static void *KVOObjectAddress = &KVOObjectAddress;
static void *KVOObjectProgress = &KVOObjectProgress;
static void *KVOObjectMArray = &KVOObjectMArray;

@implementation IFLKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mObj = [IFLKVOObject new];
//    [self.mObj addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:KVOObjectName];
//    [self.mObj addObserver:self forKeyPath:@"nickName" options:NSKeyValueObservingOptionNew context:NULL];
//    [self.mObj addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew context:KVOObjectAddress];
//    [self.mObj addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:KVOObjectProgress];
//
//    self.mObj.mArray = [NSMutableArray array];
//
//    [self.mObj addObserver:self forKeyPath:@"mArray" options:NSKeyValueObservingOptionNew context:KVOObjectMArray];
    
    [self.mObj ifl_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:KVOObjectName];
    
    [self printClasses:[self.mObj class]];
    
    NSLog(@" ----------->>>><<<<<<--------");
    [self printClasses:object_getClass(self.mObj)];
    
    [self printClassAllMethod:object_getClass(self.mObj)];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
////    if (context == KVOObjectName) {
////        NSLog(@"keyPath = %@, name = %@, %@", keyPath, ((IFLKVOObject *)object).name, change);
////    }
////    if (context == KVOObjectAddress) {
////        NSLog(@"keyPath = %@, address = %@, %@", keyPath, ((IFLKVOObject *)object).name, change);
////    }
//
////    if (context == KVOObjectProgress) {
////        NSLog(@"keyPath = %@, progress = %@, %@", keyPath, ((IFLKVOObject *)object).progress, change);
////    }
//
//    if (context == KVOObjectMArray) {
//        NSLog(@"keyPath = %@, mArray = %@, %@", keyPath, ((IFLKVOObject *)object).mArray, change);
//    }
//}

- (void)ifl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"keyPath = %@, name = %@, %@", keyPath, ((IFLKVOObject *)object).name, change);
    }
}

- (void)dealloc {
//    [self.mObj removeObserver:self forKeyPath:@"name"];
    NSLog(@"%s", __func__);
    NSLog(@" --- 移除观察者之前 self.mObj ----> %s", object_getClassName(self.mObj));
//    [self.mObj removeObserver:self forKeyPath:@"name"];
//    [self.mObj removeObserver:self forKeyPath:@"nickName"];
//    [self.mObj removeObserver:self forKeyPath:@"address"];
//    [self.mObj removeObserver:self forKeyPath:@"progress"];
//    [self.mObj removeObserver:self forKeyPath:@"mArray"];
    NSLog(@" --- 移除观察者之后  self.mObj ----> %s", object_getClassName(self.mObj));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.mObj.name = [NSString stringWithFormat:@"%@+1", self.mObj.name];
    self.mObj.address = [NSString stringWithFormat:@"%@+3", self.mObj.address];
    self.mObj->nickName = [NSString stringWithFormat:@"%@+2", self.mObj->nickName];
    
    self.mObj.received += 1.0;
    
    
//    [self.mObj.mArray addObject:@"ss.."];
//    [[self.mObj mutableArrayValueForKey:@"mArray"] addObject:@"ss..."];
    if (self.mObj.mArray.count > 10) {
        [[self.mObj mutableArrayValueForKey:@"mArray"] replaceObjectAtIndex:5 withObject:@"5555----.."];
    } else if (self.mObj.mArray.count > 3) {
        [[self.mObj mutableArrayValueForKey:@"mArray"] insertObject:@"__11..." atIndex:0];
    } else {
        [[self.mObj mutableArrayValueForKey:@"mArray"] addObject:@"__122333ff1..."];
    }
}

- (void)printClasses:(Class)cls {
    
    /// 注册类的总数
    int count = objc_getClassList(NULL, 0);
    /// 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    /// 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}

- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p", NSStringFromSelector(sel), imp);
    }
    free(methodList);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
