
<cfparam name="Attributes.FromWarehouse"  default=""> 
<cfparam name="Attributes.FromLocation"   default=""> 
<cfparam name="Attributes.ToWarehouse"    default=""> 
<cfparam name="Attributes.ToLocation"     default=""> 

<cfquery name="getLocationFrom"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *				 
		FROM     WarehouseLocation
		WHERE    Warehouse = '#Attributes.FromWarehouse#'
		AND      Location  = '#Attributes.FromLocation#'
	</cfquery>	

<cfquery name="getLocationTo"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *				 
		FROM     WarehouseLocation
		WHERE    Warehouse = '#Attributes.ToWarehouse#'
		<cfif attributes.ToLocation neq "">
		AND      Location  = '#Attributes.ToLocation#'
		</cfif>
	</cfquery>		
	
<!--- added 25/6/2012 for EFMS tuning, for interal payments --->

<cfif getLocationFrom.BillingMode eq "External" and getLocationTo.BillingMode eq "External">
  
    <!--- this is considered an internal transfer no action for billing here --->
    <cfset mode = "Internal">
	
<cfelseif getLocationFrom.BillingMode eq "External" and getLocationTo.BillingMode eq "Internal">

    <!--- we tag this as a transactio to be billed by the owner location to the entity : AP --->
    <cfset mode = "External">
   
<cfelse>

	<!--- a transaction from internal to a external is a potential AR and will instead 
	be handled as a sale record to be issued to the operators and should not trigger a AP --->	
    <cfset mode = "Internal">    
   
</cfif>   
	
<cfset caller.billingmode = mode>