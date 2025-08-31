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
<cfparam name="Attributes.CustomForm" default="">
<cfparam name="Attributes.ActionInitial" default="0">

<!--- check class --->

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_Action
	WHERE   ActionCode = '#Attributes.Code#'
</cfquery>

<cfquery name="Source" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_ActionSource
	WHERE   ActionSource = '#Attributes.ActionSource#'
</cfquery>

<cfif source.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_ActionSource (ActionSource,Description) 
		VALUES ('#Attributes.ActionSource#','#Attributes.ActionSource#')	    
	</cfquery>

</cfif>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Action
	       (ActionCode,ActionSource,Description,ActionClass,ActionInitial <cfif attributes.customform neq "">,CustomForm</cfif>) 
	VALUES ('#Attributes.Code#',
	        '#Attributes.ActionSource#',
	        '#Attributes.Description#',
			'System',
			'#Attributes.ActionInitial#'
			<cfif attributes.customform neq "">
			,'#Attributes.CustomForm#' </cfif>)
	</cfquery>
	
<cfelse>
		
	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Action
		SET    ActionClass   = 'System', 
		       ActionSource  = '#Attributes.ActionSource#',
		       Description   = '#Attributes.Description#',
			   ActionInitial = '#Attributes.ActionInitial#'
			   <!---
			   <cfif attributes.customform neq "">
			   , CustomForm   = '#Attributes.CustomForm#'
			   </cfif>
			   --->
		WHERE  ActionCode   = '#Attributes.Code#' 
	</cfquery>
	
</cfif>

