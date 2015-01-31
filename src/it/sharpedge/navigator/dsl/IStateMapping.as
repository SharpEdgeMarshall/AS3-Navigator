package it.sharpedge.navigator.dsl
{
	

	public interface IStateMapping
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
		function addGuards( ... guards ):IStateMapping;
		
		/**
		 * Remove a Guard
		 * @param guard The guard to remove.
		 * @return IStateMapping to continue mapping.
		 */
		function removeGuard( guard ):IStateMapping;
		
		/**
		 * Add Hooks to run during execution
		 * @param ... hooks a list of functions or Classes with hook() method.
		 * @return IStateMapping to continue mapping.
		 */
		function addHooks( ... hooks ):IStateMapping;
		
		/**
		 * Remove a Hook
		 * @param hook The hook to remove.
		 * @return IStateMapping to continue mapping.
		 */
		function removeHook( hook ):IStateMapping;
		
	}
}