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

<!--- refresh Ajex --->

<cfparam name="url.act" default="">
<cfparam name="url.no"  default="">

<cf_tl id="Vacant" var="1">
<cfset tVacant=#lt_text#>

<cfif url.act eq "assignmentdelete">
	
	 <cfquery name="Delete" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE PersonAssignment
		 WHERE  AssignmentNo = '#URL.no#'  
	 </cfquery>

</cfif>

<cfif url.act eq "parentdelete">

	<cfquery name="get" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * FROM Position
		 WHERE  PositionParentId = '#URL.ID#'  
	 </cfquery>
	 
	 <cfloop query="get">

		 <cfquery name="DeletePosition" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 DELETE Position
			 WHERE  PositionNo = '#PositionNo#'  
		 </cfquery>
	 
	 </cfloop>
	
	 <cfquery name="Delete" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE PositionParent
		 WHERE  PositionParentId = '#URL.ID#'  
	 </cfquery>

</cfif>
	
<cfquery name="Maintain" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    PP.OrgUnitOperational as ParentOrgUnit,
          PP.PositionParentid,
          PP.FunctionDescription as ParentFunction, 
		  PP.PostGrade as ParentGrade,
		  PP.DateEffective as ParentEffective,
		  PP.DateExpiration as ParentExpiration,
		  PP.ApprovalReference,
		  PP.PostGrade as ParentPostGrade,
		  PP.PostType as ParentPostType,
          P.*, 
		  Gr.PostOrder,		  
		  NULL as FunctionNoAss,
		  NULL as FunctionDescriptionAss,
		  NULL as AssignmentNo,
		  NULL as PersonNo, 
		  NULL as Incumbency,
		  NULL as AssignmentStart, 
		  NULL as AssignmentEnd,
		  NULL as AssignmentClass,
		  NULL as IndexNo,
		  NULL as LastName,
		  NULL as FirstName,
		  NULL as Nationality,
		  NULL as Gender,
	      NULL as ContractLevel,
		  NULL as ContractStep,
		  NULL as ContractTime,
		  NULL as PostAdjustmentLevel,
		  NULL as PostAdjustmentStep
FROM      PositionParent PP, 
          Position P, 
          Ref_PostGrade Gr
WHERE     PP.PositionParentId = '#URL.ID#' 
AND       PP.PositionParentId = P.PositionParentId 
AND		  P.PostGrade = Gr.PostGrade
AND       P.PositionNo NOT IN (SELECT PositionNo 
                               FROM PersonAssignment
							   WHERE AssignmentStatus IN ('0','1'))  
UNION
SELECT    PP.OrgUnitOperational as ParentOrgUnit,
          PP.PositionParentId,
          PP.FunctionDescription as ParentFunction, 
		  PP.PostGrade as ParentGrade,
		  PP.DateEffective as ParentEffective,
		  PP.DateExpiration as ParentExpiration,
		  PP.ApprovalReference,
		  PP.PostGrade as ParentPostGrade,
		  PP.PostType as ParentPostType,
          P.*, 
		  Gr.PostOrder,
		  A.FunctionNo as FunctionNoAss,
		  A.FunctionDescription as FunctionDescriptionAss,
		  A.AssignmentNo,
		  A.PersonNo, 
		  A.Incumbency,
		  A.DateEffective as AssignmentStart, 
		  A.DateExpiration as AssignmentEnd,
		  A.AssignmentClass,
		  Pers.IndexNo,
		  Pers.LastName,
		  Pers.FirstName,
		  Pers.Nationality,
		  Pers.Gender,
		  
		  (SELECT TOP 1 Contractlevel 
			   FROM PersonContract C 
				WHERE C.PersonNo = Pers.PersonNo 
				AND  C.ActionStatus != '9' 
				<!--- pending --->
				<!--- AND  C.DateEffective < #incumdate# --->
				ORDER BY Created DESC) as ContractLevel,
				
		   (SELECT TOP 1 ContractStep 
			    FROM PersonContract C 
				WHERE C.PersonNo = Pers.PersonNo 
				AND  C.ActionStatus != '9' 
				<!--- pending --->
				<!--- AND  C.DateEffective < #incumdate# --->
				ORDER BY Created DESC) as ContractStep,
				
		  (SELECT  TOP 1 ContractTime 
			    FROM    PersonContract C 
				WHERE   C.PersonNo = P.PersonNo 				
				AND     C.ActionStatus != '9' 
				ORDER BY Created DESC) as ContractTime,	
				
		  (SELECT TOP 1 PostAdjustmentLevel
			   FROM PersonContractAdjustment SPA 
				WHERE SPA.PersonNo = Pers.PersonNo 
				AND  SPA.ActionStatus != '9' 
				<!--- pending --->
				 AND  SPA.DateEffective < #incumdate# 
				 AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
				ORDER BY Created DESC) as PostAdjustmentLevel,
				
		  (SELECT TOP 1 PostAdjustmentStep
			    FROM PersonContractAdjustment SPA 
				WHERE SPA.PersonNo = Pers.PersonNo 
				AND  SPA.ActionStatus != '9' 
				<!--- pending --->
				 AND  SPA.DateEffective < #incumdate# 
				 AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
				ORDER BY Created DESC) as PostAdjustmentStep								  
		 
