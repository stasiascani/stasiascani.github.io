////////////////////////////////////////////////////////////////////////////
/*
//  Player Class
//
//  @class              Player
//  @package            com.ask.coaching
//	@extends			MovieClip
//
//  @author             Dave Castelnuovo
//	@version			1.0
//  @date                   2005-10-20
//
//	@description	Description
//
//  @symbolName   com.ask.video.Player
//  @linkageID    com.ask.video.Player
//
// Copyright (c) 2005 ASK learning. All rights reserved.
*/
///////////////////////////////////////////////////////////////////////////

import mx.events.EventDispatcher;

import com.ask.lib.*;
import com.ask.utils.*;
import com.ask.video.*;

class com.ask.video.Player extends MovieClip {


////////////////////////////////////////////////////////////////////////////
//
// Properties
//
////////////////////////////////////////////////////////////////////////////

	// @property					Used for debugging
    var className:String = "Player";

	// @property					symbolName for object. Used to attach.
    static var symbolName:String = "com.ask.video.Player";

	// @property					Class used in createClassObject
    static var symbolOwner = com.ask.video.Player;


	// @method						Method stub to be mixed in by EventDispatcher.
	// @see mx.events.EventDispatcher
	var dispatchEvent:Function;

	// @method						Method stub to be mixed in by EventDispatcher
	// @see mx.events.EventDispatcher
	var addEventListener:Function;

	// @method						Method stub to be mixed in by EventDispatcher
	// @see mx.events.EventDispatcher
	var removeEventListener:Function;


    var iLoadLoop:MovieClip;
    var iPlayLoop:MovieClip;
    var mControlClip:MovieClip;


    static var mbCaptionOn:Boolean = false;
    var iCaption:MovieClip;

    var mPreloadUrl:String;
    var mPreloadMap:Object;

    var mbDrag:Boolean = false;
    var mUrl:String;
    var mBaseUrl:String;
    var mDuration:Number = 0;
    var mDefaultCaptionDuration = 3;
    var mTime:Number = 0;

    var mbBufferFlush:Boolean = false;
    var mbBufferStop:Boolean = false;
    var mbBufferEmpty:Boolean = false;
    var mbMovieComplete:Boolean = false;

    var mCaption:String = "";
    var mEventNodeArray:Array;
    var mVideoEventListener:Object;

    var mVideo:Video;
    var mSwfStub:MovieClip;
    var mPlayingSwf:MovieClip;

    var mbPlaying:Boolean = false;
    var mbPlaySwf:Boolean = false;
    var mToggleProxy:Object;

    var mScrubberArray:Array;
    var mSectionIndex:Number;

    var mRevealPercent:Number;

    // @property                    a map of all the event types we encounter
    var mEventTypeMap:Object;

    // @property                    the net connection object we will use for all our video
    var mNetConnection:NetConnection;

    // @property                    the net stream object we will use for all our video
    var mNetStream:NetStream;

    // @property                    global sound object
    static var mGlobalSound:Sound;

    // @property                    used to init our statics
    static var mbClassConstruct:Boolean = classConstruct();


////////////////////////////////////////////////////////////////////////////
//
//  Class Constructor
//
//  @method                         ClassConstruct.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    static function classConstruct():Boolean
    {
        mGlobalSound = new Sound();
        return true;
	}


////////////////////////////////////////////////////////////////////////////
//
//	Constructor
//
//  @method                         Player Constructor.
//  @description                Constructor.
//
////////////////////////////////////////////////////////////////////////////


    function Player()
    {
        initPlayer();
	}


////////////////////////////////////////////////////////////////////////////
//
//	Initialization
//
//	@method							Init.
//  @description                Initilizes Player.
//
////////////////////////////////////////////////////////////////////////////


