package it.sharpedge.navigator
{
	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class NavigatorTestSuite
	{	
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/
		public var navigationState : NavigationStateTest;
		public var navigation : NavigationTest;
		public var segmentMapper : SegmentMapperTest;
		public var routingQueue : RoutingQueueTest;
		public var historyTest : HistoryTest;
		public var traceLogger : TraceLoggerTest;
	}
}
