////////////////////////////////////////////////////////////////////////////
/*
//  LoadBar Class
//
//  @class              LoadBar
//  @package            com.ask.utils
//	@extends			MovieClip
//
//  @author             Dave Castelnuovo
//	@version			1.0
//  @date                   2005-10-20
//
//	@description	Description
//
//  @symbolName   com.ask.utils.LoadBar
//  @linkageID    com.ask.utils.LoadBar
//
// Copyright (c) 2005 ASK learning. All rights reserved.
*/
///////////////////////////////////////////////////////////////////////////


import com.ask.lib.*;
import com.ask.utils.*;
import com.ask.video.*;

class com.ask.utils.LoadBar extends MovieClip {


////////////////////////////////////////////////////////////////////////////
//
// Properties
//
////////////////////////////////////////////////////////////////////////////


	// @property					Used for debugging
    var className:String = "LoadBar";

	// @property					symbolName for object. Used to attach.
    static var symbolName:String = "com.ask.utils.LoadBar";

	// @property					Class used in createClassObject
    static var symbolOwner = com.ask.utils.LoadBar;



    // @property                    the max width of the bar
    var maxWidth:Number;

    // @property                    the min width of the bar
    var minWidth:Number;

    // @property                    the percent value of this load bar
    var percent:Number;
    var mPercent:Number;

    // @property                    the left cap of the load bar
    var mcLeftCap:MovieClip;

    // @property                    the right cap of the load bar
    var mcRightCap:MovieClip;

    // @property                    the the gooey center
    var mcMiddle:MovieClip;



////////////////////////////////////////////////////////////////////////////
//
//	Constructor
//
//  @method                         LoadBar Constructor.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    function LoadBar() {
	}


////////////////////////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////////////////////////


	/////////////////////////////////////
	/*
    //  @method                     setPercent
	//
    //  @description                gets call when a user clocks the button
    //  @param                      inPercent       the percentage we wantthe bar to show
	//	@return						Void
	*/
    function setPercent( inPercent:Number) {
        percent = inPercent;
        mPercent = Math.floor( inPercent * 100);
        var oFrame = Math.floor( inPercent * ( this._totalframes - 1)) + 1;
		this.gotoAndStop( oFrame);
    }


////////////////////////////////////////////////////////////////////////////
//
//	Private Methods
//
////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////
//
//	Accessor Methods
//
////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////
//
//	Events
//
////////////////////////////////////////////////////////////////////////////


}