package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;

	/**
	 * Synchronous Guard Interface
	 */
	public interface IGuardSync
	{
		/**
		 * Called when the mapping it belongs to is processed
		 * @param from The initial state.
		 * @param to The destination state.
		 * @return Should return <code>true</code> if the Guard approve the request else <code>false</code>
		 */
		function approve( from:NavigationState, to:NavigationState ):Boolean;
	}
}