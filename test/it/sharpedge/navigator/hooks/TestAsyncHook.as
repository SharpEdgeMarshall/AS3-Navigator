package it.sharpedge.navigator.hooks
{
	import flash.utils.Timer;
	
	import it.sharpedge.navigator.api.IHookAsync;
	
	public class TestAsyncHook implements IHookAsync
	{
		private var _called:int = 0;
		private var _timer:Timer;
		
		public function TestAsyncHook()
		{
			_timer = new Timer( 100, 1 );
		}
		
		public function get called():int
		{
			return _called;
		}

		public function hook(callback:Function):void
		{
			_called++;
			callback();
		}
	}
}