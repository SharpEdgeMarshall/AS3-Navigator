package it.sharpedge.navigator.dsl
{
	public interface IEnterStateFromMapping extends IStateMapping
	{	
		/**
		 * Set a redirect to another state
		 * @param state The destination state.
		 */
		function redirectTo( state:String = null ):void;		
	}
}