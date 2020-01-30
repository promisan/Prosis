
<cfquery name="Parameter" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT TOP 1 * 
        FROM  Ref_ParameterMission
</cfquery>

<cfparam name="URL.Mission" default="#Parameter.Mission#"> 
<cfparam name="URL.scope"   default="backoffice"> 

<cfif URL.Mission eq "">
	<cfset URL.Mission = Parameter.Mission>
</cfif>

<cfquery name="Get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Wo.*, 
	         SI.Description AS ServiceItemDescription, 			
			 C.OrgUnit,
			 C.CustomerName AS CustomerName, 
             C.Reference AS CustomerReference, 
			 C.PhoneNumber AS CustomerPhoneNo
    FROM     WorkOrder Wo INNER JOIN
             ServiceItem SI ON Wo.ServiceItem = SI.Code INNER JOIN
             Customer C ON Wo.CustomerId = C.CustomerId	INNER JOIN
			 Organization.dbo.Organization O ON C.OrgUnit = O.OrgUnit
	WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
</cfquery>	
		
<cfoutput>	
	
	<cfif get.orgunit neq "">		
	
		<iframe src="../../../../System/Organization/Application/Address/UnitAddress.cfm?id=#get.orgunit#&scope=#url.scope#"
        width="100%" height="99%" frameborder="0">
		</iframe>		
		
	<cfelse>
		
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
			<tr><td height="50"><cf_tl id="Customer not associated to a organization record" class="message"></td></tr>
		</table>
	
	</cfif>	

</cfoutput>	

