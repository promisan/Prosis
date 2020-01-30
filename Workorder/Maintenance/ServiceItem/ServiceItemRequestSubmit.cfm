
<cfquery name="Tpe" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Request	
		WHERE Operational = 1	
</cfquery>
		
<cfloop query="Tpe">
	
	 <cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_RequestServiceItem
			WHERE  ServiceItem = '#url.id1#'		
			AND    Code = '#code#' 
	</cfquery>
		
	<cfparam name="Form.#code#_Operational" default="1">
	<cfparam name="Form.#code#_isAmendment" default="">
	<cfparam name="Form.#code#_pointerReference" default="">
	<cfparam name="Form.#code#_CustomForm" default="">
		
	<cfset ope = evaluate("Form.#code#_Operational")>
	<cfset amd = evaluate("Form.#code#_isAmendment")>
	<cfset ref = evaluate("Form.#code#_pointerReference")>
	<cfset cus = evaluate("Form.#code#_CustomForm")>
		
	<cfif ope eq "0" and get.recordcount eq "1">
	
			 <cfquery name="delete" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					DELETE FROM   Ref_RequestServiceItem
					WHERE  ServiceItem = '#url.id1#'		
					AND    Code = '#code#'
			</cfquery>
			
	<cfelseif ope eq "1" and get.recordcount eq "1">		
	
		 <cfquery name="update" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_RequestServiceItem
					SET    isAmendment = '#amd#',
					       PointerReference = '#ref#', 
						   CustomForm = <cfif amd eq "0">null<cfelse>'#cus#'</cfif>
					WHERE  ServiceItem = '#url.id1#'		
					AND    Code = '#code#'
			</cfquery>
	
	<cfelseif ope eq "1" and get.recordcount eq "0">
		
		   <cfquery name="insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO Ref_RequestServiceItem
				(Code,ServiceItem,isAmendment,pointerReference,customForm, officerUserId,OfficerLastName,OfficerFirstName)
				VALUES
				('#code#','#url.id1#','#amd#','#ref#',<cfif amd eq "0">null<cfelse>'#cus#'</cfif>,'#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			</cfquery>
		
	</cfif>
			
</cfloop>

<cfinclude template="ServiceItemRequest.cfm">
	