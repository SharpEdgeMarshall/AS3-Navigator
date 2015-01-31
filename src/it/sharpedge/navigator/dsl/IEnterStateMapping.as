package it.sharpedge.navigator.dsl
{
	public interface IEnterStateMapping extends IStateMapping
	{	
		/**
		 * Get a IEnterStateFromMapping rappresenting when arriving from that state
		 * @param state The from state.
		 * @return IEnterStateFromMapping to continue mapping.
		 */
		function from( state:String ):IEnterStateFromMapping;
		
		/**
		 * Set a redirect to another state
		 * @param state The destination state.
		 */
		function redirectTo( state:String = null ):void;
	}
}