package it.sharpedge.navigator.core
{
	import flash.events.EventDispatcher;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.debug.ILogger;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;
	import it.sharpedge.navigator.events.NavigatorStateEvent;

	public class Navigator extends EventDispatcher
	{	
		internal static var _logger:ILogger;
		
		private var _enterMapping:SegmentMapper = new SegmentMapper( "" );
		private var _exitMapping:SegmentMapper = new SegmentMapper( "" );
		
		private var _requestedState:NavigationState;
		
		private var _currentState:NavigationState;		
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
		public function onEnterTo( stateOrPath:* ):IEnterSegmentMapper {
			
			return _enterMapping.getSegmentMappingFor( NavigationState.make( stateOrPath ).segments );
		}
		
		/**
		 * Get an ExitStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onExitFrom( stateOrPath:* ):IExitSegmentMapper {
			return _exitMapping.getSegmentMappingFor( NavigationState.make( stateOrPath ).segments );
		}
		
		
		/**
		 * Request a new state
		 * @param state The state that you want to navigate to.
		 */
		public function request( stateOrPath:* ):void {
			if (stateOrPath == null) {
				_logger.error("Requested a null state. Aborting request.");
				return;
			}
			
			//TODO: Handle nested request made from guards and hooks
			
			// Store and possibly mask the requested state
			var requested : NavigationState = NavigationState.make(stateOrPath);
			if (requested.hasWildcard()) {
				requested = requested.mask( _currentState );
				if (requested.hasWildcard()){
					_logger.error("Cannot mask request's wildcards");
					return;
				}
			}
			
			// EVENT( STATE_REQUESTED ) This event makes it possible to add hooks and guard just in time to participate in the validation process.
			var reqEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.STATE_REQUESTED, _currentState, requested );
			dispatchEvent(reqEvent);
			
			// Check for exact match of the requested and the current state
			if ( _currentState.equals( requested ) ) {
				_logger.info("Already at the requested state: " + requested);
				return;
			}
			
			executeRequest();
			
		}
		
		private function executeRequest():void {
			
			
			
		}
		
		/*private function findMatchingStates( searchState:NavigationState, statesList:Dictionary ):Array {
			var matches : Array = new Array;
			var ns: NavigationState = NavigationStatePool.getNavigationState();
			for ( var state:String in statesList ) {
				ns.path = state;
				if( searchState.equals( ns ){
					
				}
			}
		}*/
		
	}
}