package it.sharpedge.navigator.events
{
	import flash.events.Event;
	
	public class RoutingQueueEvent extends Event
	{		
		public static const START : String = "rq_START";
		public static const	ABORT : String = "rq_ABORT";
		public static const	COMPLETE : String = "rq_COMPLETE";
		
		public function RoutingQueueEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event {
			return new RoutingQueueEvent( type );
		}
	}
}