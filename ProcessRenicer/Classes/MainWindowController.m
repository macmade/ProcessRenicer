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
#import "Execution.h"

@implementation MainWindowController

@synthesize reniceView;
@synthesize table;
@synthesize reniceButton;
@synthesize quitButton;
@synthesize forceQuitButton;
@synthesize slider;
@synthesize niceValue;
@synthesize pidValue;
@synthesize nameValue;
@synthesize image;
@synthesize search;

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
    
    timer          = [ NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector( refresh: ) userInfo: nil repeats: YES ];
    selectedColumn = [ table tableColumnWithIdentifier: @"pid" ];
    selectOrdering = NSOrderedAscending;
    
    [ reniceButton    setEnabled: NO ];
    [ quitButton      setEnabled: NO ];
    [ forceQuitButton setEnabled: NO ];
    
    [ table setIndicatorImage: [ NSImage imageNamed: @"NSAscendingSortIndicator" ] inTableColumn: selectedColumn ];
    [ processInfos setOrderingField: @"pid" order: NSOrderedAscending ];
}

- ( IBAction )renice: ( id )sender
{
    NSIndexSet * index;
    NSImage    * appImage;
    NSRange      range;
    
    index         = [ table selectedRowIndexes ];
    activeProcess = [ [ processInfos.processes objectAtIndex: [ index firstIndex ] ] retain ];
    
    ( void )sender;
    
    if( [ activeProcess.command length ] && [ activeProcess.command length ] > 0 && [ [ activeProcess.command substringToIndex: 1 ] isEqualToString: @"/" ] == NO )
    {
        appImage = [ NSImage imageNamed: NSImageNameAdvanced ];
    }
    
    range = [ activeProcess.command rangeOfString: @".app/Contents/MacOS/" ];
    
    if( range.location != NSNotFound )
    {
        appImage = [ [ NSWorkspace sharedWorkspace ] iconForFile: [ activeProcess.command substringToIndex: range.location + 4 ] ];
    }
    else
    {
        appImage = [ NSImage imageNamed: NSImageNameAdvanced ];
    }
    
    [ image setImage: appImage ];
    [ pidValue setIntegerValue: activeProcess.pid ];
    [ nameValue setStringValue: activeProcess.name ];
    [ niceValue setIntegerValue: activeProcess.nice ];
    [ slider setIntegerValue: activeProcess.nice ];
    [ NSApp beginSheet: reniceView modalForWindow: self.window modalDelegate: self didEndSelector: @selector( didEndSheet: returnCode: contextInfo: ) contextInfo: nil ];
    [ reniceView orderFront: sender ];
}

- ( IBAction )quit: ( id )sender
{
    char       * args[ 3 ];
    NSIndexSet * index;
    Process    * process;
    Execution  * exec;
    
    ( void )sender;
    
    index     = [ table selectedRowIndexes ];
    process   = [ [ processInfos.processes objectAtIndex: [ index firstIndex ] ] retain ];
    args[ 0 ] = "-s";
    args[ 1 ] = "int";
    args[ 2 ] = ( char * )[ [ NSString stringWithFormat: @"%u", ( unsigned int )process.pid ] cStringUsingEncoding: NSASCIIStringEncoding  ];
    exec      = [ Execution new ];
    
    [ exec executeWithPrivileges: "/bin/kill" arguments: args io: NULL ];
    [ exec release ];
    [ process release ];
}

- ( IBAction )forceQuit: ( id )sender
{
    char       * args[ 3 ];
    NSIndexSet * index;
    Process    * process;
    Execution  * exec;
    
    ( void )sender;
    
    index     = [ table selectedRowIndexes ];
    process   = [ [ processInfos.processes objectAtIndex: [ index firstIndex ] ] retain ];
    args[ 0 ] = "-s";
    args[ 1 ] = "kill";
    args[ 2 ] = ( char * )[ [ NSString stringWithFormat: @"%u", ( unsigned int )process.pid ] cStringUsingEncoding: NSASCIIStringEncoding  ];
    exec      = [ Execution new ];
    
    [ exec executeWithPrivileges: "/bin/kill" arguments: args io: NULL ];
    [ exec release ];
    [ process release ];
}

