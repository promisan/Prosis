<!--
    Copyright © 2025 Promisan

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
<cfparam name="datasource" default="AppsMaterials">

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">

		<cfquery name="Parameter" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Materials.dbo.Parameter			
		</cfquery>
							
		<cfset No = Parameter.ItemSerialNo+1>
		<cfif No lt 1000>
		     <cfset No = 1000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Materials.dbo.Parameter
			SET ItemSerialNo = '#No#'
		</cfquery>
		
		<!--- check if number is used --->
		
		<cfquery name="Check" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Materials.dbo.Item
			WHERE  ItemNo = '#No#'					
		</cfquery>
		
		<cfif Check.recordcount eq "1">
		
			<cfquery name="Max" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 ItemNo as Last
			    FROM   Materials.dbo.Item
				ORDER BY CONVERT(bigint, ItemNo) DESC							
			</cfquery>
			
			<cfset No = Max.Last+1>
			
			<cfquery name="Update" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Materials.dbo.Parameter
				SET ItemSerialNo = '#No#'
			</cfquery>			
		
		</cfif>
			
</cflock>
