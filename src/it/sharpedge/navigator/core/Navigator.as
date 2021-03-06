package it.sharpedge.navigator.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import it.sharpedge.navigator.api.INavigator;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.tasks.ExecuteEnterGuardsTask;
	import it.sharpedge.navigator.core.tasks.ExecuteEnterHooksTask;
	import it.sharpedge.navigator.core.tasks.ExecuteExitGuardsTask;
	import it.sharpedge.navigator.core.tasks.ExecuteExitHooksTask;
	import it.sharpedge.navigator.core.tasks.RetrieveMappingsTask;
	import it.sharpedge.navigator.core.tasks.SwitchStatesTask;
	import it.sharpedge.navigator.core.tasks.TestEnterRedirectTask;
	import it.sharpedge.navigator.core.tasks.TestExitRedirectTask;
	import it.sharpedge.navigator.core.tasks.TestRequestTask;
	import it.sharpedge.navigator.debug.ILogger;
	import it.sharpedge.navigator.debug.TraceLogger;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;
	import it.sharpedge.navigator.events.NavigatorStateEvent;
	import it.sharpedge.navigator.events.RoutingQueueEvent;

	use namespace navigator;
	
	public class Navigator extends EventDispatcher implements INavigator
	{	
		private static var _logger:ILogger = new TraceLogger();
		
		navigator static function set logger(value:ILogger):void
		{
			_logger = value;
		}

		navigator static function get logger():ILogger
		{
			return _logger;
		}
		
		private var _router:RoutingQueue = new RoutingQueue();
		
		private var _enterMapper:SegmentMapper = new SegmentMapper( "" );
		private var _exitMapper:SegmentMapper = new SegmentMapper( "" );
		
		private var _requestedState:NavigationState;		
		private var _currentState:NavigationState;		

		/**
		 * @inheritDoc
		 */
		public function get currentState() : NavigationState {
			
			return _currentState.clone();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isRunning() : Boolean {
			
			return _router.running;
		}
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Navigator
		 * @param initialState The initial sate of the navigator
		 */
		public function Navigator( initialState:* = "/" ) {
			
			_currentState = NavigationState.make( initialState );
			
			_router.add(new TestRequestTask());
			_router.add(new RetrieveMappingsTask(_exitMapper, _enterMapper));
			_router.add(new TestExitRedirectTask(this));
			_router.add(new TestEnterRedirectTask(this));
			_router.add(new ExecuteExitGuardsTask());
			_router.add(new ExecuteEnterGuardsTask());
			_router.add(new ExecuteExitHooksTask());
			_router.add(new SwitchStatesTask(this));
			_router.add(new ExecuteEnterHooksTask());
			
			_router.addEventListener( RoutingQueueEvent.COMPLETE, onRoutingComplete );
			_router.addEventListener( RoutingQueueEvent.ABORT, onRoutingComplete );
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearMappings():void {
			if( _router.running ) {
				logger.warn("Cannot clear mappings while router is running");
			}
				
			_exitMapper.clearMapping( true );
			_enterMapper.clearMapping( true );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onEnterTo( stateOrPath:* ):IEnterSegmentMapper {			
			return _enterMapper.getSegmentMapperFor( NavigationState.make(stateOrPath, false).segments );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onExitFrom( stateOrPath:* ):IExitSegmentMapper {
			return _exitMapper.getSegmentMapperFor( NavigationState.make(stateOrPath, false).segments );
		}		
		
		/**
		 * @inheritDoc
		 */
		public function request( stateOrPath:* ):void {
			
			if (stateOrPath == null) {
				logger.warn("Requested a null state. Aborting request.");
				return;
			}
			
			if(_router.running){				
				logger.warn("Cannot handle requests while a request is already being processed");
				return;
			}
			
			// Create State
			_requestedState = NavigationState.make( stateOrPath );
			
			var navEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.REQUESTED, _currentState, _requestedState );
			dispatchEvent(navEvent);
			
			// Start Router
			_router.run(_currentState, _requestedState);			
		}	
		
		/**
		 * @private
		 */
		protected function onRoutingComplete(event:Event):void
		{
			var navEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.COMPLETED, _currentState, _requestedState );
			dispatchEvent(navEvent);			
		}

	}
}