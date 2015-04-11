package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;
	/**
	 * Navigator History Interface
	 */
	public interface INavigatorHistory
	{
		/**
		 * Set the max length of the history
		 */
		function set maxLength( value:int ):void;
		/**
		 * Get the max length of the history
		 */
		function get maxLength():int;
		
		/**
		 * Get a vector with the states in the history
		 */
		function get history():Vector.<NavigationState>;
		
		/**
		 * Go back in the history and return that NavigationState
		 * 
		 * @param steps The number of steps to go back in history
		 * @return The found state or null if no state was found
		 */
		function getPreviousState( steps:int = 1 ):NavigationState;
		
		/**
		 * Go forward in the history and return that NavigationState
		 * 
		 * @param steps The number of steps to go back in history
		 * @return The found state or null if no state was found
		 */
		function getNextState( steps:int = 1 ):NavigationState;
		
		/**
		 * Clear up navigation history
		 */
		function clearHistory():void;
		
		/**
		 * Go back in the history
		 * 
		 * @param steps The number of steps to go back in history
		 * @return Returns false if there was no previous state
		 */
		function back( steps:int = 1 ):Boolean;
		
		/**
		 * Go forward in the history
		 * 
		 * @param steps The number of steps to go forward in history
		 * @return Returns false if there was no next state
		 */
		function forward( steps:int = 1 ):Boolean;
		
		/**
		 * Get the state by historyposition
		 * 
		 * @param position The position in history
		 * @return The found state or null if no state was found
		 */
		function getStateByPosition( position:int ):NavigationState;
		
		/**
		 * Get the first occurence of a state in the history
		 * 
		 * @param state The state in history
		 * @return The found position or -1 if no position was found
		 */
		function getPositionByState( state:NavigationState ):int;	
		
		/**
		 * Dispose the NavigatorHistory
		 */
		function dispose():void;
	}
}