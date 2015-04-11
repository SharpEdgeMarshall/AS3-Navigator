package it.sharpedge.navigator.core.tasks
{
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.SegmentMapper;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace routing;
	use namespace navigator;
	
	public class RetrieveMappingsTask implements ITask
	{
		private var _enterMapper:SegmentMapper;
		private var _exitMapper:SegmentMapper;
		
		public function RetrieveMappingsTask( exitMapper:SegmentMapper, enterMapper:SegmentMapper ) {
			_enterMapper = enterMapper;
			_exitMapper = exitMapper;
		}
		
		public function run(router:RoutingQueue):void
		{			
			_exitMapper.getMatchingStateMapping( router.currentState.segments, router.requestedState.segments, router.exitMapping );
			_enterMapper.getMatchingStateMapping( router.requestedState.segments, router.currentState.segments, router.enterMapping );
			
			router.next();
		}
	}
}