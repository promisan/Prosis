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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ExperienceClass
WHERE ExperienceClass  = '#Form.ExperienceClass#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ExperienceClass
				         (
						 	ExperienceClass,
						  	Description,
						  	Parent,
						  	OccupationalGroup,
						  	ListingOrder,
						  	OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						  )
				  VALUES (
				  			'#Form.ExperienceClass#',
						  	'#Description#',
				          	'#Form.Parent#',
						  	<cfif #Form.OccupationalGroup# neq "">
						  		'#Form.OccupationalGroup#',
						  	<cfelse>
						  		NULL,
						  	</cfif>
						  	'#Form.ListingOrder#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
		</cfquery>		  
    </cfif>		
	
	<cf_LanguageInput
		TableCode       = "Ref_ExperienceClass" 
		Mode            = "Save"
		Key1Value       = "#Form.ExperienceClass#"
		Name1           = "Description">		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cftransaction>
	
		<cfquery name="Update" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_ExperienceClass
				SET ExperienceClass   = '#Form.ExperienceClass#',
					Description = '#Form.Description#',
					Parent = '#Form.Parent#',
					ListingOrder = '#Form.ListingOrder#',
					<cfif #Form.OccupationalGroup# neq "">
					OccupationalGroup = '#Form.OccupationalGroup#'
					<cfelse>
					OccupationalGroup = NULL	    
					</cfif>
				WHERE ExperienceClass = '#Form.ExperienceClassOld#'
		</cfquery>
		
		<cfquery name="Update" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 
				FROM	Ref_ExperienceClassOwner
				WHERE	ExperienceClass = '#Form.ExperienceClass#'
		</cfquery>
		
		<cfquery name="qOwners"
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*
				FROM 	Ref_ParameterOwner
				WHERE 	Operational = 1
		</cfquery>
		
		<cfloop query="qOwners">
			<cfif isDefined("Form.owner_#owner#")>
				<cfquery name="qOwners"
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ExperienceClassOwner (
								ExperienceClass,
								Owner,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
						) VALUES (
								'#Form.ExperienceClass#',
								'#owner#',
								'#session.acc#',
								'#session.last#',
								'#session.first#'
							)
				</cfquery>
			</cfif>
		</cfloop>
	
	</cftransaction>

	<cf_LanguageInput
		TableCode       = "Ref_ExperienceClass" 
		Mode            = "Save"
		Key1Value       = "#Form.ExperienceClass#"
		Name1           = "Description">		  

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ExperienceClass
      FROM Ref_Experience
      WHERE ExperienceClass  = '#Form.ExperienceClassOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Experience Class is in use. Operation aborted.")     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Ref_ExperienceClass
				WHERE ExperienceClass = '#FORM.ExperienceClassOld#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