    private function initPlayer():Void
    {
		// add ability to broadcast events.
        EventDispatcher.initialize( this);

        // set the event to a local object, so our subclass can overrite it without worrying about screwing this event up
        mVideoEventListener = {};
        mVideoEventListener._parent = this;
        addEventListener( "onVideoEvent", mVideoEventListener);
        mVideoEventListener.onVideoEvent = function( inEvent:Object)
        {
            switch ( inEvent.mEventType)
            {
                case "caption":
                    if ( inEvent.node != false)
                    {
                        _parent.mCaption = inEvent.node.text;
                    }
                    else
                    {
                        _parent.mCaption = "";
                    }
                    break;
            }
        }

        createEmptyMovieClip( "iLoadLoop", 1000);
        createEmptyMovieClip( "iPlayLoop", 2000);
        mPreloadMap = {};

        mNetConnection = new NetConnection();
        mNetConnection.connect( null);

        mNetStream = new NetStream( mNetConnection);
        mNetStream.setBufferTime( 15);
        mNetStream._parent = this;
        mNetStream.onStatus = function( inInfo:Object)
        {
            this._parent.onStreamStatus( inInfo);
        };
        mNetStream.onMetaData = function( inInfo:Object)
        {
            this._parent.onStreamMetaData( inInfo);
        };
	}

////////////////////////////////////////////////////////////////////////////
//
//  Static Methods
//
////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////////////////////////


	/////////////////////////////////////
	/*
    //  @method                     attachSwfStub
	//
    //  @description                attach our stream to a video
    //  @param                      inSwfStub       the stub we load our swf type movies into
	//	@return						Void
	*/
    function attachSwfStub( inSwfStub:MovieClip)
    {
        mSwfStub = inSwfStub;
    }

	/////////////////////////////////////
	/*
    //  @method                     attachVideo
	//
    //  @description                attach our stream to a video
    //  @param                      inVideo         the video object
	//	@return						Void
	*/
    function attachVideo( inVideo:Video)
    {
        mVideo = inVideo;
        inVideo.attachVideo( mNetStream);
    }

	/////////////////////////////////////
	/*
    //  @method                     closeVideo
	//
    //  @description                shut down our video stream
	//	@return						Void
	*/
    function closeVideo()
    {
        mbPlaying = false;
        mPlayingSwf._visible = false;
        mPlayingSwf.gotoAndStop( 1);
        iPlayLoop.onEnterFrame = null;
        iLoadLoop.onEnterFrame = null;
        mNetStream.close();
    }

	/////////////////////////////////////
	/*
    //  @method                     playVideo
	//
    //  @description                play a video stream
    //  @param                      inUrl           the url of the stream
	//	@return						Void
	*/
    function playVideo( inUrl:String)
    {
        mbPlaying = true;
        mNetStream.play( inUrl);
    }


////////////////////////////////////////////////////////////////////////////
//
//	Private Methods
//
////////////////////////////////////////////////////////////////////////////


    function closeFlv()
    {
        mbPlaying = false;
        onPlayerHideVideoMode();
    }

    function onPlayerShowVideoMode()
    {
        this.gotoAndPlay( "video");
    }

    function onPlayerHideVideoMode()
    {
        this.gotoAndPlay( "standard");
    }

    function setScrubberArray( inScrubberArray:Array)
    {
        mScrubberArray = inScrubberArray;
    }

    function setRevealPercent( inRevealPercent:Number)
    {
        mRevealPercent = inRevealPercent;
    }

    function playSwf( inUrl:String)
    {
        mbPlaySwf = true;
        playContent( inUrl);
    }

    function playFlv( inUrl:String)
    {
        mbPlaySwf = false;
        playContent( inUrl);
    }

