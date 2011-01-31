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

@interface ApplicationDelegate: NSObject < NSApplicationDelegate >
{
@protected
    
    MainWindowController * mainWindowController;
    
@private
    
    id r1;
    id r2;
}

- ( IBAction )showMainWindow: ( id )sender;

@end
