<!--
    Copyright © 2025 Promisan

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


<!--- get taskid and vendors in the selected as in the prior screen --->

<cfparam name="Form.Selected" default="''">

<cfif url.tasktype eq "Purchase">
	
	<cfquery name="GetTasks" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	SELECT   T.TaskId, T.ShipToMode, P.OrgUnitVendor as Provider
		
		FROM     RequestHeader H 
				 INNER JOIN Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
				 INNER JOIN RequestTask T ON R.RequestId = T.RequestId 
				 INNER JOIN Purchase.dbo.PurchaseLine PL ON T.SourceRequisitionNo = PL.RequisitionNo
				 INNER JOIN Purchase.dbo.Purchase P ON PL.PurchaseNo = P.PurchaseNo
				 
		<!--- request header is cleared/tasked --->			 
		WHERE        H.ActionStatus IN ('2p', '3')  
		
		<!--- was not planned already, then it is part of the listing --->	
		AND          T.StockOrderId is NULL
		
		<!--- request line itself is not cancelled --->			 
		AND          R.Status IN ('1','2','3') 
		
		<!--- external processing only : local tasking not relevant --->
		
		AND          T.TaskType = 'Purchase'
		
		AND          R.Mission  = '#url.mission#' 
		
		<!--- task is valid and was not cancelled --->
		AND          T.RecordStatus = '1'		
					
	</cfquery>

<cfelse>
	
	<cfquery name="GetTasks" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	SELECT   T.TaskId, T.ShipToMode, T.SourceWarehouse as Provider
		
		FROM     RequestHeader H 
				 INNER JOIN Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
				 INNER JOIN RequestTask T ON R.RequestId = T.RequestId 
				 
		<!--- request header is cleared/tasked --->			 
		WHERE        H.ActionStatus IN ('2p', '3')  
		
		<!--- was not planned already, then it is part of the listing --->	
		AND          T.StockOrderId is NULL
		
		<!--- request line itself is not cancelled --->			 
		AND          R.Status IN ('1','2','3') 
		
		<!--- internal processing only  --->
		AND  T.TaskType = 'Internal' 
		
     		<!--- AND ShipToMode = 'Deliver' --->
		
		AND          R.Mission  = '#url.mission#' 
		
		<!--- task is valid and was not cancelled --->
		AND          T.RecordStatus = '1'		
					
	</cfquery>

</cfif>

<cfquery name="Current" maxrows=1 dbtype="query">
	SELECT   Provider, ShipToMode		 
	FROM     getTasks	
	<!--- selected --->
	<cfif form.selected neq "">	
	WHERE   TaskId IN (#preservesinglequotes(form.selected)#)
	<cfelse>
	WHERE 1=0
	</cfif>
</cfquery>	

<cfif getTasks.recordcount gte "1">
	
	<script>
		document.getElementById('taskorderbox').className = "regular"
	</script>
	
<cfelse>

	<script>
		document.getElementById('taskorderbox').className = "hide"
	</script>
	
</cfif>

<cfoutput query="getTasks">


    <cfif Current.recordcount eq "0">
			
		<script>
			try { document.getElementById('sel#taskid#').className = "" } catch(e) {}
		</script>
	
	<cfelseif Provider neq Current.Provider>	
		
		<script>
			try { document.getElementById('sel#taskid#').className = "hide" } catch(e) {}
		</script>
		
	<cfelseif ShipToMode neq Current.ShipToMode>
		
		<script>
			try { document.getElementById('sel#taskid#').className = "hide" } catch(e) {}
		</script>
		
	<cfelse>	
		
		<script>
			try { document.getElementById('sel#taskid#').className = "" } catch(e) {}
		</script>
	
	</cfif>	
		
</cfoutput>


