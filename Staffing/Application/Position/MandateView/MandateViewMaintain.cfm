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
<cf_tl id="Vacant" var="1">
<cfset tVacant=#lt_text#>

<cfset client.lay = "Maintain">

<cfparam name="url.mission" default="Promisan">
<cfparam name="url.mandate" default="P">

<cfif url.id2 eq "">

 <cfset url.id2 = url.mission>
 <cfset url.id3 = url.mandate>

</cfif>

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Mandate
	WHERE   Mission     = '#URL.Mission#'
	AND     MandateNo   = '#URL.ID3#'
</cfquery>

<cfquery name="OrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Organization O
	WHERE  Mission     = '#URL.ID2#'
	AND    MandateNo   = '#URL.ID3#'
	AND    OrgUnitCode = '#URL.ID1#'   	
</cfquery>

<cfinvoke component="Service.Access"  
          method         = "staffing" 
		  mission        = "#orgunit.Mission#"
		  orgunit        = "#OrgUnit.OrgUnit#" 
		  returnvariable = "accessStaffing"> 
		  
<cfinvoke component="Service.Access"  
          method         = "position" 
		  mission        = "#orgunit.Mission#"
		  orgunit        = "#OrgUnit.OrgUnit#" 
		  role           = "'HRPosition'"
		  returnvariable = "accessPosition"> 		  
	
<cfoutput>

<cfoutput>
		<input type="hidden" name="mission" id="mission" value="#URL.Mission#">
		<input type="hidden" name="id"  id="id"          value="#URL.ID#">
		<input type="hidden" name="id1" id="id1"         value="#URL.ID1#">
		<input type="hidden" name="PDF" id="PDF"         value="#URL.PDF#">
</cfoutput>
  
<table width="750" border="0" cellspacing="0" cellpadding="0" class="formpadding">
    
  <tr class="noprint">
  <td>  
  
  <table class="formspacing"><tr>
    
  <cfif accessPosition eq "ALL" or accessPosition eq "EDIT">
  
      <td><input type="button" value="Add Position" style="width:100px" class="button10s" onClick="AddPosition('#URL.ID2#','#URL.ID3#','#OrgUnit.OrgUnit#','','','','#URL.ID1#','','','')"></td>
	  <td><input type="button" value="Add Unit"     style="width:100px" class="button10s" onClick="addOrgUnit('#URL.ID2#','#URL.ID3#','#URL.ID1#','','STMaintain')"></td>
	  
  </cfif>
  
  <td><input type="button" value="Print"   style="width:100px" class="button10s" onClick="window.print()"></td>
  <td><input type="button" value="Refresh" style="width:100px" class="button10s" onClick="history.go()"></td>
  
  <input type="hidden" name="reloadpos">
  
  </tr></table>
   
  </td>
    
  <td align="right">
    
   <select name="layout" id="layout" size="1"  class="regularxl" onChange="reloadForm('1','','#URL.ID3#',this.value,'1',0,'#url.header#')">
	 <cfif URL.ID eq "ORG">
	 <OPTION value="Maintain" <cfif URL.Lay eq "Maintain">selected</cfif>>Maintain
	 </cfif>
     <OPTION value="Listing" <cfif URL.Lay eq "Listing">selected</cfif>>Listing:Basic
	 <option value="Advanced" <cfif URL.Lay eq "Advanced">selected</cfif>>Listing:Extended	 
    </SELECT>
     
  </td>
   
  </tr>
  
  <tr><td height="1" colspan="4" class="linedotted"></td></tr>
 
</table>
 
<table width="100%" align="left" cellspacing="0" cellpadding="0" class="formpadding">  

<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Organization O
	WHERE Mission     = '#URL.ID2#'
	AND   MandateNo   = '#URL.ID3#'
	AND   OrgUnitCode = '#OrgUnit.ParentOrgUnit#'   			
	ORDER BY TreeOrder 
</cfquery>

<cfquery name="ParamMission" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.ID2#'
</cfquery>

<cfloop query="parent">
<tr><td></td>
	<td class="labelmedium">
	<img src="#SESSION.root#/Images/up2.gif" alt="" border="0">&nbsp;
	<a href="MandateViewGeneral.cfm?ID=ORG&ID1=#parent.orgunitcode#&ID2=#URL.ID2#&ID3=#URL.ID3#">
	<font color="0080C0">#OrgUnitName#</font>
	</td>
</tr>
</cfloop>

<tr><td align="center">

</td>
<td width="94%"><table cellspacing="0" cellpadding="0">
    <tr><td class="labelit"><b>#OrgUnit.Mission#</b></td></tr>
	<tr><td class="labelit">#dateformat(mandate.DateEffective,CLIENT.DateFormatShow)# -  #dateformat(mandate.DateExpiration,CLIENT.DateFormatShow)# <b>(#OrgUnit.MandateNo#)</b></td></tr>
	<tr><td class="labelmedium"><a href="javascript:editOrgUnit('#OrgUnit.OrgUnit#')"><font color="0080C0">#OrgUnit.OrgUnitName#</a></b></td></tr>
	</table><b>
