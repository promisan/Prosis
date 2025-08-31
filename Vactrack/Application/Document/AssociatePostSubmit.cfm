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
<cfparam name="Form.Selected" default="">

<!--- remove posts --->

<cftransaction>

<cfset sl = 0>

<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="',">
			   
		<cfquery name="Get" 
		datasource="AppsVacancy" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
			SELECT *
			FROM   Employee.dbo.Position
			WHERE  PositionNo = '#Item#'
		</cfquery>   
		
		<cfif Get.recordcount eq "1">
		 <cfset sl = sl+1>
		</cfif>   
		
</cfloop>	

<!--- check if matching --->

<cfquery name="Check" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   DocumentCandidate
		WHERE  DocumentNo = '#FORM.DocumentNo#'
		AND    Status IN ('2s','3') 
		AND    EntityClass is not NULL		
</cfquery>	
			   
<cfif sl lt check.recordcount>
		
	<cftransaction action = "rollback"/>
	<cfif check.recordcount gt '1'>
		<cf_alert message="Problem, you must select at least #Check.recordcount# positions.">
	<cfelse>
		<cf_alert message="Problem, you must select at least #Check.recordcount# position.">
	</cfif>
	<cfabort>

</cfif>		   

<cfif Form.Selected neq "">

	<cfquery name="Remove" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM DocumentPost 
		WHERE  DocumentNo = '#FORM.DocumentNo#'
		AND    PositionNo NOT IN ( #Form.Selected# )
	</cfquery>

	<!--- define selected items --->
	
	<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="' ,">		  
				   
		
		<cfset val = evaluate("Form.VacantOwner_#item#")>
		<cfif val neq "">
			<CF_DateConvert Value="#val#">
			<cfset dex = dateValue>
		<cfelse>
			<cfset dex = "">
		</cfif>	
			
		<cfquery name="Get" 
		datasource="AppsVacancy" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
			SELECT *
			FROM   Employee.dbo.Position
			WHERE  PositionNo = '#Item#'
		</cfquery>   
		
		<cfquery name="Check" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   DocumentPost 
			WHERE  DocumentNo = '#FORM.DocumentNo#'
			AND   PositionNo = '#Item#'
		</cfquery>
		
		<cfif Check.recordcount eq "0">
			   		   
			<cfquery name="Insert" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO DocumentPost 
			         (DocumentNo, 
					  PositionNo,
					  Postnumber,
					  VacantOwner,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  	VALUES ('#FORM.DocumentNo#', 
			          '#Item#', 
					  '#get.SourcePostNumber#',
					  <cfif dex neq "">
					  #dex#, 
					  <cfelse>
					  NULL,
					  </cfif>
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>		
			
		<cfelse>
		
			<cfquery name="Check" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE DocumentPost 
				<cfif dex neq "">
				SET    VacantOwner = #dex# 
				<cfelse>
				SET    VacantOwner = NULL 
				</cfif>
				WHERE  DocumentNo = '#FORM.DocumentNo#'
				AND   PositionNo = '#Item#'
		     </cfquery>
		
		</cfif>
	
	</cfloop>

</cfif>

</cftransaction>

<!--- close window --->

<script>
{   
parent.parent.history.go()
parent.parent.ProsisUI.closeWindow('myassociate',true)	

}
</script>

