package it.sharpedge.navigator.core
{	
	import flash.events.EventDispatcher;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.ns.routing;
	import it.sharpedge.navigator.core.tasks.ITask;
	import it.sharpedge.navigator.events.RoutingQueueEvent;
	
	use namespace routing;
	
	public class RoutingQueue extends EventDispatcher
	{
		private var _running:Boolean = false;
		private var _tasks:Vector.<ITask> = new Vector.<ITask>();
		
		// CURRENT RUN VARIABLES
		routing var currentState:NavigationState;
		routing var requestedState:NavigationState;
		routing var exitMapping:StateMapping = new StateMapping();
		routing var enterMapping:StateMapping = new StateMapping();
		private var _currentTaskIDX:int = -1;
		
		public function RoutingQueue()
		{
		}
		
		public function get running():Boolean
		{
			return _running;
		}

		public function add( task:ITask ):void {
			if(_running) return; // TODO Should throw warning
			
			_tasks.push( task );
		}
		
		public function remove( task:ITask ):void {
			if(_running) return; // TODO Should throw warning
			
			var idx:int = _tasks.indexOf( task );
			if(idx == -1) return;
			
			_tasks.slice( idx, 1 );
		}
		
		public function run( currentState:NavigationState, requestedState:NavigationState ):void {
			if(_running) return;
			
			_running = true;
			this.currentState = currentState;
			this.requestedState = requestedState;
			
			var rqEvent : RoutingQueueEvent = new RoutingQueueEvent( RoutingQueueEvent.START );
			dispatchEvent(rqEvent);
			
			next();
		}
		
		routing function next():void {
			if(!_running) return;
			
			if(_currentTaskIDX+1 == _tasks.length){
				complete();
				return;
			}
			
			_tasks[++_currentTaskIDX]
				.run( this );
		}	
		
		routing function stop():void {
			if(!_running) return;
			
			reset();
			
			var rqEvent : RoutingQueueEvent = new RoutingQueueEvent( RoutingQueueEvent.ABORT );
			dispatchEvent(rqEvent);
		}
		
		routing function reset():void {			
			if(!_running) return;
			
			_running = false;
			currentState = null;
			requestedState = requestedState;
			exitMapping = null;
			enterMapping = null;
			_currentTaskIDX = -1;						
		}
		
		private function complete():void {
			var oldIDX:int = _currentTaskIDX;
			
			reset();
			
			var rqEvent : RoutingQueueEvent = new RoutingQueueEvent( RoutingQueueEvent.COMPLETE );
			dispatchEvent(rqEvent);
		}
	}
}