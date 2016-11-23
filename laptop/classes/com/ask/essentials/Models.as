import mx.events.EventDispatcher;

class com.ask.essentials.Toggle extends MovieClip {

	var dispatchEvent:Function;
	var addEventListener:Function;

	// @method						Method stub to be mixed in by EventDispatcher
	// @see mx.events.EventDispatcher
	var removeEventListener:Function;


    function Toggle() {
		// add ability to broadcast events.
        EventDispatcher.initialize( this);
	}

        dispatchEvent( { target: this, type: "onToggle", toggle: this});
    }
}