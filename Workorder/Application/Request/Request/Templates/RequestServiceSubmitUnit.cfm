<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	