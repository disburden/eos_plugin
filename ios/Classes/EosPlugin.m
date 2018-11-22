#import "EosPlugin.h"
#import <eos_plugin/eos_plugin-Swift.h>

@implementation EosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEosPlugin registerWithRegistrar:registrar];
}
@end
