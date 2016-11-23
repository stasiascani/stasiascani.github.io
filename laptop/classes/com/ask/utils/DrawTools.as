
import com.ask.utils.*;

////////////////////////////////////////////////////////////////////////////
//
//  <pre>This class contains some general purpose graphic routines
//  </pre>
//
//  @author             Dave Castelnuovo
//	@version			1.0
//  @date               02-01-2005
//
//  Copyright (c) 2005 Bolt Creative. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////
class com.ask.utils.DrawTools
{
    // the variable that calls classConstruct when the class is initially referenced
    static var sClassConstructed:Boolean = classConstruct();

    ////////////////////////////////////////////////////////////////////////////
    //
    //  Constructor for the entire class.
    //
    ////////////////////////////////////////////////////////////////////////////
	static function classConstruct():Boolean
	{
		return true;
    }

    ////////////////////////////////////////////////////////////////////////////
    //
    //  Draw a rectangle in a movieclip
    //
    //  @param          inMovieClip     the clip we want to draw into
    //  @param          inXPos          the start x pos of the rect
    //  @param          inYPos          the start y pos of the rect
    //  @param          inWidth         the width of the rect
    //  @param          inHeight        the height of the rect
    //  @param          inColor         (optional) the color of the rect
    //  @param          inAlpha         (optional) the alpha of the rect
    //
    ////////////////////////////////////////////////////////////////////////////
    static function drawRect( inMovieClip:MovieClip, inXPos:Number, inYPos:Number, inWidth:Number, inHeight:Number, inColor:Number, inAlpha:Number)
    {
        if ( inAlpha == undefined)
        {
            inAlpha = 0;
        }
        if ( inColor == undefined)
        {
            inColor = 0x000000;
        }
        inMovieClip.beginFill( inColor, inAlpha);
        inMovieClip.moveTo( inXPos, inYPos);
        inMovieClip.lineTo( inXPos + inWidth, inYPos);
        inMovieClip.lineTo( inXPos + inWidth, inYPos + inHeight);
        inMovieClip.lineTo( inXPos, inYPos + inHeight);
        inMovieClip.endFill();
    }

}