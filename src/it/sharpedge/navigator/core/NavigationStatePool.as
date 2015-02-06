package it.sharpedge.navigator.core
{
	import it.sharpedge.navigator.api.NavigationState;

	public class NavigationStatePool
	{
		private static var MAX_CACHE : int = 100;
		private static var _nsPool : Vector.<NavigationState>;

		/**
		 * Fetches a node from the pool.
		 */
		public static function getNavigationState( ...segments : Array ) : NavigationState
		{

			if ( _nsPool && _nsPool.length > 0 )
			{
				var ns : NavigationState = _nsPool.pop();
				ns.path = segments.join(NavigationState.DELIMITER);
				return ns;
			}
			else
			{
				return new NavigationState( segments );
			}
		}

		/**
		 * Adds a node to the pool.
		 */
		public static function disposeNavigationState( state : NavigationState ) : void
		{
			if( !_nsPool ) _nsPool = new Vector.<NavigationState>();
			else if ( _nsPool.length >= MAX_CACHE || _nsPool.indexOf( state ) != -1 ) return;
			
			_nsPool.push( state );
		}
		
		
		public static function dispose() : void
		{
			_nsPool = null;
		}
	}
}
