package it.sharpedge.navigator.dsl
{
	

	public interface ISegmentMapping
	{
		/**
		 * A list of Guards to query before execution
		 */
		function get guards():Array;
		
		/**
		 * A list of Hooks to run during execution
		 */
		function get hooks():Array;
		
		/**
		 * Add Guards to query before execution
		 * @param ... guards a list of functions or Classes with approve() method
		 * @return IStateMapping to continue mapping
		 */
		function addGuards( ... guards ):ISegmentMapping;
		
		/**
		 * Remove a Guard
		 * @param guard The guard to remove.
		 * @return IStateMapping to continue mapping.
		 */
		function removeGuard( guard ):ISegmentMapping;
		
		/**
		 * Add Hooks to run during execution
		 * @param ... hooks a list of functions or Classes with hook() method.
		 * @return IStateMapping to continue mapping.
		 */
		function addHooks( ... hooks ):ISegmentMapping;
		
		/**
		 * Remove a Hook
		 * @param hook The hook to remove.
		 * @return IStateMapping to continue mapping.
		 */
		function removeHook( hook ):ISegmentMapping;
		
		/**
		 * Set a redirect to another state
		 * @param state The destination state.
		 */
		function redirectTo( state:String = null ):void;
		
	}
}