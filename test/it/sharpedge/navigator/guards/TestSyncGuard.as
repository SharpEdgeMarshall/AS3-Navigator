package it.sharpedge.navigator.guards
{
	import it.sharpedge.navigator.api.IGuardSync;
	
	public class TestSyncGuard implements IGuardSync
	{
		private var _called:int = 0;
		private var _willPass:Boolean;
		
		public function TestSyncGuard(willPass:Boolean=false)
		{
			_willPass = willPass;
		}
		
		public function get called():int
		{
			return _called;
		}

		public function approve():Boolean
		{
			_called++;
			return _willPass;
		}
	}
}