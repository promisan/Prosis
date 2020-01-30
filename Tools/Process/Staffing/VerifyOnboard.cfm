
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



