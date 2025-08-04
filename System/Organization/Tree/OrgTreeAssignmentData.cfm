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

<!--- ----------------------------- --->
<!--- create assignment information --->
<!--- ----------------------------- --->

<cfparam name="attributes.presentation"   default="detail"> 
<cfparam name="attributes.mode"           default="view"> 
<cfparam name="attributes.tree"           default="operational"> 
<cfparam name="attributes.fund"           default="0"> 
<cfparam name="attributes.postclass"      default=""> 
<cfparam name="attributes.orgunit"        default=""> 
<cfparam name="attributes.mission"        default=""> 
<cfparam name="attributes.selectiondate"  default="01/01/2010"> 

<cfset dateValue = "">
<CF_DateConvert Value="#attributes.selectiondate#">
<cfset seldte = dateValue>

<cfif attributes.mode eq "Table">
   
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_MissionAssignment"> 
</cfif>	

<cfif attributes.presentation eq "detail">

		<cfquery name="qDetails" 
			   DataSource="AppsEmployee">
				   	SELECT  
				     'Used    ' class,
				     p.PostOrder, 
			         p.Mission,		        
			         p.PositionNo,
			         p.SourcePostNumber,
					 p.ApprovalPostGrade,
					 p.PostGrade,
					 p.Fund,
					 p.PositionParentId,
					 p.FunctionDescription,
					 p.OrgUnitOperational,
					 p.OrgUnitAdministrative,
					 '0' AS disableLoan,
			         v.PersonNo,		        
					 v.LastName,
					 v.FirstName,
					 
					 (SELECT TOP 1 Contractlevel 
					    FROM PersonContract C 
						WHERE C.PersonNo = v.PersonNo 
						AND  C.ActionStatus != '9' 
						ORDER BY Created DESC) as ContractGrade,
						
						   (SELECT TOP 1 PostAdjustmentLevel
					    FROM PersonContractAdjustment SPA 
						WHERE SPA.PersonNo = v.PersonNo 
						AND  SPA.ActionStatus != '9' 						
						ORDER BY Created DESC) as PostAdjustmentLevel,
						
						(SELECT       TOP 1 Fund
							FROM      PositionParentFunding AS PF
							WHERE     PositionParentId = p.PositionParentId AND (DateEffective <= #seldte#)
							ORDER BY DateEffective DESC) PositionParentFund,
					
						 <cfif attributes.tree eq "Administrative">
						 	
						 (SELECT TOP 1 OrgUnitNameShort   
						    FROM Organization.dbo.Organization A 
							WHERE A.OrgUnit = p.OrgUnitAdministrative ) as OrgUnitAdmin,	
						<cfelse>	 
						 (SELECT TOP 1 OrgUnitNameShort    
						    FROM Organization.dbo.Organization A 
							WHERE A.OrgUnit = p.OrgUnitOperational ) as OrgUnitOpera,	
						 </cfif>	 
											 
						   <!--- select track occurence --->
					       <!--- current mandate --->
							(
							SELECT   count(*)		
							FROM     Vacancy.dbo.Document D INNER JOIN
									 Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo
							WHERE  	 D.Status = '0'
							    AND  D.EntityClass is not NULL
							    AND  DP.PositionNo = v.PositionNo	
							) as TrackCurrent,
											
							<!--- next mandate --->				
							( 
							SELECT   count(*)	
							FROM     Vacancy.dbo.Document D INNER JOIN
					                 Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
					                 Position Post ON DP.PositionNo = Post.SourcePositionNo
							WHERE    D.Status = '0'		
							    AND  D.EntityClass is not NULL	
							    AND  Post.PositionNo = v.PositionNo	 		
							) AS  TrackPrior,				  
					   										
					 v.Incumbency,
					 0 as Blocked
							 
				<cfif attributes.mode eq "Table">				
					INTO userquery.dbo.#SESSION.acc#_MissionAssignment			 				
				</cfif>
										 
				FROM     vwPosition p LEFT OUTER JOIN vwAssignment v ON p.PositionNo = v.PositionNo 
				                   AND v.AssignmentStatus in ('0','1')
								   AND v.DateEffective   <= #seldte#
							   	   AND v.DateExpiration >= #seldte#
								   LEFT OUTER JOIN 
								   Program.dbo.Ref_Fund F ON F.Code=P.Fund
								   
				WHERE    p.DateEffective  <= #seldte#
				AND      p.DateExpiration >= #seldte#	
				
				<cfif attributes.orgunit neq "">
					<cfif attributes.tree neq "Administrative">
						AND      p.OrgUnitOperational    = '#URL.Unit#'		
					<cfelse>
						AND      p.OrgUnitAdministrative = '#URL.Unit#'		
					</cfif>					
				</cfif>
							 
				<cfif attributes.PostClass neq "">
				AND      P.PostClass='#URL.postClass#'
				</cfif>
				
				<cfif attributes.Fund neq "">
				AND      F.FundType='#URL.Fund#'
				</cfif>		
				AND   (P.Mission = '#SESSION.Mission#' OR P.Mission = '#SESSION.MissionAdmin#')

				ORDER BY p.PostOrder, v.Incumbency desc, v.LastName
		</cfquery>	
		
		
		<cfif attributes.mode eq "table">
			<!--- Adding Loaned positions --->
			<cfquery name="qDetails" 
			   DataSource="AppsEmployee">	
					INSERT INTO userquery.dbo.#SESSION.acc#_MissionAssignment 
				   	SELECT  
				    'Borrowed' as class,
				     p.PostOrder, 
			         P.Mission,		        
			         p.PositionNo,
			         p.SourcePostNumber,
					 p.ApprovalPostGrade,
					 p.PostGrade,
					 p.Fund,					 
					 p.PositionParentId,
					 p.FunctionDescription,
					 POS.OrgUnitOperational,
					 PP.OrgUnitAdministrative,
					 POS.DisableLoan,
			         v.PersonNo,		        
					 v.LastName,
					 v.FirstName,
					 
					 (SELECT TOP 1 Contractlevel 
					    FROM  PersonContract C 
						WHERE C.PersonNo = v.PersonNo 
						AND   C.ActionStatus != '9' 
						ORDER BY Created DESC) as ContractGrade,
						
					 (SELECT  TOP 1 PostAdjustmentLevel 
					    FROM  PersonContractAdjustment SPA 
						WHERE SPA.PersonNo = v.PersonNo 
						AND   SPA.ActionStatus != '9' 						
						ORDER BY Created DESC) as PostAdjustmentLevel,
						
					 (SELECT       TOP 1 Fund
						FROM      PositionParentFunding AS PF
						WHERE     PositionParentId = p.PositionParentId AND (DateEffective <= #seldte#)
						ORDER BY DateEffective DESC) PositionParentFund,						
					
						 <cfif attributes.tree eq "Administrative">						 	
						 (SELECT TOP 1 OrgUnitNameShort   
						    FROM Organization.dbo.Organization A 
							WHERE A.OrgUnit = PP.OrgUnitAdministrative ) as OrgUnitAdmin,	
						<cfelse>	
						 
						 (SELECT TOP 1 OrgUnitNameShort    
						    FROM Organization.dbo.Organization A 
							WHERE A.OrgUnit = PP.OrgUnitOperational ) as OrgUnitOpera,	
						 </cfif>	 
											 
						   <!--- select track occurence --->
					       <!--- current mandate --->
						   
							(
							SELECT   count(*)		
							FROM     Vacancy.dbo.Document D INNER JOIN
									 Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo
							WHERE  	 D.Status = '0'
							    AND  D.EntityClass is not NULL
							    AND  DP.PositionNo = v.PositionNo	
							) as TrackCurrent,
											
							<!--- next mandate --->				
							( 
							SELECT   count(*)	
							FROM     Vacancy.dbo.Document D INNER JOIN
					                 Vacancy.dbo.DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
					                 Position Post ON DP.PositionNo = Post.SourcePositionNo
							WHERE    D.Status = '0'		
							    AND  D.EntityClass is not NULL	
							    AND  Post.PositionNo = v.PositionNo	 		
							) AS  TrackPrior,				  
					   										
					
					 v.Incumbency, 0
					 
							 
				FROM     vwPosition p INNER JOIN Position POS ON POS.PositionNo = P.PositionNo 
								INNER JOIN PositionParent PP ON POS.PositionParentId = PP.PositionParentId
 								   LEFT OUTER JOIN vwAssignment v ON p.PositionNo = v.PositionNo 
				                   AND v.AssignmentStatus in ('0','1')
								   AND v.DateEffective   <= #seldte#
							   	   AND v.DateExpiration >= #seldte#
								   LEFT OUTER JOIN 
								   Program.dbo.Ref_Fund F ON F.Code=P.Fund
								   
				WHERE   (POS.OrgUnitOperational != PP.OrgUnitOperational OR P.Mission != PP.Mission)
				AND		P.DateEffective  <= #seldte#
				AND     P.DateExpiration >= #seldte#	
				AND     POS.DisableLoan = '0'
				<cfif attributes.orgunit neq "">
					<cfif attributes.tree neq "Administrative">
						AND      POS.OrgUnitOperational    = '#URL.Unit#'		
					<cfelse>
						AND      POS.OrgUnitAdministrative = '#URL.Unit#'		
					</cfif>					
				</cfif>
							 
				<cfif attributes.PostClass neq "">
				AND      P.PostClass='#URL.postClass#'
				</cfif>
				
				<cfif attributes.Fund neq "">
				AND      F.FundType='#URL.Fund#'
				</cfif>				
				AND   (P.Mission  = '#SESSION.Mission#' OR P.Mission = '#SESSION.MissionAdmin#')
				AND   PP.Mission  = '#SESSION.Mission#'
				AND   POS.Mission = '#SESSION.Mission#'				
				</cfquery>				
			
			<cfquery name="qUpdateStatus" 
			   DataSource="AppsEmployee">				
						UPDATE UserQuery.dbo.#SESSION.acc#_MissionAssignment 
						SET   Class   = 'Loaned'
						FROM UserQuery.dbo.#SESSION.acc#_MissionAssignment MA
						WHERE Class = 'Used'
						      AND Exists (
									SELECT 'X'
									FROM   UserQuery.dbo.#SESSION.acc#_MissionAssignment 
									WHERE  Class          = 'Borrowed'
									AND    PositionNo = MA.PositionNo
								)
						AND   DisableLoan = '0'		
			</cfquery>							
			
			<cfquery name="qUpdateOrigin" 
			   DataSource="AppsEmployee">				
						UPDATE UserQuery.dbo.#SESSION.acc#_MissionAssignment 
						SET 
						<cfif attributes.tree eq "Administrative">
							 OrgUnitAdmin = O.OrgUnitNameShort
						<cfelse>	 
							 OrgUnitOpera = O.OrgUnitNameShort
						</cfif>							
						FROM UserQuery.dbo.#SESSION.acc#_MissionAssignment 
							INNER JOIN UserQuery.dbo.#SESSION.acc#_MissionAssignment MA2
								ON UserQuery.dbo.#SESSION.acc#_MissionAssignment.Class='Loaned' AND MA2.Class='Borrowed' AND UserQuery.dbo.#SESSION.acc#_MissionAssignment.PositionNo= MA2.PositionNo
							INNER JOIN Organization.dbo.Organization O
							<cfif attributes.tree eq "Administrative">
								 ON O.OrgUnit = MA2.OrgUnitAdministrative
							<cfelse>	 
								ON O.OrgUnit = MA2.OrgUnitOperational
							</cfif>	
			</cfquery>							


			<cfquery name="qUpdateBlocked" 
			   DataSource="AppsEmployee">				
						UPDATE UserQuery.dbo.#SESSION.acc#_MissionAssignment 
						SET Blocked = 1
						FROM UserQuery.dbo.#SESSION.acc#_MissionAssignment 
							INNER JOIN UserQuery.dbo.#SESSION.acc#_MissionAssignment MA2
								ON UserQuery.dbo.#SESSION.acc#_MissionAssignment.Incumbency='100' AND MA2.Incumbency='0' AND UserQuery.dbo.#SESSION.acc#_MissionAssignment.PositionNo= MA2.PositionNo
			</cfquery>							
			
			<cfquery name="qUpdateBlocked" 
			   DataSource="AppsEmployee">				
						UPDATE UserQuery.dbo.#SESSION.acc#_MissionAssignment 
						SET Blocked = 2
						FROM UserQuery.dbo.#SESSION.acc#_MissionAssignment 
							INNER JOIN UserQuery.dbo.#SESSION.acc#_MissionAssignment MA2
								ON UserQuery.dbo.#SESSION.acc#_MissionAssignment.Incumbency='0' AND MA2.Incumbency='100' AND UserQuery.dbo.#SESSION.acc#_MissionAssignment.PositionNo= MA2.PositionNo
			</cfquery>							

			
		</cfif>	

<cfelse>

	<cfquery name="qDetails" 
		DataSource="AppsEmployee">
		
		SELECT   P.postOrder,
				 p.PostGrade,
				 p.Fund,
				 p.PositionParentId,
				 Count(1) as total
				 
		<cfif attributes.mode eq "Table">
		INTO Userquery.dbo.#SESSION.acc#_MissionAssignment			 
		</cfif>
						 
		FROM     vwPosition p LEFT OUTER JOIN vwAssignment v ON p.PositionNo = v.PositionNo 
		                   AND v.AssignmentStatus in ('0','1')
						   AND v.DateEffective <= #seldte#
					   	   AND v.DateExpiration >= #seldte# 
						   LEFT OUTER JOIN 
						   Program.dbo.Ref_Fund F ON F.Code=P.Fund
						   
		WHERE    p.DateEffective <= #seldte#
		AND      p.DateExpiration >= #seldte#
		
		
		<cfif attributes.orgunit neq "">
			<cfif attributes.tree neq "Administrative">
				AND      p.OrgUnitOperational    = '#URL.Unit#'		
			<cfelse>
				AND      p.OrgUnitAdministrative = '#URL.Unit#'		
			</cfif>					
		</cfif>
							 
		<cfif attributes.PostClass neq "">
				AND      PostClass='#URL.postClass#'
		</cfif>
				
		<cfif attributes.Fund neq "">
			    AND      F.FundType='#URL.Fund#'
		</cfif>		
				
		GROUP BY p.PostGrade,P.PostOrder,p.Fund
		ORDER BY p.Fund,p.PostOrder
		
	</cfquery>	


</cfif>

<cfif attributes.mode eq "Table">
     <!--- database table --->
<cfelse>
	<CFSET Caller.qDetails = qDetails>
</cfif>	
