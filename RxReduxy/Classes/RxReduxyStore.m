//
//  RxReduxyStore.m
//  Pods
//
//  Created by skyofdwarf on 2019. 1. 7..
//

#import "RxReduxyStore.h"

@interface RxReduxyStore () <ReduxyStoreSubscriber>
@property (strong, nonatomic) RACBehaviorSubject<ReduxyState> *stateSubject;
@property (strong, nonatomic) RACSignal<ReduxyState> *stateSignal;
@property (strong, nonatomic) ReduxyStore *store;
@end

@implementation RxReduxyStore

- (instancetype)initWithState:(ReduxyState)state
                      reducer:(ReduxyReducer)reducer
                  middlewares:(NSArray<ReduxyMiddleware> *)middlewares
                      actions:(NSArray *)actions
{
    self = [super init];
    if (self) {
        self.stateSubject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:state];
        self.stateSignal = [self.stateSubject replayLast];
        
        self.store = [ReduxyStore storeWithState:state
                                         reducer:reducer
                                     middlewares:middlewares
                                         actions:actions];
        [self.store subscribe:self];
    }
    return self;
}

- (RACSignal<ReduxyState> *)state {
    return self.stateSignal;
}

- (id)dispatch:(ReduxyAction)action {
    return [self.store dispatch:action];
}

- (id)dispatch:(ReduxyActionType)type payload:(ReduxyActionPayload)payload {
    return [self.store dispatch:type payload:payload];
}

#pragma mark - ReduxyStoreSubscriber

- (void)store:(id<ReduxyStore>)store didChangeState:(ReduxyState)state byAction:(ReduxyAction)action {
    NSLog(@"didChangeState: %@", state);
    [self.stateSubject sendNext:state];
}

@end
