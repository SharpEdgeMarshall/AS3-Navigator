package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;

	public interface IGuardSync
	{
		function approve( from:NavigationState, to:NavigationState ):Boolean;
	}
}