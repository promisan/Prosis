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

<!--- init --->

<cfset fld = Evaluate("Form.ConditionField")>
<cfset id = Evaluate("Form.SystemFunctionId")>

<cfparam name="Form.Deleted" default="">
<cfparam name="Form.Selected" default="">

<cfloop index="Rec" list="#Form.Selected#" delimiters=",">

  <cfif Rec eq "I" or Rec eq "D">
  
   <cfset mode = Rec>
  
  <cfelse>
  
      <cfif Mode eq "I">
	  
	    <cfquery name="Select" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * FROM UserModuleCondition
			WHERE SystemFunctionId = '#id#' 
			AND   Account = '#SESSION.acc#'
			AND   ConditionField = 'OrgUnit'
			AND   ConditionValue = '#rec#' 
		  </cfquery>
		  
		  <cfif #Select.Recordcount# eq "0">
  		 
			  <cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModuleCondition
				(SystemFunctionId,Account,ConditionField, ConditionValue)
				VALUES
				('#id#', '#SESSION.acc#','#fld#', '#rec#') 
			  </cfquery>
			  
		  </cfif>	  
				  
	  <cfelse>
	  
		  <cfquery name="Delete" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM UserModuleCondition
			WHERE SystemFunctionId = '#id#' 
			AND   Account = '#SESSION.acc#'
			AND   ConditionField = 'OrgUnit'
			AND   ConditionValue = '#rec#' 
		  </cfquery>
	  
	  </cfif>
	  
	</cfif>  
  
</cfloop>  

<script>
   window.close()
   opener.location.reload()
</script>
  

  
  
  
  
