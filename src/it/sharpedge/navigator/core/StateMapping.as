package it.sharpedge.navigator.core
{
	import it.sharpedge.navigator.api.NavigationState;

	public class StateMapping
	{
		
		// The redirect state
		private var _redirectTo : NavigationState = null;		
		
		private var _allGuards:Array = null;
		private var _syncGuards:Array = null;
		private var _asyncGuards:Array = null;
		
		private var _allHooks:Array = null;
		private var _syncHooks:Array = null;
		private var _asyncHooks:Array = null;
		
		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _allGuards;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _allHooks;
		}
		
		public function StateMapping()
		{
		}
		
		public function addGuards( ... hooks ):void
		{
			_allHooks = _allHooks ? _allHooks.concat.apply( null, hooks ) : new Array( hooks );
		}
		
		public function addHooks( ... hooks ):void
		{
			_allHooks = _allHooks ? _allHooks.concat.apply( null, hooks ) : new Array( hooks );
		}

		public function removeGuard( guard : * ):void
		{
			if( !_allGuards ) return;
			
			var index : int = _allGuards.indexOf( guard );			
			if( index == -1 ) return;
			
			_allGuards.splice( index, 1 );
		}
		
		public function removeHook( hook : * ):void
		{
			if( !_allHooks ) return;
			
			var index : int = _allHooks.indexOf( hook );			
			if( index == -1 ) return;
			
			_allHooks.splice( index, 1 );
		}
		
		public function redirectTo( stateOrPath:String = null ):void {
			
			// Dispose
			if( _redirectTo ) _redirectTo.dispose();
			
			_redirectTo = NavigationState.make( stateOrPath ).clone();
		}
	}
}