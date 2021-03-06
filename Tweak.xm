#import <objc/runtime.h>
#import <libactivator/libactivator.h>

BOOL mybool = NO;

// @interface UIStatusBarWindow : UIWindow
// -(void)tappsing;
// @end

@interface AXSettings  : NSObject
+(id)sharedInstance;
-(void)setAudioLeftRightBalance:(double)arg1;
@end

@interface AudioBalancer : NSObject<LAListener>
@end


// %hook UIStatusBarWindow

// - (instancetype)initWithFrame:(CGRect)frame {
//     self = %orig;

//     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)];
//     tapRecognizer.numberOfTapsRequired = 2;
//     tapRecognizer.cancelsTouchesInView = NO;
//     [self addGestureRecognizer:tapRecognizer];  

//     return self;
// }

// %new
//   -(void)tapping {
//      [[%c(AXSettings) sharedInstance] setAudioLeftRightBalance:1.0];
//   }
// %end

@implementation AudioBalancer

    -(void)performAction {
     if(!mybool)
     {
       [[%c(AXSettings) sharedInstance] setAudioLeftRightBalance:1.0];
     }
     else
     {
      [[%c(AXSettings) sharedInstance] setAudioLeftRightBalance:0.0];
     }
     mybool = !mybool;
    }

  -(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    [self performSelector:@selector(performAction)];
  }

  +(void)load {
      @autoreleasepool {
          [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.frostzone.audiobalancer"];
      }
  }

  - (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
      return @"AudioBalancer Activator";
  }
  - (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
      return @"Sets audiobalancer to Right 100\uFF05";
  }
  - (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
      return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
  }
@end
