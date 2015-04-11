package it.sharpedge.navigator.hooks
{
	import it.sharpedge.navigator.api.IHookSync;
	import it.sharpedge.navigator.core.NavigationState;
	
	public class TestSyncHook implements IHookSync
	{
		private var _called:int = 0;
		
		public function TestSyncHook()
		{
		}
		
		public function get called():int
		{
			return _called;
		}

		public function execute( from:NavigationState, to:NavigationState ):void
		{
			_called++;
		}
	}
}