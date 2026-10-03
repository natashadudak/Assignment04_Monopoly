/*
Name:Natasha Dudak
Course:CS 210
Assignment:Assignment 04: Circular Linked List Monopoly
Professor:Dominic Dabish

Another source of information:
•Youtube video:https://www.youtube.com/watch?v=N6dOwBde7-M
•Youtube video:https://www.youtube.com/watch?v=BBpAmxU_NQo
•Youtube video:https://www.youtube.com/watch?v=HMkdlu5sP4A&list=PLBlnK6fEyqRjW4jK-CbshJuX20nc_3IaN
•Youtube video:https://www.youtube.com/watch?v=LyuuqCVkP5I&list=PLGjplNEQ1it-OKRcYlCEDpTiIB1YOcvn6
•Zbook's book
•Chatgpt: Portuguese-to-English translation, C++ questions, help with the code bug and code review

Date last modified: 10-02-2026
*/

#import <Cocoa/Cocoa.h>

// Country information
struct Country {
    const char* name;
    int cost;
};

@interface FullBoardView : NSView
@end

@implementation FullBoardView

// Draw one property tile
- (void)drawPropertyTile:(NSRect)tileRect
                    name:(NSString*)name
                   price:(NSString*)price
               bandColor:(NSColor*)bandColor
            isHorizontal:(BOOL)isHorizontal {

    [[NSColor colorWithRed:0.96 green:0.95 blue:0.88 alpha:1.0] setFill];
    NSBezierPath* body = [NSBezierPath bezierPathWithRect:tileRect];
    [body fill];

    [[NSColor blackColor] setStroke];
    [body setLineWidth:2.0];
    [body stroke];

    NSRect bandRect;

    if (isHorizontal) {
        bandRect = NSMakeRect(tileRect.origin.x,
                              tileRect.origin.y + tileRect.size.height - 22,
                              tileRect.size.width,
                              22);
    } else {
        bandRect = NSMakeRect(tileRect.origin.x,
                              tileRect.origin.y,
                              22,
                              tileRect.size.height);
    }

    [bandColor setFill];
    NSBezierPath* band = [NSBezierPath bezierPathWithRect:bandRect];
    [band fill];

    NSMutableParagraphStyle* leftStyle = [[NSMutableParagraphStyle alloc] init];
    [leftStyle setAlignment:NSTextAlignmentLeft];

    NSDictionary* nameStyle = @{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:13],
        NSForegroundColorAttributeName: [NSColor blackColor],
        NSParagraphStyleAttributeName: leftStyle
    };

    NSDictionary* priceStyle = @{
        NSFontAttributeName: [NSFont systemFontOfSize:12],
        NSForegroundColorAttributeName: [NSColor blackColor],
        NSParagraphStyleAttributeName: leftStyle
    };

    if (isHorizontal) {
        [name drawInRect:NSMakeRect(tileRect.origin.x + 10,
                                    tileRect.origin.y + 42,
                                    tileRect.size.width - 20,
                                    34)
          withAttributes:nameStyle];

        [price drawInRect:NSMakeRect(tileRect.origin.x + 10,
                                     tileRect.origin.y + 12,
                                     tileRect.size.width - 20,
                                     18)
           withAttributes:priceStyle];
    } else {
        [name drawInRect:NSMakeRect(tileRect.origin.x + 28,
                                    tileRect.origin.y + 82,
                                    tileRect.size.width - 34,
                                    34)
          withAttributes:nameStyle];

        [price drawInRect:NSMakeRect(tileRect.origin.x + 28,
                                     tileRect.origin.y + 52,
                                     tileRect.size.width - 34,
                                     18)
           withAttributes:priceStyle];
    }
}

