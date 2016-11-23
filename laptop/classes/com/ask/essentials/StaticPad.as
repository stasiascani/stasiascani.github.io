import mx.events.EventDispatcher;
import mx.transitions.Tween;
import mx.transitions.easing.*;
import com.ask.essentials.*;
import com.ask.utils.*;

class com.ask.essentials.StaticPad extends MovieClip {
	static var sInstance:StaticPad;
	
	var iScrollLeft  :Buttons;
	var iScrollRight :Buttons;
	var iScroller    :MovieClip;
	var mImageHolder :MovieClip;
	var tTitle       :TextField;
	var yPos         :Tween;
	var thumbData    :Object = new Object();
	var iBytesTotal:Number;
	
	public var addEventListener:Function;
	public var removeEventLIstener:Function;
	private var dispatchEvent:Function;
	
	function StaticPad()
	{  
		sInstance = this;
		EventDispatcher.initialize(this);
	}

	function createStaticPad(){
		slideOUT();
	}
	
	function slideIN(){
		yPos = new Tween(this, "_y", Regular.easeOut, this._y, 467, 1, true);
	}
	
	function slideOUT(){
		yPos = new Tween(this, "_y", Regular.easeOut, this._y, 610, 1, true);
		
		var oInstance = this;
		yPos.onMotionFinished = function(eventObj){
			oInstance.iScroller.createThumbs();
		};
	}
	
	function hide(){
		yPos = new Tween(this, "_y", Regular.easeOut, this._y, 610, 1, true);
	}
	
	function onToggle(inEvent:Object)
	{
		if (Thumbs.sActiveExplore != null){
			Thumbs.sActiveExplore.hideExplore();
			Thumbs.sActiveExplore  = null;
		}
		
		switch ( inEvent.toggle)
		{
			case iScrollLeft:
				iScroller.slideRight();
				break;
			case iScrollRight:
				iScroller.slideLeft();
				break;
		}
	}
	
	function onThumbLoad(){
		slideIN();
		dispatchEvent({type:"onCreateThumbs"});
	}
}