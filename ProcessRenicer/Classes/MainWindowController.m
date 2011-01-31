/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        MainWindowController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "MainWindowController.h"
#import "Process.h"
#import "ProcessInfos.h"

@implementation MainWindowController

@synthesize table;
@synthesize reniceButton;
@synthesize quitButton;
@synthesize forceQuitButton;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"MainWindow" ] ) )
    {
        processInfos = [ ProcessInfos new ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ timer invalidate ];
    [ processInfos release ];
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ table setDataSource: self ];
    [ table setDelegate  : self ];
    
    timer = [ NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector( refresh: ) userInfo: nil repeats: YES ];
    
    [ reniceButton    setEnabled: NO ];
    [ quitButton      setEnabled: NO ];
    [ forceQuitButton setEnabled: NO ];
}

- ( IBAction )renice: ( id )sender
{
    ( void )sender;
}

- ( IBAction )quit: ( id )sender
{
    ( void )sender;
}

- ( IBAction )forceQuit: ( id )sender
{
    ( void )sender;
}

- ( void )refresh: ( id )null
{
    ( void )null;
    
    while( processInfos.isRunning == YES );
    
    [ table reloadData ];
}

- ( NSInteger )numberOfRowsInTableView: (NSTableView * )tableView
{
    ( void )tableView;
    
    return [ processInfos.processes count ];
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )column row: ( NSInteger )rowIndex
{
    Process  * process;
    NSRange    range;
    
    ( void )tableView;
    ( void )column;
    ( void )rowIndex;
    
    process = [ processInfos.processes objectAtIndex: rowIndex ];
    
    if( [ [ column identifier ] isEqualToString: @"pid" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.pid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"ppid" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.ppid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"uid" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.uid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"gid" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.gid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"nice" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.nice ];
    }
    else if( [ [ column identifier ] isEqualToString: @"pri" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.pri ];
    }
    else if( [ [ column identifier ] isEqualToString: @"cpu" ] )
    {
        return [ NSString stringWithFormat: @"%u %%", ( unsigned int )process.cpu ];
    }
    else if( [ [ column identifier ] isEqualToString: @"mem" ] )
    {
        return [ NSString stringWithFormat: @"%u %%", ( unsigned int )process.mem ];
    }
    else if( [ [ column identifier ] isEqualToString: @"rss" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.rss ];
    }
    else if( [ [ column identifier ] isEqualToString: @"vsz" ] )
    {
        return [ NSString stringWithFormat: @"%u", ( unsigned int )process.vsz ];
    }
    else if( [ [ column identifier ] isEqualToString: @"paddr" ] )
    {
        return process.paddr;
    }
    else if( [ [ column identifier ] isEqualToString: @"lstart" ] )
    {
        return process.lstart;
    }
    else if( [ [ column identifier ] isEqualToString: @"name" ] )
    {
        return process.name;
    }
    else if( [ [ column identifier ] isEqualToString: @"user" ] )
    {
        return process.user;
    }
    else if( [ [ column identifier ] isEqualToString: @"icon" ] )
    {
        if( [ process.command length ] && [ [ process.command substringToIndex: 1 ] isEqualToString: @"/" ] == NO )
        {
            return nil;
        }
        
        range = [ process.command rangeOfString: @".app/Contents/MacOS/" ];
        
        if( range.location != NSNotFound )
        {
            return [ [ NSWorkspace sharedWorkspace ] iconForFile: [ process.command substringToIndex: range.location + 4 ] ];
        }
        
        return nil;
    }
    
    return @"";
}

- ( void )tableView: ( NSTableView * )tableView willDisplayCell: ( id )cell forTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )rowIndex
{
    ( void )tableView;
    ( void )cell;
    ( void )tableColumn;
    ( void )rowIndex;
    
    if( [ [ tableColumn identifier ] isEqualToString: @"name" ] == NO )
    {
        return;
    }
}

- ( void )tableViewSelectionDidChange: ( NSNotification * )notification
{
    ( void )notification;
    
    [ reniceButton    setEnabled: YES ];
    [ quitButton      setEnabled: YES ];
    [ forceQuitButton setEnabled: YES ];
}

@end