// Draw arrow in empty spaces
- (void)drawArrowInRect:(NSRect)rect
              direction:(NSString*)direction
                  color:(NSColor*)color {

    [color setStroke];

    NSBezierPath* arrow = [NSBezierPath bezierPath];
    [arrow setLineWidth:6.0];
    [arrow setLineCapStyle:NSLineCapStyleRound];
    [arrow setLineJoinStyle:NSLineJoinStyleRound];

    CGFloat midX = NSMidX(rect);
    CGFloat midY = NSMidY(rect);

    if ([direction isEqualToString:@"up"]) {
        [arrow moveToPoint:NSMakePoint(midX, rect.origin.y + 25)];
        [arrow lineToPoint:NSMakePoint(midX, rect.origin.y + rect.size.height - 35)];
        [arrow moveToPoint:NSMakePoint(midX, rect.origin.y + rect.size.height - 35)];
        [arrow lineToPoint:NSMakePoint(midX - 18, rect.origin.y + rect.size.height - 55)];
        [arrow moveToPoint:NSMakePoint(midX, rect.origin.y + rect.size.height - 35)];
        [arrow lineToPoint:NSMakePoint(midX + 18, rect.origin.y + rect.size.height - 55)];
    }
    else if ([direction isEqualToString:@"down"]) {
        [arrow moveToPoint:NSMakePoint(midX, rect.origin.y + rect.size.height - 25)];
        [arrow lineToPoint:NSMakePoint(midX, rect.origin.y + 35)];
        [arrow moveToPoint:NSMakePoint(midX, rect.origin.y + 35)];
        [arrow lineToPoint:NSMakePoint(midX - 18, rect.origin.y + 55)];
        [arrow moveToPoint:NSMakePoint(midX, rect.origin.y + 35)];
        [arrow lineToPoint:NSMakePoint(midX + 18, rect.origin.y + 55)];
    }
    else if ([direction isEqualToString:@"left"]) {
        [arrow moveToPoint:NSMakePoint(rect.origin.x + rect.size.width - 25, midY)];
        [arrow lineToPoint:NSMakePoint(rect.origin.x + 35, midY)];
        [arrow moveToPoint:NSMakePoint(rect.origin.x + 35, midY)];
        [arrow lineToPoint:NSMakePoint(rect.origin.x + 55, midY + 18)];
        [arrow moveToPoint:NSMakePoint(rect.origin.x + 35, midY)];
        [arrow lineToPoint:NSMakePoint(rect.origin.x + 55, midY - 18)];
    }
    else if ([direction isEqualToString:@"right"]) {
        [arrow moveToPoint:NSMakePoint(rect.origin.x + 25, midY)];
        [arrow lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 35, midY)];
        [arrow moveToPoint:NSMakePoint(rect.origin.x + rect.size.width - 35, midY)];
        [arrow lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 55, midY + 18)];
        [arrow moveToPoint:NSMakePoint(rect.origin.x + rect.size.width - 35, midY)];
        [arrow lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 55, midY - 18)];
    }

    [arrow stroke];
}

