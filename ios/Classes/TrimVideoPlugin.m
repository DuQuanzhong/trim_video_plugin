#import "TrimVideoPlugin.h"
#if __has_include(<trim_video_plugin/trim_video_plugin-Swift.h>)
#import <trim_video_plugin/trim_video_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "trim_video_plugin-Swift.h"
#endif

@implementation TrimVideoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTrimVideoPlugin registerWithRegistrar:registrar];
}
@end
