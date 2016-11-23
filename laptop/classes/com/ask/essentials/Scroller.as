import mx.transitions.Tween;
import mx.transitions.easing.*;
import com.ask.essentials.*;
import mx.events.EventDispatcher;

class com.ask.essentials.Scroller extends MovieClip {
                 
	static var sInstance:Scroller;
	static var slideTo:Number;
	
	var dispatchEvent      :Function;
	var addEventListener   :Function;
	var removeEventListener:Function;

	var posSpacing	   :Number = 10;
	var thumbWidth     :Number = 85;
	var slideIncrement :Number = 500;
	var mCurrentThumbs :Number;
	var xPos		   :Tween;
	var mcThumb		   :String;
	
	var sThumbArray:Array;
	var pThumbArray:Array;
	var mThumbNode :Array;

	function Scroller()
	{
		EventDispatcher.initialize( this);
		sInstance = this;
	}
	
	//========================================================
	// @function 
	// @description				create thumbs for scroller
	//========================================================
	function createThumbs(){
		if (mCurrentThumbs != undefined){
			for(var i:Number=0; i < mCurrentThumbs; i++){
				this[mThumbNode[i].mId].removeMovieClip();
			}
		} 

		mThumbNode = sThumbArray
		
		for(var i:Number=0; i < mThumbNode.length; i++){
			mcThumb = mThumbNode[i].mId;
			attachMovie("iThumb", mcThumb, this.getNextHighestDepth(), {_x:(thumbWidth*i)+(posSpacing*i), _y:0});
			this[mcThumb].init(mThumbNode[i])
		}
		
		dispatchEvent( {target:this, type:"onThumbLoad"});
		mCurrentThumbs = mThumbNode.length;
		setPosition();
	}
	
	
	
	//========================================================
    //  @description                resets thumb back to default state
	//	@return						Void
	//========================================================
	static function resetThumbs():Void
	{
		for (var i:Number = 0; i<Thumbs.sThumbsArray.length; i++)
		{
			var thisClip:MovieClip = _root.iShell.iStaticPad.iScroller[Thumbs.sThumbsArray[i]];
			switch(Shell.sCurrentMode)
			{
				case 0:
					if(!thisClip.isActive())
					{
						thisClip.activate()
					}
					break;
				case 1:
					if(thisClip.isActive())
					{
						thisClip.deactivate()
					}
					break;
			}
		}
		_root.iShell.iStaticPad.iScroller.setPosition();
	}
	
	static function positionThumbs(){
		_root.iShell.iStaticPad.iScroller.setPosition();
	}
	//========================================================
	// @function 
	// @description				set scroller position
	//========================================================
	function setPosition(){
		if(Shell.sCurrentLesson == 1){
			slideTo = 37;
		} else if(Shell.sCurrentLesson == 2){
			slideTo = -720
		} else if(Shell.sCurrentLesson == 3){
			slideTo = -910;
		} else if(Shell.sCurrentLesson == 4){
			slideTo = -1080;
		} else if(Shell.sCurrentLesson == 5){
			slideTo = -1480;
		} else if(Shell.sCurrentLesson == 6){
			slideTo = -1870;
		} else if(Shell.sCurrentLesson == 7){
			slideTo = -2140;
		} 
		xPos = new Tween(this, "_x", Regular.easeOut, this._x, slideTo, 60, false);
		var callback:Object = this;
		xPos.onMotionFinished = function(obj) {
			callback.setButtons();
		}
	}
	
	//========================================================
	// @function 
	// @description				scroll movie right
	//========================================================
	function slideRight()
	{
		if(this._x + slideIncrement > 30)
		{
			xPos = new Tween(this, "_x", Regular.easeOut, this._x, 37, 1.5, true);
			
		} else {
			
			xPos = new Tween(this, "_x", Regular.easeOut, this._x, this._x+slideIncrement, 1.5, true);
		}
		
		var callback:Object = this;
		xPos.onMotionFinished = function(obj) {
			callback.setButtons();
		}
	}
	
	//========================================================
	// @function 
	// @description				scroll movie left
	//========================================================
	function slideLeft()
	{
		if(this._x- slideIncrement< (this._width - 550)*-1)
		{
			
			xPos = new Tween(this, "_x", Regular.easeOut, this._x, (this._width - 675)*-1, 1.5, true);
			
		} else {
			
			xPos = new Tween(this, "_x", Regular.easeOut, this._x, this._x-slideIncrement, 1.5, true);
		}
		
		var callback:Object = this;
		xPos.onMotionFinished = function(obj) {
			callback.setButtons();
		}
	}
	//========================================================
	// @function 
	// @description				set navigation button
	//========================================================
	function setButtons()
	{
		if(this._x > 36)
		{
			_parent.iScrollRight.activate();
			_parent.iScrollLeft.deactivate();
		
		} else if (this._x < (this._width - 750)*-1){
			
			_parent.iScrollRight.deactivate();
			_parent.iScrollLeft.activate();
			
		} else {
			_parent.iScrollRight.activate();
			_parent.iScrollLeft.activate();
		}
	}
}