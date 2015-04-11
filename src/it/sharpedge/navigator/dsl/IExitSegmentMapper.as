package it.sharpedge.navigator.dsl
{
	public interface IExitSegmentMapper extends ISegmentMapper
	{
		/**
		 * Creates a mapping triggered by the entrance to stateOrPath
		 * @param stateOrPath The to state.
		 * @return ISegmentMapping to continue mapping.
		 */
		function to( stateOrPath:* ):ISegmentMapper;
	}
}