- ( IBAction )confirmRenice: ( id )sender
{
    ( void )sender;
    
    [ NSApp endSheet: reniceView returnCode: 0 ];
}

- ( IBAction )cancelRenice: ( id )sender
{
    ( void )sender;
    
    [ NSApp endSheet: reniceView returnCode: 1 ];
}

- ( IBAction )filter: ( id )sender
{
    ( void )sender;
    
    processInfos.filter = [ sender stringValue ];
    
    [ table reloadData ];
}

- ( void )executeRenice
{
    NSInteger    nice;
    Execution  * exec;
    char       * args[ 2 ];
    
    nice      = [ slider integerValue ];
    exec      = [ Execution new ];
    args[ 1 ] = ( char * )[ [ NSString stringWithFormat: @"%u", ( unsigned int )[ activeProcess pid ] ] cStringUsingEncoding: NSASCIIStringEncoding ];
    
    if( nice == 0 )
    {
        args[ 0 ] = "0";
    }
    else if( nice < 0 )
    {
        args[ 0 ] = ( char * )[ [ NSString stringWithFormat: @"%i", ( int )nice ] cStringUsingEncoding: NSASCIIStringEncoding ];
    }
    else if( nice > 0 )
    {
        args[ 0 ] = ( char * )[ [ NSString stringWithFormat: @"+%i", ( int )nice ] cStringUsingEncoding: NSASCIIStringEncoding ];
    }
    
    [ exec executeWithPrivileges: "/usr/bin/renice" arguments: args io: NULL ];
    [ exec release ];
}

- ( void )refresh: ( id )null
{
    ( void )null;
    
    [ table reloadData ];
}

- ( void )didEndSheet: ( NSWindow * )window returnCode: ( NSInteger )code contextInfo: ( id )context
{
    [ window orderOut: nil ];
    
    ( void )context;
    
    if( code == 0 )
    {
        [ self executeRenice ];
    }
    
    [ activeProcess release ];
    
    activeProcess = nil;
}

