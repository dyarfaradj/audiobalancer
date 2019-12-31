#import <objc/runtime.h>

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
     [[%c(AXSettings) sharedInstance] setAudioLeftRightBalance:1.0];
  }
%end
