
<cfloop index="fld" list="TransferMode,PersonNo,Customer,OrgUnit,Funding,ServiceItem,Asset,Personal">

    <cfif fld eq "ServiceItem">
	
		<cfparam name="Form.#fld#From" default="#Form.ServiceItem#">
		<cfparam name="Form.#fld#To"   default="#Form.ServiceItem#">
	
	<cfelse>
	
		<cfparam name="Form.#fld#From" default="">
		<cfparam name="Form.#fld#To"   default="">
		
	</cfif>	
	
	<cfset fr = evaluate("Form.#fld#From")>
	<cfset to = evaluate("Form.#fld#To")>
	
	<cfif fr neq "" or to neq "">
	
	<cfquery name="InsertAmendment" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		  INSERT INTO RequestWorkorderDetail (
			   RequestId,
			   WorkorderId, 
			   WorkOrderLine,
			   Amendment,
			   ValueFrom,
			   ValueTo )
		   VALUES (  
			  '#url.requestid#',
			  '#checkLine.WorkorderId#',
			  '#checkLine.WorkOrderLine#',
			  '#fld#',
			  '#fr#',
			  '#to#' )
		</cfquery>	
		
		</cfif>

</cfloop>

<cfinclude template="RequestDeviceSubmit.cfm">

