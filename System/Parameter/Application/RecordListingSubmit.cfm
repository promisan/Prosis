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


<cfif url.action eq "new">

	<cfquery name="Check" 
		     datasource="AppsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
				SELECT *
				FROM   Ref_Application
				WHERE  Code = '#Form.Code#'
				
	</cfquery>
	
	<cfif Check.recordcount gt 0>
		<cfoutput>
			<script>
				alert('There is already a record using #Form.Code# in the database. \nOperation not allowed.');
			</script>
			
			<cfabort>
		</cfoutput>
	</cfif>

	<cfquery name="Check" 
			 datasource="AppsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 	INSERT INTO Ref_Application
					(
						Code,
						Description,
						HostName,
						Owner,
						<cfif Form.Acc neq "">
						OfficerManager,
						</cfif>
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName,
						Created
					)
				VALUES (
					'#Form.Code#',
				    <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">'#evaluate("Form.Description_#client.languageId#")#'<cfelse>''</cfif>,
					'#Form.HostName#',
					'#Form.Owner#',
					<cfif Form.Acc neq "">
					'#Form.Acc#',
					</cfif>
					#Form.Operational#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#',
					getdate()
					)
			 
	</cfquery>
	
	<cf_LanguageInput
	TableCode       		= "Ref_Application" 
	Key1Value       		= "#Form.Code#"
	Mode            		= "Save"
	Name1            		= "Description"
	Operational     		= "1">
	

<cfelse>

	<cfquery name="Update" 
	 datasource="AppsSystem" 
     username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
	 	UPDATE Ref_Application
		SET    Description = <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">'#evaluate("Form.Description_#client.languageId#")#'<cfelse>''</cfif>,
			   HostName    = '#Form.HostName#',
			   Owner       = '#Form.Owner#',
			   <cfif Form.Acc neq "">
			   OfficerManager = '#Form.Acc#',
			   </cfif>
			   Operational   = #Form.Operational#			   
		WHERE  Code = '#Form.Code#'
	 
	</cfquery>
	
	
  	<cf_LanguageInput
	TableCode       		= "Ref_Application" 
	Key1Value       		= "#Form.Code#"
	Mode            		= "Save"
	Name1            		= "Description"
	Operational     		= "1">
	
</cfif>

<cfinclude template="RecordListingDetail.cfm">