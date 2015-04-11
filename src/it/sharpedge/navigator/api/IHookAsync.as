package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;
	
	/**
	 * Asynchronous Hook Interface
	 */
	public interface IHookAsync
	{
		/**
		 * @param from The initial state.
		 * @param to The destination state.
		 * @param callback The callback, MUST be called to continue the processing of the request
		 */
		function execute( from:NavigationState, to:NavigationState, callback:Function ):void;
	}
}