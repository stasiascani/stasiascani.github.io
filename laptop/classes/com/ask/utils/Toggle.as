////////////////////////////////////////////////////////////////////////////
/*
//  Toggle Class
//
//  @class              Toggle
//  @package            com.ask.utils
//	@extends			MovieClip
//
//  @author             Dave Castelnuovo
//	@version			1.0
//  @date                   2005-10-20
//
//	@description	Description
//
//  @symbolName   com.ask.utils.Toggle
//  @linkageID    com.ask.utils.Toggle
//
// Copyright (c) 2005 ASK learning. All rights reserved.
*/
///////////////////////////////////////////////////////////////////////////


import mx.events.EventDispatcher;

import com.ask.lib.*;
import com.ask.utils.*;

class com.ask.utils.Toggle extends MovieClip {


////////////////////////////////////////////////////////////////////////////
//
// Properties
//
////////////////////////////////////////////////////////////////////////////


	// @property					Used for debugging
    var className:String = "Toggle";

	// @property					symbolName for object. Used to attach.
    static var symbolName:String = "com.ask.utils.Toggle";

	// @property					Class used in createClassObject
    static var symbolOwner = com.ask.utils.Toggle;



	// @method						Method stub to be mixed in by EventDispatcher.
	// @see mx.events.EventDispatcher
	var dispatchEvent:Function;

	// @method						Method stub to be mixed in by EventDispatcher
	// @see mx.events.EventDispatcher
	var addEventListener:Function;

	// @method						Method stub to be mixed in by EventDispatcher
	// @see mx.events.EventDispatcher
	var removeEventListener:Function;



    // @property                    the button
    var bButton:MovieClip;

    // @property                    wether we are on or off
    var mbIsActive:Boolean;



////////////////////////////////////////////////////////////////////////////
//
//	Constructor
//
//  @method                         Toggle Constructor.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    function Toggle() {
		// add ability to broadcast events.
        EventDispatcher.initialize( this);
	}


////////////////////////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////////////////////////


	/////////////////////////////////////
	/*
    //  @method                     refreshUi
	//
    //  @description                refresh out button functions
	//	@return						Void
	*/
    function refreshUi() {
        bButton.onRelease = function()
        {
            _parent.onToggle();
        }
    }

	/////////////////////////////////////
	/*
    //  @method                     isActive
	//
    //  @description                tells others if we are on or off
    //  @return                     true if we are active
	*/
    function isActive():Boolean {
        return mbIsActive;
    }

	/////////////////////////////////////
	/*
    //  @method                     hide
	//
    //  @description                hide the button
	//	@return						Void
	*/
    function hide() {
        this._visible = false;
    }

	/////////////////////////////////////
	/*
    //  @method                     show
	//
    //  @description                show the button
	//	@return						Void
	*/
    function show() {
        this._visible = true;
    }

	/////////////////////////////////////
	/*
    //  @method                     activate
	//
    //  @description                put the toggle into active mode
	//	@return						Void
	*/
    function activate() {
        mbIsActive = true;
        this.gotoAndPlay( "active");
    }

	/////////////////////////////////////
	/*
    //  @method                     deactivate
	//
    //  @description                put the toggle into deactive mode
	//	@return						Void
	*/
    function deactivate() {
        mbIsActive = false;
        this.gotoAndPlay( "deactive");
    }

	/////////////////////////////////////
	/*
    //  @method                     onToggle
	//
    //  @description                gets call when a user clocks the button
	//	@return						Void
	*/
    function onToggle() {
        if ( mbIsActive == true)
        {
            deactivate();
        }
        else
        {
            activate();
        }
        dispatchEvent( { target: this, type: "onToggle", toggle: this});
    }
}