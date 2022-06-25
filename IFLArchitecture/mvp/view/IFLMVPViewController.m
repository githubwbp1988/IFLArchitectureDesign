//
//  IFLMVPViewController.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "IFLMVPViewController.h"
//#import "IFLMVPPresenter.h"

#import "IFLListPresenter.h"
#import "IFLCommMacro.h"

@interface IFLMVPViewController () /*<IFLViewProtocol>*/

//@property(nonatomic, strong)IFLMVPPresenter *presenter;

@end

@implementation IFLMVPViewController

- (void)viewDidLoad {
    // 配置mvp
    [self configMVP:@"list" configAdapter:YES];
    [super viewDidLoad];
//    {
//        self.presenter = [[IFLMVPPresenter alloc] init];
//        [self.presenter attach:self];
//        [self.presenter getData:@"http://rap2api.taobao.org/app/mock/303994/test/dbbooklist"];
//    }
    
    IFL(self.context.view, IFLListPresenterProtocol, createView);
    IFL(self.context.presenter, IFLListPresenterProtocol, loadData:@"http://rap2api.taobao.org/app/mock/303994/test/dbbooklist");
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

//- (void)getDataSuccess:(IFLMVPModel *)model {
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
