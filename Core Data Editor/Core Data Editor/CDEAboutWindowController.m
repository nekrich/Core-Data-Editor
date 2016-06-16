#import "CDEAboutWindowController.h"

@interface CDEAboutWindowController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation CDEAboutWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSURL *aboutURL = [[NSBundle mainBundle] URLForResource:@"Credits" withExtension:@"rtf"];
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_11
    NSAttributedString *aboutText = [[NSAttributedString alloc] initWithURL:aboutURL options:@{} documentAttributes:nil error:nil];
#else
    NSAttributedString *aboutText = [[NSAttributedString alloc] initWithURL:aboutURL documentAttributes:NULL];
#endif
    [[self.textView textStorage] appendAttributedString:aboutText];
}

@end
