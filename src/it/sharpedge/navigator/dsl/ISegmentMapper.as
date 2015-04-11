package it.sharpedge.navigator.dsl
{
	

	public interface ISegmentMapper
	{
		
		/**
		 * Add Guards to query before execution
		 * @param ... guards a list of functions or Classes with approve() method
		 * @return IStateMapping to continue mapping
		 */
		function addGuards( ... guards ):ISegmentMapper;
		
		/**
		 * Remove a Guard
		 * @param guard The guard to remove.
		 * @return IStateMapping to continue mapping.
		 */
		function removeGuard( guard:* ):ISegmentMapper;
		
		/**
		 * Add Hooks to run during execution
		 * @param ... hooks a list of functions or Classes with hook() method.
		 * @return IStateMapping to continue mapping.
		 */
		function addHooks( ... hooks ):ISegmentMapper;
		
		/**
		 * Remove a Hook
		 * @param hook The hook to remove.
		 * @return IStateMapping to continue mapping.
		 */
		function removeHook( hook:* ):ISegmentMapper;
		
		/**
		 * Set a redirect to another state
		 * @param state The destination state or null to remove redirect.
		 */
		function redirectTo( state:* = null ):void;
		
	}
}