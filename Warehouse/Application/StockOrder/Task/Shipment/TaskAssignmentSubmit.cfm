
<!---
1. Create record
2. Link the tasks
3. Replace with the view (option to print)
--->
		
<cfset dateValue = "">
<CF_DateConvert Value="#Form.OrderDate#">
<cfset dte = dateValue>

<cfparam name = "Form.Warehouse"  default = "">		
<cfparam name = "Form.PersonNo"   default = "">
<cfparam name = "Form.Vendor"     default = "0">

<cftransaction>

<cfquery name="createTaskOrder" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    INSERT INTO TaskOrder
		(StockOrderId,
		 Mission, 	
		 TaskType,	 
		 <cfif url.tasktype eq "Internal">
		 	PersonNo,
		 	Warehouse,
		 	Location,	
		<cfelse>	 
		    OrgUnit,
		 </cfif>
		 Reference, 
		 OrderDate, 
		 TaskClass, 
		 DeliveryDate, 
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
	VALUES ('#Form.StockOrderId#',
			'#url.mission#',	
			'#url.tasktype#',	
			<cfif url.tasktype eq "Internal">
			 	'#Form.PersonNo#',
			 	'#Form.Warehouse#',
				'#Form.Location#',
			<cfelse>
			    '#Form.Vendor#',
			 </cfif>
			'#Form.Reference#',
			#dte#,
			'#form.TaskClass#',
			#dte#,
			'#Form.Remarks#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#' )	 
</cfquery>

<cfquery name="LinkToTaskOrder" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     UPDATE RequestTask
	 SET    StockOrderId = '#Form.StockOrderId#'
	 WHERE  TaskId IN (#preservesinglequotes(form.taskids)#)	
</cfquery>

<cfquery name="getMode" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * FROM RequestTask
	WHERE   StockOrderId = '#Form.StockOrderId#'	
</cfquery>

</cftransaction>

<!--- generate workflow --->

<cfset wflink = "Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?drillid=#Form.StockOrderId#">

<cfset Reset = "Yes">

<cfif url.tasktype eq "Purchase">
						
	<cf_ActionListing 
		EntityCode       = "WhsTaskorder"
		EntityClass      = "#url.tasktype#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#url.mission#"
		OrgUnit          = ""		
		PersonEMail      = ""
		ObjectReference  = "#Form.Reference#"
		ObjectReference2 = "#url.tasktype#"						
		ObjectKey4       = "#Form.StockOrderId#"
		AjaxId           = "#Form.StockOrderId#"
		ObjectURL        = "#wflink#"	
		Show             = "No">
		
<cfelse>
	
	<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ShipToModeMission
		WHERE  Code    = '#getMode.shipToMode#'		
		AND    Mission = '#url.mission#'	
	</cfquery>
	
	<cfif get.EntityClass eq "">
	   <cfset getClass = url.tasktype>	   
	<cfelse>      
	   <cfset getClass = get.EntityClass>
	</cfif>
					
	<cf_ActionListing 
		EntityCode       = "WhsTaskorder"
		EntityClass      = "#getClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#url.mission#"
		OrgUnit          = ""		
		PersonEMail      = ""
		ObjectReference  = "#Form.Reference#"
		ObjectReference2 = "#url.tasktype#"						
		ObjectKey4       = "#Form.StockOrderId#"
		AjaxId           = "#Form.StockOrderId#"
		ObjectURL        = "#wflink#"	
		Show             = "No">

</cfif>
	
<cfoutput>
	<script>
		showtaskpending('#url.mission#','#url.tasktype#')
		// refresh the tree of the process screen for the shipping warehouse 
        if (document.getElementById('tasktreerefresh')) {		
        ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#url.mission#&warehouse=#url.warehouse#','tasktreerefresh')
        }		
	</script>
</cfoutput>

<cfset url.stockorderid = form.StockOrderId>
<cfset url.scope    = "direct">
<cfinclude template = "TaskView.cfm">

