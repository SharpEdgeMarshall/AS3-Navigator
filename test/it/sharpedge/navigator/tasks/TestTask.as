package it.sharpedge.navigator.tasks
{
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.tasks.ITask;
	
	public class TestTask implements ITask
	{
		public var called:int = 0;
		
		public function TestTask()
		{
		}
		
		public function run(router:RoutingQueue):void
		{
			called++;
		}
	}
}