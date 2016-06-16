#import "CDEAttributeEditor.h"
#import "CDEAttributeEditorViewController.h"
#import "CDEAttributeEditorWindowController.h"

@interface CDEAttributeEditor ()

#pragma mark - Globals

#pragma mark - Properties
@property (nonatomic, strong) CDEAttributeEditorViewController *viewController;
@property (nonatomic, strong) CDEAttributeEditorWindowController *windowController;
@property (nonatomic, copy) CDEAttributeEditorCompletionHandler completionHandler;


@end

@implementation CDEAttributeEditor

#pragma mark - Showing the Editor
- (void)showEditorForManagedObject:(NSManagedObject *)managedObject
              attributeDescription:(NSAttributeDescription *)attributeDescription
                showRelativeToRect:(NSRect)positioningRect
                            ofView:(NSView *)positioningView
                 completionHandler:(CDEAttributeEditorCompletionHandler)completionHandler {
    NSParameterAssert(managedObject);
    NSParameterAssert(attributeDescription);
    NSParameterAssert(positioningView);
    
    self.completionHandler = completionHandler;
    self.windowController = [[CDEAttributeEditorWindowController alloc] initWithManagedObject:managedObject attributeDescription:attributeDescription];
    [self.windowController window];
    
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
  [positioningView.window
   beginSheet:self.windowController.window
   completionHandler:^(NSModalResponse returnCode) {
     [self sheetDidEnd:self.windowController.window returnCode:returnCode contextInfo:nil];
  }];
#else
    [NSApp beginSheet:self.windowController.window
       modalForWindow:positioningView.window
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:NULL];
#endif
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
    self.viewController = nil;
    self.windowController = nil;
    self.completionHandler ? self.completionHandler() : nil;
    self.completionHandler = nil;
}

#pragma mark - Closing the Editor
- (BOOL)isShown {
    return (self.windowController != nil);
}

- (void)close {
    [NSApp endSheet:self.windowController.window];
}

@end
