	  
	 
<cfoutput>

	<cfif url.context eq "cfwindow">
	
	 	<cfquery name="RequestTask" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT *
			FROM   RequestTask
			WHERE  TaskId = '#url.taskid#'
		 
		 </cfquery>
	 
	  	<cfquery name="UnlinkTask" 
	 	datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			UPDATE RequestTask
			SET    StockOrderId = NULL
			WHERE  TaskId = '#url.taskid#'
		 
		 </cfquery>
	 
	 
		<cfquery name="Request" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT *
			FROM   Request
			WHERE  RequestId = '#RequestTask.RequestId#'
		 
		 </cfquery>
	 
		<cfset url.stockorderid = RequestTask.StockOrderId>
		<cfset url.scope    = "direct">
		<cfinclude template = "TaskView.cfm">
		
		<cfif url.scope eq "direct">
			<script>
				showtaskpending('#Request.Mission#','#RequestTask.TaskType#');
			</script>
		</cfif>
	
	<cfelseif url.context eq "window">
	
		 	<cfquery name="UnlinkTask" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">

				UPDATE RequestTask
				SET    StockOrderId = NULL
				WHERE  TaskId = '#url.taskid#'
		 
			 </cfquery>
	
		<script>
			window.location.reload();
		</script>
	
	</cfif>
	
</cfoutput>