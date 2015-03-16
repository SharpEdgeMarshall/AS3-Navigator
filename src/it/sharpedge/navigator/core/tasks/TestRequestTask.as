package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace navigator;
	use namespace routing;
	
	public class TestRequestTask implements ITask
	{	
		
		public function TestRequestTask()
		{
			
		}
		
		public function run(router:RoutingQueue):void
		{
			if (router.requestedState.hasWildcard()) {
				router.requestedState = router.requestedState.mask( router.currentState );
				if (router.requestedState.hasWildcard()){
					Navigator.logger.error("Cannot mask request's wildcards");
					router.stop();
					return;
				}
			}
			
			// EVENT( STATE_REQUESTED ) This event makes it possible to add hooks and guard just in time to participate in the validation process.
			//var reqEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.STATE_REQUESTED, _currentState, requestedState );
			//dispatchEvent(reqEvent);
			
			// Check for exact match of the requested and the current state
			if ( router.currentState.equals( router.requestedState ) ) {
				Navigator.logger.info("Already at the requested state: " + router.requestedState);
				router.stop();
				return;
			}
		}
	}
}