</td></tr>

<cfquery name="Child" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Organization O
	WHERE Mission     = '#URL.ID2#'
	AND   MandateNo   = '#URL.ID3#'
	AND   ParentOrgUnit = '#OrgUnit.OrgUnitCode#'   			
	ORDER BY TreeOrder 
</cfquery>

<cfloop query="child">
<cfif currentrow eq "1">
<tr><td></td>
	<td><img src="#SESSION.root#/Images/down2.gif" alt="" border="0"></td>
</tr>
</cfif>

<tr><td></td>
	<td class="labelmedium">
	&nbsp;&nbsp;-&nbsp;&nbsp;
	<a href="MandateViewGeneral.cfm?ID=ORG&ID1=#child.orgunitcode#&ID2=#URL.ID2#&ID3=#URL.ID3#">
	<font color="0080C0">#OrgUnitName#</font>
	</a>	
	</td>
</tr>
</cfloop>

</cfoutput>

	<cfif (AccessStaffing eq "NONE" or AccessStaffing eq "READ") and (AccessPosition eq "NONE" or AccessPosition eq "READ")>
	<tr><td colspan="2" align="center" class="labelit" bgcolor="yellow"><b>I am sorry you have no authorization to access this function</b></td></tr>
	</table>
<cfabort>
</cfif>

<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="Maintain" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

