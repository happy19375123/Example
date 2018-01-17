# BJPlaybackCore

## 1. 集成

- ```Podfile```里面设置```source```

``` 
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/baijia/specs.git'
```
- ```Podfile```引入```BJPlaybackCore```

```
pod 'BJPlaybackCore' 
```

## 2. 导入头文件 
``` 
#import <BJPlaybackCore/BJPlaybackCore.h>
```

## 3. 创建房间并设置播放器的代理,上报回放用户的标识符
- 创建回放的room
```
/**
创建回放的room
创建在线视频, 参数不可传空
创建本地room的话, 两个参数传nil

@param classId classId
@param token token
@return room
*/
+ (instancetype)createRoomWithClassId:(nullable NSString *)classId token:(nullable NSString *)token;
```
- 遵守协议```<BJPMProtocol>```, 设置播放器的代理
```
self.room.playbackVM.playerControl.delegate = self;


遵守协议需要实现的方法:
/**
播放过程中出错

@param playerManager 播放器实例
@param error 错误
*/
- (void)videoplayer:(BJPlayerManager *)playerManager throwPlayError:(NSError *)error;

```
- 如果有用户的标识符, 上报回放用户的标识符
```
[self.room.playbackVM setUserInfo:_userInfo];
```


## 4.进入房间
```
/**
在线视频 进入房间
*/
[self.room enter];

/**
 播放本地视频  进入房间

 @param videoPath 本地视频的路径
 @param startVideo 片头地址, 可为nil
 @param endVideo 片尾地址,可为nil
 @param path 本地信令 压缩文件的路径
 */
- (void)enterRoomWithVideoPath:(NSString *)videoPath
                    startVideo:(nullable NSString*)startVideo
                      endVideo:(nullable NSString*)endVideo
                    signalPath:(NSString *)signalPath;
```
- 需要把localVideo文件夹放到沙盒Library -> Caches下面, 才可以看本地视频
- 在APP的info.plist增加媒体资料库```NSAppleMusicUsageDescription```, 用于iOS10以上系统的手机访问本地的视频和信令文件
- iOS10以上的系统首次播放本地视频时候, 需要用户授权:
```
[self.room enterRoomWithVideoPath:self.videoPath startVideo:nil endVideo:nil signalPath:self.signalPath definition:DT_LOW status:^(BJPMediaLibraryAuthorizationStatus status) {
    if (status != BJPMediaLibraryAuthorizationStatusAuthorized) {
        //NSString *str = @"请到设置 -> 隐私 -> 媒体资料库 中打开 本APP的选项, 否则无法看本地视频";
        //code 
    }
}];
```

## 5.自定义UI

- 自定义播放器的UI
```
self.room.playbackVM.playView是播放器的view, 可自定义frame,
```
- 播放器的播放时间支持KVO回调
```
[self bjl_kvo:BJLMakeProperty(self.room.playbackVM, currentTime) observer:^BOOL(NSNumber * _Nullable old, NSNumber *  _Nullable now) {
     //code
     return YES;
}];
```

- 播放信息```self.room.playbackVM.videoInfoModel```在```roomDidEnter```之后才有信息

- 播放器的其他功能可查看```BJPPlaybackVM.h```, 调用相关的API即可实现.

## 6.设置PPT
```
self.room.slideshowViewController.view
```
## 7.退出房间
```
/** 退出教室 */
- (void)exit;
```

## 8.changeLogs

- 参见```BJLiveCore```的```wiki```(https://github.com/baijia/BJLiveCore-iOS/wiki)
- 0.1.6: fix crash, 优化回调
- 0.1.8: 增加本地视频播放的接口
- 0.2.0: 增加片头片尾广告
- 0.2.3: 更新本地播放方法, 本地信令解压失败的容错
- 0.2.5: 增加访问媒体资料库授权状态, 用于iOS10以上版本首次播放本地视频时的回调
- 0.2.6: 优化
- 0.2.7: BJPPlaybackVM.h增加属性duration,initialPlaybackTime和方法-changeDefinition:
