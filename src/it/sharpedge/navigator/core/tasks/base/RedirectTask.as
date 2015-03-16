package it.sharpedge.navigator.core.tasks.base
{
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.StateMapping;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace routing;
	use namespace navigator;
	
	public class RedirectTask
	{	
		
		public function RedirectTask() {
			
		}
		
		protected function testRedirect( router:RoutingQueue, mapping:StateMapping ):void {
			// Search for redirects
			if( mapping.redirectTo != null ){
				// Stop routing
				router.stop();
				
				Navigator.logger.info("Redirecting: " + router.requestedState + " -> " + mapping.redirectTo );
				// Dispatch REIDIRECT Event
				//var redEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.STATE_REDIRECTING, _currentState, destination );
				//dispatchEvent(redEvent);
				
				// Restart routing
				router.run( router.currentState, mapping.redirectTo );
			}
			
			router.next();
		}
	}
}