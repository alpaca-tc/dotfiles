/**
 * @Copyright 2011 Dearps All rights reserved.
 *�Ԃ��������@�X�N���v�g
 *http://dearps.lovwar.com/
 * @author Sho Miura
*/
var id35  = charIDToTypeID( "Mk  " );
var desc6 = new ActionDescriptor();
var id36  = charIDToTypeID( "null" );
var ref2  = new ActionReference();
var id37  = charIDToTypeID( "Dcmn" );
ref2.putClass( id37 );
desc6.putReference( id36, ref2 );

var id38 = charIDToTypeID( "Usng" );
var ref3 = new ActionReference();
var id39 = charIDToTypeID( "Lyr " );
var id40 = charIDToTypeID( "Ordn" );
var id41 = charIDToTypeID( "Trgt" );
ref3.putEnumerated( id39, id40, id41 );
desc6.putReference( id38, ref3 );
executeAction( id35, desc6, DialogModes.NO );

var id42  = stringIDToTypeID( "trim" );
var desc7 = new ActionDescriptor();
var id43  = stringIDToTypeID( "trimBasedOn" );
var id44  = stringIDToTypeID( "trimBasedOn" );
var id45  = charIDToTypeID( "Trns" );
desc7.putEnumerated( id43, id44, id45 );

var id46 = charIDToTypeID( "Top " );
desc7.putBoolean( id46, true );

var id47 = charIDToTypeID( "Btom" );
desc7.putBoolean( id47, true );

var id48 = charIDToTypeID( "Left" );
desc7.putBoolean( id48, true );

var id49 = charIDToTypeID( "Rght" );
desc7.putBoolean( id49, true );

executeAction( id42, desc7, DialogModes.NO );


