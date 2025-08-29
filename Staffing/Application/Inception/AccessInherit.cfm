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
<!--- ----------- select access for mandate 1 --->

<cfparam name="url.mission"          default="DPA">
<cfparam name="Form.missionTemplate" default="P001">
<cfparam name="Man"                  default="P002">

<cf_assignId>
						
	<cfquery name="Instance" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO UserAuthorizationAction
		        (ProfileActionId, 			 
				 Memo,
				 UserAccount,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		VALUES  ('#rowguid#',
	   			 'Carry over #URL.Mission# #Form.MissionTemplate#',
				 '',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	</cfquery>
	
	<cfloop index="itm" list="Authorization,AuthorizationDeny">
					
		<!--- remove possible existing entries --->
		<cfquery name="Step2" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Organization#itm#
			WHERE       OrgUnit IN (SELECT O.OrgUnit 
									FROM   Organization O 
									WHERE  O.Mission   = '#URL.Mission#' 
									AND    O.MandateNo = '#Man#') 
		</cfquery>
		
		<cfoutput>
		
			<cfsavecontent variable="subtable">
			
			SELECT     newid() as AccessId,
				           A.Mission, 
				           O.OrgUnitCode AS OrgUnitCode, 
						   A.OrgUnit, 
						   A.OrgUnitInherit,
						   A.UserAccount, 
						   Role, 
						   ClassParameter, 
						   GroupParameter,
						   ClassIsAction,
						   AccessLevel,
						   A.Source		
				FROM       Organization O INNER JOIN
				           Organization#itm# A ON O.OrgUnit = A.OrgUnit  <!--- only with orgunit access --->
				WHERE      O.Mission   = '#URL.Mission#' 
				AND        O.MandateNo = '#Form.MissionTemplate#' 
			
			</cfsavecontent>
		
		 </cfoutput>
		
		 <!--- add positive entries and convert the orgunit --->
				
			<cfquery name="Step3" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Organization#itm#
				       (Accessid,
					    Mission, 
					    OrgUnit, 	
						OrgUnitInherit,		
						UserAccount, 
						Role, 
						ClassParameter, 
						GroupParameter,
						ClassIsAction,
						AccessLevel, 
						Source,
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName)
						
				SELECT *
				FROM (		
				SELECT  DISTINCT 
				        AccessId,
						T.Mission, 
						<!--- we can also replace this with MissionorgUnitId --->
						(SELECT   OrgUnit 
						 FROM     Organization O
						 WHERE    T.Mission     = O.Mission 
						 AND      T.OrgUnitCode = O.OrgUnitCode
						 AND      O.MandateNo   = '#Man#') as OrgUnitNew,
						'0' as OrgUnitInherit, 
						T.UserAccount, 
						T.Role, 
						T.ClassParameter, 
						T.GroupParameter,
						T.ClassIsAction,
						T.AccessLevel, 
						T.Source,
						'#SESSION.acc#'   as OfficerUserId, 
						'#SESSION.last#'  as OfficerLastName, 
						'#SESSION.first#' as OfficerFirstName	
						
				FROM    (#preservesingleQuotes(subtable)#) T
				WHERE   T.OrgUnitCode is not NULL
				) as V
				WHERE OrgUnitNew is not NULL
				
				
			</cfquery>
			
			<cfquery name="Log" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO UserAuthorizationActionLog
					        (ProfileActionId, 
							 ActionStatus, 
							 AccessId, 
							 Mission, 
							 OrgUnit, 
							 UserAccount, 
							 Role, 
							 ClassParameter, 
							 GroupParameter, 
							 ClassisAction, 
							 AccessLevel, 
							 Source, 
					         OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName, 
							 Created)								 
							 
					SELECT   '#rowguid#',
							<cfif itm eq "Authorization">								
					         '1',
							 <cfelse>
							 '9',
							 </cfif>
					         AccessId,
							 Mission, 
							 OrgUnit, 
							 UserAccount,
							 Role, 
							 ClassParameter, 
							 GroupParameter, 
							 ClassIsAction, 
					         AccessLevel, 
							 Source, 
							 '#SESSION.acc#', 
						     '#SESSION.last#', 
						     '#SESSION.first#',	
							 getDate()
							 
					FROM    (#preservesingleQuotes(subtable)#) T
				    WHERE   T.OrgUnitCode is not NULL
					
				</cfquery>
				
	</cfloop>

