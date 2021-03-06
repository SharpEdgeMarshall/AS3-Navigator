package it.sharpedge.navigator.core
{

	public class StateMapping
	{
		
		// The redirect state
		private var _redirectTo : NavigationState = null;		
		
		private var _guards:Array = new Array();
		
		private var _hooks:Array = new Array();
		
		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}
		
		public function get redirectTo():NavigationState
		{
			return _redirectTo;
		}
		
		public function set redirectTo( value:* ):void {
			
			// Dispose
			if( _redirectTo ) _redirectTo.dispose();
			
			_redirectTo = NavigationState.make( value );
		}
		
		public function StateMapping() {
			
		}
		
		public function clear():void {
			_guards = new Array();
			_hooks = new Array();
			_redirectTo = null;
		}
		
		public function addGuards( ... guards ):void
		{
			_guards = _guards.concat.apply( null, guards );
		}
		
		public function addHooks( ... hooks ):void
		{
			_hooks = _hooks.concat.apply( null, hooks );
		}

		public function removeGuard( guard : * ):void
		{		
			var index : int = _guards.indexOf( guard );			
			if( index == -1 ) return;
			
			_guards.splice( index, 1 );
		}
		
		public function removeHook( hook : * ):void
		{			
			var index : int = _hooks.indexOf( hook );			
			if( index == -1 ) return;
			
			_hooks.splice( index, 1 );
		}
		
		public function concat( stateMapping:StateMapping ):void 
		{
			if( stateMapping.redirectTo )
				redirectTo = stateMapping.redirectTo;
			
			addGuards( stateMapping.guards );
			addHooks( stateMapping.hooks );
		}
	}
}