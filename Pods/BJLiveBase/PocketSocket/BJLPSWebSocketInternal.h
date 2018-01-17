//  Copyright 2014-Present Zwopple Limited
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "BJLPSWebSocketTypes.h"
#import "BJLPSWebSocketDriver.h"
#import <sys/socket.h>
#import <arpa/inet.h>


typedef NS_ENUM(uint8_t, BJLPSWebSocketOpCode) {
    BJLPSWebSocketOpCodeContinuation = 0x0,
    BJLPSWebSocketOpCodeText = 0x1,
    BJLPSWebSocketOpCodeBinary = 0x2,
    // 0x3 -> 0x7 reserved
    BJLPSWebSocketOpCodeClose = 0x8,
    BJLPSWebSocketOpCodePing = 0x9,
    BJLPSWebSocketOpCodePong = 0xA,
    // 0xB -> 0xF reserved
};

static const uint8_t BJLPSWebSocketFinMask = 0x80;
static const uint8_t BJLPSWebSocketOpCodeMask = 0x0F;
static const uint8_t BJLPSWebSocketRsv1Mask = 0x40;
static const uint8_t BJLPSWebSocketRsv2Mask = 0x20;
static const uint8_t BJLPSWebSocketRsv3Mask = 0x10;
static const uint8_t BJLPSWebSocketMaskMask = 0x80;
static const uint8_t BJLPSWebSocketPayloadLenMask = 0x7F;

#define BJLPSWebSocketSetOutError(e, c, d) if(e){ *e = [BJLPSWebSocketDriver errorWithCode:c reason:d]; }

static inline void _BJLPSWebSocketLog(id self, NSString *format, ...) {
    __block va_list arg_list;
    va_start (arg_list, format);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    
    va_end(arg_list);
    
    NSLog(@"[%@]: %@", self, formattedString);
}
#define BJLPSWebSocketLog(...) _BJLPSWebSocketLog(self, __VA_ARGS__)

static inline BOOL BJLPSWebSocketOpCodeIsControl(BJLPSWebSocketOpCode opcode) {
    return (opcode == BJLPSWebSocketOpCodeClose ||
            opcode == BJLPSWebSocketOpCodePing ||
            opcode == BJLPSWebSocketOpCodePong);
};

static inline BOOL BJLPSWebSocketOpCodeIsValid(BJLPSWebSocketOpCode opcode) {
    return (opcode == BJLPSWebSocketOpCodeClose ||
            opcode == BJLPSWebSocketOpCodePing ||
            opcode == BJLPSWebSocketOpCodePong ||
            opcode == BJLPSWebSocketOpCodeText ||
            opcode == BJLPSWebSocketOpCodeBinary ||
            opcode == BJLPSWebSocketOpCodeContinuation);
};


static inline BOOL BJLPSWebSocketCloseCodeIsValid(NSInteger closeCode) {
    if(closeCode < 1000) {
        return NO;
    }
    if(closeCode >= 1000 && closeCode <= 1011) {
        if(closeCode == 1004 ||
           closeCode == 1005 ||
           closeCode == 1006) {
            return NO;
        }
        return YES;
    }
    if(closeCode >= 3000 && closeCode <= 3999) {
        return YES;
    }
    if(closeCode >= 4000 && closeCode <= 4999) {
        return YES;
    }
    return NO;
}

static inline NSOrderedSet* BJLPSHTTPHeaderFieldValues(NSString *header) {
    NSMutableOrderedSet *components = [NSMutableOrderedSet orderedSet];
    [[header componentsSeparatedByString:@";"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        while ([str hasPrefix:@" "] && str.length > 1) {
            str = [str substringWithRange:NSMakeRange(1, str.length - 1)];
        }
        while ([str hasSuffix:@" "] && str.length > 1) {
            str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
        }
        if ([str length] > 0 && ![str isEqualToString:@" "]) {
            [components addObject:str];
        }
    }];
    return components;
}

static inline NSData* BJLPSPeerAddressOfInputStream(NSInputStream *stream) {
    // First recover the socket handle from the stream:
    NSData* handleData = CFBridgingRelease(CFReadStreamCopyProperty((__bridge CFReadStreamRef)stream,
                                                                    kCFStreamPropertySocketNativeHandle));
    if(!handleData || handleData.length != sizeof(CFSocketNativeHandle)) {
        return nil;
    }
    CFSocketNativeHandle socketHandle = *(const CFSocketNativeHandle*)handleData.bytes;
    struct sockaddr_in addr;
    unsigned addrLen = sizeof(addr);
    if(getpeername(socketHandle, (struct sockaddr*)&addr,&addrLen) < 0) {
        return nil;
    }
    return [NSData dataWithBytes: &addr length: addr.sin_len];
}

static inline NSString* BJLPSPeerHostOfInputStream(NSInputStream *stream) {
    NSData *peerAddress = BJLPSPeerAddressOfInputStream(stream);
    if(!peerAddress) {
        return nil;
    }
    const struct sockaddr_in *addr = peerAddress.bytes;
    char nameBuf[INET6_ADDRSTRLEN];
    if(inet_ntop(addr->sin_family, &addr->sin_addr, nameBuf, (socklen_t)sizeof(nameBuf)) == NULL) {
        return nil;
    }
    return [NSString stringWithFormat: @"%s:%hu", nameBuf, ntohs(addr->sin_port)];
}
