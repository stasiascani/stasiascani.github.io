////////////////////////////////////////////////////////////////////////////
/*
//  Preloader Class
//
//  @class              Preloader
//  @package            com.ask.utils
//	@extends			MovieClip
//
//  @author             Dave Castelnuovo
//	@version			1.0
//  @date                   2005-10-20
//
//	@description	Description
//
//  @symbolName   com.ask.utils.Preloader
//  @linkageID    com.ask.utils.Preloader
//
// Copyright (c) 2005 ASK learning. All rights reserved.
*/
///////////////////////////////////////////////////////////////////////////


import mx.events.EventDispatcher;

import com.ask.lib.*;
import com.ask.utils.*;

class com.ask.utils.Preloader extends MovieClip {


////////////////////////////////////////////////////////////////////////////
//
// Properties
//
////////////////////////////////////////////////////////////////////////////


	// @property					Used for debugging
    var className:String = "Preloader";

	// @property					symbolName for object. Used to attach.
    static var symbolName:String = "com.ask.utils.Preloader";

	// @property					Class used in createClassObject
    static var symbolOwner = com.ask.utils.Preloader;



    // @property                    the Preloader singleton
    static var instance:Preloader;

    // @property                    Array of modules that need to be preloaded
    static var preloadModuleArray:Array;


    // @property                    The load bar in the site
    var mcBar:MovieClip;

    // @property                    the number of items we are loading
    var loadCount:Number;

    // @property                    the number of items that have loaded so far
    var loadedCount:Number;

    // @property                    the current item that is loading
    var loadItem:MovieClip;


    // @property                    true if we are already activated
    var bActive:Boolean = false;



    // @property                    used to init our statics
    static var bClassConstruct:Boolean = classConstruct();


////////////////////////////////////////////////////////////////////////////
//
//  Class Constructor
//
//  @method                         ClassConstruct.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    static function classConstruct():Boolean {
        preloadModuleArray = [];
        return true;
    }


////////////////////////////////////////////////////////////////////////////
//
//	Constructor
//
//  @method                         Preloader Constructor.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    function Preloader() {
		init();
	}


////////////////////////////////////////////////////////////////////////////
//
//	Initialization
//
//	@method							Init.
//  @description                Initilizes Preloader.
//
////////////////////////////////////////////////////////////////////////////


	private function init():Void {
        instance = this;
        bActive = true;
        onEnterFrame = onEnterFrameLoadRoot;
	}


////////////////////////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////////////////////////

	/////////////////////////////////////
	/*
    //  @method                     addPreloadClass
	//
    //  @description                add a class to preload
    //  @param                      inClass         the class we want to load
	//	@return						Void
	*/
    static function addPreloadClass( inClass:Function) {
        preloadModuleArray.push( inClass);
    };

	/////////////////////////////////////
	/*
    //  @method                     activate
	//
    //  @description                turn on the preloader
    //  @param                      inLoadCount     the number of items we expect to load
	//	@return						Void
	*/
    function activate( inLoadCount:Number) {
        loadCount = inLoadCount;
        loadedCount = -1;               // the first load item will increment this to 0
        onEnterFrame = onEnterFrameLoadItem;
        if ( bActive != true)
        {
            bActive = true;
            this.gotoAndPlay( "lActivate");
        }
    };

	/////////////////////////////////////
	/*
    //  @method                     deactivate
	//
    //  @description                turn off the preloader
	//	@return						Void
	*/
    function deactivate() {
        _root.mcBlocker._visible = false;
        onEnterFrame = null;
        if ( bActive == true)
        {
            bActive = false;
            this.gotoAndPlay( "lDeactivate");
        }
    };

	/////////////////////////////////////
	/*
    //  @method                     loadNextItem
	//
    //  @description                called to track the next item in our load list
    //  @param                      inLoadItem      the item we are tracking
	//	@return						Void
	*/
    function loadNextItem( inLoadItem:MovieClip) {
        loadedCount ++;
        loadItem = inLoadItem;
    };

	/////////////////////////////////////
	/*
    //  @method                     onEnterFrameLoadItem
	//
    //  @description                the onEnterFrame method we use for loading items
	//	@return						Void
	*/
    function onEnterFrameLoadItem() {
        var oBytes = loadItem.getBytesLoaded();
        var oTotal = loadItem.getBytesTotal();
        var oPercent = oBytes / oTotal;
        var oItemRange = 1 / loadCount;

        mcBar.mcLoadBar.setPercent( oItemRange * ( loadedCount + oPercent));
    };

	/////////////////////////////////////
	/*
    //  @method                     onEnterFrameLoadRoot
	//
    //  @description                the onEnterFrame method we use for laoding the root assets
	//	@return						Void
	*/
    function onEnterFrameLoadRoot() {
        var oBytes = _root.getBytesLoaded ();
        var oTotal = _root.getBytesTotal ();
        var oPercent = oBytes / oTotal;
        mcBar.mcLoadBar.setPercent( oPercent);
        if ( oPercent == 1 && oBytes > 4) {
            onEnterFrame = null;
            onPreloadComplete();
        }
    };

	/////////////////////////////////////
	/*
    //  @method                     preloadNextModule
	//
    //  @description                preload the next module in our preload array
	//	@return						Void
	*/
    function preloadNextModule()
    {
        var oModule = preloadModuleArray.shift();
        oModule.preload();
    }

	/////////////////////////////////////
	/*
    //  @method                     onPreloadComplete
	//
    //  @description                called by a module when it is done preloading
	//	@return						Void
	*/
    function onPreloadComplete()
    {
        if ( preloadModuleArray.length > 0)
        {
            preloadNextModule();
        }
        else
        {
            deactivate();
            _root.gotoAndPlay( "lInit");
        }
    }

	/////////////////////////////////////
	/*
    //  @method                     onRollOver
	//
    //  @description                just here to block the mouse
	//	@return						Void
	*/
    function onRollOver()
    {
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