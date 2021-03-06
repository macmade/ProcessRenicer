/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ApplicationDelegate.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class MainWindowController;
@class AboutController;

@interface ApplicationDelegate: NSObject < NSApplicationDelegate >
{
@protected
    
    MainWindowController * mainWindowController;
    AboutController      * aboutWindowController;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet AboutController * aboutWindowController;

- ( IBAction )showMainWindow: ( id )sender;
- ( IBAction )showAboutWindow: ( id )sender;

@end