    function playContent( inUrl:String)
    {
        mBaseUrl = inUrl;
        mbPlaying = true;
        mDuration = 0;
        mCaption = "";
        mbMovieComplete = false;
        mPlayingSwf._visible = false;
        mPlayingSwf.gotoAndStop(1);

        if ( mScrubberArray != undefined)
        {
            mSectionIndex = -1;
            var oIndex = 0;
            while ( oIndex < mScrubberArray.length)
            {
                if ( mScrubberArray[ oIndex] == mBaseUrl)
                {
                    mSectionIndex = oIndex;
                    break;
                }

                oIndex ++;
            }

            if ( mSectionIndex == -1)
            {
                mScrubberArray = null;
            }
        }

        mControlClip.iPlay.deactivate();

        if ( mbPlaySwf == true)
        {
            mUrl = inUrl + ".swf";
        }
        else
        {
            mUrl = inUrl + ".flv";
        }
		
		if ( mbPlaySwf == true)
        {
            mSwfStub.createEmptyMovieClip( "iSwf", 1);
            var oMovieClipLoader:MovieClipLoader = new MovieClipLoader();
            oMovieClipLoader.loadClip( mUrl, mSwfStub.iSwf);
            oMovieClipLoader.addListener( this);
            mPlayingSwf = mSwfStub.iSwf;
        }
        else
        {
            playVideo( mUrl);
        }

        iPlayLoop.onEnterFrame = function()
        {
            _parent.onEnterFramePlay();
        }
        iLoadLoop.onEnterFrame = function()
        {
            _parent.onEnterFrameLoad();
        }
       onPlayerShowVideoMode();
    }

    function onLoadInit( inMovieClip:MovieClip)
    {
        inMovieClip.gotoAndStop( 1);
    }

    function onLoadComplete( inMovieClip:MovieClip)
    {
        inMovieClip.gotoAndStop( 1);
    }

	/////////////////////////////////////
	/*
    //  @method                     onStreamStatus
	//
    //  @description                called when our video stream gets an onStatusEvent
    //  @param                      inInfo          info about the event
	//	@return						Void
	*/
    function onStreamStatus( inInfo:Object)
    {
        switch ( inInfo.code)
        {
            case "NetStream.Seek.InvalidTime":
                mNetStream.seek( inInfo.details);
                break;
            case "NetStream.Play.Stop":
                if ( mbBufferFlush == true)
                {
                    mbMovieComplete = true;
                    closeFlv();
                    dispatchEvent( { target: this, type: "onVideoComplete"});
                }
                mbBufferFlush = false;
                mbBufferStop = true;
                mbBufferEmpty = false;
                break;
            case "NetStream.Buffer.Empty":
                if ( mbBufferStop == true)
                {
                    mbMovieComplete = true;
                    closeFlv();
                    dispatchEvent( { target: this, type: "onVideoComplete"});
                }
                mbBufferFlush = false;
                mbBufferStop = false;
                mbBufferEmpty = true;
                break;
            case "NetStream.Buffer.Flush":
                // if we were immediately preceded by a stop of empty, then we are at the end of the movie
                if (( mbBufferEmpty == true) ||
                    ( mbBufferStop == true))
                {
                    mbMovieComplete = true;
                    closeFlv();
                    dispatchEvent( { target: this, type: "onVideoComplete"});
                }
                mbBufferFlush = true;
                mbBufferStop = false;
                mbBufferEmpty = false;
                break;
            default:
                mbBufferFlush = false;
                mbBufferStop = false;
                mbBufferEmpty = false;
                mbMovieComplete = false;
                break;
        }
    }

	/////////////////////////////////////
	/*
    //  @method                     onStreamMetaData
	//
    //  @description                called when our video stream gets an onMetaData event
    //
    //                              the info object contains the following attributes
    //
    //                                canSeekToEnd
    //                                videocodecid
    //                                framerate
    //                                videodatarate
    //                                height
    //                                width
    //                                duration
    //
    //  @param                      inInfo          info about the event
	//	@return						Void
	*/
    function onStreamMetaData( inInfo:Object)
    {
        mDuration = inInfo.duration;
    }