FROM      PositionParent PP INNER JOIN
          Position P ON PP.PositionParentId = P.PositionParentId INNER JOIN
          Ref_PostGrade Gr ON PP.PostGrade = Gr.PostGrade INNER JOIN
          PersonAssignment A ON P.PositionNo = A.PositionNo INNER JOIN
		  Person Pers ON A.PersonNo = Pers.PersonNo 
WHERE     PP.PositionParentId = '#URL.ID#' AND  A.AssignmentStatus IN ('0','1')		  
ORDER BY  Gr.PostOrder, 
          PP.PositionParentId, 
		  P.PostClass,
		  PP.FunctionDescription,
		  P.PositionNo, 
		  AssignmentClass, 
		  AssignmentStart
	  
</cfquery>

<cfquery name="OrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Organization O
	WHERE OrgUnit     = '#Maintain.ParentOrgUnit#'
</cfquery>

<cfinvoke component="Service.Access"  
          method         = "staffing" 
		  orgunit        = "#OrgUnit.OrgUnit#" 
		  returnvariable = "accessStaffing"> 
		  
<cfinvoke component="Service.Access"  
          method         = "position" 
		  orgunit        = "#OrgUnit.OrgUnit#" 
		  role           = "'HRPosition'"
		  returnvariable = "accessPosition"> 		  

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Mandate
	WHERE Mission     = '#Maintain.Mission#'
	AND   MandateNo   = '#Maintain.MandateNo#'
</cfquery>

<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ParameterMission
		WHERE   Mission   = '#Maintain.Mission#'		
</cfquery>	

<cfoutput query="Maintain" group="PostOrder">
				
		<table width="750" cellspacing="0" cellpadding="0" bgcolor="f4f4f4" class="regular" id="t#row#" class="formpadding">
							
			    <cfinclude template="MandateViewMaintainParent.cfm">
			
				<tr><td height="1" colspan="10" class="line"></td></tr>
						
				<cfoutput group="ParentFunction">
							
				<cfoutput group="PostClass">
				
					<cfif PostClass neq "Valid">
						<tr><td colspan="10">#PostClass#</td></tr>
					</cfif>
					
				<cfset pprior = "01/01/1900">	
				
				<cfset pos = 0>
				<cfoutput group="PositionNo">
								
					<cfset pos = pos + 1>
											
					<cfinclude template="MandateViewMaintainPosition.cfm">	
											
					<cfset vac = "1">
					
					<cfoutput group="AssignmentClass">
					
						<cfset cls = "">
						<cfset prior = "01/01/1900">
						
						<cfif AssignmentClass neq "regular" and AssignmentClass neq "">
						<tr><td bgcolor="white"></td><td colspan="9" bgcolor="CAFFFF">#AssignmentClass#</td></tr>
						</cfif>
						
						<cfoutput>
						    
						    <cfif AssignmentNo neq "">
													
								 <cfinclude template="MandateViewMaintainAssignment.cfm">		
								
							</cfif>
							
						</cfoutput>	
																		
					</cfoutput>
					
										
				</cfoutput>	
				
					<!--- --------------------??????????????????------------ --->
					<!--- 7/7/2014 it is unclear what this is filtering about --->
					<!--- --------------------------------------------------- --->
				
					<cfif param.AssignmentEntryDirect eq "0" and getAdministrator("*") eq "0">
				
						<cfif vac eq "1">
						
							<tr>
							    <td bgcolor="white"></td>
							    <td colspan="7">&nbsp;
								<A HREF ="javascript:AddAssignment('#PositionNo#','#PositionParentId#')">
								<font color="FF0000">#tVacant#</font>
								</a></td>
							</tr>
										
						</cfif>
					
					</cfif>
					
				</cfoutput>						
				</cfoutput>
				<cfif currentrow neq recordcount>
					<tr><td></td><td height="1" bgcolor="d0d0d0" colspan="7"></td></tr>
				</cfif>
									
		</table>
					
</cfoutput>