/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ApplicationDelegate.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ApplicationDelegate.h"
#import "MainWindowController.h"
#import "AboutController.h"

@implementation ApplicationDelegate

@synthesize aboutWindowController;

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    mainWindowController = [ MainWindowController new ];
    
    [ mainWindowController.window center ];
    [ mainWindowController showWindow: self ];
    [ NSApp activateIgnoringOtherApps: YES ];
    
    ( void )notification;
}

- ( void )applicationWillTerminate: ( NSNotification * )notification
{
    [ mainWindowController release ];
    
    ( void )notification;
}

- ( IBAction )showMainWindow: ( id )sender
{
    [ mainWindowController showWindow: sender ];
    [ NSApp activateIgnoringOtherApps: YES ];
}

- ( IBAction )showAboutWindow: ( id )sender
{
    ( void )sender;
    
    [ [ aboutWindowController window ] center ];
    [ aboutWindowController showWindow: self ];
    [ NSApp activateIgnoringOtherApps: YES ];
}

@end
