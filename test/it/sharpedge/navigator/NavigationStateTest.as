package it.sharpedge.navigator 
{
	import it.sharpedge.navigator.api.NavigationState;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	
	
	/**
	 * @author epologee
	 */
	public class NavigationStateTest {
		
		[Test]
		public function pathStringEquality() : void {
			var a : NavigationState = NavigationState.make("anyState");
			var b : NavigationState = NavigationState.make("/anyState/");
			assertThat(a.path, equalTo(b.path));
			
			a.segments = ["a", "b", "c"];
			b = new NavigationState("a", "b", "c");
			assertThat(a.path, equalTo(b.path));	
			
			a.segments = [];
			b = new NavigationState("/");
			assertThat(a.path, equalTo(b.path));
			
			a.dispose();
			b.dispose();
		}
		
		[Test]
		public function advancedEquality() : void {
			var a : NavigationState = NavigationState.make("anyState");
			var b : NavigationState = NavigationState.make("/anyState/");
			assertThat("the equals method works on single segmented paths", a.equals(b), equalTo(true));
			
			a = new NavigationState("a", "b", "c");
			b = new NavigationState("a/b/c");
			assertThat("the equals method works on multi segmented paths", a.equals(b), equalTo(true));
			
			a = new NavigationState("a", "b", "c");
			b = new NavigationState("a/*/c");
			assertThat("the equals method works on multi segmented paths with wildcards", a.equals(b), equalTo(true));
			
			a = new NavigationState("a", "*", "c");
			b = new NavigationState("a/b/c");
			assertThat("the equals method works on multi segmented paths with wildcards (inverted)", a.equals(b), equalTo(true));
			
			a.dispose();
			b.dispose();
		}
		
		[Test]
		public function containment() : void {
			var a : NavigationState = NavigationState.make("anyState");
			var b : NavigationState = NavigationState.make("/anyState/subState");
			assertThat("a contains b", a.contains(b), equalTo(false));
			assertThat("b does not contain a", b.contains(a), equalTo(true));
			
			a.dispose();
			b.dispose();
		}
	}
}