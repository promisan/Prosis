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
<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM Parameter
</cfquery>

<cfparam name="url.verbose" default="">
<cfparam name="url.output"  default="">
<cfparam name="url.attach"  default="1">

<cfparam name="client.verbose" default="#url.verbose#">

<cfif url.verbose eq "">
	<cfset url.verbose = client.verbose>
<cfelse>
    <cfset client.verbose = url.verbose>	
</cfif>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  P.*, 
			O.OrgUnitName as OrganizationName, 
	        Pe.OrgUnit, 
			O.ParentorgUnit,
			O.Mission, 
			O.MandateNo,
			O.OrgUnitCode, 
			Pe.PeriodParentCode,
			Pe.Reference, 
			Pe.ReferenceBudget1,
			Pe.ReferenceBudget2,
			Pe.ReferenceBudget3,
			Pe.ReferenceBudget4,
			Pe.ReferenceBudget5,
			Pe.ReferenceBudget6,
			Pe.Period, 
			Pe.ProgramManager, 
			Pe.PeriodDescription,
			Pe.PeriodProblem,
			Pe.PeriodObjective,
			Pe.PeriodGoal,
			Pe.ProgramId,
			Pe.RecordStatus,
			Pe.Status,
			Pe.RecordStatusDate,
			Pe.RecordStatusOfficer 
	FROM    #CLIENT.LanPrefix#Program P, 
	        Organization.dbo.#CLIENT.LanPrefix#Organization O, 
			#CLIENT.LanPrefix#ProgramPeriod Pe
	WHERE   Pe.OrgUnit       = O.OrgUnit
	AND     P.ProgramCode    = '#URL.ProgramCode#'
	AND     Pe.ProgramCode   = P.ProgramCode
	AND     Pe.Period        = '#URL.Period#'
</cfquery>

<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Program.Mission#'
</cfquery>

<!--- check if period is controlled for this mission --->

<cfquery name="getArea" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT AreaCode
    FROM   ProgramCategory P INNER JOIN Ref_ProgramCategory R ON P.ProgramCategory = R.Code
	WHERE  P.ProgramCode = '#URL.ProgramCode#'								 
	AND    P.Status != '9'
	AND    R.Area != 'Risk' and R.Area != 'Gender Marker'
</cfquery>

<cfset dis = "">

<cfloop query="GetArea">
	
	<cfinvoke component="Service.Process.Program.Category"  
		   method         = "ReferenceTableControl" 
		   Mission        = "#program.mission#"
		   ProgramCode    = "#url.ProgramCode#" 
		   Period         = "#url.period#"
		   AreaCode       = "#areacode#"
		   returnvariable = "control">		
		   
	   <cfif control.deny neq "">	
	       <cfif dis neq "">   	   
			   <cfset dis = "#dis#,#control.deny#">	   
		   <cfelse>
			   <cfset dis = "#control.deny#">	
		   </cfif>
	   </cfif>
	   
</cfloop>	   

<!--- get the relevant values to be shown for this program --->	   

