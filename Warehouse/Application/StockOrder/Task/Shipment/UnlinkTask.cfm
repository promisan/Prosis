<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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