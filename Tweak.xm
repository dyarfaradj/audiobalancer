#import <objc/runtime.h>
#import <notify.h>

@interface UIStatusBarWindow : UIWindow
-(void)tapping;
@end

@interface AXSettings  : NSObject
-(void)setAudioLeftRightBalance:(double)arg1;
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)];
    tapRecognizer.numberOfTapsRequired = 2;
    tapRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapRecognizer];  

    return self;
}

%new
  -(void)tapping {
    notify_post("com.frostzone.audiobalancer"); 
  }
%end

%ctor
{
  if([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.AccessibilityUtilities.framework"])
  {
    int regToken; // The registration token
      notify_register_dispatch("com.frostzone.audiobalancer", &regToken, dispatch_get_main_queue(), ^(int token) { 
      [((AXSettings *)[%c(AXSettings) sharedApplication]) setAudioLeftRightBalance:0.3];
      NSLog(@"TEST");
    });
  }
}
