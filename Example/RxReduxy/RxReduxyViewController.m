//
//  RxReduxyViewController.m
//  RxReduxy
//
//  Created by skyofdwarf on 01/07/2019.
//  Copyright (c) 2019 skyofdwarf. All rights reserved.
//

#import "RxReduxyViewController.h"

@import RxReduxy;



@interface RxReduxyViewController ()
@property (strong, nonatomic) RxReduxyStore *store;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;

@end

@implementation RxReduxyViewController

- (void)attachStore {
    ReduxyReducer valueReducer = ^ReduxyState (ReduxyState state, ReduxyAction action) {
        NSNumber *value = action.payload;
        NSNumber *currentValue = state;
        
        if ([action is:ratype(plus)]) {
            return @(currentValue.integerValue + value.integerValue);
        }
        else if ([action is:ratype(minus)]) {
            return @(currentValue.integerValue - value.integerValue);
        }
        
        return state ?: @0;
    };
    
    ReduxyReducer reducer = ^ReduxyState(ReduxyState state, ReduxyAction action) {
        return @{ @"value": valueReducer(state[@"value"], action) };
    };
    
    self.store = [[RxReduxyStore alloc] initWithState:reducer(nil, nil)
                                              reducer:reducer
                                          middlewares:@[]
                                              actions:@[ ratype(plus), ratype(minus) ]];
}

- (void)bindActions {
    @weakify(self);
    self.plusButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.store dispatch:raction(plus, @1)];
        return RACSignal.empty;
    }];
    
    self.minusButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        [self.store dispatch:raction(plus, @1)];
        return RACSignal.empty;
    }];
}

- (void)bindState {
    [[self.store.state map:^id _Nullable(ReduxyState  _Nullable state) {
        return state[@"value"];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"1 state next: %@", x);
    }];
    
    [[self.store.state map:^id _Nullable(ReduxyState  _Nullable state) {
        return state[@"value"];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 state next: %@", x);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self attachStore];
    
    [self bindActions];
    [self bindState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
