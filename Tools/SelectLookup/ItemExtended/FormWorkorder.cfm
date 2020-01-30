
<cfoutput>
	
		<cfparam name="itemlist" default="">	
		<cfparam name="form.Provisioning" default="">
		<cfparam name="form.serviceitem" default="">
		<cfset serviceitem = "#form.ServiceItem#">
			
		<cfset units = "">
		
		<cfloop index="itm" list="#Form.Provisioning#" delimiters="|">
		
			<cfif isValid("GUID",itm)>
			
				<cfquery name="getId" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT ServiceItemUnit
				    FROM   ServiceItemUnitMission
					WHERE  CostId  = '#itm#'			
				</cfquery>
			
				<cfif getId.recordcount eq "1">	
				     <cfif units eq "">
				         <cfset units = "'#getId.ServiceItemUnit#'">	
					 <cfelse>	
						 <cfset units = "#units#,'#getId.ServiceItemUnit#'">		 
					 </cfif>	 
				</cfif>		
		
			<cfelse>
			
				<cfif units eq "">
				   <cfset units = "'#itm#'">
				<cfelse>
				   <cfset units = "#units#,'#itm#'">
				</cfif>   
		
			</cfif>	
		
		</cfloop>
		
		<cfif units neq "">
			
			<cfquery name="allUnits" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT  R.Unit
				    FROM    ServiceItemUnit R
					WHERE   R.ServiceItem = '#serviceitem#'	
					<!--- get all units that have an item defined --->		
					AND     R.Unit IN (SELECT  Unit
					                   FROM    ServiceItemUnitItem
					  		           WHERE   ServiceItem    = '#serviceitem#'
								 	   AND     Unit           = R.Unit
									   AND     Operational = 1)
					AND     Operational = 1 	
					<!--- only selected units --->
					AND     R.Unit IN (#preserveSingleQuotes(units)#)				  							   
			</cfquery>
			
			<cfif allUnits.recordcount gte "1">
			
				<cfloop query="allUnits">
							
				    <cfquery name="getItem" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">	 
					
						  SELECT   ItemNo
						  FROM     ServiceItemUnitItem
						  WHERE    ServiceItem = '#serviceitem#' 
						  AND      Unit = '#unit#'
						
					</cfquery>
					
					<cfset list = valuelist(getItem.ItemNo)>									
					<cfif currentrow eq "1">	
						<cfset variables.aList = listToArray(list)>
					<cfelse>
					    <cfset variables.bList = listToArray(list)>
						<cfset variables.aList.retainAll(variables.bList)>
					</cfif>			
						
				</cfloop>
						
				<cfset itemlist = arrayToList(variables.alist)>
				
			</cfif>		
			
		</cfif>
			
	</cfoutput>