import mx.events.EventDispatcher;
import com.ask.essentials.*;
import flash.geom.Transform;
import flash.geom.ColorTransform;


class com.ask.essentials.Thumbs extends MovieClip {
	// @property                    reference to the active instance of the thumb class
	static var sActiveExplore:Thumbs;
	
	// @property                    wether we are on or off 
	var mbIsActive:Boolean = false;
	
	// @property                    wether we are enabled or disabled 
	var mbIsEnabled:Boolean = true;
	
	// @property                    wether we Exporer View is on or off
	var mbExplorerActive:Boolean = false;
	
	var intervalId:Number;
	
	var btn:Button;
	var mcTools:MovieClip;
	var bInstance:MovieClip;
	var mcExplorer:MovieClip;
	var mImageHolder:MovieClip;
	var mThumbHolder:MovieClip;
	var container:MovieClip;
	var mcBG:MovieClip;
	
	var mclListener:Object = new Object();
	
	var mThumbNode:Object;
	var mTitle:TextField;
	var mImage:String;
	var mDeviceImg:String;
	var mExplore:Object;
	
	
	function Thumbs()
	{
		setButtons();
	}
	
	/////////////////////////////////////
	/*
    //  @method                     setButtons
	//
    //  @description                assigns methods to buttons
	//	@return						Void
	*/
	function setButtons(){
		mcTools.btn.onRelease = function()
		{
			_parent._parent.showExplore();
		}
		
		mcTools.btn.onRollOut = function()
		{
			_parent._parent.beginInterval();
		}
		
		mcTools.btn.onRollOver = function()
		{
			_parent._parent.clearRollOut();
		}
		
		btn.onRollOut = function()
		{
			_parent.beginInterval();
		}
		
		btn.onRollOver = function()
		{
			_parent.btnRollOver();
		}
		
		btn.onPress = function()
		{
			_parent.onPressButton();
		}
		
		btn.onRelease = function()
		{
			_parent.onReleaseButton();
		}
		
		btn.onReleaseOutside = function()
		{
			_parent.onReleaseButton();
			_parent.btnRollOut();
		}
	}
	/////////////////////////////////////
	/*
    //  @method                     activate
	//
    //  @description                activates thumb
	//	@return						Void
	*/
	function activate(){
		mThumbHolder._alpha = 100;
		mTitle.textColor = 0x336666;
		mbIsEnabled = true;
		setButtons();
	}
	
	/////////////////////////////////////
	/*
    //  @method                     deactivate
	//
    //  @description                deactivates thumb
	//	@return						Void
	*/
	function deactivate(){
		mThumbHolder._alpha = 30;
		mTitle.textColor = 0x999999;
		btn.onPress   = null;
		btn.onRelease = null;
	}

	/////////////////////////////////////
	/*
    //  @method                     
	//
    //  @description                
	//	@return						Void
	*/
	function init( inThumbNode)
    {
        mThumbNode  = inThumbNode;
        mImage      = inThumbNode.mImage;
		mDeviceImg  = inThumbNode.mDeviceImg; 
		mTitle.text = inThumbNode.mTitle;
		mExplore = inThumbNode.mExplore ;
		
		mThumbHolder.loadMovie( 'media/thumbs/'+mImage);
		mImageHolder.container.loadMovie( 'media/images/'+mDeviceImg);
    }
	
	/////////////////////////////////////
	/*
    //  @method                     btnRollOut
	//
    //  @description                on button roll out
	//	@return						Void
	*/
	function btnRollOut():Void 
	{
		if(!mbExplorerActive){
			clearRollOut();
			if(mbIsEnabled){
				mcBG.gotoAndStop('deactive')
			} else {
				mcBG.gotoAndStop('disabled')
			}
			gotoAndPlay('deactive');
			mbIsActive = false;
		}
	}
	
	/////////////////////////////////////
	/*
    //  @method                   	 btnRollOver
	//
    //  @description                on button roll over
	//	@return						Void
	*/
	function btnRollOver():Void 
	{
		clearRollOut();
		if(!mbIsActive)
		{
			if(mbIsEnabled){
				mcBG.gotoAndStop('active')
			} else {
				mcBG.gotoAndStop('disabled')
			}
			
			mbIsActive = true;
			gotoAndPlay('active');
		} 
	}
	
	/////////////////////////////////////
	/*
    //  @method                   	 clearRollOut
	//
    //  @description                clears interval 
	//	@return						Void
	*/
	function clearRollOut():Void 
	{
		clearInterval(intervalId);
	}
	
	/////////////////////////////////////
	/*
    //  @method                   	beginInterval
	//
    //  @description                delays btnRollOut() call
	//	@return						Void
	*/
	function beginInterval():Void 
	{
		clearInterval(intervalId);
		intervalId = setInterval(this, "btnRollOut", 100);
	}

	/////////////////////////////////////
	/*
    //  @method                   	showExplore
	//
    //  @description                activates explore view
	//	@return						Void
	*/
	function showExplore():Void 
	{
		if(sActiveExplore != null){
			sActiveExplore.hideExplore();
			sActiveExplore  = null;
		}
	
		gotoAndPlay('explore');
		positionExpore();
		mbExplorerActive = true;
		sActiveExplore   = this;
		mcExplorer.container.loadMovie('media/explore/'+mExplore);
	}

	/////////////////////////////////////
	/*
    //  @method                   	hideExplore
	//
    //  @description                sets mbExplorerActive to false allowing btnRollOut()
	//	@return						Void
	*/
	function hideExplore():Void 
	{
		mbExplorerActive = false;
	}
	
	/////////////////////////////////////
	/*
    //  @method                   	positionExpore
	//
    //  @description                positions the explorer window on stage
	//	@return						Void
	*/
	function positionExpore(){
		if(_root._xmouse < 375){
			mcExplorer._x = 0;
		} else if(_root._xmouse < 460 && _root._xmouse >375){
			mcExplorer._x = -90;
		} else if(_root._xmouse < 550 && _root._xmouse >460){
			mcExplorer._x = -120;
		} else if(_root._xmouse < 750 && _root._xmouse >550){
			mcExplorer._x = -180;
		} else if(_root._xmouse > 750){
			mcExplorer._x = -340;
		}
	}
	/////////////////////////////////////
	/*
    //  @method                   	
	//
    //  @description                
	//	@return						Void
	*/
	function onPressButton(){
		if(sActiveExplore != null && sActiveExplore != this)
		{
			sActiveExplore.hideExplore();
			sActiveExplore  = null;
		}
		
		if(mbExplorerActive){
			gotoAndPlay('selected');
			mbExplorerActive = false;
		}
		
		mclListener.onLoadInit = function(target_mc:MovieClip):Void {
   	 		target_mc._x = (target_mc._width/2)*-1
			target_mc._y = (target_mc._height/2)*-1
		}
		
		var image_mcl:MovieClipLoader = new MovieClipLoader();
		image_mcl.addListener(mclListener);
		image_mcl.loadClip('media/images/'+mDeviceImg, StaticPad.sInstance.mImageHolder.container);
		
		StaticPad.sInstance.mImageHolder.startDrag(true);
		StaticPad.sInstance.mImageHolder._visible = true;
	}
	
	/////////////////////////////////////
	//
    //  @method                   	
	//
    //  @description                
	//	@return						Void
	
	function onReleaseButton(){
		StaticPad.sInstance.mImageHolder.stopDrag();
		StaticPad.sInstance.mImageHolder._visible = false;
		StaticPad.sInstance.mImageHolder._x = 50;
		StaticPad.sInstance.mImageHolder._y = 50;
	}
}