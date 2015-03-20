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
			
			// Check for exact match of the requested and the current state
			if ( router.currentState.equals( router.requestedState ) ) {
				Navigator.logger.info("Already at the requested state: " + router.requestedState);
				router.stop();
				return;
			}
			
			router.next();
		}
	}
}