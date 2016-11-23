
class com.ask.lib.Alcon
{
    static var debug_lc:LocalConnection;            // The local connection object:
    private static var rec:Number = 20;                     // Default depth of recursion for object tracing:

    static var sClassConstructed:Boolean = classConstruct();

	static function classConstruct():Boolean
	{
        debug_lc = new LocalConnection();
		return true;
	}

    private function Alcon()
	{
	}

    public static function send( inMsg, inColor:Number):Void
	{
		// Define default vars:
		var out:String = "";

		// First argument is always the traceable information:
        var msg:String = inMsg;

        // Check if recursive object tracing:
        if ( typeof( msg) == "string")
        {
            out += String(msg);
        }
        else
        {
            out += traceObject(msg);
        }

        // Send output to Alcon console:
        trace( "ALCON: " + out);
        debug_lc.send("_alcon_lc", "onMessage", out, inColor);
	}

	public static function clr():Void
	{
        debug_lc.send("_alcon_lc", "onMessage", "[%CLR%]", 1);
	}

	public static function dlt():Void
	{
        debug_lc.send("_alcon_lc", "onMessage", "[%DLT%]", 1);
	}

	private static function traceObject(obj:Object):String
	{
		// Set the max. recursive depth:
		var rcdInit:Number = rec;
		// tmp holds the string with the whole object structure:
		var tmp:String = "" + obj + "\n";

		// Nested recursive function:
		var processObj:Function;
		processObj = function(o:Object, rcd:Number, idt:Number):Void
		{
			for (var p in o)
			{
				// Preparing indention:
				var tb:String = "";
				for (var i:Number = 0; i < idt; i++) tb += "   ";

				tmp += tb + p + ": " + o[p] + "\n";
				if (rcd > 0) processObj(o[p], rcd - 1, idt + 1);
			}
		}

		processObj(obj, rcdInit, 1);
		return tmp;
	}

	public static function setRecursionDepth(_rec:Number):Void
	{
		rec = _rec;
	}
}