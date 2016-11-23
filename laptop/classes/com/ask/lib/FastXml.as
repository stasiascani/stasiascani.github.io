
import com.ask.lib.*;

class com.ask.lib.FastXml extends XML
{
    var mRawXml:String;
    var mTags:Array;

    function onData( pSrc:String):Void
    {
        if ( pSrc == undefined)
        {
            Connection.onLoadXmlFailure( this);
        }
        else
        {
            // ok, do a quick process of the nodes
            mRawXml = pSrc;
            mTags = new Array();
            if ( getVersion() == "WIN 5,0,30,0")
            {
                status = [ "ASnative"]( 300, 0)( pSrc, this.mTags);
            }
            else
            {
                status = [ "ASnative"]( 300, 0)( pSrc, this.mTags, false);
            }
            Connection.onLoadXmlSuccess( this);
        }
    }
}