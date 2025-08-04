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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="header"        default="0">
<cfparam name="url.output"    default="">
<cfparam name="url.titleedit" default="0">
<cfparam name="url.attach"    default="1">
<cfparam name="URL.Mission"   default="">

<cfif header eq "0">
	<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
	<link href="../../../print.css" rel="stylesheet" type="text/css" media="print">
</cfif>

<cf_dialogmail>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  P.ProgramName,
		P.ProgramCode,
		P.ProgramClass,
		P.ProgramAllotment, 
		P.EnforceAllotmentRequest,
        O.OrgUnitName as OrganizationName, 
        O.OrgUnitName, 
		O.OrgUnitCode, 
		O.ParentOrgUnit,
		O.MandateNo, 
		O.Mission, 
		Pe.PeriodParentCode,
		Pe.PeriodHierarchy,
		Pe.ProgramManager, 
		Pe.OrgUnit, 
		Pe.Reference, 
		Pe.ReferenceBudget1,
		Pe.ReferenceBudget2,
		Pe.ReferenceBudget3,
		Pe.ReferenceBudget4,
		Pe.ReferenceBudget5,
		Pe.ReferenceBudget6,
		Pe.Period, 
		Pe.ProgramId,
		Pe.RecordStatus,
		Pe.Status
FROM    #CLIENT.LanPrefix#Program P, Organization.dbo.#CLIENT.LanPrefix#Organization O, ProgramPeriod Pe
WHERE   Pe.OrgUnit       = O.OrgUnit
AND     P.ProgramCode    = '#URL.ProgramCode#'
AND     Pe.ProgramCode   = P.ProgramCode
AND     Pe.Period        = '#URL.Period#'
</cfquery>

<cfquery name="Param" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_ParameterMission
WHERE   Mission = '#Program.Mission#'
</cfquery>

<cfquery name="ParentProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.ProgramCode, 
	       P.ProgramName, 
		   Pe.PeriodParentCode as ParentCode, 
		   P.ProgramClass
    FROM   #CLIENT.LanPrefix#Program P, ProgramPeriod Pe
	WHERE  P.ProgramCode = Pe.ProgramCode
	AND    P.ProgramCode =  '#Program.PeriodParentCode#'
	AND    Pe.Period = '#url.period#' 
</cfquery>

<cfif Program.ProgramClass eq "Project">

	<cfset text = "Project">

<cfelse>

	<cfset lev = 0>
	<cfset pos = 0>
	<cfloop index="i" from="1" to="3" step="1">
	    <cfset pos = Find(".", "#Program.PeriodHierarchy#" , "#pos#")>
		<cfif pos neq "0">
		 	<cfset lev = lev + 1>
			<cfset pos = pos + 1>
		<cfelse> <cfset pos = "99">	
		</cfif>
	</cfloop>
	
	<cfswitch expression="#lev#">
	  	
		<cfcase value="0"><cfset text = "#Param.TextLevel0#"></cfcase>
		<cfcase value="1"><cfset text = "#Param.TextLevel1#"></cfcase>
		<cfcase value="2"><cfset text = "#Param.TextLevel2#"></cfcase>
		<cfcase value="3"><cfset text = "Program component"></cfcase>
	
	</cfswitch>

</cfif>

<cf_dialogOrganization>
<cf_FileLibraryScript>
			
<!--- get user Authorization level for adding programs --->

<cfinvoke component="Service.AccessGlobal"
    Method="global"
  	Role="AdminProgram"
    ReturnVariable="ManagerAccess">	

 <cfif ManagerAccess is "EDIT" OR ManagerAccess is "ALL">	
	
	<cfset ProgramAccess = "ALL">
	
 <cfelse>
 
	<cfif ParentProgram.ProgramClass neq "Program">
		<cfset TopProgramCode = ParentProgram.ParentCode>
	<cfelse>
		<cfset TopProgramCode = ParentProgram.ProgramCode>
	</cfif>	

	<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"
		ReturnVariable="ProgramAccess">	
		
</cfif>

<table width="99%" align="center">

<tr><td height="1"></td></tr>

