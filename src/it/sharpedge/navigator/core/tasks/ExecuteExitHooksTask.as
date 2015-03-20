package it.sharpedge.navigator.core.tasks
{	
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.routing;
	import it.sharpedge.navigator.core.tasks.base.ExecuteHooks;

	use namespace routing;
	
	public class ExecuteExitHooksTask extends ExecuteHooks implements ITask
	{		
		public function ExecuteExitHooksTask()
		{		
			
		}
		
		public function run(router:RoutingQueue):void
		{
			executeHooks( router, router.exitMapping );
		}
	}
}