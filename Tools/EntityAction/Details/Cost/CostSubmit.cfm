<cfparam name="Form.ActionCode" default="">
<cfparam name="Form.DocumentId" default="">
<cfparam name="Form.DocumentItem" default="">
<cfparam name="Form.Description" default="">
<cfparam name="Form.DocumentNo" default="">
<cfparam name="Form.DocumentDate" default="">
<cfparam name="Form.DocumentDateHour" default="12">
<cfparam name="Form.DocumentDateMinute" default="00">
<cfparam name="Form.DocumentCurrency" default="">
<cfparam name="Form.DocumentAmount" default="">
<cfparam name="Form.DocumentMinute" default="0">
<cfparam name="Form.DocumentMemo" default="">
<cfparam name="Form.UserAccount" default="#SESSION.acc#">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DocumentDate#">
<cfset DTE = dateValue>

<cfset hour = form.documentDateHour>
<cfset min  = form.documentDateMinute>

<cfif hour eq "">
  <cfset hour = 12>
</cfif>

<cfif min eq "">
  <cfset min = "00">
</cfif>

<cfset DTE = #CreateDateTime(Year(DTE), Month(DTE), Day(DTE), #hour#, #min#, '00')#>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionCost
		WHERE  ObjectId  = '#Form.ObjectId#'
		AND    ObjectCostId  = '#Form.ObjectCostId#'		
</cfquery>

<cfif check.recordcount eq "0">		

	<cfif Form.DocumentMinute neq "0">
	    <cfif form.documentquantity gte 0>
		   	<cfset t = Form.DocumentQuantity+(Form.DocumentMinute/60)>	
		<cfelse>
		   	<cfset t = Form.DocumentQuantity-(Form.DocumentMinute/60)>			
		</cfif>
	<cfelse>
	    <cfset t = Form.DocumentQuantity>	
	</cfif>
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   OrganizationObjectAction
		WHERE  ObjectId    = '#Form.ObjectId#'
		AND    ActionCode  = '#Form.ActionCode#'		
		ORDER BY Created DESC
	</cfquery>
	

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO  OrganizationObjectActionCost
		( ObjectCostId,
		  ObjectId,
		  ActionCode,
		  <cfif form.documentitem neq "">
		  DocumentId,
		  DocumentItem,
		  </cfif>
		  <cfif check.recordcount eq "1">
		  ActionId,
		  </cfif>
		  OwnerAccount,
		  DocumentType,
		  Description,
		  DocumentNo, 
		  DocumentDate, 
		  DocumentQuantity,
		  DocumentCurrency, 
		  DocumentRate, 
		  <cfif form.mode eq "Regular">
		  InvoiceRate,
		  </cfif>
		  DocumentMemo,
		  OfficerIPAddress,		 
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName)
		VALUES 
		( '#Form.ObjectCostId#',
		  '#Form.ObjectId#',
		  '#Form.ActionCode#',
		  <cfif form.documentitem neq "">
		  '#Form.documentId#',
		  '#Form.DocumentItem#',
		  </cfif>
		  <cfif check.recordcount eq "1">
		  '#Check.actionId#',
		  </cfif>
		  '#Form.UserAccount#',
		  '#url.type#',
		  '#Form.Description#',
		  '#Form.DocumentNo#', 
		  #DTE#, 
		  '#t#', 
		  '#Form.DocumentCurrency#', 
		  '#Form.DocumentRate#', 
		  <cfif form.mode eq "Regular">
		  '#Form.InvoiceRate#',
		  </cfif>
		  '#Form.DocumentMemo#',
		  '#CGI.Remote_Addr#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
	</cfquery>
		
	<cfoutput>
	<script>
	   <!--- refresh and reload entry screen --->
   		ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box=#url.box#&mode=#form.Mode#&objectid=#Form.ObjectId#&actioncode=#url.actioncode#','#url.box#') 						
		ColdFusion.navigate('#SESSION.root#/tools/entityaction/Details/Cost/CostEntry.cfm?box=#url.box#&mode=#form.Mode#&objectid=#Form.ObjectId#&recordid=&type=#url.type#&actioncode=#url.actioncode#','costdialog') 					
	</script>	
	</cfoutput>		

	
<cfelse>

	<cfif Form.DocumentMinute neq "0">
	    <cfif form.documentquantity gte 0>
		   	<cfset t = Form.DocumentQuantity+(Form.DocumentMinute/60)>	
		<cfelse>
		   	<cfset t = Form.DocumentQuantity-(Form.DocumentMinute/60)>			
		</cfif>
	<cfelse>
	    <cfset t = Form.DocumentQuantity>	
	</cfif>

	<cfquery name="Edit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE OrganizationObjectActionCost
		SET    ActionCode       = '#Form.ActionCode#',
		       Description      = '#Form.Description#',
			   DocumentNo       = '#Form.DocumentNo#',
			   DocumentDate     = #DTE#,
			   DocumentQuantity = '#t#', 
			   DocumentCurrency = '#Form.DocumentCurrency#',
			   DocumentRate     = '#Form.DocumentRate#',
			   DocumentMemo     = '#Form.DocumentMemo#'			  	   
			  <cfif form.mode eq "Regular">
			  ,InvoiceRate      = '#Form.InvoiceRate#'
			  </cfif>
			  <cfif form.documentitem neq "">
			  ,DocumentId   = '#Form.documentId#'
			  ,DocumentItem = '#Form.DocumentItem#'
			  </cfif>
		WHERE  ObjectId      = '#Form.ObjectId#'
		AND    ObjectCostId  = '#Form.ObjectCostId#'		
	</cfquery>
	
	<cfoutput>
	<script>
	    ProsisUI.closeWindow('costdialog') 		
   		ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box=#url.box#&mode=#form.Mode#&objectid=#Form.ObjectId#&actioncode=#url.actioncode#','#url.box#') 						
	</script>	
	</cfoutput>		
	
</cfif>	
