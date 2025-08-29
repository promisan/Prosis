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
<cfparam name="Attributes.Enforce" default="0">
<!--- check role --->

<cfquery name="Check" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Validation
WHERE Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Validation
	       (Code, TriggerGroup, ValidationClass, ValidationContext, Description, MessagePerson, MessageAuditor, Color, ValidationPath, ValidationTemplate, 
                      Remarks, Operational,Enforce)
	VALUES ('#Attributes.Code#',
	         '#Attributes.TriggerGroup#', 
			 '#Attributes.ValidationClass#', 
			 '#Attributes.ValidationContext#', 
			 '#Attributes.Description#', 
			 '#Attributes.MessagePerson#', 
			 '#Attributes.MessageAuditor#', 
			 '#Attributes.Color#', 
			 '#Attributes.ValidationPath#', 
			 '#Attributes.ValidationTemplate#', 
             '#Attributes.Remarks#', 
			 '#Attributes.Enforce#',
			 '#Attributes.Operational#')
	</cfquery>
	
</cfif>
