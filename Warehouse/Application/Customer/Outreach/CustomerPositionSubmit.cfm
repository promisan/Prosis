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
<cfparam name="url.action" default="insert">

<cfquery name="Customer" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT * FROM Customer WHERE CustomerId = '#url.customerid#'
</cfquery>   

<cfset url.mission = customer.mission>

<cfif url.action eq "insert">

<script>ProsisUI.closeWindow('customer')</script>

   <cfset dateValue = "">
   <CF_DateConvert Value="#DateFormat(form.DateEffective,CLIENT.DateFormatShow)#">
   <cfset dte = dateValue>
					
   <cfset dateValue = "">
   <CF_DateConvert Value="#DateFormat(form.DateExpiration,CLIENT.DateFormatShow)#">
   <cfset end = dateValue>
  
		
<cfquery name="Position" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 INSERT INTO CustomerPosition
	 (CustomerId,PositionNo,DateEffective,DateExpiration,Memo,OfficerFirstName,OfficerLastName,OfficerUserId)
	 VALUES
	 ('#url.customerid#','#url.positionno#',#dte#,#end#,'#form.Memo#','#session.first#','#session.last#','#session.acc#')	
</cfquery>

<cfelseif url.action eq "delete">

	<cfquery name="Position" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 DELETE FROM CustomerPosition
	 WHERE CustomerId = '#url.customerid#'
	 and PositionNo = '#url.positionno#'	
</cfquery>

</cfif>

<cfinclude template="CustomerOutreachPosition.cfm">
	