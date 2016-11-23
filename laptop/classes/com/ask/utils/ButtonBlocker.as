////////////////////////////////////////////////////////////////////////////
/*
//  Button Blocker Class
//
//  @class              ButtonBlocker
//  @package            com.ask.utils
//	@extends			MovieClip
//
//  @author             Dave Castelnuovo
//	@version			1.0
//  @date                   2005-10-20
//
//	@description	Description
//
//  @symbolName   com.ask.utils.ButtonBlocker
//  @linkageID    com.ask.utils.ButtonBlocker
//
// Copyright (c) 2005 ASK learning. All rights reserved.
*/
///////////////////////////////////////////////////////////////////////////


import mx.events.EventDispatcher;

import com.ask.lib.*;
import com.ask.utils.*;

class com.ask.utils.ButtonBlocker extends MovieClip {


////////////////////////////////////////////////////////////////////////////
//
// Properties
//
////////////////////////////////////////////////////////////////////////////


	// @property					Used for debugging
    var className:String = "ButtonBlocker";

	// @property					symbolName for object. Used to attach.
    static var symbolName:String = "com.ask.utils.ButtonBlocker";

	// @property					Class used in createClassObject
    static var symbolOwner = com.ask.utils.ButtonBlocker;



    // @property                    the ButtonBlocker singleton
    static var sInstance:ButtonBlocker;

    // @property                    the number of frames left to animate
    var mAnimFrames:Number = 0;

    // @property                    the current tweened alpha  value
    var mAlphaPos:Number = 0;


////////////////////////////////////////////////////////////////////////////
//
//	Constructor
//
//  @method                         ButtonBlocker Constructor.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    function ButtonBlocker() {
        sInstance = this;

        var oCoords = { x: 0, y: 0};
        _parent.globalToLocal( oCoords);

        this._x = oCoords.x;
        this._y = oCoords.y;
        this._width = Stage.width;
        this._height = Stage.height;

        this._visible = false;
        this._alpha = 0;
        mAlphaPos = 0;
	}


////////////////////////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////////////////////////


	/////////////////////////////////////
	/*
    //  @method                     activate
	//
    //  @description                turn on the button blocker
	//	@return						Void
	*/
    function activate() {
        this._visible = true;
        mAnimFrames = 30;
        onEnterFrame = onEnterFrameFadeIn;
        onRollOver = function() {};
    }

	/////////////////////////////////////
	/*
    //  @method                     deactivate
	//
    //  @description                turn off the button blocker
	//	@return						Void
	*/
    function deactivate() {
        mAnimFrames = 30;
        onEnterFrame = onEnterFrameFadeOut;
        delete onRollOver;
    }

	/////////////////////////////////////
	/*
    //  @method                     onEnterFrameFadeIn
	//
    //  @description                fade us up to 100% alpha
	//	@return						Void
	*/
    function onEnterFrameFadeIn() {
        mAlphaPos += ( 100 - mAlphaPos) * 0.5;
        this._alpha = Math.floor( mAlphaPos);
        mAnimFrames --;
        if ( mAnimFrames == 0)
        {
            onEnterFrame = null;
        }
    }

	/////////////////////////////////////
	/*
    //  @method                     onEnterFrameFadeOut
	//
    //  @description                fade us to 0% alpha
	//	@return						Void
	*/
    function onEnterFrameFadeOut() {
        mAlphaPos += - mAlphaPos * 0.5;
        this._alpha = Math.floor( mAlphaPos);
        mAnimFrames --;
        if ( mAnimFrames == 0)
        {
            onEnterFrame = null;
            this._visible = false;
        }
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