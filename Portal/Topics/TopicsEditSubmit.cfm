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
<cfset fld = Evaluate("Form.ConditionField")>
<cfset id  = Evaluate("Form.SystemFunctionId")>

<cftransaction>

	<cfquery name="Delete" 
	    datasource="AppsSystem" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    DELETE 
		FROM   UserModuleCondition
		WHERE  SystemFunctionId = '#id#' 
		AND    Account          = '#SESSION.acc#'
		AND    ConditionField  = '#fld#'
	</cfquery>
	
	<cfloop index="Rec" from="1" to="#Form.Number#">
	  
	   <cfparam name="Form.Value_#Rec#" default="">
	   <cfset value = Evaluate("Form.Value_" & #Rec#)>
	   	   	   
	   <cfif value neq "">
	   	   
	      <cftry>
		  		   
			  <cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO UserModuleCondition
				 (SystemFunctionId,
				  Account,
				  ConditionField, 
				  ConditionValue)
				VALUES
				('#id#', '#SESSION.acc#','#fld#', '#value#')
			  </cfquery>
		 
		  	  <cfcatch></cfcatch>
		  
		  </cftry>
	   
	   </cfif> 
	   
	</cfloop>  

</cftransaction>

<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_ModuleControl 
		WHERE    SystemFunctionId = '#Form.SystemFunctionId#'
</cfquery>


<cfset url.id = Form.SystemFunctionId>	
<cfinclude template="#Searchresult.FunctionPath#/Topic.cfm">