    function refreshVideoUi()
    {
        mControlClip.iFF1.mPlayer = this;
        mControlClip.iFF1.onRelease = function()
        {
            this.mPlayer.onFF1();
        }

        mControlClip.iRW1.mPlayer = this;
        mControlClip.iRW1.onRelease = function()
        {
            this.mPlayer.onRW1();
        }

        mControlClip.iFF2.mPlayer = this;
        mControlClip.iFF2.onRelease = function()
        {
            this.mPlayer.onFF2();
        }
        mControlClip.iRW2.mPlayer = this;
        mControlClip.iRW2.onRelease = function()
        {
            this.mPlayer.onRW2();
        }

        if ( mToggleProxy == undefined)
        {
            mToggleProxy = {};
            mToggleProxy._parent = this;
        }
        mToggleProxy.onToggle = function( inEvent:Object)
        {
            this._parent.onTogglePlayer( inEvent);
        }

        if ( mbPlaying == true)
        {
            mControlClip.iPlay.deactivate();
        }
        else
        {
            mControlClip.iPlay.activate();
        }
        mControlClip.iPlay.addEventListener( "onToggle", mToggleProxy);

        if ( mGlobalSound.getVolume() == 100)
        {
            mControlClip.iSound.activate();
        }
        else
        {
            mControlClip.iSound.deactivate();
        }
        mControlClip.iSound.addEventListener( "onToggle", mToggleProxy);

        if ( mbCaptionOn == true)
        {
            iCaption.gotoAndPlay( "active");
            mControlClip.iCaption.activate();
        }
        else
        {
            iCaption.gotoAndPlay( "deactive");
            mControlClip.iCaption.deactivate();
        }
        mControlClip.iCaption.addEventListener( "onToggle", mToggleProxy);

        mControlClip.iScrubHandle.mPlayer = this;
        mControlClip.iBarBackdrop.mPlayer = this;
        mControlClip.iBarBackdrop.onPress = function()
        {	
			 this.mPlayer.onPressScrubHandle();
        }
        mControlClip.iBarBackdrop.onRelease = function()
        {
            this.mPlayer.onReleaseScrubHandle();
        }
        mControlClip.iBarBackdrop.onReleaseOutside = function()
        {
            this.mPlayer.onReleaseScrubHandle();
        }

        mControlClip.iScrubHandle._x = mControlClip.iControls.iBarBackdrop._x;
        mControlClip.iLoadBar.setPercent( 0);

        if ( mRevealPercent != undefined)
        {
            mControlClip.iRevealBar. n( mRevealPercent);
        }
    }

    function onEnterFrameLoad()
    {
        var oPercent = 0;
        if ( mbPlaySwf == true)
        {
            var oBytesLoaded = mPlayingSwf.getBytesLoaded();
            var oBytesTotal = mPlayingSwf.getBytesTotal();

            if (( oBytesLoaded != 4) &&
                ( oBytesLoaded != 0))
            {
                oPercent = oBytesLoaded / oBytesTotal;
            }
        }
        else if ( mNetStream.bytesTotal > 0)
        {
            oPercent = mNetStream.bytesLoaded / mNetStream.bytesTotal;
        }
		
        mControlClip.iLoadBar.setPercent( oPercent);
    }

    function onFF1()
    {
        mNetStream.seek( mTime + 1);
    }

    function onRW1()
    {
        mNetStream.seek( mTime - 5);
    }

    function onFF2()
    {
        mNetStream.seek( mTime + 10);
    }

    function onRW2()
    {
        mNetStream.seek( mTime - 10);
    }

	/////////////////////////////////////
	/*
    //  @method                     onTogglePlayer
	//
    //  @description                call by one of our toggles when they get selected
    //  @param                      inEvent     the event that was triggered
	//	@return						Void
	*/
    function onTogglePlayer( inEvent)
    {
        switch ( inEvent.toggle)
        {
            case mControlClip.iPlay:
                if ( mControlClip.iPlay.isActive() == true)
                {
                    onPlay();
                }
                else
                {
                    onPause();
                }
                break;
            case mControlClip.iSound:
                if ( mControlClip.iSound.isActive() == true)
                {
                    soundOn();
                }
                else
                {
                    soundOff();
                }
                break;
            case mControlClip.iCaption:
                if ( mControlClip.iCaption.isActive() == true)
                {
                    captionOn();
                }
                else
                {
                    captionOff();
                }
                dispatchEvent( { type: "onToggleCaption", mbCaptionOn: mbCaptionOn});
                break;
        }
    }

    function onPlay()
    {	
        if ( mbPlaySwf == true)
        {
            mPlayingSwf.stop();
        }
        else
        {
            mNetStream.pause( true);
        }
        dispatchEvent( { type: "onPauseVideo"});
    }

