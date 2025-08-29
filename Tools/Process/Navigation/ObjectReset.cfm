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
<cfif URL.Delete eq "0">

		<!--- reset the wizzard --->

		<cfquery name="Update" 
			datasource="#Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE #Object#Section 
			SET    ProcessStatus = 0
		    WHERE  #Object##ObjectId# = '#URL.Id#' 
		</cfquery>
		
		<!--- reset also all the workflow associated to this ePas incl evaluation --->
				
		<cfquery name="Clear" 
			datasource="#Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Organization.dbo.OrganizationObject
			SET    Operational = 0
			WHERE  ObjectKeyValue4 = '#URL.Id#'			
		</cfquery>		
				
<cfelse>

		<cfquery name="Select" 
			datasource="#Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  #URL.Object#
			WHERE #Object##ObjectId# = '#URL.ID#' 
		</cfquery>
		
		<!--- delete the record completely --->	
		
		<cfquery name="Delete" 
			datasource="#Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM #URL.Object#
			WHERE #Object##ObjectId# = '#URL.ID#' 
		</cfquery>
		
		<!--- reset also the workflows associated which will 
		   also remove the related workflow for the eMail --->
				
		<cfquery name="Clear" 
			datasource="#Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Organization.dbo.OrganizationObject			
			WHERE  ObjectKeyValue4 = '#URL.Id#'			
		</cfquery>		

</cfif>

<cfquery name="Parameter" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM    Parameter
</cfquery>

<cfoutput>

	<cfparam name="url.mid" default="">
	
	<script language="JavaScript">
	
		 {
		 	window.location ="#SESSION.root#/#Parameter.TemplateHome#?reload=1&mission=#url.mission#&owner=#url.owner#&Alias=#url.alias#&Object=#url.object#&Code=#URL.Code#&TableName=#TableName#&#Object#Id=#URL.Id#&PersonNo=#CLIENT.PersonNo#&ApplicantNo=#url.id#&section=#url.section#&mid=#url.mid#";
		 }
	
	</script>		
</cfoutput>	