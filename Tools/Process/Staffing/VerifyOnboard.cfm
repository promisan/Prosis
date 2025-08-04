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

<!--- limit to relevant set --->

<cfparam name="attributes.Personno" default="">

 <cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     PersonAssignment PA, Position P
		 WHERE    PersonNo = '#attributes.PersonNo#'
		 AND      PA.PositionNo =     P.PositionNo
		 AND      PA.DateEffective    < getdate()
		 AND      PA.DateExpiration   > getDate()
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass  IN (SELECT AssignmentClass 
		                                  FROM   Ref_AssignmentClass 
										  WHERE  Incumbency > 0)
		 AND      PA.AssignmentType   = 'Actual'
		 AND      P.Mission IN (
		                        SELECT Mission 
		                        FROM   Organization.dbo.Ref_MissionModule
			                    WHERE  SystemModule IN ('Staffing','Attendance')
								AND    Mission = P.Mission
								)
		 AND      PA.Incumbency = '100' 
</cfquery>

<cfif OnBoard.recordcount eq "0">
	
	 <!--- wildcard to check on a contract --->
	 
	 <cfquery name="OnBoard" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   TOP 1 *
			 FROM     PersonContract P
			 WHERE    PersonNo = '#attributes.PersonNo#'		
			 AND      ActionStatus IN ('0','1')		
			 AND      Mission IN (
			                      SELECT Mission 
			                      FROM   Organization.dbo.Ref_MissionModule
				                  WHERE  SystemModule IN ('Staffing','Attendance')
								  AND    Mission = P.Mission
								  )
	 </cfquery>
	 
	 <CFSET Caller.mission = OnBoard.Mission>	
	<CFSET Caller.orgunit = 0>	
	 
<cfelse>

<CFSET Caller.mission = OnBoard.Mission>	
<CFSET Caller.orgunit = OnBoard.OrgUnit>		 

</cfif>



