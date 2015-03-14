package it.sharpedge.navigator.core
{
	import flash.events.EventDispatcher;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.tasks.ExecuteEnterGuardsTask;
	import it.sharpedge.navigator.core.tasks.ExecuteExitGuardsTask;
	import it.sharpedge.navigator.core.tasks.RetrieveMappingsTask;
	import it.sharpedge.navigator.core.tasks.SwitchStatesTask;
	import it.sharpedge.navigator.core.tasks.TestEnterRedirectTask;
	import it.sharpedge.navigator.core.tasks.TestExitRedirectTask;
	import it.sharpedge.navigator.core.tasks.TestRequestTask;
	import it.sharpedge.navigator.debug.ILogger;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;

	use namespace navigator;
	
	public class Navigator extends EventDispatcher
	{	
		navigator static var logger:ILogger;
		
		private var _router:RoutingQueue = new RoutingQueue();
		
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
			
			_router.add(new TestRequestTask());
			_router.add(new RetrieveMappingsTask(_exitMapper, _enterMapper));
			_router.add(new TestExitRedirectTask());
			_router.add(new TestEnterRedirectTask());
			_router.add(new ExecuteExitGuardsTask());
			_router.add(new ExecuteEnterGuardsTask());
			_router.add(new SwitchStatesTask());
			
			// TODO listen to complete routing or failed
			//_rounter.on();			
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
				logger.error("Requested a null state. Aborting request.");
				return;
			}
			
			if(_router.running){				
				//TODO: Handle nested request made from guards and hooks
				return;
			}
			
			// Create State
			_requestedState = NavigationState.make( stateOrPath );
			
			// Start Router
			_router.run(_currentState, _requestedState);			
		}

	}
}