<cfquery name="ProgramCategory" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT R.Description as Category
    FROM   ProgramCategory P INNER JOIN Ref_ProgramCategory R ON P.ProgramCategory = R.Code
	WHERE  P.ProgramCode = '#URL.ProgramCode#'
	
	<cfif dis neq "">
	AND       Code NOT IN (#preservesingleQuotes(dis)#)
	</cfif>
							 
	AND    P.Status != '9'
	AND    R.Area != 'Risk' and R.Area != 'Gender Marker'
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
	WHERE  P.ProgramCode  = Pe.ProgramCode
	AND    P.ProgramCode  = '#Program.PeriodParentCode#'
	AND    Pe.Period      = '#url.period#' 
</cfquery>

<cfinvoke component="Service.Access"
	Method="program"
	ProgramCode="#URL.ProgramCode#"
	Period="#URL.Period#"
	ReturnVariable="ProgramAccess">	

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding formspacing">

	<cfoutput query="Program">
		
	 <tr>
       
        <td id="ref_#programid#" valign="top" class="labelmedium" style="padding-top:3px;padding-left:3px;padding-right:4px">
			
		<cfif Program.RecordStatus eq "1">
		<font color="black">
		<cfelse>
		<font color="red">
		</cfif>		
				
		<cfif ReferenceBudget1 neq "">
		    #ReferenceBudget1#
			<cfif ReferenceBudget2 neq "">
			- #ReferenceBudget2#
			</cfif>
			<cfif ReferenceBudget3 neq "">
			- #ReferenceBudget3#
			</cfif>
			<cfif ReferenceBudget4 neq "">
			- #ReferenceBudget4#
			</cfif>
			<cfif ReferenceBudget5 neq "">
			- #ReferenceBudget5#
			</cfif>
			<cfif ReferenceBudget6 neq "">
			- #ReferenceBudget6#
			</cfif>
			<cfelseif Reference neq "">#Reference#&nbsp;<font size="1">(#ProgramCode#)</font>
			<cfelse>#ProgramCode#</cfif>		
			
			<cf_space spaces="40">
			
		</td>
		
		<td width="90%" style="cursor:pointer" id="nme_#programid#" class="labelmedium" onclick="EditProgram('#programcode#','#period#','#ProgramClass#','Resource')">		
		<cfif Program.RecordStatus eq "1">
		<font color="0080C0">
		<cfelseif Program.RecordStatus eq "8">
		<font color="FF8000"><cf_tl id="Stalled">:
		<cfelse>
		<font color="red">
		<cf_tl id="Deactivated">:</b>
		</cfif>		
		#ProgramName#
		</font>
		</b></td>		
		
		<td class="noprint" align="right" style="padding-right:5px">
				
		<cfif url.output neq "print">				
							
			<cfif url.Verbose eq "0">
				
				<img src="#SESSION.root#/Images/down2.gif" 
					onclick="ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/Header/ComponentViewHeaderContent.cfm?programcode=#url.programcode#&period=#url.period#&verbose=1&attach=#url.attach#','header')"
					align="absmiddle" 
					style="mouse:hand"			
					alt="Expand information" border="0">
			
			<cfelse>
					
				<img src="#SESSION.root#/Images/up2.gif" align="absmiddle" alt="Hide information" border="0"
					onclick="ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/Header/ComponentViewHeaderContent.cfm?programcode=#url.programcode#&period=#url.period#&verbose=0&attach=#url.attach#','header')"
					align="absmiddle" 
					style="mouse:hand">
						
			</cfif>		
		
		</cfif>
		
		</td> 	
			
	</tr>
			 
	 </cfoutput>

<cfif url.Verbose eq "0">

	<!--- nada --->
	
<cfelse>

     <cfoutput query="Program"> 
			 
	 <cfif ProgramClass eq "Project">
	 
		 		  	 
		  <tr class="line">
	        <td height="16" style="padding-left:5px" class="labelit"><!--- <cf_tl id="Class"> ---><cf_tl id="Created">:</td>
	        <td class="labelit" colspan="2" id="nme_#programid#"><!--- <cf_tl id="Project"> --->
			<font color="808080">#officerUserid# #dateformat(created,client.dateformatshow)#</font> <cfif recordstatusOfficer neq "">&nbsp;Last updated: <font color="808080">#recordstatusOfficer# #dateformat(RecordStatusDate,client.dateformatshow)#)</cfif></font>			
			</td>
	      </tr>
		  
		   <cfif Param.EnableObjective eq "1" and len(PeriodProblem) gte "5">
			  
			 
		     <tr class="line">			   
				
				<td height="16" valign="top" style="padding-top:3px;padding-left:5px" class="labelit"><cf_tl id="Analysis">:</td>
				
				<cfif len(PeriodProblem) lte "200">
			    	 <td class="labelit" colspan="2">#PeriodProblem#</td>
				<cfelse>
					<cfset url.field = "PeriodProblem">
				        <td class="labelit" colspan="2" id="#url.field#box">						 
						  <cfinclude template="getProgramText.cfm">											 
						</td>
				</cfif>
				
			</tr>		
							 	 
		  </cfif>
		  
		  <cfif len(PeriodGoal) gte "5">
		  			 	  
		      <tr class="line">
		        <td valign="top" style="padding-top:1px;padding-left:5px;padding-right:10px" class="labelit"><cf_tl id="Summary and Objective">:</td>
				
				<cfif len(PeriodGoal) lte "200">
			        <td class="labelit" colspan="2">#PeriodGoal#</td>
					<cfelse>
					<cfset url.field = "PeriodGoal">
			        <td class="labelit" colspan="2" id="#url.field#box">							 
					  <cfinclude template="getProgramText.cfm">											 
					</td>
			</cfif>
				
		     </tr>
		  
		  </cfif>
		 				 
		  <cfif Param.EnableObjective eq "1" and len(PeriodObjective) gte "5">
			  
			 
		     <tr class="line">			   
				
				<td height="16" valign="top" style="padding-top:3px;padding-left:5px" class="labelit"><cf_tl id="Requirements">:</td>
				
				<cfif len(PeriodObjective) lte "200">
			    	 <td class="labelit" colspan="2">#PeriodObjective#</td>
				<cfelse>
					<cfset url.field = "PeriodObjective">
				        <td class="labelit" colspan="2" id="#url.field#box">						 
						  <cfinclude template="getProgramText.cfm">											 
						</td>
				</cfif>
				
			</tr>		
							 	 
		  </cfif>
	 
	 </cfif>
	 
	 </cfoutput>
	 	 	  
     <tr class="line">
        <td height="16" style="padding-left:5px" class="labelit"><cf_tl id="Expected Outcome">:</td>
		
		<cfif programCategory.recordcount eq "0">
			
			<td class="labelit" colspan="2"><cf_tl id="Not categorized"></b></td>
		
		<cfelse>
		
			<cfSet Cat = "">
			<cfoutput query = "ProgramCategory">
				<cfset Cat = " - " & #Category# & #Cat#>
			</cfoutput>
			<cfset Cat = Mid(Cat,4,100)>
			<cfoutput>
	        <td class="labelit" colspan="2"><b>#Cat#</b></td>
			</cfoutput>
			
		</cfif>
			
    </tr>
				
	<cfoutput query="Program">
		 
    <tr class="line">
        <td height="16" style="padding-left:5px" class="labelit"><cf_tl id="Requesting Unit">:</td>
        <td class="labelit" colspan="2">
		
		<table>
		<tr><td class="labelit"><a href="javascript:viewOrgUnit('#OrgUnit#')">#OrganizationName#</a>
			 
	   <cfset Parent    = ParentOrgUnit>
	   <cfset Mission   = Mission>
	   <cfset MandateNo = MandateNo>
	 	 
	   <cfloop condition="Parent neq ''">
	   	  
		   	<cfquery name="LevelUp" 
	          datasource="AppsOrganization" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	          SELECT * 
	          FROM #CLIENT.LanPrefix#Organization
	          WHERE (OrgUnitCode = '#Parent#')
			    AND Mission   = '#Mission#'
			    AND MandateNo = '#MandateNo#'
		   </cfquery>
		   
		   <cfset Parent = #LevelUp.ParentOrgUnit#>
			
		   <cfloop query="LevelUp">
	      
	           / #OrgUnitName# [#OrgUnitCode#]   	    
		   
		   </cfloop>
	
	   </cfloop>
	   
	   </td>
	   
	   <!--- partners --->
	   
	     	<cfquery name="Partners" 
	          datasource="AppsOrganization" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	          SELECT * 
	          FROM   Program.dbo.ProgramPeriodOrgUnit Pe, #CLIENT.LanPrefix#Organization O
	          WHERE  Pe.OrgUnit = O.OrgUnit 
			  AND    Pe.ProgramCode = '#url.programcode#'
			  AND    Pe.Period = '#url.period#'
		   </cfquery>
		   
		   <cfif partners.recordcount gte "1">
			   <td class="labelit" style="padding-left:10px"><b><cf_tl id="Partner">:</td>
			   <cfloop query="Partners">
				   <td class="labelit" style="padding-left:5px;padding-right:7px">#OrgUnitName#</td>
			   </cfloop>		   
		   </cfif>
		   
		   </tr></table>
	   
	   </td>
      </tr>
	  
	  <cfif ProgramMemo neq "">	  
				 	 	 	 
	     <tr class="line">
	        <td valign="top" style="padding-top:3px;padding-left:5px" height="16" class="labelit"><cf_tl id="Memo">:</td>
	        <td class="labelit" colspan="2">#ProgramMemo#</td>
			
	      </tr>  
	  
	  </cfif>
	  
	  	<cfquery name="Beneficiary" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   R.Description
				FROM     ProgramBeneficiary P, Ref_Beneficiary R
				WHERE    P.Beneficiary = R.Code
				AND      Status = '1'
				AND      ProgramCode = '#URL.ProgramCode#' 
		</cfquery>
			
		<cfif beneficiary.recordcount gte "1">
										
		<tr class="line">
		   <td height="16" style="padding-left:5px" class="labelit"><cf_tl id="Beneficiaries">:</td>
		   <td class="labelit" colspan="2">
		   <cfloop query="Beneficiary">- #Beneficiary.Description#&nbsp;</cfloop>
		   </td>
		</tr>
		
		</cfif>
		
		<cfquery name="Approval" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT   R.Description, 
				         PeR.ReviewId, 
						 R.DateEffective, 
						 R.DateExpiration, 
						 PeR.ActionStatus,
						 S.StatusDescription, 
						 PeR.OfficerUserId, 
						 PeR.OfficerLastName, 
						 PeR.OfficerFirstName, 
						 PeR.Created
				FROM     ProgramPeriodReview PeR INNER JOIN
	                     Ref_ReviewCycle R ON PeR.ReviewCycleId = R.CycleId INNER JOIN
	                     Organization.dbo.Ref_EntityStatus S ON PeR.ActionStatus = S.EntityStatus AND S.EntityCode = 'EntProgramReview'
				WHERE    ProgramCode = '#url.programcode#' and R.Period = '#url.period#'  and Per.Period = '#url.period#'
				AND      R.Operational = 1 and PeR.ActionStatus <= '3'		
				AND      R.EnableMultiple = 0	
			
		</cfquery>		
					
		<cfif approval.recordcount gte "1">
		
		<tr class="line">
		   <td height="16" style="padding-left:5px" class="labelit"><cf_tl id="Review cycles">#url.period#:</td>
		   <td class="labelit" colspan="2">
		   <cfloop query="Approval"> <cfif ActionStatus eq "3"><font color="008000"><cfelse><font color="FF0000"></cfif>#Description# (#statusdescription#)<cfif currentrow neq recordcount>;</cfif>&nbsp;&nbsp;</font></cfloop>
		   </td>
		</tr>
		
		</cfif>		
				
		<cfif url.attach eq "1">
	 			
			<!--- previsously recorded attachments 
			
			<tr><td class="labelit clsNoPrint" colspan="4">
			
				 <cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#ProgramCode#" 
						Box="prior"
						Filter="main"
						Insert="no"
						Remove="no"
						width="100%"
						Highlight="no"
						Listing="yes">
			
			</td></tr>
			
			--->
		    		  
			<tr class="line">
			  <td style="padding-top:4px" class="clsNoPrint" colspan="4">	
			  			  			  
			  	<cfset per = replaceNoCase(url.period,"-","")>
							  
			  	 <cfif ListFind("ALL,EDIT",ProgramAccess) GT 0>		
				 				 
				  	 <cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#ProgramCode#" 
						Filter="#per#"
						Insert="yes"
						Remove="yes"
						width="100%"
						Highlight="no"
						Listing="yes">
					
				 <cfelse>
				 
				   	 <cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#ProgramCode#" 
						Filter="#per#"
						Insert="no"
						Remove="no"
						width="100%"
						Highlight="no"
						Listing="yes">
				 	 
				 </cfif>
				 
				 </td>
				 
			 </tr>
			  		
			<!---				  		  
				  <cfif ProgramAccess eq "ALL">		
				 				 
				  	 <cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#ProgramCode#" 
						Filter="main"
						Insert="no"
						Remove="no"
						width="100%"
						Highlight="no"
						Listing="yes">
					
				 <cfelse>
				 
				   	 <cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#ProgramCode#" 
						Filter="main"
						Insert="no"
						Remove="no"
						width="100%"
						Highlight="no"
						Listing="yes">
				 	 
				 </cfif>
				 
			--->
				 
		</cfif>
		 	 	  
	  </cfoutput>	  
	  
   </cfif>
	   
   </table>