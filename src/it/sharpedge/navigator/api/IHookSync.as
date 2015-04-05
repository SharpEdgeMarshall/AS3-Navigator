package it.sharpedge.navigator.api
{
	import it.sharpedge.navigator.core.NavigationState;

	public interface IHookSync
	{
		function execute( from:NavigationState, to:NavigationState ):void;
	}
}