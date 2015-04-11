package it.sharpedge.navigator.core.async
{
	import it.sharpedge.navigator.api.IHookAsync;

	public class HooksAsyncDelegate
	{
		private var _hook:IHookAsync;
		private var _hooksHandler:HooksAsyncHandler;		
		
		public function get hook():IHookAsync
		{
			return _hook;
		}
		
		public function HooksAsyncDelegate( hookAsync:IHookAsync, hooksHandler:HooksAsyncHandler )
		{
			_hook = hookAsync;
			_hooksHandler = hooksHandler;
			
			hooksHandler.addDelegate( this );
		}

		public function call( ):void {
			_hooksHandler.notifyExecution( this );
		}
	}
}