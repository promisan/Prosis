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
<cfparam name="Attributes.ValidationCode"   default="">
<cfparam name="Attributes.SystemModule"     default="">
<cfparam name="Attributes.ValidationName"   default="">
<cfparam name="Attributes.ValidationMethod" default="">
<cfparam name="Attributes.ValidationScope"  default="1">

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Validation 
WHERE   ValidationCode = '#attributes.ValidationCode#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Validation
		       (ValidationCode, 
			    SystemModule, 
				ValidationName,
				ValidationMethod, 
				ValidationScope, 
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
		VALUES ('#Attributes.ValidationCode#',
		        '#Attributes.SystemModule#',
				'#Attributes.ValidationName#',
				'#Attributes.ValidationMethod#',
				'#Attributes.ValidationScope#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			   ) 
	</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Validation
		SET    SystemModule         = '#Attributes.SystemModule#', 
		       ValidationName       = '#Attributes.ValidationName#',		  
			   ValidationMethod     = '#Attributes.ValidationMethod#',
			   ValidationScope      = '#Attributes.ValidationScope#'				  
	 	WHERE  ValidationCode = '#Attributes.ValidationCode#'
	</cfquery>	

</cfif>