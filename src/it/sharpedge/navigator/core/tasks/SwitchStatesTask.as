package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.routing;
	import it.sharpedge.navigator.events.NavigatorStateEvent;

	use namespace routing;
	
	public class SwitchStatesTask implements ITask
	{
		private var _nav:Navigator;
		
		public function SwitchStatesTask(navigator:Navigator) {
			_nav = navigator;
		}
		
		public function run(router:RoutingQueue):void
		{
			var from : NavigationState = router.currentState.clone();
			var to : NavigationState = router.requestedState.clone();
			
			// Dispatch CHANGING Event
			var chgEvent : NavigatorStateEvent = new NavigatorStateEvent( NavigatorStateEvent.CHANGING, from, to );
			_nav.dispatchEvent(chgEvent);
			
			router.currentState.path = router.requestedState.path;
			
			// Dispatch CHANGED Event
			chgEvent = new NavigatorStateEvent( NavigatorStateEvent.CHANGED, from, to );
			_nav.dispatchEvent(chgEvent);
			
			router.next();
		}
	}
}