SELECT 	*
FROM	(
			SELECT    <!--- PP.PositionParentid, --->
			          PP.FunctionDescription as ParentFunction, 
					  PP.PostGrade as ParentGrade,
					  PP.DateEffective as ParentEffective,
					  PP.DateExpiration as ParentExpiration,
					  PP.ApprovalReference,
					  PP.PostGrade as ParentPostGrade,
					  PP.PostType as ParentPostType,
			          P.*, 
					  Gr.PostOrder,
					  NULL as AssignmentNo,
					  NULL as PersonNo, 
					  NULL as Incumbency,
					  NULL as AssignmentStart, 
					  NULL as AssignmentEnd,
					  NULL as AssignmentClass,
					  NULL as FunctionNoAss,
					  NULL as FunctionDescriptionAss,
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
					  
			WHERE     PP.OrgUnitOperational = '#OrgUnit.OrgUnit#' 
			AND       PP.PositionParentId = P.PositionParentId 
			AND		  P.PostGrade = Gr.PostGrade
			AND       P.PositionNo NOT IN (SELECT PositionNo 
			                               FROM   PersonAssignment
										   WHERE  PositionNo = P.PositionNo
										   AND    AssignmentStatus IN ('0','1'))  
										   
			
			UNION 
			
			SELECT    <!--- PP.PositionParentId,		   --->
			          PP.FunctionDescription as ParentFunction, 
					  PP.PostGrade           as ParentGrade,
					  PP.DateEffective       as ParentEffective,
					  PP.DateExpiration      as ParentExpiration,
					  PP.ApprovalReference,
					  PP.PostGrade           as ParentPostGrade,
					  PP.PostType            as ParentPostType,
			          P.*, 
					  Gr.PostOrder,
					  A.AssignmentNo,
					  A.PersonNo, 
					  A.Incumbency,
					  A.DateEffective        as AssignmentStart, 
					  A.DateExpiration       as AssignmentEnd,
					  A.AssignmentClass,
					  A.FunctionNo as FunctionNoAss,
					  A.FunctionDescription  as FunctionDescriptionAss,
					  Pers.IndexNo,
					  Pers.LastName,
					  Pers.FirstName,
					  Pers.Nationality,
					  Pers.Gender,
					  
					  <!--- retrieving last contract record for this person latest --->
					  
					  (SELECT TOP 1 Contractlevel 
						   FROM   PersonContract C 
							WHERE C.PersonNo = Pers.PersonNo 
							AND   C.ActionStatus != '9' 
							<!--- pending --->
							<!--- AND  C.DateEffective < #incumdate# --->
							ORDER BY C.Created DESC) as ContractLevel,
							
					  (SELECT TOP 1 ContractStep 
						    FROM  PersonContract C 
							WHERE C.PersonNo = Pers.PersonNo 
							AND   C.ActionStatus != '9' 
							<!--- pending --->
							<!--- AND  C.DateEffective < #incumdate# --->
							ORDER BY C.Created DESC) as ContractStep,		
							
					  (SELECT  TOP 1 ContractTime 
					  	    FROM    PersonContract C 
							WHERE   C.PersonNo = P.PersonNo 							
							AND     C.ActionStatus != '9' 
							ORDER BY Created DESC) as ContractTime,	
							
					  (SELECT TOP 1 PostAdjustmentLevel
						   FROM   PersonContractAdjustment SPA 
							WHERE SPA.PersonNo = Pers.PersonNo 
							AND   SPA.ActionStatus != '9' 
							AND  SPA.DateEffective < #incumdate# 
					        AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
							<!--- pending --->
							<!--- AND  SPA.DateEffective < #incumdate# --->
							ORDER BY SPA.Created DESC) as PostAdjustmentLevel,
							
					  (SELECT TOP 1 PostAdjustmentStep
						    FROM  PersonContractAdjustment SPA 
							WHERE SPA.PersonNo = Pers.PersonNo 
							AND   SPA.ActionStatus != '9' 
							AND  SPA.DateEffective < #incumdate# 
					        AND  (SPA.DateExpiration is NULL or SPA.DateExpiration >= #incumdate#)
							<!--- pending --->
							<!--- AND  SPA.DateEffective < #incumdate# --->
							ORDER BY SPA.Created DESC) as PostAdjustmentStep				  
					
			FROM      PositionParent PP 
			          INNER JOIN Position P ON PP.PositionParentId = P.PositionParentId 
					  INNER JOIN Ref_PostGrade Gr ON PP.PostGrade = Gr.PostGrade 
					  INNER JOIN PersonAssignment A ON P.PositionNo = A.PositionNo 
					  INNER JOIN Person Pers ON A.PersonNo = Pers.PersonNo 
					  
			WHERE     PP.OrgUnitOperational = '#OrgUnit.OrgUnit#' 
			AND       A.AssignmentStatus IN ('0','1')	
			
	) AS Data	
  
ORDER BY  PostOrder, 
          PositionParentId, 
		  PostClass,
		  ParentFunction,
		  PositionNo,		   
		  AssignmentClass, 
		  AssignmentStart
		
</cfquery>

</cftransaction>

<cfif Maintain.recordcount eq "0">

	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" class="labelmedium" style="height:30px"><b>This unit has no authorised positions defined</b></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	</table>
	<cfabort>
	
</cfif>

<tr><td colspan="2">
<table width="750" align="left" cellspacing="0" cellpadding="0">
<cfset main = 0>
<cfset row  = 0>
<cfset dr = "">

<cfoutput query="Maintain" group="PostOrder">

    <tr><td height="4"></td></tr>
	<tr><td height="20" colspan="6" class="labelmedium">&nbsp;&nbsp;
	
	<cfquery name="detail"
	     dbtype="query">
		 SELECT count(PostOrder) as Total 
		 FROM   Maintain
		 WHERE PostOrder = #PostOrder#
	 </cfquery>
	
    <cfset main = main + 1>

	<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
		id="#main#Exp" border="0" class="show" 
		align="absmiddle" style="cursor: pointer;" 
		onClick="show('#main#')">
		
		<img src="#SESSION.root#/Images/icon_collapse.gif" 
		id="#main#Min" alt="" border="0" 
		align="absmiddle" class="hide" style="cursor: pointer;" 
		onClick="show('#main#')">
	
	<b><font color="black">&nbsp;<a href="javascript:show('#main#')">#ParentPostGrade#</b> (#detail.total#)</a></td></tr>
	<tr><td colspan="6" class="linedotted"></td></tr>
	<tr id="g#main#" class="hide"><td height="4"></td></tr>
	   
		<cfoutput group="PositionParentId">
			
		<cfset row = row + 1>
						
		<tr name="g#main#" class="hide">
				
		<input type="hidden" name="row_#PositionParentId#" value="#row#">
		<!--- refreshed the full portion of the parent position in maintenance --->
		<input type="hidden" name="refresh_#PositionParentId#" onclick="refresh('#PositionParentId#','')">
		
		<td id="#PositionParentId#">
									
			<table id="t#row#" width="850" border="0" class="regular" cellspacing="0" cellpadding="0" class="formpadding">
			
				<cfset init = 1>

				<cfinclude template="MandateViewMaintainParent.cfm">
				
				<tr><td height="1" colspan="8" class="line"></td></tr>
							
					<cfoutput group="ParentFunction">
								
					<cfoutput group="PostClass">
					
						<cfif PostClass neq "Valid">
						<tr>
							<td></td><td colspan="7" class="labellarge">#PostClass#</td>					 
						</tr>
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
								<tr>
									<td bgcolor="white"></td>
									<td colspan="7" class="labelmedium" bgcolor="CAFFFF">#AssignmentClass#</td>
								</tr>
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
						
						<cfif paramMission.AssignmentEntryDirect eq "0" and getAdministrator("*") eq "0">
					
							<cfif vac eq "1">
							
								<tr>
								    <td colspan="2"></td>
								    <td colspan="5" class="labellarge">&nbsp;
									<A HREF ="javascript:AddAssignment('#PositionNo#','#PositionParentId#')">
									<font color="FF0000">#tVacant#</font>
									</a></td>
								</tr>
											
							</cfif>
						
						</cfif>
						
					</cfoutput>						
					</cfoutput>
					<cfif currentrow neq recordcount>
						<tr><td></td>
						    <td height="1" class="labelit" colspan="7"></td>
						</tr>
						<tr><td height="10" colspan="7"></td></tr>
					</cfif>
				
			</table>
						
		</td></tr>	
		</cfoutput>
</cfoutput>

</table>
</td></tr>
 
</table>  


