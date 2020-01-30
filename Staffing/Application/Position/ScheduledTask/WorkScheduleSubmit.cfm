

<cfparam name="Form.workorderid_#left(url.workorderid,8)#" default="">

<cfset sel = evaluate("Form.workorderid_#left(url.workorderid,8)#")>
<cfset mem = evaluate("Form.workordermemo_#left(url.workorderid,8)#")>

<cfif sel eq "">

	<cfquery name="Delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Employee.dbo.PositionWorkorder
	    WHERE  PositionNo = '#URL.PositionNo#'
        AND    WorkOrderId = '#url.workorderid#'
	</cfquery>	
	
	<cfoutput>
	<script>
	  document.getElementById('workordermemo_#left(url.workorderid,8)#').className = "hide"
	</script>
	</cfoutput>

<cfelse>

	<cfoutput>
	<script>
	  document.getElementById('workordermemo_#left(url.workorderid,8)#').className = "regular"
	</script>
	</cfoutput>

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Employee.dbo.PositionWorkorder
	    WHERE  PositionNo = '#URL.PositionNo#'
        AND    WorkOrderId = '#url.workorderid#'
	</cfquery>	
	
	<cfif get.recordcount eq "0">
	
	<cfquery name="insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Employee.dbo.PositionWorkorder
		(PositionNo, WorkOrderId,Memo,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES
		('#url.positionno#','#url.workorderid#','#mem#','#session.acc#','#session.last#','#session.first#')
	</cfquery>		
	
	<cfelse>
	
	<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PositionWorkorder
		SET    Memo = '#mem#'
	    WHERE  PositionNo = '#URL.PositionNo#'
        AND    WorkOrderId = '#url.workorderid#'
	</cfquery>	
	
	</cfif>
	

</cfif>