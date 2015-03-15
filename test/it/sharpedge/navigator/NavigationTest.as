package it.sharpedge.navigator
{
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NavigationTest
	{
		private var navigator:Navigator;
		
		[Before]
		public function before():void
		{
			navigator = new Navigator();
		}
		
		[Test]
		public function simpleRquest() : void {
			var a : NavigationState = NavigationState.make("/anystate/");
			
			navigator.request(a);
			
			assertThat(navigator.currentState, equalTo("/"));
		}
	}
}