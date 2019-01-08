//
//  RxReduxyStore.h
//  Pods
//
//  Created by skyofdwarf on 2019. 1. 7..
//

@import Reduxy;
@import ReactiveObjC;

NS_ASSUME_NONNULL_BEGIN

@interface RxReduxyStore : NSObject

- (instancetype)initWithState:(ReduxyState)state
                      reducer:(ReduxyReducer)reducer
                  middlewares:(NSArray<ReduxyMiddleware> *)middlewares
                      actions:(NSArray *)actions;

- (RACSignal<ReduxyState> *)state;

- (id)dispatch:(ReduxyAction)action;    
- (id)dispatch:(ReduxyActionType)type payload:(ReduxyActionPayload)payload;
@end

NS_ASSUME_NONNULL_END
