package it.sharpedge.navigator.core.tasks.base
{
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.StateMapping;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace routing;
	
	public class RedirectTask
	{		
		protected function testRedirect( router:RoutingQueue, mapping:StateMapping ):void {
			// Search for redirects
			if( mapping.redirectTo != null ){
				// Stop routing
				router.stop();
				
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