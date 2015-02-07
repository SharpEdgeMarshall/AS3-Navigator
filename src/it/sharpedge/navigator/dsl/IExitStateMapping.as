package it.sharpedge.navigator.dsl
{
	public interface IExitStateMapping extends ISegmentMapping
	{
		function to( stateOrPath:* ):ISegmentMapping;
	}
}