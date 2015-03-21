package it.sharpedge.navigator.guards
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import it.sharpedge.navigator.api.IGuardAsync;
	
	public class TestAsyncGuard implements IGuardAsync
	{
		private var _called:int = 0;
		private var _timer:Timer;
		private var _callback:Function;
		private var _willPass:Boolean;
		
		public function TestAsyncGuard(willPass:Boolean)
		{
			_willPass = willPass;
			
			_timer = new Timer( 100, 0 );
			_timer.addEventListener(TimerEvent.TIMER, onTime);
		}
		
		public function get called():int
		{
			return _called;
		}

		public function approve(callback:Function):void
		{
			_callback = callback;
			_timer.start();
		}
		
		protected function onTime(event:TimerEvent):void
		{
			_timer.reset();
			
			_called++;
			_callback(_willPass);			
		}		
	}
}