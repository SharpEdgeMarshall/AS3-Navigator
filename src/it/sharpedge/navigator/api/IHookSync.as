package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;
	
	/**
	 * Synchronous Hook Interface
	 */
	public interface IHookSync
	{
		/**
		 * Called when the mapping it belongs to is processed
		 * @param from The initial state.
		 * @param to The destination state.
		 */
		function execute( from:NavigationState, to:NavigationState ):void;
	}
}