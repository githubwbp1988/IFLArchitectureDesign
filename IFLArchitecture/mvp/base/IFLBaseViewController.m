//
//  IFLBaseViewController.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLBaseViewController.h"

@interface IFLBaseViewController ()

@property (nonatomic, strong)IFLContext    *rootContext;

@end

@implementation IFLBaseViewController

- (void)configMVP:(NSString *)name configAdapter:(BOOL)configAdapter {
    // 由于 context 是分类获取关联对象，所以需要 先通过属性 rootContext持有一下，否则context分配内存 赋值完就会释放
    self.rootContext = [[IFLContext alloc] init];
    self.context = self.rootContext;
    
    // 驼峰命名法
    NSString *configName = [NSString stringWithFormat:@"%@%@", [[name substringToIndex:1] capitalizedString], [name substringFromIndex:1]];
    
    
    // presenter  format - IFL + name + Presenter
    Class presenterClass = NSClassFromString([NSString stringWithFormat:@"IFL%@Presenter", configName]);
    if (presenterClass) {
        self.context.presenter = [presenterClass new];
        self.context.presenter.context = self.context;
    }
    
    // interactor  format - IFL + name + Interactor
    Class interactorClass = NSClassFromString([NSString stringWithFormat:@"IFL%@Interactor", configName]);
    if (interactorClass) {
        self.context.interactor = [interactorClass new];
        self.context.interactor.context = self.context;
    }
    
 
    // view  format - IFL + name + View
    Class viewClass = NSClassFromString([NSString stringWithFormat:@"IFL%@View", configName]);
    if (viewClass) {
        self.context.view = [viewClass new];
        self.context.view.context = self.context;
    }
    
    // adapter  format - IFL + name + Adapter
    if (configAdapter) {
        Class adapterClass = NSClassFromString([NSString stringWithFormat:@"IFL%@Adapter", configName]);
        if (adapterClass) {
            self.context.adapter = [adapterClass new];
            self.context.adapter.context = self.context;
        }
    }
    
    // create releation
    if (self.context.presenter && self.context.interactor && self.context.view) {
        self.context.presenter.viewController = self;
        self.context.presenter.view = self.context.view;
        
        self.context.interactor.viewController = self;
        
        self.context.view.presenter = self.context.presenter;
        self.context.view.interactor = self.context.interactor;
        
        if (self.context.adapter) {
            self.context.presenter.adapter = self.context.adapter;
            self.context.adapter.presenter = self.context.presenter;
            
            self.context.view.adapter = self.context.adapter;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context.view.frame = self.view.bounds;
    self.view = self.context.view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