// Draw player box
- (void)drawPlayerBox:(NSRect)boxRect
                 name:(NSString*)name
                label:(NSString*)label {

    [[NSColor colorWithRed:0.98 green:0.96 blue:0.92 alpha:1.0] setFill];
    NSBezierPath* box = [NSBezierPath bezierPathWithRoundedRect:boxRect
                                                        xRadius:10
                                                        yRadius:10];
    [box fill];

    [[NSColor blackColor] setStroke];
    [box setLineWidth:2.0];
    [box stroke];

    NSMutableParagraphStyle* centerStyle = [[NSMutableParagraphStyle alloc] init];
    [centerStyle setAlignment:NSTextAlignmentCenter];

    NSDictionary* nameStyle = @{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:26],
        NSForegroundColorAttributeName: [NSColor blackColor],
        NSParagraphStyleAttributeName: centerStyle
    };

    NSDictionary* labelStyle = @{
        NSFontAttributeName: [NSFont systemFontOfSize:17],
        NSForegroundColorAttributeName: [NSColor darkGrayColor],
        NSParagraphStyleAttributeName: centerStyle
    };

    [name drawInRect:NSMakeRect(boxRect.origin.x + 10,
                                boxRect.origin.y + 68,
                                boxRect.size.width - 20,
                                34)
      withAttributes:nameStyle];

    [label drawInRect:NSMakeRect(boxRect.origin.x + 10,
                                 boxRect.origin.y + 34,
                                 boxRect.size.width - 20,
                                 25)
       withAttributes:labelStyle];

    [@"Starts at Brazil" drawInRect:NSMakeRect(boxRect.origin.x + 10,
                                               boxRect.origin.y + 10,
                                               boxRect.size.width - 20,
                                               25)
                     withAttributes:labelStyle];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Window background
    [[NSColor colorWithRed:0.88 green:0.88 blue:0.86 alpha:1.0] setFill];
    NSRectFill(self.bounds);

    Country countries[10] = {
        {"Brazil", 60},
        {"Spain", 80},
        {"Mexico", 100},
        {"Italy", 120},
        {"France", 140},
        {"Poland", 160},
        {"Germany", 180},
        {"United States", 200},
        {"Japan", 220},
        {"Netherlands", 240}
    };

    NSColor* bandColors[10] = {
        [NSColor colorWithRed:0.92 green:0.33 blue:0.20 alpha:1.0], // Brazil
        [NSColor colorWithRed:0.96 green:0.48 blue:0.17 alpha:1.0], // Spain
        [NSColor colorWithRed:0.96 green:0.65 blue:0.42 alpha:1.0], // Mexico
        [NSColor colorWithRed:0.85 green:0.29 blue:0.54 alpha:1.0], // Italy
        [NSColor colorWithRed:0.73 green:0.16 blue:0.43 alpha:1.0], // France
        [NSColor colorWithRed:0.87 green:0.22 blue:0.15 alpha:1.0], // Poland
        [NSColor colorWithRed:0.96 green:0.46 blue:0.16 alpha:1.0], // Germany
        [NSColor colorWithRed:0.95 green:0.67 blue:0.45 alpha:1.0], // United States
        [NSColor colorWithRed:0.84 green:0.26 blue:0.52 alpha:1.0], // Japan
        [NSColor colorWithRed:0.69 green:0.11 blue:0.34 alpha:1.0]  // Netherlands
    };

    CGFloat boardX = 90;
    CGFloat boardY = 90;
    CGFloat boardSize = 760;

    // Outer board
    [[NSColor colorWithRed:0.92 green:0.91 blue:0.86 alpha:1.0] setFill];
    NSRect boardRect = NSMakeRect(boardX, boardY, boardSize, boardSize);
    NSBezierPath* boardPath = [NSBezierPath bezierPathWithRect:boardRect];
    [boardPath fill];

    [[NSColor blackColor] setStroke];
    [boardPath setLineWidth:4.0];
    [boardPath stroke];

    CGFloat corner = 120;
    CGFloat edgeWidth = 173.3333;
    CGFloat sideHeight = 200;

    // Property tiles
    NSRect tileRects[10] = {
        NSMakeRect(boardX, boardY, corner, corner),                                     // Brazil
        NSMakeRect(boardX + corner, boardY, edgeWidth, corner),                         // Spain
        NSMakeRect(boardX + corner + edgeWidth, boardY, edgeWidth, corner),             // Mexico
        NSMakeRect(boardX + corner + edgeWidth * 2, boardY, corner, corner),            // Italy
        NSMakeRect(boardX + boardSize - corner, boardY + corner, corner, sideHeight),   // France
        NSMakeRect(boardX + boardSize - corner, boardY + boardSize - corner, corner, corner), // Poland
        NSMakeRect(boardX + corner + edgeWidth, boardY + boardSize - corner, edgeWidth, corner), // Germany
        NSMakeRect(boardX + corner, boardY + boardSize - corner, edgeWidth, corner),    // United States
        NSMakeRect(boardX, boardY + boardSize - corner, corner, corner),                // Japan
        NSMakeRect(boardX, boardY + corner, corner, sideHeight)                         // Netherlands
    };

    BOOL horizontal[10] = {YES, YES, YES, YES, NO, YES, YES, YES, YES, NO};

    for (int i = 0; i < 10; i++) {
        NSString* countryName = [NSString stringWithUTF8String:countries[i].name];
        NSString* price = [NSString stringWithFormat:@"$%d", countries[i].cost];

        [self drawPropertyTile:tileRects[i]
                          name:countryName
                         price:price
                     bandColor:bandColors[i]
                  isHorizontal:horizontal[i]];
    }

    // Inner center area - light background
    CGFloat innerMargin = 120;
    NSRect innerRect = NSMakeRect(boardX + innerMargin,
                                  boardY + innerMargin,
                                  boardSize - innerMargin * 2,
                                  boardSize - innerMargin * 2);

    [[NSColor colorWithRed:0.95 green:0.94 blue:0.90 alpha:1.0] setFill];
    NSBezierPath* innerPath = [NSBezierPath bezierPathWithRect:innerRect];
    [innerPath fill];

    [[NSColor colorWithRed:0.30 green:0.30 blue:0.28 alpha:1.0] setStroke];
    [innerPath setLineWidth:2.5];
    [innerPath stroke];

    // Arrows in empty spaces
    NSColor* softPink = [NSColor colorWithRed:0.90 green:0.58 blue:0.72 alpha:1.0];
    NSColor* softOrange = [NSColor colorWithRed:0.96 green:0.71 blue:0.46 alpha:1.0];

    NSRect topArrowRect = NSMakeRect(boardX + 520, boardY + 640, 120, 120);
    NSRect leftArrowRect = NSMakeRect(boardX, boardY + 320, 120, 200);
    NSRect rightArrowRect = NSMakeRect(boardX + 640, boardY + 320, 120, 200);
    NSRect bottomRightArrowRect = NSMakeRect(boardX + 580, boardY, 180, 120);

    [self drawArrowInRect:leftArrowRect direction:@"down" color:softOrange];
    [self drawArrowInRect:topArrowRect direction:@"left" color:softPink];
    [self drawArrowInRect:rightArrowRect direction:@"up" color:softOrange];
    [self drawArrowInRect:bottomRightArrowRect direction:@"up" color:softPink];

    // Natasha higher, Nicole lower
    NSRect natashaBox = NSMakeRect(boardX + 110, boardY + 420, 180, 130);
    NSRect nicoleBox  = NSMakeRect(boardX + 460, boardY + 160, 180, 130);

    [self drawPlayerBox:natashaBox name:@"Natasha" label:@"Player 1"];
    [self drawPlayerBox:nicoleBox  name:@"Nicole"  label:@"Player 2"];

    // Center MONOPOLY banner
    [NSGraphicsContext saveGraphicsState];

    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform translateXBy:NSMidX(innerRect) yBy:NSMidY(innerRect)];
    [transform rotateByDegrees:45];
    [transform translateXBy:-160 yBy:-40];
    [transform concat];

    NSRect bannerRect = NSMakeRect(0, 0, 320, 80);

    [[NSColor colorWithRed:0.84 green:0.35 blue:0.34 alpha:1.0] setFill];
    NSBezierPath* banner = [NSBezierPath bezierPathWithRoundedRect:bannerRect
                                                           xRadius:6
                                                           yRadius:6];
    [banner fill];

    [[NSColor whiteColor] setStroke];
    [banner setLineWidth:3.0];
    [banner stroke];

    NSMutableParagraphStyle* monopolyCenter = [[NSMutableParagraphStyle alloc] init];
    [monopolyCenter setAlignment:NSTextAlignmentCenter];

    NSDictionary* monopolyStyle = @{
        NSFontAttributeName: [NSFont boldSystemFontOfSize:36],
        NSForegroundColorAttributeName: [NSColor whiteColor],
        NSParagraphStyleAttributeName: monopolyCenter
    };

    [@"MONOPOLY" drawInRect:NSMakeRect(0, 18, 320, 45)
             withAttributes:monopolyStyle];

    [NSGraphicsContext restoreGraphicsState];

    // Bottom explanation only
    NSMutableParagraphStyle* centerInfo = [[NSMutableParagraphStyle alloc] init];
    [centerInfo setAlignment:NSTextAlignmentCenter];

    NSDictionary* infoStyle = @{
        NSFontAttributeName: [NSFont systemFontOfSize:15],
        NSForegroundColorAttributeName: [NSColor darkGrayColor],
        NSParagraphStyleAttributeName: centerInfo
    };

    [@"The last country connects back to Brazil, creating a circular linked list."
        drawInRect:NSMakeRect(130, 30, 680, 22)
    withAttributes:infoStyle];
}

@end

int main(int argc, const char* argv[]) {
    @autoreleasepool {
        NSApplication* app = [NSApplication sharedApplication];
        [app setActivationPolicy:NSApplicationActivationPolicyRegular];

        NSRect windowRect = NSMakeRect(0, 0, 940, 940);

        NSWindow* window =
            [[NSWindow alloc]
                initWithContentRect:windowRect
                          styleMask:NSWindowStyleMaskTitled |
                                    NSWindowStyleMaskClosable |
                                    NSWindowStyleMaskMiniaturizable
                            backing:NSBackingStoreBuffered
                              defer:NO];

        [window setTitle:@"World Monopoly - Circular Linked List"];
        [window center];

        FullBoardView* boardView =
            [[FullBoardView alloc] initWithFrame:windowRect];

        [window setContentView:boardView];
        [window makeKeyAndOrderFront:nil];

        [app activateIgnoringOtherApps:YES];
        [app run];
    }

    return 0;
}