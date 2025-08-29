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
 	<cfif URL.PublishNo eq "">
		<cfset tbl = "Ref_EntityClassAction">
	<cfelse>
		<cfset tbl = "Ref_EntityActionPublish">
	</cfif>
	
	<cfset spec = Form.ActionSpecification>
				
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE #tbl#
	SET    ActionSpecification  = '#spec#'
	WHERE  ActionCode = '#URL.ActionCode#'
	 <cfif #tbl# eq "Ref_EntityActionPublish">
	       AND ActionPublishNo = '#URL.PublishNo#'
		 <cfelse>
		   AND EntityCode  = '#URL.EntityCode#' 
		   AND EntityClass = '#URL.EntityClass#'  
		 </cfif>
	 </cfquery>
	 
	 <!--- sync for all --->
	 	 
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityClassAction
		SET ActionSpecification  = '#spec#'
		WHERE ActionCode         = '#URL.ActionCode#'
		AND (ActionSpecification is NULL)
	</cfquery>
	
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityActionPublish
		SET ActionSpecification   = '#spec#'
		WHERE ActionCode          = '#URL.ActionCode#'
		AND (ActionSpecification is NULL)
	</cfquery>
	
	
	<cfinclude template="ActionStepMemo.cfm">