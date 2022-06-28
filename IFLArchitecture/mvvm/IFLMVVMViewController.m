//
//  IFLMVVMViewController.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "IFLMVVMViewController.h"
#import "IFLList1Presenter.h"
#import "IFLCommMacro.h"

@interface IFLMVVMViewController ()

@end

@implementation IFLMVVMViewController


- (void)viewDidLoad {
    // 配置mvp
    [self configMVP:@"list1" configAdapter:YES];
    [super viewDidLoad];
    
    IFL(self.context.view, IFLList1PresenterProtocol, createView);
    // 订阅
    IFL(self.context.view, IFLBasePresenterProtocol, subscribe);
    IFL(self.context.presenter, IFLList1PresenterProtocol, loadData:@"http://rap2api.taobao.org/app/mock/303994/test/dbbooklist");
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
