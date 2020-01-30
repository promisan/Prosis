	
	<cfset qty = evaluate("Form.#cl#_unitquantity_#id#")>
	<cfset rte = evaluate("Form.#cl#_standardcost_#id#")>
	<cfset rte = replace("#rte#",",","")>
	
	<cfset chg = evaluate("Form.#cl#_charged_#id#")>
	
	<!--- check if record exists --->
			
	<cfquery name="Exist" 
    datasource="appsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  * 
	FROM    RequestLine			
	WHERE   Requestid        = '#url.requestId#'	
	AND     ServiceItem      = '#form.serviceitemto#'
	AND     ServiceItemUnit  = '#selected#'
   </cfquery>		
   	
	<cfif Exist.recordcount eq "0">
	
	   <cfif qty eq "0">
	        <cfset qty = "1">
	   </cfif>
	
		<cfquery name="Insert" 
			  datasource="appsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				INSERT INTO RequestLine
				( RequestId,
				  RequestLine,			 
				  ServiceItem,
				  ServiceItemUnit,		
				  DateEffective,			 
				  CostId,
				  Quantity,
				  Currency,
				  Charged,
				  Rate,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
				VALUES (
				 '#url.requestid#',
				 '#ln#',					
				 '#form.serviceitemto#',
				 '#selected#',			
				 #eff#,		
				 '#costid.costid#',
				 '#qty#',
				 '#currency#',
				 '#chg#',
				 '#rte#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')		
		</cfquery>				
			
	<cfelse>
	
		 <cfif qty eq "0">
	        <cfset qty = "1">
	   </cfif>
	
		<cfquery name="Exist" 
	    datasource="appsWorkOrder" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    UPDATE  RequestLine	
			SET     DateEffective    = #eff#,
			        Quantity         =  '#qty#',
			        Currency         =  '#currency#',
				    Charged          =  '#chg#',
				    Rate             =  '#rte#'							
			WHERE   RequestId        = '#url.requestid#'		
			AND     ServiceItem      = '#form.serviceitemto#'
			AND     ServiceItemUnit  = '#selected#'	
	   </cfquery>	
	   
	</cfif>
	