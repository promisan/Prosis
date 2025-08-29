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
<cf_screenTop height="100%" html="No" scroll="yes">

<table width="99%" align="center" border="0"><tr><td style="padding:10px">

<cfinclude template="Header\ViewHeader.cfm">

<cfquery name="ThisProgram"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Program
    WHERE ProgramCode ='#URL.ProgramCode#'
</cfquery>


<cfquery name="ThisPeriod"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM ProgramPeriod
    WHERE ProgramCode ='#URL.ProgramCode#'
	AND Period='#URL.Period#'	
</cfquery>

<cfquery name="Param"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Ref_ParameterMission
    WHERE Mission = '#ThisProgram.Mission#'
</cfquery>

<cfquery name="Parent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.ProgramCode, P.ProgramClass, Pe.PeriodParentCode
    FROM   Program P, ProgramPeriod Pe
	WHERE  P.ProgramCode = Pe.ProgramCode
    AND    P.ProgramCode = '#ThisPeriod.PeriodParentCode#'
	AND    Pe.Period = '#url.period#'
</cfquery>

<!--- Verify Resources --->
<cfquery name="Resource"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ProgramCode
    FROM ProgramAllotmentDetail
    WHERE ProgramCode ='#URL.ProgramCode#'
	AND Period='#URL.Period#'	
</cfquery>

<cfset HasResource = #Resource.RecordCount#>

<!--- verify components only for programs and first level components --->
<cfif #Parent.RecordCount# eq 0 OR (#Parent.RecordCount# eq 1 AND #Parent.ProgramClass# eq 'Program')>

<!--- Verify Component --->
	<cfquery name="Component"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT P.ProgramCode	
	    FROM   Program P Inner Join ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode 
		WHERE  Pe.Period = '#URL.Period#' 
		AND    Pe.RecordStatus != 9
		AND    Pe.PeriodParentCode ='#URL.ProgramCode#'
	</cfquery>

	<cfset HasComponent = #Component.RecordCount#>

<cfelse>

	<cfset HasComponent = 0>

</cfif>

<!--- rest only apply to components and subcomponents --->

<cfset HasActivity = 0>
<cfset HasTarget = 0>

<cfif Parent.RecordCount eq 1 >

<!--- Verify Component --->
	<cfquery name="Activity"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ProgramCode	
		FROM   ProgramActivity 
		WHERE  ProgramCode ='#URL.ProgramCode#'
		AND    ActivityPeriod='#URL.Period#'
		AND    RecordStatus != 9
	</cfquery>

	<cfset HasActivity = Activity.RecordCount>
		
</cfif>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

 <tr>
    <td height="24" class="labelit" align="center">
	  <b><cfoutput>#Program.ProgramClass#</cfoutput> <cf_tl id="checklist"></b>
	</td>
 </tr> 	
 
 <tr><td width="100%" height="1" class="linedotted"></td></tr>
 
</table>
   
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr class="labelit">
    <td width="10%" class="labelit">&nbsp;</td>
    <TD width="60%" class="labelit"><cf_tl id="Topic"></TD>
    <TD width="20%" class="labelit"><cf_tl id="Action"></TD>
	<TD width="10%" class="labelit">&nbsp;</TD>
</tr>

<tr><td height="2"></td></tr>

<cfoutput>


<!--- Verify Category --->
<cfquery name="Category"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ProgramCode
    FROM ProgramCategory
    WHERE ProgramCode ='#URL.ProgramCode#'
</cfquery>

<cfif Category.RecordCount eq 0>
         <tr height="20"  class="labelit">
		 <td>
    		 <img src="#Session.root#/Images/caution.gif" alt="" border="0" align="middle">
		 </td>
		 <td class="regular">
        	<a href="Category/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	        <b>#URL.Layout# <cf_tl id="has NOT been categorised"></b>
            </A>
		 </td>
		 <td class="regular">
		   <a href="Category/CategoryEntry.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	       [<cf_tl id="GOTO">]
		 </td>
         </tr>
<cfelse>
        <tr height="20" class="labelit">
		 <td>
    		 <img src="#Session.root#/Images/check.gif" alt="" border="0" align="middle">
		 </td>
		 <td>
        	<a href="Category/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	        #URL.Layout# <cf_tl id="has been associated to"> <cfoutput><b>#Category.RecordCount#</b></cfoutput> <cfif #Category.RecordCount# eq "1"> <cf_tl id="category"> <cfelse> <cf_tl id="categories"> </cfif>
            </A>
		 </td>
		 <td>
		   <a href="Category/CategoryEntry.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	       [<cf_tl id="VIEW">]
		 </td>
         </tr>
