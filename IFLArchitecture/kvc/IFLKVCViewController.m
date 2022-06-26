//
//  IFLKVCViewController.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "IFLKVCViewController.h"
#import "IFLKVCObject.h"

@interface IFLKVCViewController ()

@end

@implementation IFLKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    IFLKVCObject *obj = [IFLKVCObject new];
    
//    [obj setValue:@"kvc_name1" forKey:@"name"];
    
//    // accessInstanceVariablesDirectly 返回YES  根据 _<key> _is<Key> <key> is<Key> 的顺序查找变量进行设置
//    // accessInstanceVariablesDirectly 返回NO  setValue: forUndefinedKey: 会执行
//    [obj setValue:@"kvc_name11" forKey:@"name1"];
//    [obj setValue:@"kvc_name12" forKey:@"name2"];
//    [obj setValue:@"kvc_name13" forKey:@"name3"];
//    [obj setValue:@"kvc_name14" forKey:@"name4"];
    
    // value设置的顺序为 _<key> _is<Key> <key> is<Key>
    obj->name = @"ifl_name";
    // 取值顺序为   _<key> _is<Key> <key> is<Key>
    NSLog(@"get --- %@", [obj valueForKey:@"name"]);
    
    // 调用get判断顺序  get<Key>  <key>  is<Key> _<key>
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
