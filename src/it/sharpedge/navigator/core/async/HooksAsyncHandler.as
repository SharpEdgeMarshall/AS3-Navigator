package it.sharpedge.navigator.core.async
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class HooksAsyncHandler extends EventDispatcher
	{
		private var _delegates : Vector.<HooksAsyncDelegate> = new Vector.<HooksAsyncDelegate>();
		
		private var _busy:Boolean = false;
		private var _valid:Boolean = true;
		
		public function get busy():Boolean
		{
			return _busy;
		}
		
		public function HooksAsyncHandler( )
		{
		}

		public function addDelegate( delegate:HooksAsyncDelegate ):void {
			if(  _delegates.indexOf( delegate ) != -1 ) return;
			
			_delegates.push( delegate );
			_busy = true;
		}
		
		public function notifyValidation( delegate:HooksAsyncDelegate ):void {
			if(!_busy) return;
			
			var idx:int = _delegates.indexOf( delegate );
			
			if( idx != -1 ){
				
				_delegates.splice( idx, 1 );		
				
				if( _delegates.length == 0 ){
					_busy = false;
					dispatchEvent( new Event( Event.COMPLETE ) );
				}
			}			
		}
	}
}