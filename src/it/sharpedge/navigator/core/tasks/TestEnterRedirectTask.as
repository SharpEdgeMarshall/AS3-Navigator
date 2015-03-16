package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.ns.routing;
	import it.sharpedge.navigator.core.tasks.base.RedirectTask;
	
	use namespace routing;
	
	public class TestEnterRedirectTask extends RedirectTask implements ITask
	{
		
		public function TestEnterRedirectTask()
		{
			
		}
		
		public function run(router:RoutingQueue):void
		{
			testRedirect( router, router.enterMapping );
		}
	}
}