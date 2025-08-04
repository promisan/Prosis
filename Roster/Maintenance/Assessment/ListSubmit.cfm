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

<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.SkillCode"          default="">
<cfparam name="Form.SkillDescription"   default="">
<cfparam name="Form.ListOrder"          default="">
<cfparam name="Form.Owner"              default="">

<cfif URL.SkillCode neq "new">

	 <cfquery name="Update" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_Assessment
		  SET    Operational         = '#Form.Operational#',
 		         SkillDescription    = '#FORM.SkillDescription#',
				 ListingOrder        = '#Form.ListingOrder#'
		  WHERE  SkillCode           = '#URL.SkillCode#'
		   AND   Owner               = '#URL.Owner#' 		   
		   AND   AssessmentCategory  = '#URL.Code#' 
	</cfquery>
		
	<cfset url.skillcode = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		  FROM  Ref_Assessment 
		 WHERE  SkillCode            = '#Form.SkillCode#'
		   AND  Owner               = '#Form.Owner#' 		   
		   AND  AssessmentCategory  = '#URL.Code#' 
		
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_Assessment
			         (AssessmentCategory,
					 SkillCode,
					 SkillDescription,
					 Owner,					
					 ListingOrder,
					 Operational)
			      VALUES ('#URL.Code#',
				      '#Form.SkillCode#',
					  '#Form.SkillDescription#',
					  '#Form.Owner#',
					  '#Form.ListingOrder#',
			      	  '#Form.Operational#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #Form.SkillCode#/#Form.Owner# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfset url.skillcode = "new">
			   	
</cfif>

<cfoutput>
  <script>
  	ColdFusion.navigate('RecordListingDelete.cfm?code=#url.code#','del_#url.code#')
    ColdFusion.navigate('List.cfm?Code=#URL.Code#&skillcode=#url.skillcode#','#url.code#_list')	
  </script>	
</cfoutput>