    function onPause()
    {
        if ( mbPlaySwf == true)
        {
            if ( mbMovieComplete != true)
            {
                mPlayingSwf.play();
            }
        }
        else
        {
            mNetStream.pause( false);
        }
        dispatchEvent( { type: "onPlayVideo"});
    }

    function soundOn()
    {	
        mGlobalSound.setVolume( 100);
    }

    function soundOff()
    {	
        mGlobalSound.setVolume( 0);
    }

    function captionOn()
    {
        mbCaptionOn = true;
        iCaption.gotoAndPlay( "active");
    }

    function captionOff()
    {
        mbCaptionOn = false;
        iCaption.gotoAndPlay( "deactive");
    }
	
	function disableScrub(){
		mControlClip.iBarBackdrop.enabled = false;
	}
	
	function enableScrub(){
		mControlClip.iBarBackdrop.enabled = true;
	}

    function updatePlayBar( inPercent:Number)
    {
        if ( mScrubberArray != undefined)
        {
            var oSectionWidth = ( mControlClip.iBarBackdrop._width - mControlClip.iScrubHandle._x) / mScrubberArray.length;
            var oStartXPos = mControlClip.iBarBackdrop._x + ( oSectionWidth * mSectionIndex);
            mControlClip.iScrubHandle._x = oStartXPos + ( oSectionWidth * inPercent);
        }
        else
        {
            var oStartXPos = mControlClip.iBarBackdrop._x;
            var oDeltaXPos = mControlClip.iBarBackdrop._width - mControlClip.iScrubHandle._width;
            mControlClip.iScrubHandle._x = oStartXPos + ( oDeltaXPos * inPercent);
        }

        if ( mRevealPercent != undefined)
        {
            var oRevealPercent = ( mControlClip.iScrubHandle._x - mControlClip.iBarBackdrop._x) / ( mControlClip.iBarBackdrop._width - mControlClip.iScrubHandle._x);
            if ( oRevealPercent > mRevealPercent)
            {
                mRevealPercent = oRevealPercent;
                dispatchEvent( { type: "onVideoRevealPercent", mRevealPercent: mRevealPercent});
            }
            mControlClip.iRevealBar.setPercent( mRevealPercent);
        }
    }

    function onEnterFramePlay()
    {
        var oPercent = 0;
        var oEventTime = 0;
        if ( mbPlaySwf == true)
        {
            oPercent = mPlayingSwf._currentframe / mPlayingSwf._totalframes;
            oEventTime = mPlayingSwf._currentframe;
			
            if (( mPlayingSwf._currentframe == mPlayingSwf._totalframes) &&
                ( mbMovieComplete != true))
            {
                mPlayingSwf.stop();
				
                mbMovieComplete = true;
                dispatchEvent( { target: this, type: "onVideoComplete"});
            }
        }
        else
        {
            if ( mDuration != 0)
            {
                oPercent = mNetStream.time / mDuration;
            }

            oEventTime = mNetStream.time;
        }
        mTime = oEventTime;
        var oEventMap = {};

        var oIndex = 0;
        while ( oIndex < mEventNodeArray.length)
        {
            var oEvent = mEventNodeArray[ oIndex];
            var oMinTime = parseFloat( oEvent.attributes.time);
            var oDuration = mDefaultCaptionDuration;
            if ( oEvent.attributes.duration != undefined)
            {
                oDuration = parseFloat( oEvent.attributes.duration);
            }
            var oMaxTime = oMinTime + oDuration;
            if (( oMinTime < oEventTime) &&
                ( oMaxTime > oEventTime))
            {
                oEventMap[ oEvent.attributes.type] = oEvent;
            }

            oIndex ++;
        }

        // process all the video events that we know about
        for ( var oName in mEventTypeMap)
        {
            if ( oEventMap[ oName] == undefined)
            {
                oEventMap[ oName] = false;
            }
            if ( mEventTypeMap[ oName] != oEventMap[ oName])
            {
                mEventTypeMap[ oName] = oEventMap[ oName];
                dispatchEvent( { target: this, type: "onVideoEvent", mEventType: oName, node: oEventMap[ oName]});
            }
        }
        updatePlayBar( oPercent);
    }

