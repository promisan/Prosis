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

<!--- check role --->

<!---
<cfparam name="Attributes.PositionParentId" default="">
<cfparam name="Attributes.Element"          default="">
<cfparam name="Attributes.ElementNo"        default="">
<cfparam name="Attributes.Observation"      default="">
--->

<cfparam name="Attributes.AuditElement"     default="">
<cfparam name="Attributes.AuditSourceNo"    default="">
<cfparam name="Attributes.AuditSourceId"    default="">
<cfparam name="Attributes.Observation"      default="">


<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO AuditIncumbency
	       (AuditElement,
		    AuditSourceNo, 
			<cfif Attributes.AuditSourceId neq "">
		    AuditSourceId, 
			</cfif>
			Observation) 
	VALUES ('#Attributes.AuditElement#',
			'#Attributes.AuditSourceNo#',
			<cfif Attributes.AuditSourceId neq "">
			'#Attributes.AuditSourceId#',
			</cfif>
	        '#Attributes.Observation#')
</cfquery>
	