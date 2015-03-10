package it.sharpedge.navigator.core
{
	import flash.events.EventDispatcher;
	
	import it.sharpedge.navigator.api.IGuardAsync;
	import it.sharpedge.navigator.api.IGuardSync;
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.debug.ILogger;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;
	import it.sharpedge.navigator.events.NavigatorStateEvent;

	public class Navigator extends EventDispatcher
	{	
		internal static var _logger:ILogger;
		
		private var _enterMapper:SegmentMapper = new SegmentMapper( "" );
		private var _exitMapper:SegmentMapper = new SegmentMapper( "" );
		
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
			
			_currentState = NavigationState.make( initialState );
			
		}
		
		/**
		 * Get an EnterStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onEnterTo( stateOrPath:* ):IEnterSegmentMapper {
			
			return _enterMapper.getSegmentMapperFor( NavigationState.make(stateOrPath, false).segments );
		}
		
		/**
		 * Get an ExitStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onExitFrom( stateOrPath:* ):IExitSegmentMapper {
			return _exitMapper.getSegmentMapperFor( NavigationState.make(stateOrPath, false).segments );
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
			var requested : NavigationState = NavigationState.make( stateOrPath );
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
			
			executeRequest( requested );
			
		}
		
		private function executeRequest( requested:NavigationState ):void {
			
			var exitMapping : StateMapping = new StateMapping();
			var enterMapping : StateMapping = new StateMapping();			
			var res : Boolean = true;
			
			_exitMapper.getMatchingStateMapping( _currentState.segments, requested.segments, exitMapping );
			
			res = testRedirect(exitMapping);
			if(res) return;
			
			_enterMapper.getMatchingStateMapping( requested.segments, _currentState.segments, enterMapping );
			
			res = testRedirect(enterMapping);
			if(res) return;
			
			// Execute exit guards
			//res = executeGuards(exitMapping);
			//if(!res) return;
			
			// Execute enter guards
			//res = executeGuards(enterMapping);
			//if(!res) return;
			
			// Execute exit hooks
			
			// Switch state
			
			// Execute enter hooks
			
			
		}
		
		private function testRedirect( mapping:StateMapping ):Boolean {
			// search for redirects
			if( mapping.redirectTo != null ){
				redirect( mapping.redirectTo );
				return true;
			}		
			return false;
		}
		
		private function redirect( destination:NavigationState ):void {
			var redEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.STATE_REDIRECTING, _currentState, destination );
			dispatchEvent(redEvent);
			request( destination );
		}
		
		private function onGuardAsyncCallback( result:Boolean=false ):void {
			
		}
		
		private function executeGuardAsync( guard:IGuardAsync ):Boolean {
			return false;
		}
		
		private function executeGuards( mapping:StateMapping ):Boolean {
			
			for( var guard:Object in mapping.guards ){					
				if (guard is Function)
				{
					if ((guard as Function)())
						continue;
					return false;
				} 
				else if (guard is Class)
				{
					guard = new (guard as Class);
				}
				
				if(guard is IGuardAsync)
					executeGuardAsync( guard as IGuardAsync );
				else if( guard is IGuardSync && !guard.approve() )
					return false;
			}				

			return true;
		}
		
		private function executeHooksAsync():void{
			
		}
		
		private function executeHooksSync():void {
			
		}
		
		private function switchState():void {
			
		}
			
		
	}
}