#import <objc/runtime.h>
#import <notify.h>

@interface SpringBoard : NSObject  
-(void)_simulateLockButtonPress; //gotta define it u know?
@end

@interface UIStatusBarWindow : UIWindow
-(void)tapping;
@end

@interface AXSettings  : NSObject
+(id)sharedInstance;
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
    // [((AXSettings *)[%c(AXSettings) sharedInstance]) setAudioLeftRightBalance:1.0];
     [[%c(AXSettings) sharedInstance] setAudioLeftRightBalance:1.0];
     // [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress]; //locks device :)
    //notify_post("com.frostzone.audiobalancer"); 
  }
%end

%ctor
{
  if([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.AccessibilityUtilities.framework"])
  {
    int regToken; // The registration token
      notify_register_dispatch("com.frostzone.audiobalancer", &regToken, dispatch_get_main_queue(), ^(int token) { 
      [((AXSettings *)[%c(AXSettings) sharedInstance]) setAudioLeftRightBalance:1.0];
      NSLog(@"TEST");
    });
  }
}
