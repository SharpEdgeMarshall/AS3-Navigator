package it.sharpedge.navigator.core.tasks
{	
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.routing;
	import it.sharpedge.navigator.core.tasks.base.ExecuteHooks;

	use namespace routing;
	
	public class ExecuteEnterHooksTask extends ExecuteHooks implements ITask
	{		
		public function ExecuteEnterHooksTask()
		{		
			
		}
		
		public function run(router:RoutingQueue):void
		{
			executeHooks( router, router.enterMapping );
		}
	}
}