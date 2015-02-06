package it.sharpedge.navigator.core
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterStateMapping;
	import it.sharpedge.navigator.dsl.IExitStateMapping;

	public class Navigator
	{	
		private var _enterMappings : Dictionary = new Dictionary();
		private var _exitMappings : Dictionary = new Dictionary();
		
		
		private var _currentState : NavigationState;		
		/**
		 * Get the current state
		 */
		public function get currentState() : NavigationState {
			
			return _currentState.clone();
		}
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Navigator
		 */
		public function Navigator( initialState:* = "/" ) {
			
			_currentState = NavigationState.make( initialState ).clone();
			
		}
		
		/**
		 * Get an EnterStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onEnter( stateOrPath:* ):IEnterStateMapping {
			return _enterMappings[ NavigationState.make( stateOrPath ).path ] ||= new EnterStateMapping();
		}
		
		/**
		 * Get an ExitStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onExit( stateOrPath:* ):IExitStateMapping {
			return _exitMappings[ NavigationState.make( stateOrPath ).path ] ||= new ExitStateMapping();
		}
		
		
		/**
		 * Request a new state
		 * @param state The state that you want to navigate to.
		 */
		public function request( stateOrPath:* ):void {
			
		}
		
	}
}