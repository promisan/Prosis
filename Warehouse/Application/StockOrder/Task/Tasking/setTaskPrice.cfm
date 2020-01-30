<!--- ------------------------- --->
<!--- get the price if possible --->
<!--- ------------------------- --->		

<cf_setTaskValue RequestId="#url.id#" SerialNo="#URL.serialNo#">
	
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Request R, RequestTask T
		WHERE  R.RequestId    = '#url.id#'
		AND    R.RequestId    = T.RequestId
		AND    T.TaskSerialNo = '#URL.serialNo#'
</cfquery>	
	
<cfquery name="getLoc" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT * 
		FROM   Warehouse
		WHERE  Warehouse  = '#get.ShipToWarehouse#'			
</cfquery>
	
<cfif getLoc.LocationId eq "">	
	
	<script>
		 alert("A price has not been defined for this Product. Contact your administrator.")
	</script>	
		
</cfif>	
	
<!--- show the determined value to be taken into consideration --->

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   RequestTask T
	WHERE  T.RequestId     = '#URL.ID#'
	AND    T.TaskSerialNo  = '#URL.serialNo#'
</cfquery>

<cfquery name="TaskedBase" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM   RequestTask
      WHERE  RequestId = '#URL.Id#'		 
</cfquery>

<cfoutput>

	#get.TaskCurrency# #numberformat(get.TaskAmount,'__,__.__')# 
	
	<cfif get.taskcurrency neq APPLICATION.BaseCurrency>	
		(#numberformat(get.TaskAmountBase,'__,__.__')# )		
	</cfif>				

	<script>
		taskselect('#URL.ID#','#URL.SerialNo#','#taskedbase.recordcount#','standard')
	</script>

</cfoutput>