</cfif>		 

<tr><td height="1" colspan="4" class="linedotted"></td></tr>

<cfif Param.enableIndicator eq "1">

<cfquery name="Target"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT ProgramCode	
	    FROM  ProgramIndicator
	    WHERE ProgramCode ='#URL.ProgramCode#'
		AND   Period='#URL.Period#'
		AND   RecordStatus != 9
	</cfquery>
	
	<cfset link = "Indicator">		
		
		<!--- Target --->
		
		<cfif ThisProgram.ProgramClass neq "Project">
		
			<cfif Target.RecordCount eq 0>
			
		         <tr height="20"  class="labelit">
				 <td>
		    		 <img src="#Session.root#/Images/caution.gif" alt="" border="0" align="middle">
				 </td>
				 <TD class="regular">
		        	<a href="#link#/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
					<cfif URL.Layout eq "Component">
			            <b><font color="FF0000"><cf_tl id="Targets or outcome indicators have not been defined"></b>
					<cfelse>
		    			<b><font color="FF0000"><cf_tl id="Program Performance Indicators have NOT been defined"></b>
					</cfif>
		            </A>
				 </TD>
				 <td class="regular">
				   <a href="#link#/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
			       [<cf_tl id="GOTO">]
				 </td>
		         </tr>
					 
			<cfelse>
			
		        <tr height="20"  class="labelit">
				 <td style="padding-left:10px">
		    		 <img src="#Session.root#/Images/check.gif" alt="" border="0" align="middle">
				 </td>
				 <td class="regular">
		        	<a href="#link#/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
			        <cfoutput>#Target.RecordCount# </cfoutput> 
					<cfif URL.Layout eq "Component">
			            <cf_tl id="target/outcome indicators have been identified">
					<cfelse>
		    			<cf_tl id="Program Performance Indicators have been identified">
					</cfif>
		            </A>
				 </td>
				 <td class="regular">
				   <a href="#link#/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
			       [<cf_tl id="VIEW">]
				 </td>
		         </tr>
				 
			</cfif>		 
		
		</cfif>
		

</cfif>			

<cfif Parent.RecordCount eq 1>

<tr><td height=2></td></tr>
    
	<cfquery name="Activity"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT ActivityId	
	    FROM ProgramActivity 
	    WHERE ProgramCode ='#URL.ProgramCode#'
		AND ActivityPeriod='#URL.Period#'
		AND RecordStatus != 9
	</cfquery>

	<cfset HasActivity = Activity.RecordCount>
	
	<cfif Activity.RecordCount eq 0>
         <tr height="20"  class="labelit">
		 <td>
    		 <img src="#Session.root#/Images/caution.gif" alt="" border="0" align="middle">
		 </td>
		 <td>
        	<a href="../Activity/Progress/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	        <b><font color="FF0000"><cf_tl id="Program has no activities defined"></b>
            </A>
		 </td>
		 <td>
		   <a href="../Activity/Progress/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	       [<cf_tl id="GOTO">]
		 </td>
         </tr>
    <cfelse> 

        <cfset st = "1">

        <cfloop query="Activity">

		 <!--- Verify Component --->
			<cfquery name="Output"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT OutputId
			    FROM ProgramActivityOutput
			    WHERE ActivityId = '#Activity.ActivityId#'
			</cfquery>
			
			<cfif Output.recordcount eq "0">
			   <cfset st = "0">
			</cfif>
	
     	</cfloop>
				
        <tr height="20" class="labelit">
		 <td>
		    <cfif st eq "1">
    		 <img src="#Session.root#/Images/check.gif" alt="" border="0" align="middle">
			<cfelse>
			 <img src="#Session.root#/Images/caution.gif" alt="" border="0" align="middle"> 
			</cfif> 
		 </td>
		 
		 <cfif ThisProgram.ProgramClass neq "Project">
		 <td>
        	<a href="Activity/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	        <cfoutput><b>#Activity.RecordCount#</b></cfoutput> 
			<cfif Activity.RecordCount eq "1"> 
				<cf_tl id="activity has"> 
			<cfelse>
				<cf_tl id="activities have">
			</cfif>
				<cf_tl id="been defined">.
			<cfif st eq "0">, <cf_tl id="however one or more activities do not have outputs defined"></cfif>
            </A>
		 </td>
		 <td class="regular">
		   <a href="Activity/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	       [<cf_tl id="VIEW">]
		 </td>
		 <cfelse>
		 
		 <td class="regular">
        	<a href="ActivityProject/ActivityChart.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#&Size=Small">
	        <cfoutput>#Activity.RecordCount#</cfoutput> 
			<cfif Activity.RecordCount eq "1">
				<cf_tl id="activity has">
			<cfelse>
				<cf_tl id="activities have">
			</cfif>
			<cf_tl id="been defined">.
			<cfif st eq "0">, <cf_tl id="however one or more activities do not have outputs defined"></cfif>
            </A>
		 </td>
		 <td class="regular">
		   <a href="ActivityProject/ActivityChart.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#&Size=Small">
	       [<cf_tl id="VIEW">]
		 </td>
		 
		 </cfif>
		 
         </tr>
     </cfif>		 

