package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.routing;
	import it.sharpedge.navigator.core.tasks.base.ExecuteGuards;

	use namespace routing;
	
	public class ExecuteEnterGuardsTask extends ExecuteGuards implements ITask
	{
		public function run(router:RoutingQueue):void
		{
			validateGuards( router, router.enterMapping );
		}
	}
}