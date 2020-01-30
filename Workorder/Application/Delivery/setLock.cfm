
<!--- SET LOCK --->

<cfparam name="url.date" default="">

<cfif url.date eq "">
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#dateformat(now()+1,client.dateformatshow)#">
	<cfset DTS = dateValue>		
	
<cfelse>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.date#">
	<cfset DTS = dateValue>		
	
</cfif>


<cfquery name="Lock"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	UPDATE Workorder
	SET    ActionStatus = '1'
	WHERE  WorkorderId IN (
	SELECT WorkOrderId		  
	FROM (  	   
			
		SELECT   W.WorkOrderId
				 
	    FROM     WorkOrder AS W INNER JOIN						
                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine LEFT OUTER JOIN 
			     Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit LEFT OUTER JOIN
			     Organization.dbo.OrganizationCategory OC ON O.OrgUnit = OC.Orgunit LEFT OUTER JOIN 
			     Organization.dbo.Ref_OrganizationCategory ROC ON ROC.Code = OC.OrganizationCategory AND ROC.Area ='Location'
				 
	    WHERE    W.Mission          = '#url.mission#'
		AND      A.ActionClass      = 'Delivery' 
		AND      A.DateTimePlanning = #dts#  			    	
		AND      WL.Operational     = '1'
		AND      W.ActionStatus    != '9' 
	
	) F  )
			   
</cfquery>	

<script>
    try {
	document.getElementById('lock').className = "hide"
	} catch(e) {}
</script>
	