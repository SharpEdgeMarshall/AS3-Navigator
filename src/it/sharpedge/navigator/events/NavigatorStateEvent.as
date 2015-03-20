package it.sharpedge.navigator.events
{
	import flash.events.Event;
	
	import it.sharpedge.navigator.api.NavigationState;
	
	public class NavigatorStateEvent extends Event
	{		
		public static const STATE_REQUESTED : String = "STATE_REQUESTED";
		public static const STATE_REDIRECTING : String = "STATE_REDIRECTING";
		public static const GUARD_LOCK : String = "GUARD_LOCK";
		public static const STATE_CHANGING : String = "STATE_CHANGING";
		public static const STATE_CHANGED : String = "STATE_CHANGED";
		public static const COMPLETED : String = "COMPLETED";
		
		public function get newState () : NavigationState { return _newState; }
		public function get oldState () : NavigationState { return _oldState; }
		
		private var _newState : NavigationState;
		private var _oldState : NavigationState;
		
		public function NavigatorStateEvent(type:String, oldState:NavigationState, newState:NavigationState, cancelable:Boolean = false)
		{
			super(type, false, cancelable);
			
			_oldState = oldState;
			_newState = newState;
		}
		
		override public function clone():Event {
			return new NavigatorStateEvent( type, _oldState, _newState );
		}
	}
}