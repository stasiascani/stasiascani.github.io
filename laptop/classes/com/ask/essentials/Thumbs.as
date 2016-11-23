import mx.events.EventDispatcher;
import com.ask.essentials.*;
import flash.geom.Transform;
import flash.geom.ColorTransform;

class com.ask.essentials.Thumbs extends MovieClip {
	// @property                    reference to the active instance of the thumb class
	static var sActiveExplore:Thumbs;
	
	// @property                    array of thumbs created
	static var sThumbsArray:Array = [];
	
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
	
	var mTitle:TextField;
	var mTitle2:TextField;
	var mThumbNode:Object;
	var mImage:String;
	var mDeviceImg:String;
	var mId:String;
	var mExplore:Object;
	var mAccess:Number;
	var mLinkTo:String;
	
	/////////////////////////////////////
	/*
    //  @method                     clearThumbsArray
	//
    //  @description                clear thumb array to empty
	//	@return						Void
	*/ 
	static function clearThumbsArray():Void
	{
		sThumbsArray = [];
	}
	
	/////////////////////////////////////
	/*
    //  @method                     Thumbs
	//
    //  @description                
	//	@return						Void
	*/  
	function Thumbs()
	{
		setButtons();
		deactivate();
	}
	
	/////////////////////////////////////
	/*
    //  @method                     isActive()
	//
    //  @description                returns wether thumb is active or not
	//	@return						Boolean
	*/ 
	function isActive():Boolean
	{
		return mbIsEnabled ;
	}
	
	/////////////////////////////////////
	/*
    //  @method                     setButtons
	//
    //  @description                
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
	function activate():Void 
	{
		mThumbHolder._alpha = 100;
		mTitle.textColor = 0x336666;
		mTitle2.textColor = 0x336666;
		mbIsEnabled = true;
		mcBG.gotoAndStop('deactive')
		setButtons();
	}
	
	/////////////////////////////////////
	/*
    //  @method                     deactivate
	//
    //  @description                deactivates thumb
	//	@return						Void
	*/
	function deactivate():Void 
	{
		mThumbHolder._alpha = 30;
		mTitle.textColor = 0x999999;
		mTitle2.textColor = 0x999999;
		mbIsEnabled = false;
		btn.onPress   = null;
		btn.onRelease = null;
	}

	/////////////////////////////////////
	/*
    //  @method                     init
	//
    //  @description                inititalizes instance
	//	@return						Void
	*/
	function init( inThumbNode):Void 
    {
        mThumbNode  = inThumbNode;
        mImage      = inThumbNode.mImage;
		mDeviceImg  = inThumbNode.mDeviceImg; 
		mTitle.text = inThumbNode.mTitle;
		mTitle2.text = inThumbNode.mTitle2;
		mExplore    = inThumbNode.mExplore;
		mId 		= inThumbNode.mId;
		mAccess     = parseInt(inThumbNode.mAccess);
		mLinkTo  	= inThumbNode.mLinkTo;
		
		sThumbsArray.push(mId)
		
		mThumbHolder.loadMovie( 'media/thumbs/'+mImage);
		mImageHolder.container.loadMovie( 'media/images/'+mDeviceImg);
		
		if(Shell.sCurrentMode == 1){
			deactivate();
		}
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
			
			if(mExplore != ''){
				gotoAndPlay('deactive');
			}
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
			if(mbIsEnabled)
			{
				mcBG.gotoAndStop('active')
			} else {
				mcBG.gotoAndStop('disabled')
			}
			
			if(mExplore != ''){
				gotoAndPlay('active');
			}
			
			mbIsActive = true;
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
		Shell.sInstance.btnBlocker._visible = true;
	}

	/////////////////////////////////////
	/*
    //  @method                   	hideExplore
	//
    //  @description                
	//	@return						Void
	*/
	function hideExplore():Void 
	{
		mbExplorerActive = false;
		Shell.sInstance.btnBlocker._visible = false;
	}
	
