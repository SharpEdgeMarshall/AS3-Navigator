package it.sharpedge.navigator.dsl
{
	public interface IEnterSegmentMapper extends ISegmentMapper
	{	
		/**
		 * Creates a mapping triggered by the exit from stateOrPath
		 * @param stateOrPath The from state.
		 * @return ISegmentMapping to continue mapping.
		 */
		function from( stateOrPath:* ):ISegmentMapper;
		
		
	}
}