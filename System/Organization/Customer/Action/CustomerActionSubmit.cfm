
<cfparam name="url.action" 				default="">
<cfparam name="url.CustomerId" 			default="">
<cfparam name="url.CustomerActionId" 	default="">

<cfif url.action eq "new">

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.ActionDate#">
	<cfset vActionDate = dateValue>
	
	<cf_assignid>
	
	<cfset url.customeractionid = rowguid>

	<cfquery name="Insert" 
			 datasource="AppsWorkorder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 	INSERT INTO CustomerAction
				
					( CustomerActionId,
					  CustomerId,
					  ActionClass,
					  ActionDate,
					  ActionStatus,
					  Remarks,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName )
					  
				VALUES
				
					( '#url.customeractionid#',
					  '#url.CustomerId#',
					  '#Form.ActionClass#', 
					  #vActionDate#, 
					  '0', 
					  '#Form.Remarks#', 
					  '#SESSION.acc#', 
					  '#SESSION.last#', 
					  '#SESSION.first#')
			 
	</cfquery>		
		
	<cfquery name="Customer" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    Customer
		WHERE   CustomerId = '#url.customerid#'	
	</cfquery>
	
	<cfquery name="ActionDef" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    Ref_Action
		WHERE   Code = '#form.ActionClass#'	
	</cfquery>
	
	<cf_ActionListing 
	    EntityCode       = "WrkCustomer"
		EntityClass      = "#Form.WorkFlow#"
		EntityGroup      = "" 
		EntityStatus     = ""
		Mission          = "#ActionDef.Mission#"	
		ObjectReference  = "#Customer.CustomerName#"
		ObjectReference2 = "#ActionDef.Description#"	  
		ObjectKey4       = "#url.customeractionid#"	
		Show             = "No"
		ToolBar          = "No"
		ObjectURL        = ""
		CompleteFirst    = "No"
		CompleteCurrent  = "No"> 

	
<cfelseif url.action eq "delete">

	<!--- make sure action status is 0 --->
	<cfquery name="Check" 
		 datasource="AppsWorkorder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT ActionStatus
			 FROM   CustomerAction
			 WHERE  CustomerActionId = '#url.CustomerActionId#' 
	</cfquery>
	
	<cfif Check.recordcount eq 0>
		
		<cfset vMessage = "This record has been processed and it cannot be deleted">
		
		<cfoutput>
			<script language="javascript">
				alert("#vMessage#.");
			</script>
		</cfoutput>
	
	<cfelse>
	
		<!--- make sure action status is 0 --->
		<cfquery name="Delete" 
			 datasource="AppsWorkorder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				DELETE FROM CustomerAction
				WHERE  CustomerActionId = '#url.CustomerActionId#'
		</cfquery>
		
	</cfif>

</cfif>

<cfinclude template="CustomerActionListingDetail.cfm">