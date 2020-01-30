
<!--- 11/11/2011
1. This for the mode that the entity is charged for the issuances which are done by a warehouse on hehalf of the main entity ; 
2. so called EFMS outsourced mode as opposed to billing for tasked bulk deliveries 
--->

<cfset class = "warehouse">  <!--- will have to be set to [Issue] next week --->
	
<cfquery name= "getWarehouse" 
	datasource   = "AppsMaterials" 
	username     = "#SESSION.login#" 
	password     = "#SESSION.dbpw#">
	SELECT * 
	FROM   Warehouse 
	WHERE  Warehouse = '#url.warehouse#'
</cfquery>	
		  		  
<cfdiv style="height:100%" 
     bind="url:#SESSION.root#/Procurement/Application/Invoice/InvoiceView/InvoiceViewListing.cfm?mission=#url.mission#&missionorgunitid=#getWarehouse.missionOrgUnitId#&id1=SHP&invoiceclass=#class#">	
		
