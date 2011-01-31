/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      MainWindowController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class ProcessInfos;

/*!
 * @class       MainWindowController
 * @abstract    ...
 */
@interface MainWindowController: NSWindowController < NSTableViewDataSource, NSTableViewDelegate >
{
@protected
    
    NSTimer       * timer;
    NSTableView   * table;
    NSToolbarItem * reniceButton;
    NSToolbarItem * quitButton;
    NSToolbarItem * forceQuitButton;
    ProcessInfos  * processInfos;
    
@private
    
    id r1;
    id r2;
}

@property( assign, readonly ) IBOutlet NSTableView   * table;
@property( assign, readonly ) IBOutlet NSToolbarItem * reniceButton;
@property( assign, readonly ) IBOutlet NSToolbarItem * quitButton;
@property( assign, readonly ) IBOutlet NSToolbarItem * forceQuitButton;

- ( IBAction )renice: ( id )sender;
- ( IBAction )quit: ( id )sender;
- ( IBAction )forceQuit: ( id )sender;
- ( void )refresh: ( id )null;

@end
