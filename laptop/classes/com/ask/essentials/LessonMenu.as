import mx.events.EventDispatcher;
import mx.transitions.Tween;
import mx.transitions.easing.*;
import com.ask.essentials.*;

class com.ask.essentials.LessonMenu extends MovieClip {
	static var sInstance = LessonMenu;
	
	var dispatchEvent      :Function;
	var addEventListener   :Function;
	var removeEventListener:Function;
	
	var yPos:Tween;
	
	var mcSection1:MovieClip;
	var mcSection2:MovieClip;
	var mcSection3:MovieClip;
	
	var mbLink1Collapsed:Boolean = false;
	var mbLink2Collapsed:Boolean = false;
	var mbLink3Collapsed:Boolean = false;
	
	var nPosition1:Number;
	var nPosition2:Number;
	var nPosition3:Number;
	
	// flag for peripherals pad
	var mbActive:Boolean;

	function LessonMenu()
	{ 
		sInstance = this;
		init();
	}
	
	function init(){
		mcSection1.btn.onRelease = function()
		{
			_parent._parent.onSlide(_parent._parent.mcSection1);
			Shell.sInstance.mbExpertMode = false;
			Shell.sInstance.restartUI()
		}
		
		mcSection2.btn.onRelease = function()
		{
			_parent._parent.onSlide(_parent._parent.mcSection2);
			Shell.sInstance.mbExpertMode = true;
			Shell.sInstance.restartUI();
			
		}
		
		mcSection3.btn.onRelease = function()
		{
			_parent._parent.onSlide(_parent._parent.mcSection3);
			Shell.sInstance.loadExplorerMode()
		}
		
		onSlide(mcSection1)
	}
	
	function onSlide(pThisClip)
	{
		switch (pThisClip){
			case mcSection1:
				nPosition1 = 0;
				nPosition2 = 455;
				nPosition3 = 483;
				break;
			case mcSection2:
				nPosition1 = 0;
				nPosition2 = 28;
				nPosition3 = 483;
				break;
			case mcSection3:
				nPosition1 = 0;
				nPosition2 = 28;
				nPosition3 = 56;
				break;
			}
		
		yPos = new Tween(mcSection1, "_y", Regular.easeOut, mcSection1._y, nPosition1, 1.5, true);
		yPos = new Tween(mcSection2, "_y", Regular.easeOut, mcSection2._y, nPosition2, 1.5, true);
		yPos = new Tween(mcSection3, "_y", Regular.easeOut, mcSection3._y, nPosition3, 1.5, true);
	}
	
	function isActive(){
		return mbActive;
	}
}