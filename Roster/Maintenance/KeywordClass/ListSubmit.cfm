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
<cfparam name="Form.Status"               default="0">
<cfparam name="Form.ExperienceFieldId"    default="">
<cfparam name="Form.Description"          default="">
<cfparam name="Form.ListingOrder"         default="">
<cfparam name="Form.ListDefault"    default="0">

<cfif URL.ID2 neq "">

	 <cfquery name="Update" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_Experience
		  SET    Status              = '#Form.Status#',
 		         Description         = '#Form.Description#',
				 ListingOrder        = '#Form.ListingOrder#'
		 WHERE ExperienceFieldId = '#URL.id2#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       = "Ref_Experience" 
		Mode            = "Save"
		Key1Value       = "#URL.id2#"
		Name1           = "Description">		
	
	<!---
	<cfif Form.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_TopicList
			  SET    ListDefault = 0
			  WHERE  TopicValueCode <> '#URL.ID2#'
			   AND   Topic = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	--->
	
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_Experience
		 WHERE   ExperienceFieldId = '#Form.ExperienceFieldId#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_Experience
			         (ExperienceFieldId,
					 ExperienceClass,
					 Description,
					 ListingOrder,
					 Status)
			      VALUES ('#Form.ExperienceFieldId#',
				      '#URL.Code#',
					  '#Form.Description#',
					  '#Form.ListingOrder#',
					  '#Form.Status#')
			</cfquery>
			
				<cf_LanguageInput
				TableCode       = "Ref_Experience" 
				Mode            = "Save"
				Key1Value       = "#Form.ExperienceFieldId#"
				Name1           = "Description">		
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #Form.ExperienceFieldId# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfset url.id2 = "">
	
	<!---
	<cfif Form.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_TopicList
			  SET    ListDefault = 0
			  WHERE  TopicValueCode <> '#Form.TopicValueCode#'
			   AND   Topic = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	
	--->
		   	
</cfif>

<cfoutput>
  <script>
    ptoken.navigate('List.cfm?Code=#URL.Code#&ID2=','#url.code#_list')	
  </script>	
</cfoutput>
