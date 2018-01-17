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

typedef NS_ENUM(NSInteger, BJLPSWebSocketMode) {
    BJLPSWebSocketModeClient = 0,
    BJLPSWebSocketModeServer
};

typedef NS_ENUM(NSInteger, BJLPSWebSocketErrorCodes) {
    BJLPSWebSocketErrorCodeUnknown = 0,
    BJLPSWebSocketErrorCodeTimedOut,
    BJLPSWebSocketErrorCodeHandshakeFailed,
    BJLPSWebSocketErrorCodeConnectionFailed
};

typedef NS_ENUM(NSInteger, BJLPSWebSocketStatusCode) {
    BJLPSWebSocketStatusCodeNormal = 1000,
    BJLPSWebSocketStatusCodeGoingAway = 1001,
    BJLPSWebSocketStatusCodeProtocolError = 1002,
    BJLPSWebSocketStatusCodeUnhandledType = 1003,
    // 1004 reserved
    BJLPSWebSocketStatusCodeNoStatusReceived = 1005,
    // 1006 reserved
    BJLPSWebSocketStatusCodeInvalidUTF8 = 1007,
    BJLPSWebSocketStatusCodePolicyViolated = 1008,
    BJLPSWebSocketStatusCodeMessageTooBig = 1009
};

#define BJLPSWebSocketGUID @"258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
#define BJLPSWebSocketErrorDomain @"BJLPSWebSocketErrorDomain"

// NSError userInfo keys, used with PSWebSocketErrorCodeHandshakeFailed:
#define BJLPSHTTPStatusErrorKey @"HTTPStatus"      // The HTTP status (404, etc.)
#define BJLPSHTTPResponseErrorKey @"HTTPResponse"  // The entire HTTP response as an CFHTTPMessageRef
