package it.sharpedge.navigator.core
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.dsl.IEnterSegmentMapper;
	import it.sharpedge.navigator.dsl.IExitSegmentMapper;
	import it.sharpedge.navigator.dsl.ISegmentMapper;
	
	use namespace navigator;
	
	public class SegmentMapper implements ISegmentMapper, IEnterSegmentMapper, IExitSegmentMapper	{
		
		private static const DW_STATE:NavigationState = NavigationState.make(NavigationState.DOUBLE_WILDCARD);
		
		/**
		 * @private
		 * The state segment this SegmentMapping belongs to
		 */ 
		internal var _stateSegment:String;
		
		/**
		 * Parent SegmentMapping
		 */
		private var _parent:SegmentMapper = null;
		
		/**
		 * @private
		 * Sub SegmentMappers
		 */
		internal var _subMappers:Dictionary = new Dictionary();
		
		/**
		 * @private
		 * Complementary SegmentMappers
		 */
		internal var _complementaryMappers:SegmentMapper = null;
		
		private var _stateMapping : StateMapping = new StateMapping();

		/**
		 * Get the parent SegmentMapper
		 */
		public function get parent():SegmentMapper
		{
			return _parent;
		}
		
		/**
		 * Get the full path corresponding to this SegmentMapper
		 */
		public function get path():String {
			if( _parent )
				return _parent.path + _stateSegment + NavigationState.DELIMITER;
			else
				return _stateSegment + NavigationState.DELIMITER;				
		}
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a State Mapping
		 */
		public function SegmentMapper( stateSegment:* )
		{
			_stateSegment = NavigationState.make(stateSegment).segments[0] || "";
		}
		
		/*============================================================================*/
		/* Private/Internal                                                           */
		/*============================================================================*/
		
		
		/*
		* Return the SegmentMapper matching the segments passed if not exist it'll generate it
		* @param segments The segments that will generate the mapping
		* @return The SegmentMapper matching the segments
		*/
		navigator function getSegmentMapperFor( segments:Array ):SegmentMapper {
			if( !segments.length )
				return this;
			
			var segment:String = segments.shift();
			
			if(!_subMappers[ segment ])
				addSubSegmentMapper(new SegmentMapper( segment ));
			
			// if there are other segments go deeper
			if( segments.length )
				return SegmentMapper( _subMappers[ segment ] ).getSegmentMapperFor( segments );
			else
				return SegmentMapper( _subMappers[ segment ] );
		}
		
	    /*
		* Return an array of StateMapping matching the segments passed
		* @param segments The segments that will be resolved
		* @result the resulting array of StateMappings
		*/
		navigator function getMatchingStateMapping( segments:Array, complementarySegments:Array, result:StateMapping ) : void {
			//populate result of StateMapping objects going recursive looking for matching path			
			
			//Still searching an endpoint
			if( segments.length != 0){	
				// TODO complete GLOBE Handling
				// if GLOBE add StateMapping
				/*if(DW_STATE.equals( NavigationState.make(_stateSegment) )){
					// Add general mapping
					result.concat( _stateMapping );
					
					// Search for specific mapping
					if(complementarySegments && _complementaryMappers)
						_complementaryMappers.getMatchingStateMapping(complementarySegments, null, result);
				}*/
				
				segments = segments.concat(); // clone for safe shifting
				var segment:String = segments.shift();
				
				// First search for Wildcard	
				if(_subMappers[ NavigationState.WILDCARD ])
					SegmentMapper( _subMappers[ NavigationState.WILDCARD ] ).getMatchingStateMapping(segments, complementarySegments, result);
				if(_subMappers[ segment ])
					SegmentMapper( _subMappers[ segment ] ).getMatchingStateMapping(segments, complementarySegments, result);
			
			} else { //This is an endpoint
				
				// Add general mapping
				result.concat( _stateMapping );
				
				// Search for specific mapping (from/to-to/from)
				if(complementarySegments && _complementaryMappers)
					_complementaryMappers.getMatchingStateMapping(complementarySegments, null, result);				
			}
			
			return;
		}
		
		/*============================================================================*/
		/* Public                                                                     */
		/*============================================================================*/
		
		/*
		 * Clear mappings
		 * @param subState Should go in deep cleaning also for all subStates
		 */
		public function clearMapping( clearSubStates:Boolean = false ):void {
			
			if( clearSubStates ) {
				var mapper:SegmentMapper;			
				// Clear subMappers
				for each( mapper in _subMappers )
				{
					mapper.clearMapping();
				}
				// Clear complementaryMappers
				_complementaryMappers = null;
			}	
			
			_stateMapping.clear();			
		}
		
		/*
		 * Add a SubSegmentMapper
		 * @param segmentMapper The segmentMapper to add as a child
		 */
		public function addSubSegmentMapper( segmentMapper:SegmentMapper ):void {
			
			// TODO: dispatch error or log
			if( segmentMapper._parent ) return;
			
			segmentMapper._parent = this;
			_subMappers[ segmentMapper._stateSegment ] = segmentMapper;
		}
		
		/*
		* @param segmentMapper The segmentMapper to remove 
		*/
		public function removeSubSegmentMapper( segmentMapper:SegmentMapper ):void {
			// TODO: dispatch error or log
			if( segmentMapper._parent != this ) return;
			
			segmentMapper._parent = null;
			delete _subMappers[ segmentMapper._stateSegment ];
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( stateOrPath:* ):ISegmentMapper{
			_complementaryMappers ||= new SegmentMapper( "" );
			
			return  _complementaryMappers.getSegmentMapperFor( NavigationState.make( stateOrPath, false ).segments );
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( stateOrPath:* ):ISegmentMapper {
			_complementaryMappers ||= new SegmentMapper( "" );
			
			return _complementaryMappers.getSegmentMapperFor( NavigationState.make( stateOrPath, false ).segments );
		}
		
		/**
		 * @inheritDoc
		 */
		public function addGuards( ... guards ):ISegmentMapper
		{
			_stateMapping.addGuards( guards );			
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addHooks( ... hooks ):ISegmentMapper
		{
			_stateMapping.addHooks( hooks );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeGuard( guard : * ):ISegmentMapper
		{
			_stateMapping.removeGuard( guard );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeHook( hook : * ):ISegmentMapper
		{
			_stateMapping.removeHook( hook );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function redirectTo( stateOrPath:* = null ):void {
			
			_stateMapping.redirectTo = NavigationState.make(stateOrPath);
		}
		
	}
}