<tr><td height="1" colspan="4" class="linedotted"></td></tr>

</cfif>


<!--- Resource --->
<tr height="20" class="labelit">
    <td></td>
    <td>
		<a href="Resource/ResourceView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
		Resources</a>
	</td>
    <TD align="center"><cfif HasResource gt 0> <cf_tl id="YES"> <cfelse> <cf_tl id="NO"> </cfif></TD>
</tr>


<cfif Param.enableBudget eq "1">
				
<tr><td height="1" colspan="4" class="linedotted"></td></tr>

<!--- Verify Allotment --->
<cfquery name="Funding"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     SUM(ProgramAllotmentDetail.Amount) AS Amount
FROM         ProgramAllotmentDetail INNER JOIN
                      Ref_AllotmentEdition ON ProgramAllotmentDetail.EditionId = Ref_AllotmentEdition.EditionId
WHERE   ProgramAllotmentDetail.ProgramCode = '#URL.ProgramCode#' 
AND     Ref_AllotmentEdition.Period = '#URL.Period#'
</cfquery>

<cfset HasFunding = Funding.Amount>

<cf_dialogREMProgram> 

	<cfif HasFunding eq '' or HasFunding eq "0">
	    	
	         <tr  class="labelit" height="20">
			 <td>
	    		 <img src="#Session.root#/Images/caution.gif" alt="" border="0" align="middle">
			 </td>
			 <td class="regular">
	     		 <a href="javascript:AllotmentProgram('#mission#','#ProgramCode#','#period#')">
	        	  <b><cf_tl id="Allotments have NOT been defined"></b>
				 </a> 
			 </td>
			 <td class="labelit">
			   [<cf_tl id="GOTO">]
			 </td>
	         </tr>
	<cfelse>
	
	        <tr  class="labelit" height="30">
			 <td>
	    		 <img src="#Session.root#/Images/check.gif" alt="" border="0" align="middle">
			 </td>
			 <TD class="regular">
	        	<a href="javascript:AllotmentProgram('#mission#','#ProgramCode#','#Period#')">
		        	<cf_tl id="Total amount alloted for this program"> : <b>USD #NumberFormat(HasFunding,"___,___")# </b>
	            </A>
			 </TD>
			 <td class="regular">
	 		    <a href="javascript:AllotmentProgram('#mission#','#ProgramCode#','#period#')">
			    [<cf_tl id="VIEW">]
				</a>
			 </td>
	         </tr>
	
	</cfif>		 

</cfif>

<!---  components only for programs and first level components --->
<cfif Parent.RecordCount eq 0 OR (Parent.RecordCount eq 1 AND Parent.ProgramClass eq 'Program')>

<cfif URL.Layout eq "Program">
	<cfset ComponentType = "components">
<cfelse>
	<cfset ComponentType = "subcomponents">
</cfif>

<cfif HasComponent eq '0'>
    	
         <tr height="20"  class="labelit">
		 <td>
    		 <img src="#Session.root#/Images/caution.gif" alt="" border="0" align="middle">
		 </td>
		 <TD class="regular">
     		 <a href="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
        	  <b> <cf_tl id="No program"> #componentType# <cf_tl id="have been identified"></b>
			 </a> 
		 </TD>
		 <td class="regular">
		   <a href="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
		    [<cf_tl id="GOTO">]
			</a>
		 </td>
         </tr>
<cfelse>

        <tr height="20"  class="labelit">
		 <td>
    		 <img src="#Session.root#/Images/check.gif" alt="" border="0" align="middle">
		 </td>
		 <td class="regular">
        	<a href="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	        #Hascomponent# #componentType# <cf_tl id="have been identified for this program">
            </A>
		 </td>
		 <td class="regular">
 		    <a href="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
		    [<cf_tl id="VIEW">]
			</a>
			
		 </td>
         </tr>

</cfif>		 

</cfif>

</cfoutput>

<tr><td height="2"></td></tr>

</table>

</table>
