package it.sharpedge.navigator
{
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.SegmentMapper;
	import it.sharpedge.navigator.core.ns.navigator;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	use namespace navigator;
	
	public class SegmentMapperTest
	{
		
		private var a:NavigationState = new NavigationState("/substate/substate2/");
		
		[Test]
		public function getPath():void {
			var sm:SegmentMapper = new SegmentMapper("");
			sm = sm.getSegmentMapperFor(a.segments);
			
			assertThat("Check the path", sm.path, equalTo(a.path));
		}
	}
}