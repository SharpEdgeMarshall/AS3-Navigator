package it.sharpedge.navigator.api
{
	import flash.events.IEventDispatcher;
	
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;

	/**
	 * Navigator Interface
	 */
	public interface INavigator extends IEventDispatcher
	{
		/**
		 * Get the current NavigationState
		 */
		function get currentState():NavigationState;
		
		/**
		 * Return <code>true</code> if there is some request in progress
		 */
		function get isRunning():Boolean;
		
		/**
		 * Clear all mappings
		 */
		function clearMappings():void;
		/**
		 * Start a EnterTo mapping
		 * @param stateOrPath The enter NavigationState mapped
		 * @return SegmentMapper to continue the mapping
		 */
		function onEnterTo( stateOrPath:* ):IEnterSegmentMapper;
		/**
		 * Start a ExitFrom mapping
		 * @param stateOrPath The exit NavigationState mapped
		 * @return SegmentMapper to continue the mapping
		 */
		function onExitFrom( stateOrPath:* ):IExitSegmentMapper;
		/**
		 * Request a new state
		 * @param state The state that you want to navigate to.
		 */
		function request( stateOrPath:* ):void;
	}
}