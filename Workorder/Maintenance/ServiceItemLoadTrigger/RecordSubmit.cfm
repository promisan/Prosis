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

<cfif Form.LoadMode eq "Month">

	<cfset vStart = createDate(Form.year,Form.month, 1)>

	<cfset vEnd = dateAdd("m",1,vStart)>
	<cfset vEnd = dateAdd("d",-1,vEnd)>

<cfelseif Form.LoadMode eq "Period">

	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.SelectionDateStart#">
	<cfset vStart = dateValue>
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.SelectionDateEnd#">
	<cfset vEnd = dateValue>

</cfif>

<cfquery name="Verify" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ServiceItemLoadTrigger
		WHERE	ServiceItem = '#Form.ServiceItem#'
		AND		SelectionDateStart = #vStart#
		AND		SelectionDateEnd = #vEnd#
		AND		LoadScope = '#Form.LoadScope#'
</cfquery>

<cfif Verify.recordCount is 1>

	<script language="JavaScript">
	
		alert("This service item has already been registered with these dates and scope!")
	
	</script>
	
	<cfinclude template="RecordAdd.cfm">  

<cfelse>

	<cfif vStart lte vEnd>

		<cfquery name="Insert" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ServiceItemLoadTrigger
					(
						ServiceItem,
						SelectionDateStart,
						SelectionDateEnd,
						LoadMode,
						LoadScope,
						Memo,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES 
					(
						'#Form.ServiceItem#',
						#vStart#, 
						#vEnd#,
						'#Form.LoadMode#',
						'#Form.LoadScope#',
						'#Form.Memo#',
						'#SESSION.acc#',
						'#SESSION.last#',		  
						'#SESSION.first#'
					)
		</cfquery>
		
		<script language="JavaScript">
		
			window.close()
			opener.location.reload()
		
		</script>  
		
	<cfelse>
	
		<script language="JavaScript">
	
			alert("The end date must be greater or equal than the start date!")
	
		</script>
	
		<cfinclude template="RecordAdd.cfm">  
	
	</cfif>

</cfif>		  
