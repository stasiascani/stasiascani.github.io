import com.ask.essentials.*;
import com.ask.lib.*;
import com.ask.utils.*;
class com.ask.essentials.Shell extends MovieClip {
	static var sInstance:Shell;
	
	static var sThumbArray:Array;
	static var sLessonArray:Array;
	static var pThumbArray:Array;
	static var sAccordianArray:Array;
	
	static var sThumbNode:Object;
	static var sLessonNode:Object;
	static var sModelNode:Object;
	static var sAccordianNode:Object;
	
	static var sLessonLayer:Object;
	static var sArrayId:Object;
	static var mAccessLevel:Object;
	static var sCurrentMode:Number;
	static var sCurrentLesson:Number;
	
	var mbExpertMode:Boolean = false ;
	var mLessonSwf:MovieClip;
	var iStaticPad:MovieClip;
	var preloader:MovieClip;
	var iMenu:MovieClip;
	var btnBlocker:Button;
	var mclListener:Object = new Object();
	
	function Shell() 
	{
		sInstance = this;
		this.gotoAndPlay("lActivate");
		btnBlocker._visible = false;
		preload();
	}
	static function preload() 
	{
		sThumbArray  = [];
		pThumbArray  = [];
		sLessonArray = [];
		sAccordianArray = [];
		Connection.loadXml(Shell, "essentials.xml");
	}
	
	
	static function onXmlNode(inNodeName:String, inNode:Object) 
	{
		switch (inNodeName) {
		case "pThumb" :
			sThumbNode = inNode;
			sThumbNode.mId = [inNode.attributes.id];
			break;
		case "thumb" :
			sThumbNode = inNode;
			sThumbNode.mId = [inNode.attributes.id];
			sThumbNode.mAccess = [inNode.attributes.accessLevel];
			sThumbNode.mLinkTo = [inNode.attributes.linkTo];
			break;
		case "title" :
			sThumbNode.mTitle = Connection.getHtml();
			break;
		case "title2" :
			sThumbNode.mTitle2 = Connection.getHtml();
			break;
		case "smallImg" :
			sThumbNode.mImage = Connection.getHtml();
			break;
		case "largeImg" :
			sThumbNode.mDeviceImg = Connection.getHtml();
			break;
		case "explore" :
			sThumbNode.mExplore = Connection.getHtml();
			break;
		case "/thumb" :
			sThumbArray.push(sThumbNode);
			break;
		case "/pThumb" :
			pThumbArray.push(sThumbNode);
			break;
		case "lesson" :
			sLessonLayer = [inNode.attributes.layer];
			sLessonNode = inNode;
			sLessonNode.mModel = [];
			sLessonNode.mFile = [inNode.attributes.file];
			break;
		case "modelName" :
			sLessonNode.mModel.push({id:[inNode.attributes.id]});
			break;
		case "/lesson" :
			sLessonArray[sLessonLayer] = sLessonNode;
			break;
		case "accordian" :
			sAccordianNode       = inNode;
			sAccordianNode.mId   = [inNode.attributes.id];
			sAccordianNode.mFile = [inNode.attributes.file];
			break;
		case "text" :
			sAccordianNode.mText = Connection.getHtml();
			break;
		case "text2" :
			sAccordianNode.mText2 = Connection.getHtml();
			break;
		case "text3" :
			sAccordianNode.mText3 = Connection.getHtml();
			break;
		case "/accordian" :
			sAccordianArray.push(sAccordianNode) 
			break;
		}
	}
 	
	static function onLoadXml( inXml:FastXml)
    {
    }
	
	function refreshUI() 
	{
		sCurrentMode   = _root.mode;
		sCurrentLesson = _root.lesson;
		iStaticPad.iScroller.sThumbArray = sThumbArray;
		iStaticPad.iScroller.pThumbArray = pThumbArray;
		iStaticPad.createStaticPad();
		iMenu.mcSection1.createAccordion( sAccordianArray);
		loadLessonNum(sCurrentLesson);
	}
	
	function restartUI() 
	{
		Scroller.resetThumbs();
		iStaticPad.createStaticPad();
		loadLessonNum(sCurrentLesson);
	}
	
	function loadLessonNum(pNum) 
	{
		sCurrentLesson = pNum;
		if (mbExpertMode){
			Scroller.positionThumbs();
		} else {
			Scroller.resetThumbs();
		}
		
		LessonMenu.sInstance.mcSection1.iAccordion.selectedIndex = (sCurrentLesson-1);
		
		mclListener.onLoadInit = function(target_mc:MovieClip):Void  {
			sLessonArray[pNum].mMode = sCurrentMode;
			target_mc.oLessonData = sLessonArray[pNum];
			target_mc.gotoAndPlay('lInit');
			Shell.sInstance.preloader._visible = false;
		};
		
		mclListener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void  {
			var percentLoaded = Math.ceil(bytesLoaded/bytesTotal*100);
			Shell.sInstance.preloader.bar._xscale = percentLoaded;
			Shell.sInstance.preloader._visible = true;
		};
		
		var image_mcl:MovieClipLoader = new MovieClipLoader();
		image_mcl.addListener(mclListener);
		image_mcl.loadClip('models/'+sLessonArray[pNum].mFile, mLessonSwf);
	}
	
	function loadExplorerMode() {
		iStaticPad.hide();
		mclListener.onLoadInit = function(target_mc:MovieClip):Void  {
			Shell.sInstance.preloader._visible = false;
			target_mc.gotoAndPlay('lInit');
		};
		
		mclListener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void  {
			var percentLoaded = Math.ceil(bytesLoaded/bytesTotal*100);
			Shell.sInstance.preloader.bar._xscale = percentLoaded;
			Shell.sInstance.preloader._visible = true;
		};
		
		var image_mcl:MovieClipLoader = new MovieClipLoader();
		image_mcl.addListener(mclListener);
		image_mcl.loadClip('models/exploreMode.swf', mLessonSwf);
	}
	
	function loadNextLesson(){
		var nextLesson:Number = sCurrentLesson+1
		loadLessonNum(nextLesson);
	}
	
	function loadPreviousLesson(){
		var nextLesson:Number = sCurrentLesson-1
		loadLessonNum(nextLesson);
	}
}
