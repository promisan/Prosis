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

<cfparam name="attributes.PositionParentId" default="0">
<cfparam name="attributes.current" default="false">

<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM       PositionParent
WHERE      PositionParentId = '#Attributes.PositionParentId#' 
</cfquery>

<cfset PStr = PositionParent.DateEffective>
<cfset PEnd = PositionParent.DateExpiration>

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       Position
WHERE      PositionParentId = '#Attributes.PositionParentId#'
ORDER BY   DateEffective, PositionNo
</cfquery>

<cfloop query="Position">

	<cfif DateEffective lt PStr>

	   <cf_AuditIncumbencyLog
	    AuditSourceNo    = "#PositionNo#"
		AuditElement     = "Position"
		Observation      = "Position effective date #dateformat(DateEffective,CLIENT.DateFormatShow)# lies before #dateformat(PStr,CLIENT.DateFormatShow)#">
		<!--- write error message --->
	</cfif>
	
	<cfif DateEffective lt PStr and currentrow neq "1">
	   <cf_AuditIncumbencyLog
	    AuditSourceNo    = "#PositionNo#"
		AuditElement     = "Position"
		Observation      = "Period overlaps with prior position that ended #dateformat(PStr-1,CLIENT.DateFormatShow)#.">
		<!--- write error message --->
	</cfif>
	
	<cfif DateExpiration gt PEnd>
	   <cf_AuditIncumbencyLog
	    AuditSourceNo    = "#PositionNo#"
		AuditElement     = "Position"
		Observation      = "Expiration date exceeds Parent Expiration date #dateformat(PEnd,CLIENT.DateFormatShow)#">
		<!--- write error message --->
	</cfif>
	
	<cfset PoStr = DateEffective>
	<cfset AStr = DateEffective>
	<cfset AEnd = DateExpiration>
		
		<cfquery name="Assignment" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      PersonAssignment
			WHERE     PositionNo = '#PositionNo#'
			AND       AssignmentStatus IN ('0','1')
			
			<cfif attributes.current eq "true">
			AND       DateEffective <= getDate() 
			AND       DateExpiration >= getdate()			
			</cfif>
			AND       Incumbency > 0
			ORDER BY  DateEffective
		</cfquery>
		
		<cfloop query="Assignment">
		
				<cfif DateEffective lt PoStr>
					 <cf_AuditIncumbencyLog
						AuditElement     = "Assignment"
						AuditoSourceNo   = "#AssignmentNo#"
						Observation      = "Assignment starts before #dateformat(PoStr,CLIENT.DateFormatShow)#">
				</cfif>
		
				<cfif DateEffective lt AStr and currentrow neq "1" and Incumbency gt 0>
					 <cf_AuditIncumbencyLog
						AuditElement     = "Assignment"
						AuditSourceNo    = "#AssignmentNo#"
						Observation      = "Assignment starts before #dateformat(Astr,CLIENT.DateFormatShow)#">
				</cfif>
			
				<cfif DateExpiration gt AEnd>
					 <cf_AuditIncumbencyLog
						AuditElement     = "Assignment"
						AuditSourceNo    = "#AssignmentNo#"
						Observation      = "Assignment exceeds its Postion expiration date #dateformat(Position.DateExpiration,CLIENT.DateFormatShow)#">
				</cfif>
				
				<cfset Astr = DateAdd("d", 1, DateExpiration)>
				
		</cfloop>
	
	<cfset Pstr = DateAdd("d", 1, DateExpiration)>
	
</cfloop>
 