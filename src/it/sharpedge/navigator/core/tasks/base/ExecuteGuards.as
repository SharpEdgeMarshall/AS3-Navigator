package it.sharpedge.navigator.core.tasks.base
{
	import it.sharpedge.navigator.api.IGuardAsync;
	import it.sharpedge.navigator.api.IGuardSync;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.StateMapping;
	import it.sharpedge.navigator.core.async.GuardsAsyncDelegate;
	import it.sharpedge.navigator.core.async.GuardsAsyncHandler;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace routing;
	use namespace navigator;
	
	public class ExecuteGuards
	{		
		protected function validateGuards( router:RoutingQueue, mapping:StateMapping ):void {
			var guardsAsyncHandler:GuardsAsyncHandler = new GuardsAsyncHandler( );
			
			for( var guard:Object in mapping.guards ){					
				if (guard is Function)
				{
					if ((guard as Function)())
						continue;
					
					invalidateRoute(router);
					return;
				} 
				else if (guard is Class)
				{
					guard = new (guard as Class);
				}
				
				if(guard is IGuardAsync){
					guard.approve( new GuardsAsyncDelegate( (guard as IGuardAsync), guardsAsyncHandler ).call );
				} else if( guard is IGuardSync && !guard.approve() ) {
					invalidateRoute(router);
					return;
				}

			}
			
			// Check if async handler has completed ( or has never run )
			if( !guardsAsyncHandler.busy ) {
				if(guardsAsyncHandler.valid)
					router.next();
				else
					invalidateRoute(router);
			}
		}
		
		private function completeCallback():void{
			
		}
		
		private function invalidateRoute(router:RoutingQueue):void {
			Navigator.logger.info("Stopped by Guard");
			router.stop();
		}
	}
}