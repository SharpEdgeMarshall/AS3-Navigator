package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.routing;

	use namespace routing;
	
	public class SwitchStatesTask implements ITask
	{
		public function SwitchStatesTask()
		{
			
		}
		
		public function run(router:RoutingQueue):void
		{
			router.currentState.path = router.requestedState.path;
		}
	}
}