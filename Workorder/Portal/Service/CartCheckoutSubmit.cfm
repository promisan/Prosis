
<!--- determine based on the lines if this going to be one or several requests as each request
will have its own workflow --->


<cfif Form.OrgUnit1 eq "">
	  <cf_tl id="Your must to identify a unit." var="1">
	  <cf_alert message = "#lt_text#">
	  <cfabort>
</cfif>

	
<cfquery name="Cart" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    C.ServiceItemUnit, 
             C.Reference, 
			 C.DateEffective, 
			 C.DateExpiration, 
			 C.Currency, 
			 C.Amount, 
			 C.Remarks, 
			 C.ActionStatus, 
			 C.Mission, 
			 C.ServiceItem, 
			 S.ServiceClass,
             C.CartId, 
			 S.Description AS ServiceItemDescription, 
			 U.UnitDescription
   FROM      Cart AS C INNER JOIN
             ServiceItem AS S ON C.ServiceItem = S.Code INNER JOIN
             ServiceItemUnit AS U ON C.ServiceItem = U.ServiceItem AND C.ServiceItemUnit = U.Unit
	WHERE    C.OfficerUserId = '#CLIENT.acc#'
	ORDER BY C.ServiceItem
</cfquery>

<cfquery name="Acc" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   UserNames 
	 WHERE  Account = '#CLIENT.acc#'  
</cfquery>

<cftransaction> 
	
	<cfoutput query="Cart" group="ServiceItem">
	
		<!--- assign requestNo --->
		
		<cf_AssignRequestNo>
		<cf_assignId>
			
		<cfquery name="Insert" 
	     datasource="AppsWorkOrder" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO Request
			 (RequestId,
			  RequestDate, 
			  Mission, 
			  Reference, 
			  OrgUnit, 
			  Memo, 
			  EntityClass,
			  eMailAddress, 
			  ActionStatus, 
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName)
			 VALUES (
			  '#rowguid#',
			  '#dateformat(now(),client.datesql)#',
			  '#mission#',
			  '#reference#',
			  '#form.orgunit1#',
			  '#form.remarks#',
			  '#serviceclass#',
			  '#form.eMailAddress#',
			  '0',
			  '#client.acc#',
			  '#client.last#',
			  '#client.first#' )	  
	     </cfquery>
		 
		 <cfset row = 0>
		 
		<cfoutput>		
		
			<cfset row = row+1>
				
			<cfquery name="Lines" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO RequestLine 
				         (RequestId,
						  Serviceitem,
						  ServiceItemUnit,
						  RequestLine,
						  Reference,
						  Currency,
						  Amount,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#rowguid#',
				          '#ServiceItem#', 
				          '#ServiceItemUnit#', 
						  '#row#',
						  '#Reference#',
						  '#Currency#',
						  '#Amount#',			
						  '#CLIENT.acc#',
						  '#CLIENT.last#',
						  '#CLIENT.first#')
			</cfquery>
	
		</cfoutput>	
				
	</cfoutput>
	
	<cfquery name="Clear" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	       DELETE Cart
	  	   WHERE  OfficerUserid = '#CLIENT.acc#'
	</cfquery>
		
</cftransaction> 

<!--- ------------------------- --->
<!--- generate workflow objects --->
<!--- ------------------------- --->

<cfquery name="Requested" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Request
	 WHERE  ActionStatus = '0'
	 AND    OfficerUserid = '#client.acc#'
</cfquery>		 

<cfoutput query="Requested">
	
	<cfset wflink = "WorkOrder/Portal/Service/ServiceView.cfm?requestid=#requestid#">
				
	<cf_ActionListing 
		EntityCode       = "WrkRequest"
		EntityClass      = "#EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#mission#"
		OrgUnit          = "#orgunit#"		
		PersonEMail      = "#EmailAddress#"
		ObjectReference  = "#Reference#"
		ObjectReference2 = ""						
		ObjectKey4       = "#requestid#"
		ObjectURL        = "#wflink#"
		Show             = "No"
		ToolBar          = "No"		
		CompleteFirst    = "Yes"
		CompleteCurrent  = "No">
		
</cfoutput>

<!--- ------------------------- --->
<!--- ----reload portal screen- --->
<!--- ------------------------- --->
	
<cfoutput>
  
 <script language="JavaScript">
    ColdFusion.navigate('../../../../WorkOrder/Portal/Service/HistoryList.cfm?mode=history','reqmain')   
 </script>
 
</cfoutput>  

