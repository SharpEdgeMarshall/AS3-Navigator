package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.RoutingQueue;

	public interface ITask
	{
		function run( router:RoutingQueue ):void;
	}
}