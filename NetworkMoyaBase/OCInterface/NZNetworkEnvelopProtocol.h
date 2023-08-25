//
//  NZNetworkEnvelopProtocol.h
//  nfzm
//
//  Created by anthony zhu
//

#ifndef NZNetworkEnvelopProtocol_h
#define NZNetworkEnvelopProtocol_h

@protocol NZNetworkEnvelopProtocol <NSObject>

- (id)getData;

- (id)getBizData;

- (void)setBizData:(id)model;

@end

#endif /* NZNetworkEnvelopProtocol_h */
