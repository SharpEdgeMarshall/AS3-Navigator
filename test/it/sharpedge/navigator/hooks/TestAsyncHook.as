package it.sharpedge.navigator.hooks
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import it.sharpedge.navigator.api.IHookAsync;
	
	public class TestAsyncHook implements IHookAsync
	{
		private var _called:int = 0;
		private var _timer:Timer;
		private var _callback:Function;
		
		public function TestAsyncHook()
		{
			_timer = new Timer( 100, 0 );
			_timer.addEventListener(TimerEvent.TIMER, onTime);
		}
		
		public function get called():int
		{
			return _called;
		}
		
		public function execute(callback:Function):void
		{
			_callback = callback;
			_timer.start();
		}
		
		protected function onTime(event:TimerEvent):void
		{
			_timer.reset();
			
			_called++;
			_callback();			
		}		
	}
}


