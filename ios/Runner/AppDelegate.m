#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include <AVFoundation/AVFoundation.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    NSError* audio_session_error = nil;
    BOOL is_success = YES;
    is_success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:&audio_session_error];
    if(!is_success || audio_session_error) {
        NSLog(@"Error");
    }
    [[AVAudioSession sharedInstance] setActive:true error:&audio_session_error];
    if(!is_success || audio_session_error) {
        NSLog(@"Error");
    }
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
