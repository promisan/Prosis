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
<cfparam name="url.cfmapname" default="gmap">

<cfif url.cfmapname neq "gmap">

	<!--- detail --->
	
	<cfquery name="Address"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
		   
			SELECT    P.PersonNo, 
			          P.IndexNo, 
					  P.LastName, 
					  P.FirstName, 
					  P.Gender, 
					  P.Nationality, 
					  A.Address, 
					  A.AddressCity, 
					  A.AddressPostalCode, 
					  A.Country, 
					  A.EMailAddress, 
					  A.Contact, 
					  A.ContactRelationship, 
					  A.ActionStatus,
					  A.Coordinates,
					  A.AddressId
		    FROM      vwPersonAddress A INNER JOIN
		              Person P ON A.PersonNo = P.PersonNo
			WHERE     A.AddressId = '#url.cfmapname#'
			
	</cfquery>	
	
	
	<cfoutput>
		
		<cfset url.id  = Address.PersonNo>
		<cfset url.id1 = Address.AddressId>
		<cfinclude template = "AddressContactView.cfm">
		<!---
		<cfinclude template = "AddressEditShort.cfm">
		--->
		
	</cfoutput>

<cfelse>

	<font face="calibri" size="2">
		Warden Zone
	</font>
	
</cfif>