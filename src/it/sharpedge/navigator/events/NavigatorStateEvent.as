package it.sharpedge.navigator.events
{
	import flash.events.Event;
	
	import it.sharpedge.navigator.core.NavigationState;
	
	public class NavigatorStateEvent extends Event
	{		
		public static const REQUESTED : String = "ns_REQUESTED";
		public static const REDIRECTING : String = "ns_REDIRECTING";
		public static const BLOCKED : String = "ns_BLOCKED";
		public static const CHANGING : String = "ns_CHANGING";
		public static const CHANGED : String = "ns_CHANGED";
		public static const COMPLETED : String = "ns_COMPLETED";
		
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