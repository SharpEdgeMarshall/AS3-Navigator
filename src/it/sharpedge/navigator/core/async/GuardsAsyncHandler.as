package it.sharpedge.navigator.core.async
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class GuardsAsyncHandler extends EventDispatcher
	{
		private var _delegates : Vector.<GuardsAsyncDelegate> = new Vector.<GuardsAsyncDelegate>();
		
		private var _busy:Boolean = false;
		private var _valid:Boolean = true;
		
		public function get busy():Boolean
		{
			return _busy;
		}
		
		public function get valid():Boolean
		{
			return _valid;
		}
		
		public function GuardsAsyncHandler( )
		{
		}

		public function addDelegate( delegate:GuardsAsyncDelegate ):void {
			if(  _delegates.indexOf( delegate ) != -1 ) return;
			
			_delegates.push( delegate );
			_busy = true;
		}
		
		public function notifyValidation( delegate:GuardsAsyncDelegate, valid:Boolean ):void {
			if(!_busy) return;
			
			var idx:int = _delegates.indexOf( delegate );
			
			if( idx != -1 ){
				
				_delegates.splice( idx, 1 );
				
				if(!valid){
					_busy = false;
					_valid = false;
					dispatchEvent( new Event( Event.COMPLETE ) );
				}				
				
				if( _delegates.length == 0 ){
					_busy = false;
					_valid = true;
					dispatchEvent( new Event( Event.COMPLETE ) );
				}
			}			
		}
	}
}