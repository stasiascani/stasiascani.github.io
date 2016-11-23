
import com.ask.lib.*;

class com.ask.lib.Connection
{
    private static var sCallBack:Object;
    private static var sIndex:Number;
    private static var sXml:FastXml;

    static function loadXml( pCallBack:Object, pFileName:String):Void
    {
        sCallBack = pCallBack;
        var oXml:FastXml = new FastXml();
        oXml.load( pFileName);
    }

    static function onLoadXmlFailure( pXml:FastXml):Void
    {
        sCallBack.onLoadXmFailure();
    }

    static function onLoadXmlSuccess( pXml:FastXml):Void
    {
        // I need to parse the XML here
        sXml = pXml;
        sIndex = 0;
        while ( sIndex < pXml.mTags.length)
        {
            var oNode:Object = pXml.mTags[ sIndex];
            oNode.attributes = oNode.attrs;
            if ( oNode.type == 1)
            {
                // have the callback process the node instead of us
                sCallBack.onXmlNode( oNode.value, { nodeName: oNode.value, attributes: oNode.attributes, empty: oNode.empty});
            }
            else
            {
                // have the callback process the node instead of us
                sCallBack.onXmlBody( oNode.value);
            }

            sIndex ++;
        }

        sCallBack.onLoadXml( pXml);
    }

    static function getHtml():String
    {
        // grab the name of the closing node
        var oClosingNode = "/" + sXml.mTags[ sIndex].value;
        var oHtml = "";
        sIndex ++;

        // I need to parse the XML here
        while ( sIndex < sXml.mTags.length)
        {
            var oNode:Object = sXml.mTags[ sIndex];
            if ( oNode.type == 1)
            {
                if ( oNode.value == oClosingNode)
                {
                    return oHtml;
                }
                else
                {
                    oHtml += nodeToString( oNode);
                }
            }
            else
            {
                oHtml += oNode.value;
            }

            sIndex ++;
        }
        return oHtml;
    }

    static function nodeToString( inNode)
    {
        if ( inNode.value.charAt( 0) == "/")
        {
            return "<" + inNode.value + ">";
        }
        var oString = "<" + inNode.value;

        var oName;
        for ( oName in inNode.attrs)
        {
            oString += " " + oName + "=\"" + inNode.attrs[ oName] + "\"";
        }
        if ( inNode.empty == true)
        {
            oString += "/";
        }
        oString += ">";
        return oString;
    }
}