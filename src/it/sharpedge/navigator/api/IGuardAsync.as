package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;
	
	/**
	 * Asynchronous Guard Interface
	 */
	public interface IGuardAsync
	{
		/**
		 * Called when the mapping it belongs to is processed
		 * @param from The initial state.
		 * @param to The destination state.
		 * @param callback The callback, MUST be called to continue the processing of the request passing <code>true</code> or <code>false</code>
		 * @return Should return <code>true</code> if the Guard approve the request else <code>false</code>
		 */
		function approve( from:NavigationState, to:NavigationState, callback:Function ):void;
	}
}