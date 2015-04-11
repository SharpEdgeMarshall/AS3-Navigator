package it.sharpedge.navigator
{
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.events.RoutingQueueEvent;
	import it.sharpedge.navigator.tasks.TestTask;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	public class RoutingQueueTest
	{
		private var rq : RoutingQueue;
		
		[Before]
		public function initRoutingQueue() : void {			
			rq = new RoutingQueue();			
		}
		
		[After]
		public function disposeRoutingQueue():void
		{
			rq = null;
		}
		
		[Test]
		public function addTask():void {
			var tt:TestTask = new TestTask();
			rq.add(tt);
			
			rq.run(new NavigationState("/fromState/"), new NavigationState("/toState/"));
			
			assertThat("TestTask is executed", tt.called, equalTo(1));
		}
		
		[Test]
		public function removeTask():void {
			var tt:TestTask = new TestTask();
			rq.add(tt);
			rq.remove(tt);
			
			rq.run(new NavigationState("/fromState/"), new NavigationState("/toState/"));
			
			assertThat("TestTask is not executed", tt.called, equalTo(0));
		}
		
		[Test]
		public function routingQueueEvent() : void {
			var event:RoutingQueueEvent = new RoutingQueueEvent(RoutingQueueEvent.COMPLETE);
			
			assertThat("Clone is working", event.clone(), instanceOf(RoutingQueueEvent));
		}
	}
}