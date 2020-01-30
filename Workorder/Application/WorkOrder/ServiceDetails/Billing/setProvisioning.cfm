

<!--- set prvisioining from the number of actions selected --->

<cfoutput>

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT    *							  
			FROM      WorkOrder
			WHERE     WorkOrderId = '#url.workorderid#'
																							
	</cfquery>		
	
	<cfparam name="form.workactionid" default="">
	
	<cfset act = "">
	<cfloop index="itm" list="#Form.WorkActionId#">
	  <cfif act neq "">
		  <cfset act = "#act#,'#itm#'">
	  <cfelse>
	      <cfset act = "'#itm#'">
	  </cfif>
	</cfloop>
	
	<cfquery name="Actions" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT    *							  
			FROM      WorkOrderLineAction 
			<cfif act neq "">
			WHERE     WorkActionId  IN (#preserveSingleQuotes(act)#) 
			<cfelse>
			WHERE   1=0
			</cfif>																				
	</cfquery>		
	
	<cfquery name="DefaultClasses" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT SIU.UnitClass
		FROM     ServiceItemUnitMission SIUM INNER JOIN
                 ServiceItemUnit SIU ON SIUM.ServiceItemUnit = SIU.Unit AND SIUM.ServiceItem = SIU.ServiceItem
        WHERE    SIUM.Mission = '#get.mission#' 
        AND      SIUM.EnableSetDefault = '1'
	</cfquery>
	
	<cfloop query="defaultclasses">
	
		<script>
		    try {
			document.getElementById('#UnitClass#_unitquantity_0').value = '#Actions.recordcount#'
			calc('#unitclass#','0','#Actions.recordcount#',document.getElementById('#UnitClass#_standardcost_0').value)
			} catch(e) {}			
		</script>
	
	</cfloop>	
	
	<!--- wildcard : or take the first regular entry to be increased with the check box --->
	<script>
	       
			try {
			document.getElementById('Regular_UnitQuantity_1').value = '#Actions.recordcount#'			
			calc('Regular','1','#Actions.recordcount#',document.getElementById('Regular_StandardCost_1').value)
			} catch(e) {}	
	</script>
	
</cfoutput>