- ( NSInteger )numberOfRowsInTableView: (NSTableView * )tableView
{
    ( void )tableView;
    
    return [ processInfos.processes count ];
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )column row: ( NSInteger )rowIndex
{
    Process  * process;
    id         value;
    NSRange    range;
    
    ( void )tableView;
    ( void )column;
    ( void )rowIndex;
    
    process = [ [ processInfos.processes objectAtIndex: rowIndex ] retain ];
    
    if( [ [ column identifier ] isEqualToString: @"pid" ] )
    {
        value = [ NSString stringWithFormat: @"%u", ( unsigned int )process.pid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"ppid" ] )
    {
        value = [ NSString stringWithFormat: @"%u", ( unsigned int )process.ppid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"uid" ] )
    {
        value = [ NSString stringWithFormat: @"%i", ( int )process.uid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"gid" ] )
    {
        value = [ NSString stringWithFormat: @"%i", ( int )process.gid ];
    }
    else if( [ [ column identifier ] isEqualToString: @"nice" ] )
    {
        value = [ NSString stringWithFormat: @"%i", ( int )process.nice ];
    }
    else if( [ [ column identifier ] isEqualToString: @"pri" ] )
    {
        value = [ NSString stringWithFormat: @"%u", ( unsigned int )process.pri ];
    }
    else if( [ [ column identifier ] isEqualToString: @"cpu" ] )
    {
        value = [ NSString stringWithFormat: @"%.02f %%", process.cpu ];
    }
    else if( [ [ column identifier ] isEqualToString: @"mem" ] )
    {
        value = [ NSString stringWithFormat: @"%.02f %%", process.mem ];
    }
    else if( [ [ column identifier ] isEqualToString: @"rss" ] )
    {
        if( process.rss < 1024 )
        {
            value = [ NSString stringWithFormat: @"%u KB", ( unsigned int )process.rss ];
        }
        else if( process.rss < 1024 * 1024 )
        {
            value = [ NSString stringWithFormat: @"%.2f MB", ( CGFloat )( ( CGFloat )process.rss / ( CGFloat )1024 ) ];
        }
        else if( process.rss < 1024 * 1024 * 1024 )
        {
            value = [ NSString stringWithFormat: @"%.2f GB", ( CGFloat )( ( CGFloat )process.rss / ( CGFloat )( 1024 * 1024 ) ) ];
        }
    }
    else if( [ [ column identifier ] isEqualToString: @"vsz" ] )
    {
        if( process.vsz < 1024 )
        {
            value = [ NSString stringWithFormat: @"%u KB", ( unsigned int )process.vsz ];
        }
        else if( process.vsz < 1024 * 1024 )
        {
            value = [ NSString stringWithFormat: @"%.2f MB", ( CGFloat )( ( CGFloat )process.vsz / ( CGFloat )1024 ) ];
        }
        else if( process.vsz < 1024 * 1024 * 1024 )
        {
            value = [ NSString stringWithFormat: @"%.2f GB", ( CGFloat )( ( CGFloat )process.vsz / ( CGFloat )( 1024 * 1024 ) ) ];
        }
    }
    else if( [ [ column identifier ] isEqualToString: @"paddr" ] )
    {
        value = process.paddr;
    }
    else if( [ [ column identifier ] isEqualToString: @"lstart" ] )
    {
        value = process.lstart;
    }
    else if( [ [ column identifier ] isEqualToString: @"name" ] )
    {
        value = process.name;
    }
    else if( [ [ column identifier ] isEqualToString: @"user" ] )
    {
        value = process.user;
    }
    else if( [ [ column identifier ] isEqualToString: @"icon" ] )
    {
        if( [ process.command length ] && [ process.command length ] > 0 && [ [ process.command substringToIndex: 1 ] isEqualToString: @"/" ] == NO )
        {
            value = [ NSImage imageNamed: NSImageNameAdvanced ];
        }
        
        range = [ process.command rangeOfString: @".app/Contents/MacOS/" ];
        
        if( range.location != NSNotFound )
        {
            value = [ [ NSWorkspace sharedWorkspace ] iconForFile: [ process.command substringToIndex: range.location + 4 ] ];
        }
        else
        {
            value = [ NSImage imageNamed: NSImageNameAdvanced ];
        }
    }
    else
    {
        value = @"";
    }
    
    [ process release ];
    
    return value;
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

- ( void )tableView: ( NSTableView * )tableView mouseDownInHeaderOfTableColumn: ( NSTableColumn * )tableColumn
{
    if( [ [ tableColumn identifier ] isEqualToString: @"icon" ] )
    {
        return;
    }
    
    if( tableColumn == selectedColumn )
    {
        [ tableView setIndicatorImage: ( selectOrdering == NSOrderedAscending ) ? [ NSImage imageNamed: @"NSDescendingSortIndicator" ] : [ NSImage imageNamed: @"NSAscendingSortIndicator" ] inTableColumn: selectedColumn ];
        
        selectOrdering = ( selectOrdering == NSOrderedAscending ) ? NSOrderedDescending : NSOrderedAscending;
    }
    else
    {
        [ tableView setIndicatorImage: nil inTableColumn: selectedColumn ];
        
        selectedColumn = tableColumn;
    
        [ tableView setIndicatorImage: ( selectOrdering == NSOrderedAscending ) ? [ NSImage imageNamed: @"NSAscendingSortIndicator" ] : [ NSImage imageNamed: @"NSDescendingSortIndicator" ] inTableColumn: selectedColumn ];
    }
    
    [ processInfos setOrderingField: [ selectedColumn identifier ] order: selectOrdering ];
    [ tableView reloadData ];
}

@end