	/////////////////////////////////////
	/*
    //  @method                   	positionExpore
	//
    //  @description                positions the explorer window on stage
	//	@return						Void
	*/
	function positionExpore():Void 
	{
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
    //  @method                   	onPressButton
	//
    //  @description                
	//	@return						Void
	*/
	function onPressButton():Void 
	{
		this.onEnterFrame = function(){
			this.onEnterFrameHitTest();
		}
		
		if(sActiveExplore != null && sActiveExplore != this)
		{
			sActiveExplore.hideExplore();
			sActiveExplore  = null;
		}
		
		if(mbExplorerActive)
		{
			gotoAndPlay('selected');
			mbExplorerActive = false;
		}
		
		mclListener.onLoadInit = function(target_mc:MovieClip)
		{
   	 		target_mc._x = (target_mc._width/2)*-1
			target_mc._y = (target_mc._height/2)*-1
		}
		
		var image_mcl:MovieClipLoader = new MovieClipLoader();
		image_mcl.addListener(mclListener);
		image_mcl.loadClip('media/images/'+mDeviceImg, StaticPad.sInstance.mImageHolder.container);
		
		StaticPad.sInstance.mImageHolder.startDrag(true);
		StaticPad.sInstance.mImageHolder._visible = true;
		
		this.onEnterFrame = function(){
			if (StaticPad.sInstance.mImageHolder.hitTest(Shell.sInstance.mLessonSwf[mId]) && Shell.sInstance.mLessonSwf[mId]._visible != false)
			{
				if(!_root.iShell.mbExpertMode){
					Shell.sInstance.mLessonSwf[mId].highlight._visible = true;
				}
			} else {
				Shell.sInstance.mLessonSwf[mId].highlight._visible = false;
			}
		}
	}
	
	/////////////////////////////////////
	//
    //  @method                   	onReleaseButton
	//
    //  @description                
	//	@return						Void
	
	function onReleaseButton():Void 
	{
		Shell.sInstance.mLessonSwf[mId].highlight._visible = false;
		if (StaticPad.sInstance.mImageHolder.hitTest(Shell.sInstance.mLessonSwf[mId].mcHotSpot) && Shell.sInstance.mLessonSwf[mId]._visible == true &&  Shell.sInstance.mLessonSwf.mbActive == false) 
		{
			if(mAccess == 0 || _root.iShell.iStaticPad.iScroller[mLinkTo].isActive() == false){
				Shell.sInstance.mLessonSwf.stepCounter = 0;
				Shell.sInstance.mLessonSwf.playAssemble(mId);
				deactivate();
			} else if(Shell.sInstance.mLessonSwf.nCurrentAcessLevel == mAccess){
				Shell.sInstance.mLessonSwf.playAssemble(mId);
				deactivate();
			}
		} else if(Shell.sInstance.mLessonSwf.activeLesson.mcHotSpot != undefined) {
			Shell.sInstance.mLessonSwf.stepCounter++;
		}
		
		if(Shell.sInstance.mLessonSwf.stepCounter == 3 && !_root.iShell.mbExpertMode){
			Shell.sInstance.mLessonSwf.playAssemble(Shell.sInstance.mLessonSwf.activeLesson._name);
			Shell.sInstance.mLessonSwf.deactivateThumb(Shell.sInstance.mLessonSwf.activeLesson._name);
			Shell.sInstance.mLessonSwf.activeLesson.autoplay._visible = true;
			Shell.sInstance.mLessonSwf.activeLesson.autoplay.instruction_txt.text = "Autoplay";
			Shell.sInstance.mLessonSwf.stepCounter = 0;
		}
		
		Shell.sInstance.mLessonSwf.test_txt.text = Shell.sInstance.mLessonSwf.stepCounter+" | "+Shell.sInstance.mLessonSwf.activeLesson;
		this.onEnterFrame = null;
		StaticPad.sInstance.mImageHolder.stopDrag();
		StaticPad.sInstance.mImageHolder._visible = false;
		StaticPad.sInstance.mImageHolder._x = 50;
		StaticPad.sInstance.mImageHolder._y = 50;
	}
}