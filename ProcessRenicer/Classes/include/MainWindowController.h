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
@class Process;

/*!
 * @class       MainWindowController
 * @abstract    ...
 */
@interface MainWindowController: NSWindowController < NSTableViewDataSource, NSTableViewDelegate >
{
@protected
    
    NSWindow          * reniceView;
    NSTimer           * timer;
    NSTableView       * table;
    NSToolbarItem     * reniceButton;
    NSToolbarItem     * quitButton;
    NSToolbarItem     * forceQuitButton;
    NSSlider          * slider;
    NSTextField       * niceValue;
    NSTextField       * pidValue;
    NSTextField       * nameValue;
    NSImageView       * image;
    NSSearchField     * search;
    NSTableColumn     * selectedColumn;
    NSComparisonResult  selectOrdering;
    ProcessInfos      * processInfos;
    Process           * activeProcess;
    
@private
    
    id r1;
    id r2;
}

@property( assign, readonly ) IBOutlet NSWindow      * reniceView;
@property( assign, readonly ) IBOutlet NSTableView   * table;
@property( assign, readonly ) IBOutlet NSToolbarItem * reniceButton;
@property( assign, readonly ) IBOutlet NSToolbarItem * quitButton;
@property( assign, readonly ) IBOutlet NSToolbarItem * forceQuitButton;
@property( assign, readonly ) IBOutlet NSSlider      * slider;
@property( assign, readonly ) IBOutlet NSTextField   * niceValue;
@property( assign, readonly ) IBOutlet NSTextField   * pidValue;
@property( assign, readonly ) IBOutlet NSTextField   * nameValue;
@property( assign, readonly ) IBOutlet NSImageView   * image;
@property( assign, readonly ) IBOutlet NSSearchField * search;

- ( IBAction )renice: ( id )sender;
- ( IBAction )quit: ( id )sender;
- ( IBAction )forceQuit: ( id )sender;
- ( IBAction )confirmRenice: ( id )sender;
- ( IBAction )cancelRenice: ( id )sender;
- ( IBAction )filter: ( id )sender;
- ( void )refresh: ( id )null;
- ( void )didEndSheet: ( NSWindow * )window returnCode: ( NSInteger )code contextInfo: ( id )context;
- ( void )executeRenice;

@end