    function onPressScrubHandle()
    {
        mbDrag = true;
        if ( mScrubberArray != undefined)
        {
            mControlClip.iScrubHandle.onEnterFrame = function()
            {
                this.mPlayer.onEnterFrameDragScrubArray();
            }
        }
        else
        {
            mControlClip.iScrubHandle.onEnterFrame = function()
            {
                this.mPlayer.onEnterFrameDrag();
            }
        }

        if ( mbPlaySwf != true)
        {
            mNetStream.pause( true);
        }
    }

    function onReleaseScrubHandle()
    {
		mbDrag = false;
        mControlClip.iScrubHandle.onEnterFrame = null;

      // if ( mControlClip.iPlay.isActive() == false)
       // {
            if ( mbPlaySwf != true)
            {
                mNetStream.pause( true);
            }
            else
            {
                mPlayingSwf.stop();
            }
        //}
    }

    function onEnterFrameDrag()
    {
        mbMovieComplete = false;
        var oStartXPos = mControlClip.iBarBackdrop._x;
        var oDeltaXPos = mControlClip.iBarBackdrop._width - mControlClip.iScrubHandle._width;
		
        if ( mControlClip._xmouse < oStartXPos)
        {
            mControlClip.iScrubHandle._x = oStartXPos;
        }
        else if ( mControlClip._xmouse > ( oStartXPos + oDeltaXPos))
        {
            mControlClip.iScrubHandle._x = oStartXPos + oDeltaXPos;
        }
        else
        {
            mControlClip.iScrubHandle._x = mControlClip._xmouse;
        }

        var oMouseDelta = mControlClip.iScrubHandle._x - oStartXPos;
        var oPercent = oMouseDelta / oDeltaXPos;

        if ( mbPlaySwf == true)
        {
            var oFrame = Math.floor( oPercent * ( mPlayingSwf._totalframes - 1)) + 1;
            mPlayingSwf.gotoAndStop( oFrame);
        }
        else
        {
            mNetStream.seek( mDuration * oPercent);
        }
    }


    function onEnterFrameDragScrubArray()
    {
        mbMovieComplete = false;
        var oStartXPos = mControlClip.iBarBackdrop._x;
        var oDeltaXPos = mControlClip.iBarBackdrop._width - mControlClip.iScrubHandle._width;

        if ( mControlClip._xmouse < oStartXPos)
        {
            mControlClip.iScrubHandle._x = oStartXPos;
        }
        else if ( mControlClip._xmouse > ( oStartXPos + oDeltaXPos))
        {
            mControlClip.iScrubHandle._x = oStartXPos + oDeltaXPos;
        }
        else if (( mRevealPercent != undefined) &&
                 ( mControlClip._xmouse > ( oStartXPos + ( oDeltaXPos * mRevealPercent))))
        {
            mControlClip.iScrubHandle._x = oStartXPos + ( oDeltaXPos * mRevealPercent);
        }
        else
        {
            mControlClip.iScrubHandle._x = mControlClip._xmouse;
        }



        var oSectionWidth = ( mControlClip.iBarBackdrop._width - mControlClip.iScrubHandle._x) / mScrubberArray.length;
        var oSectionPercent = ( mControlClip.iScrubHandle._x - oStartXPos) / oSectionWidth;
        var oSectionIndex = Math.floor( oSectionPercent);
        var oSectionPercent = oSectionPercent - oSectionIndex;

        if ( oSectionIndex != mSectionIndex)
        {
            // we need to change sections
            playContent( mScrubberArray[ oSectionIndex]);
            dispatchEvent( { type: "onVideoChangeSection", mSectionIndex: mSectionIndex, mUrl: mBaseUrl});
        }

        if ( mbPlaySwf == true)
        {
            var oFrame = Math.floor( oSectionPercent * ( mPlayingSwf._totalframes - 1)) + 1;
            mPlayingSwf.gotoAndStop( oFrame);
        }
        else
        {
            mNetStream.seek( mDuration * oSectionPercent);
        }
    }


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