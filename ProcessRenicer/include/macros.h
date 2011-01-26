/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      macros.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#ifndef __PROCESSRENICER_MACROS_H__
#define __PROCESSRENICER_MACROS_H__

/*!
 * @define      NSSTR
 * @abstract    Gets a NSString object from a C string
 */
#define NSSTR( str )        [ NSString stringWithCString: str encoding: NSASCIIStringEncoding ]

/*!
 * @define      CSTR
 * @abstract    Gets an C string from a NSString object
 */
#define CSTR( str )         ( char * )[ str cStringUsingEncoding: NSASCIIStringEncoding ]

/*!
 * @define      CSTR_UTF8
 * @abstract    Gets an C string from a NSString object
 */
#define CSTR_UTF8( str )    ( char * )[ str cStringUsingEncoding: NSUTF8StringEncoding ]

/*!
 * @define      STRF
 * @abstract    Returns a string created by using a given format string as a template into which the remaining argument values are substituted
 */
#define STRF( ... )         [ NSString stringWithFormat: __VA_ARGS__ ]

/*!
 * @define      L10N
 * @abstract    Gets a localized label from the 'Localizable.strings' file
 */
#define L10N( label )       NSLocalizedString( label, nil )

/*!
 * @define      Log
 * @abstract    Logs an instance of an Objective-C class instance to the console
 */
#define Log( object )       NSLog( @"%@", object )

/*!
 * @define      LogPoint
 * @abstract    Logs a CGPoint structure to the console
 */
#define LogPoint( point )                           \
    NSLog( @"X: %f", point.x );                     \
    NSLog( @"Y: %f", point.y );

/*!
 * @define      LogSize
 * @abstract    Logs a CGSize structure to the console
 */
#define LogSize( size )                             \
    NSLog( @"Width:  %f", size.width );             \
    NSLog( @"Height: %f", size.height );

/*!
 * @define      LogRect
 * @abstract    Logs a CGRect structure to the console
 */
#define LogRect( rect )                             \
    NSLog( @"X:      %f", rect.origin.x );          \
    NSLog( @"Y:      %f", rect.origin.y );          \
    NSLog( @"Width:  %f", rect.size.width );        \
    NSLog( @"Height: %f", rect.size.height );

/*!
 * @define      LogRange
 * @abstract    Logs a NSRange structure to the console
 */
#define LogRange( range )                           \
    NSLog( @"Location:  %i", range.location );      \
    NSLog( @"Length:    %i", range.length );

/*!
 * @define      LogEdgeInsets
 * @abstract    Logs a UIEdgeInsets structure to the console
 */
#define LogEdgeInsets( edgeInsets )                 \
    NSLog( @"Top:       %f", edgeInsets.top );      \
    NSLog( @"Left:      %f", edgeInsets.left );     \
    NSLog( @"Bottom:    %f", edgeInsets.bottom );   \
    NSLog( @"Right:     %f", edgeInsets.right );

#endif /* __PROCESSRENICER_MACROS_H__ */
