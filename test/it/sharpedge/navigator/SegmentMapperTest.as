package it.sharpedge.navigator
{
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.core.SegmentMapper;
	import it.sharpedge.navigator.core.StateMapping;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.guards.TestSyncGuard;
	import it.sharpedge.navigator.hooks.TestSyncHook;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.object.equalTo;

	use namespace navigator;
	
	public class SegmentMapperTest
	{
		
		private var a:NavigationState;
		
		[Before]
		public function initNavigator() : void {			
			a = NavigationState.make("/substate/substate2/");			
		}
		
		[After]
		public function disposeNavigator():void
		{
			a.dispose();
		}
		
		[Test]
		public function getPath():void {
			var sm:SegmentMapper = new SegmentMapper("");
			sm = sm.getSegmentMapperFor(a.segments);
			
			assertThat("Check the path", sm.path, equalTo(a.path));
		}
		
		[Test]
		public function removeHook():void {
			var sm:SegmentMapper = new SegmentMapper("");
			sm.addHooks(TestSyncHook);
			sm.removeHook(TestSyncHook);
			
			var mapping:StateMapping = new StateMapping();
			
			sm.getMatchingStateMapping([],[],mapping);
			
			assertThat("Check there are no hooks", mapping.hooks, emptyArray());
		}
		
		[Test]
		public function removeGuards():void {
			var sm:SegmentMapper = new SegmentMapper("");
			sm.addGuards(TestSyncGuard);
			sm.removeGuard(TestSyncGuard);
			
			var mapping:StateMapping = new StateMapping();
			
			sm.getMatchingStateMapping([],[],mapping);
			
			assertThat("Check there are no guards", mapping.guards, emptyArray());
		}
		
		[Test]
		public function removeSubSegment():void {
			var sm:SegmentMapper = new SegmentMapper("");
			var ssm:SegmentMapper = sm.getSegmentMapperFor(a.segments);
			
			ssm.addGuards(TestSyncGuard);

			sm.removeSubSegmentMapper(ssm.parent);
			
			var mapping:StateMapping = new StateMapping();
			sm.getMatchingStateMapping(a.segments,[],mapping);
			
			assertThat("Check there are no guards", mapping.guards, emptyArray());
		}
	}
}