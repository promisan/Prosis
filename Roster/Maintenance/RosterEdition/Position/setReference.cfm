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
<cfswitch expression="#URL.op#">
	
	<cfcase value="update">
	
		<cfparam name="FORM.GroupReference" default="">
		
	    <cfif FORM.GroupReference neq "">
		
			<!--- get all selected --->	
			
			<cfquery name="getMission"
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_Mission
					WHERE   Mission   = '#url.mission#'											
			</cfquery>
						
			<cfquery name="getSelection"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  PositionNo,Mission,PostGrade 
					FROM    Position
					WHERE   Positionno IN (#preservesinglequotes(FORM.GroupReference)#)		
					AND     Postgrade = '#url.grade#'
					AND     Mission   = '#url.mission#'						
					ORDER BY Mission, PostGrade
			</cfquery>
			
			<cfoutput query="getSelection" group="Mission">
			
				<cfoutput group="PostGrade">
				
					<!--- assign No --->		
					
					<cflock timeout= "2">
					
						<cfquery name="qLast"
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  * 
							FROM    Ref_SubmissionEdition 
							WHERE   SubmissionEdition = '#URL.ID#'				
						</cfquery>
					
						<cfset value = qLast.ReferenceNo + 1>
												
						<cfquery name="qNewONe"
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE  Ref_SubmissionEdition 
							SET     ReferenceNo = '#value#'
							WHERE   SubmissionEdition = '#URL.ID#'				
						</cfquery>				
					
					</cflock>	
					
					<cfif value lt "10">
							<cfset value = "0#value#">
					</cfif>
					
					<cfoutput>	
			
						<cfquery name="qUpdate"
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE Ref_SubmissionEditionPosition 
								SET    Reference         = '#getmission.Missionprefix#/#qlast.editionshort#/#postgrade#/#value#'
								WHERE  SubmissionEdition = '#url.id#'
								AND    PositionNo        = '#positionno#'
						</cfquery>
						
						<script>
						   ptoken.navigate('#session.root#/Roster/Maintenance/RosterEdition/Position/getReference.cfm?id=#url.id#&positionno=#positionno#','reference_#positionno#')		   	
						</script>
										
					</cfoutput>
					
					<cfquery name="getSelection"
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  PositionNo 
							FROM    Position
							WHERE   Positionno IN (#preservesinglequotes(FORM.GroupReference)#)		
							AND     Postgrade = '#url.grade#'
							AND     Mission   = '#url.mission#'													
					</cfquery>
					
					
					<cfquery name="check"
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT * 
								FROM   Ref_SubmissionEditionPosition 
								WHERE  SubmissionEdition = '#url.id#'
								AND    PositionNo  IN (SELECT PositionNo 
								                       FROM   Employee.dbo.Position 
													   WHERE  Mission   = '#url.mission#'
													   AND    PostGrade = '#url.grade#')
								AND    (Reference is NULL or reference = '')
						</cfquery>
						
					<cfif check.recordcount eq "0">
					
					   <script>
						    document.getElementById('apply#PostGrade#').className = "hide"
					   </script>
					   
					</cfif>						
								
				</cfoutput>
						
			</cfoutput>
		
		</cfif>	
		
	</cfcase>
	
	<cfcase value="remove">
	
		<cfquery name="qNewONe"
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE  Ref_SubmissionEdition 
				SET     ReferenceNo = '0'
				WHERE   SubmissionEdition = '#URL.ID#'				
		</cfquery>			
	
		<cfquery name="qDelete"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				UPDATE Ref_SubmissionEditionPosition 
				SET    Reference = ''
				WHERE  SubmissionEdition = '#URL.ID#'
		</cfquery>	
		
		<cfoutput>
				
		<script>
		   // efresh our contentbox which is set to [contentbox3]		  
		   ptoken.navigate('#session.root#/Roster/Maintenance/RosterEdition/Position/PositionListing.cfm?submissionedition=#url.id#','contentbox3')		   
		</script>
		
		</cfoutput>
		
	</cfcase>

</cfswitch>