package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;

	public interface IGuardAsync
	{
		function approve( from:NavigationState, to:NavigationState, callback:Function ):void;
	}
}