<tr>

    <cfoutput>
	 
	<td height="24" class="clsNoPrint">
		
	<cfif url.output eq "">
	<a href="javascript:EditProgram('#ParentProgram.ProgramCode#','#URL.Period#','#ParentProgram.ProgramClass#')">
		<img src="#SESSION.root#/Images/up2.gif" alt="Click here to go to #ParentProgram.ProgramName#" border="0" align="absmiddle">
	</a>
	</cfif>
	</td>
		
	<td style="font-size:16px;padding-left:2px" class="labelmedium2 fixlength" title="#ParentProgram.ProgramName#">
	
		<a href="javascript:EditProgram('#ParentProgram.ProgramCode#','#URL.Period#','#ParentProgram.ProgramClass#')">#ParentProgram.ProgramName#</a>
		
	</td>
	
	</cfoutput>
		
	<!--- Header buttons ---->

	<td align="right" height="26" style="padding-left:10px" class="clsNoPrint">
		
	<table class="formpadding">
	
	<tr>
	
	<!--- option to toggle the budget entry mode Hanno : 20/8/2010 --->
		
	<cfquery name="CheckAllotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     ProgramAllotmentDetail
		WHERE    ProgramCode = '#url.ProgramCode#' 
		AND      Period      = '#url.period#'
		AND      AmountBase > 0
		AND      Status = '1'
	</cfquery>
							 
    <cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"					
		Role           = "'BudgetManager','BudgetOfficer'"
		ReturnVariable = "BudgetAccess">	
			
	<cfif Program.ProgramAllotment eq "1"	
	   and (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL")>

		<td style="padding-right:6px" class="labelmedium"><cf_tl id="Mode"></td>
		<td id="enforcedetail"  class="labelmedium" style="padding-right:6px">	
		
		<cfif CheckAllotment.recordcount eq "0" or Program.EnforceAllotmentRequest eq "1">
		
		<!--- allow for change if no budget exisits or if the mode = detailed to be resrt to default 
		as we ALWAYS allow to revert from enforce to default --->
		
			<cfoutput>
			
				<a href="javascript:ptoken.navigate('#SESSION.root#/ProgramREM/Application/Program/Header/ProgramEditAllotment.cfm?programcode=#program.programcode#','enforcedetail')">		
						
					<cfif Program.EnforceAllotmentRequest eq "1"> <cf_tl id="Enforce Request Details"> <cfelse> <cf_tl id="Default"> </cfif>		
				
				</a>
				
			</cfoutput>
		
		<cfelse>
		
			<font color="gray">				
				<cfif Program.EnforceAllotmentRequest eq "1"> <cf_tl id="Enforce Request Details"> <cfelse> <cf_tl id="Default"> </cfif>		
			</font>
					
		</cfif>
				
		</td>
				
	</cfif>
	
	<td>
	<table width="100%" align="right">
	<tr>
	
	<td class="noprint clsNoPrint" id="recordstatus" style="padding:2px" align="right">
			
	<cfif (ProgramAccess eq "ALL" or ProgramAccess eq "EDIT")>
		
		<cfoutput>
		
			<table class="formspacing"><tr>

			<cf_tl id="Deactivate" var="vDeactivate">

		    <cfif Program.RecordStatus eq "1">
			
				<td>
					<cf_tl id="Stall" var="1">
					<button name="Delete" 
					 style="width:160px;height:27" 
					 value="Deactivate" 
					 class="button10g"
					 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=8&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>		
				</td>
				<cfif CheckAllotment.recordCount eq "0">
					<td>
					<button name="Delete" 
					 style="width:160px;height:27" 
					 value="#vDeactivate#" 
					 class="button10g"
					 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramREM/Application/Program/setProgramStatus.cfm?status=9&programcode=#Program.ProgramCode#&period=#URL.Period#','recordstatus')">#vDeactivate# : #url.period#</button>
					</td> 
				</cfif>	 
			
			<cfelseif Program.RecordStatus eq "8">
			
				<cf_tl id="Reinstate" var="vReinstate">
				<td>
					<button name="Reinstate" 
					 style="width:260px;height:27" 
					 value="#vReinstate#" 
					 class="button10g" 
					 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramREM/Application/Program/setProgramStatus.cfm?status=1&programcode=#Program.ProgramCode#&period=#URL.Period#','recordstatus')">#vReinstate# : #url.period#</button>
				</td>
				
				<cfif CheckAllotment.recordCount eq "0">	 
					<td>
					<button name="Delete" 
						 style="width:160px;height:27" 
						 value="#vDeactivate#" 
						 class="button10g"
						 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramREM/Application/Program/setProgramStatus.cfm?status=9&programcode=#Program.ProgramCode#&period=#URL.Period#','recordstatus')">#vDeactivate# : #url.period#</button>
					</td>	 
				</cfif>	 				
					 
			<cfelse>
				
				<td>		
				<cf_tl id="Reinstate" var="1">
				<button name="Delete" 
				 style="width:160px;height:27" 
				 value="Deactivate" 
				 class="button10g"
				 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=1&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
				</td>
				
				<td>				 
				<cf_tl id="Stall" var="1">
				<button name="Delete" 
				 style="width:160px;height:27" 
				 value="Deactivate" 
				 class="button10g"
				 onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/setProgramStatus.cfm?status=8&programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
				</td> 
			
						
			</cfif>		
			
			</table>	
			
		</cfoutput>
		
	</cfif>
	
	</td>
	
	<cfoutput>
	
	<td class="noprint clsNoPrint" width="10%" style="padding-left:2px;padding:2px" align="right">
	
		<cfif url.titleedit eq "1">
		
			<cfif ProgramAccess eq "ALL" or ProgramAccess eq "EDIT">	
			
				<cfif Program.ProgramClass eq "Project">
						<cf_tl id="Maintain Project title" var="1">
						<button class="button10g" style="width:190;height:27" name="Edit" onClick="AddProject('#URL.Mission#','#URL.Period#','#Program.PeriodParentCode#','#Program.OrgUnit#','#Program.ProgramCode#','0','#program.ProgramId#')">#lt_text#</button>
				<cfelse>
						<cf_tl id="Maintain Program title" var="1">
						<button class="button10g" style="width:190;height:27" name="Edit" onClick="AddComponent('#URL.Mission#','#URL.Period#','#Program.PeriodParentCode#','#Program.OrgUnit#','#Program.ProgramCode#','0','#program.ProgramId#')">#lt_text#</button>
				</cfif>
			
			</cfif>
		
		</cfif>
	
	</td>
	
	</cfoutput>
	
	</tr>
	</table>
	</td>
	
	</tr>
	</table>
					
	</td>
  </tr> 	
  
  <tr><td height="1" colspan="3" class="line"></td></tr>
    
  <tr>
    <td width="100%" colspan="3" id="header">
	
	
	<cfparam name="client.verbose" default="">	
	
	<cfif client.verbose eq "">
		<cfset url.verbose = Param.BudgetAllotmentVerbose>
	<cfelse>
	    <cfset url.verbose = client.verbose>	
	</cfif>	
				
	<cfinclude template="ComponentViewHeaderContent.cfm">
			
	</td>
  </tr>
  
  <cfquery name="CheckMission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization.dbo.Ref_EntityMission 
			 WHERE    EntityCode     = 'EntProgram'  
			 AND      Mission        = '#Program.Mission#' 
	</cfquery>
  
  <cfif Program.Status eq "0" and CheckMission.workflowEnabled eq "1" and Program.ProgramClass neq "Program">
  
  	  <cf_ActionListingScript>
      
	  <cfset wflnk = "#session.root#/ProgramREM/Application/Program/Header/ComponentViewWorkFlow.cfm">
	
	  <tr><td width="100%" colspan="3" align="center">
	 	  	
	  <cfoutput>
	 
	 	<input type="hidden"           
			  id="workflowlink_#Program.ProgramId#" 
	          value="#wflnk#"> 
			  
		 <input type="button" class="hide"
		     name  = "workflowlinkprocess_#Program.ProgramId#"
             id    ="workflowlinkprocess_#Program.ProgramId#"
		     onClick= "ColdFusion.navigate('#client.root#/programREM/Application/Program/Header/getStatus.cfm?id=#Program.ProgramId#','process')">	  
			  
	 
	    <cfdiv id="#program.ProgramId#"  bind="url:#wflnk#?ajaxid=#Program.ProgramId#"/>
		
	  </cfoutput>	
	  
	  </td>
	  </tr> 
	  
	  <tr class="xhide"><td id="process"></td></tr>
  
   </cfif> 
	    
 </table>	
 
