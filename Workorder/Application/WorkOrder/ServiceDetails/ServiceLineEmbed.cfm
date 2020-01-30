
<!--- ------------------- --->
<!--- pending development --->
<!--- ------------------- --->

<cfoutput>

 <cfquery name="Check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineTopic R 
		WHERE   R.WorkOrderId = '#WorkOrderId#'			
		AND     R.WorkOrderLine = '#WorkOrderLine#'
	 </cfquery>
					 
		<cfif check.recordcount eq "0">
			   			   
			 <img src="#SESSION.root#/Images/features.gif"
			     	alt="Topics / Features for this line"
				    id="d#box#_min"
			     	border="0"
				  	height="12"
				 	width="12"
				  	align="absmiddle"
			     	class="regular"
			     	style="cursor: pointer;"
					<!--- 	onClick="object('#box#','#workorderid#','#workorderline#')" --->>
				 
				 <cfelse>
				 
			  <img src="#SESSION.root#/Images/agent.gif"
			     	alt="Topics/Features"
				    id="d#box#_min"
			     	border="0"
				  	height="12"
				 	width="12"
				  	align="absmiddle"
			     	class="regular"
			     	style="cursor: pointer;"
			     	onClick="object('#box#','#workorderid#','#workorderline#')">
				 				 
				 </cfif>
				 
				<img src="#SESSION.root#/Images/icon_collapse.gif"
			     alt="Hide"
			     id="d#box#_max"
			     border="0"
				  height="12"
				 width="12"
				 align="absmiddle"
			     class="hide"
			     style="cursor: pointer;"
			     onClick="object('#box#','#workorderid#','#workorderline#')">
				 
</cfoutput>				 