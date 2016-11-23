import com.ask.essentials.*;
import com.ask.lib.*;
import com.ask.utils.*;
import com.ask.video.*;

class com.ask.essentials.VideoPlayer extends Player
{
    static var sInstance:VideoPlayer;

    var iSwfStub:MovieClip;
    var iVideo:Video;
    var iPlay:MovieClip;
    var iScrubHandle:MovieClip;

    function VideoPlayer()
    {
        sInstance = this;
        attachSwfStub( _parent.iSwfStub);
       	attachVideo( _parent.iVideo.video);
        mControlClip = this;
    }

    function refreshUi()
    {
        refreshVideoUi();
    }

    function onVideoEvent( inEvent:Object)
    {
    }

}