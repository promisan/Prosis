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
<!---  Name: /Component/Process/Program.cfc
       Description: Program procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Position Support">
	
	<cffunction name="CreatePosition"
             access="public"
             returntype="any"
             displayname="Position">
		
		<cfargument name="EditionId"          type="string" required="true"  default="">	 
		
		<!--- adjustment 14/5 to look at the position parent dates to run into the budget year but only 
		of there is a position which has the expiration date of the date just before the period --->
		 
				
		<cfquery name="Edition" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT  *
		    FROM    Ref_AllotmentEdition
			WHERE   Editionid = '#EditionId#'					  
		</cfquery>
				
		<!--- execution period --->
				
		<cfquery name="Period" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT  *
		    FROM    Ref_Period
			WHERE   Period = '#Edition.period#'					  
		</cfquery>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(Period.DateEffective,CLIENT.DateFormatShow)#">
		<cfset dte = dateValue>
		<cfset dte = dateAdd("d",-1,DTE)>
		
		<!--- if a position is not budgetted yet we can safely clean it first to control its size and content  --->
		
		<cfquery name="Reset" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			DELETE   Ref_AllotmentEditionPosition
			FROM     Ref_AllotmentEditionPosition AS E
			WHERE    EditionId = '#Editionid#' 
			AND      PositionNo NOT IN
                                (SELECT      PositionNo
                                 FROM        ProgramAllotmentRequest
                                 WHERE       EditionId = '#Editionid#' 
						 		 AND         PositionNo = E.PositionNo)
		 </cfquery>						
										
		<!--- add positions --->
				
		<cfquery name="Add" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			
			INSERT INTO Program.dbo.Ref_AllotmentEditionPosition
                        (EditionId, 
						 PositionNo, 
						 PositionParentId,
						 PostGradeBudget, 
						 PostOrderBudget,
						 PostGrade, 
						 OrgUnitOperational, 
						 PostType, 
						 PostClass, 
						 PostAuthorised, 
						 FunctionNo, 
						 FunctionDescription, 						 
                         SourcePostNumber, 
						 Fund)
			SELECT      
			            '#Editionid#', 
			            P.PositionNo, 
						P.PositionParentId,
						G.PostGradeBudget, 
						G.PostOrderBudget,
						P.PostGrade, 
						P.OrgUnitOperational, 
						P.PostType, 
						P.PostClass, 
						P.PostAuthorised, 
						P.FunctionNo, 
                        P.FunctionDescription, 						
						P.SourcePostNumber,						
                        (SELECT   TOP (1) Fund
                         FROM     PositionParentFunding
                         WHERE    PositionParentId = P.PositionParentId 
						 AND      DateEffective <= '#Period.DateEffective#'
                         ORDER BY DateEffective DESC) AS Fund
						 
			FROM         Position AS P INNER JOIN
                         Ref_PostGrade AS G ON P.PostGrade = G.PostGrade INNER JOIN
						 PositionParent AS PP ON P.PositionParentId   = PP.PositionParentId
			AND          P.MissionOperational = '#Edition.Mission#' <!--- better to make this based on the mission --->
			
			AND          PP.DateEffective   <= '#Period.DateEffective#' 
			AND          PP.DateExpiration  >= '#Period.DateEffective#' 	
			AND          P.DateExpiration   >= #dte# 

			<!--- 4/7/2018 we add only positions whose positionparent id does not exist yet to prevent doubles --->								
			
            AND          NOT EXISTS
                             (SELECT       'X' 
                               FROM        Program.dbo.Ref_AllotmentEditionPosition 
                               WHERE       EditionId        = '#Editionid#' 
							   AND         PositionNo       = P.PositionNo)
							   -- AND     PositionNoParentId = P.PositionParentId)
							   
			ORDER BY    G.PostOrderBudget, P.PositionNo
									
		</cfquery>
		
		<!--- this only applies for positions that were already budgetted and are no longer relevant --->
		
		<cfquery name="ResetOperational" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
		    UPDATE Program.dbo.Ref_AllotmentEditionPosition
			SET    Operational = 0
			FROM   Program.dbo.Ref_AllotmentEditionPosition E
			WHERE  Editionid = '#editionid#'
			AND    PositionNo NOT IN (  
			                            SELECT P.PositionNo 
			                            FROM   Position P INNER JOIN
											   PositionParent AS PP ON P.PositionParentId   = PP.PositionParentId
									    WHERE  PositionNo = E.PositionNo 
									    AND    PP.DateEffective  <= '#Period.DateEffective#' 
						     		    AND    PP.DateExpiration >= '#Period.DateEffective#' 
										AND    P.DateExpiration   >= #dte# 
									    AND    P.MissionOperational = '#Edition.Mission#' )			
										
															
		</cfquery>	
				
		<!--- inherit the last values of the position instance in case this was changed for a budgetted position --->
		
		<cfquery name="UpdateExisting" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			UPDATE Program.dbo.Ref_AllotmentEditionPosition
			SET    PostGradeBudget     = A.PostGradeBudget,
			       PostOrderBudget     = A.PostOrderBudget,
				   PostGrade           = A.PostGrade, 
				   -- OrgUnitOperational  = A.OrgUnitOperational, <!--- removed as this can be moved to another unit now within the system --->
				   PostType            = A.PostType, 
				   PostClass           = A.PostClass, 
				   PostAuthorised      = A.PostAuthorised, 
				   FunctionNo          = A.FunctionNo, 
				   FunctionDescription = A.FunctionDescription, 
				   PositionParentId    = A.PositionParentId,
                   SourcePostNumber    = A.SourcePostNumber, 
				   Fund                = A.Fund,
				   Operational         = 1
				   
			FROM  ( SELECT P.PositionNo, 
						   G.PostGradeBudget, 
						   G.PostOrderBudget,
						   P.PostGrade, 
						   P.OrgUnitOperational, 
						   P.PostType, 
						   P.PostClass, 
						   P.PostAuthorised, 
						   P.FunctionNo, 
                           P.FunctionDescription, 
						   P.SourcePostNumber,
						   P.PositionParentId,
	                        (SELECT   TOP (1) Fund
	                         FROM     PositionParentFunding
	                         WHERE    PositionParentId = P.PositionParentId 
							 AND      DateEffective <= '#Period.DateEffective#'
	                         ORDER BY DateEffective DESC) AS Fund
							 
			        FROM    Position AS P INNER JOIN Ref_PostGrade AS G ON P.PostGrade = G.PostGrade INNER JOIN
						    PositionParent AS PP ON P.PositionParentId   = PP.PositionParentId
					WHERE   P.MissionOperational = '#Edition.Mission#' 
					AND     PP.DateEffective     <= '#Period.DateEffective#' 
					AND     PP.DateExpiration    >= '#Period.DateEffective#' 	
					AND     P.DateExpiration   >= #dte# 		
					AND     P.MissionOperational = '#Edition.Mission#' ) as A 
					
					INNER JOIN Program.dbo.Ref_AllotmentEditionPosition E ON E.Editionid = '#editionid#' AND E.PositionNo = A.PositionNo
          
		</cfquery>
						
		<!--- update position budgeted based on the valid instance at this moment --->
		
		<cfquery name="UpdateExisting" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			UPDATE ProgramAllotmentRequest
			SET     Positionno = PP.PositionNo
			FROM    ProgramAllotmentRequest AS R INNER JOIN
                    Ref_AllotmentEditionPosition AS P ON R.EditionId = P.EditionId AND R.PositionNo = P.PositionNo INNER JOIN
                    Ref_AllotmentEditionPosition AS PP ON P.EditionId = PP.EditionId AND P.PositionParentId = PP.PositionParentId
			WHERE   R.EditionId = '#editionid#'
			AND     P.Operational = '0' 
			AND     PP.Operational = '1'
		</cfquery>	
						
		
   </cffunction>
   		
		  		
</cfcomponent>	 