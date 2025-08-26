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
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>SAT CHANGE</proDes>
	<proCom>SAT CHANGE</proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfquery name="Period" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
   	  SELECT    R.*, M.MandateNo, M.DefaultPeriod
	  FROM      Ref_Period R, Organization.dbo.Ref_MissionPeriod M	 
	  WHERE     IncludeListing = 1
	    <!--- added 20/8/2010 --->
	   AND      (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
	   AND      M.Mission = '#URL.Mission#' 
	   AND      R.Period = M.Period
	   ORDER BY DateEffective 
</cfquery>

<cfif Period.recordcount eq "no">

<table width="100%">
	<tr><td align="center" height="40" class="labelit"> <cf_tl id="No Plan Period defined"></td></tr>
</table>

<cfelse>

<cfquery name="Def" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
       SELECT   TOP 1 *
	   FROM     Ref_Period R, Organization.dbo.Ref_MissionPeriod M
	   WHERE    IncludeListing   = 1
	   <!--- added 20/8/2010 --->
	   AND      (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
	   AND      M.Mission = '#URL.Mission#' 
	   AND      R.Period = M.Period
	   ORDER BY M.DefaultPeriod DESC 
</cfquery>
 	 
<cfset man = "#Def.MandateNo#">
<cfset per = "#Def.Period#">
 
<cfif url.period eq "">
	  <cfset URL.Period = "#per#">
</cfif>		

<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>
	
<cfparam name="CLIENT.ProgramMode" default="Maintain">  

<cfset Criteria = ''>

<!--- hold the value selected from the tree nodes --->
<input type="hidden" name="treeselect" id="treeselect">

<table width="100%" height="100%" class="tree formpadding">
  
  <tr><td valign="top" id="treebox">  	
  
    <table width="97%" align="center">
		  
	  <tr><td height="2"></td></tr>
	  
	  <cfquery name="Check" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT *
		  FROM   OrganizationAuthorization
		  WHERE  UserAccount = '#SESSION.acc#'
		  AND    Mission     = '#URL.Mission#'
		  AND    Role IN ('ProgramOfficer','AdminProgram','ProgramManager','ProgramAuditor')
	  </cfquery>
	  
	  <cfquery name="Project" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT top 1 *
		  FROM   Program
		  WHERE  ProgramClass = 'Project'
		  AND    Mission = '#URL.Mission#'
	  </cfquery>
	  
	  <cfif check.recordcount gte "1" or 
	        getAdministrator("*") eq "1">
		  
		  <tr>
			  
		   <td colspan="2" style="padding-left:8px;padding-top:5px"">
		   
		   <table cellspacing="0" cellpadding="0" class="formspacing">
		   
			<cfoutput>
		   
		   	    <input type="hidden" name="Mode" id="Mode" value="#client.ProgramMode#">					
		 			   
			    <cfinvoke component="Service.Access"
					Method="organization"
					Mission="#URL.Mission#"
					Period="#URL.Period#"
					OrgUnit="some"
					Role="ProgramOfficer', 'ProgramManager', 'ProgramAuditor"
					ReturnVariable="ListingAccess">	
				
				<cfif ListingAccess eq "READ" or ListingAccess eq "EDIT" or ListingAccess eq "ALL">
				
				  <tr>
				  	<td>-</td>
					<td id="viewmode1" class="labelmedium"
						style="height:20px;padding-left:4px;cursor: pointer;font-weight:bold" 
				        onclick="document.getElementById('Mode').value='maintain';view('1');updatePeriod(document.getElementById('PeriodSelect').value,document.getElementById('MandateNo').value,'1');refreshListing()">				 									  																	
					  		<cf_tl id="Programs and Projects">																		
				  	    </td>
				 </tr>
				 
				</cfif>
				
				<cfinvoke component="Service.Access"
					Method="organization"
					Mission="#URL.Mission#"
					Period="#URL.Period#"
					OrgUnit="some"
					Role="ContributionOfficer','ContributionManager','ProgramAuditor','ProgramManager"
					ReturnVariable="ListingAccess">	
												  
					
				<cfif (ListingAccess eq "READ" or ListingAccess eq "EDIT"  or ListingAccess eq "ALL") and Parameter.enableDonor eq "1">	 
				
					 <tr>
					   <td>-</td>
					   <td id="viewmode5" class="labelmedium" style="height:20px;padding-left:4px;cursor: pointer;<cfif CLIENT.Programmode eq 'donor'>font-weight:bold</cfif>"
					   onclick="document.getElementById('Mode').value='donor';view('5');updateDonor()">						   
						  		<cf_tl id="Donor Contributions">					
							</font>	
					  </td>
					 </tr> 
								
				</cfif>										  
													  
				<cfif Parameter.enableGANTT eq "1" and project.recordcount eq "1">
				
				   <tr>
				   <td>-</td>
				   <td id="viewmode2" class="labelmedium" style="height:20px;padding-left:4px;cursor: pointer;<cfif CLIENT.Programmode eq 'Progress'>font-weight:bold</cfif>"
				      onclick="document.getElementById('Mode').value='progress';view('2');updatePeriod(document.getElementById('PeriodSelect').value,document.getElementById('MandateNo').value,'1');refreshListing();">				      
				  	   		<cf_tl id="Project Activity Progress">						
					   </font>
				  </td>
				  </tr>
				  
				  <!---
				  
				  <tr>
				   <td>-</td>
				   <td id="viewmode2" class="labelmedium" style="height:20px;padding-left:4px;cursor: pointer;<cfif CLIENT.Programmode eq 'Progress'>font-weight:bold</cfif>"
				      onclick="document.getElementById('Mode').value='progress';view('2');updatePeriod(document.getElementById('PeriodSelect').value,document.getElementById('MandateNo').value,'1');refreshListing();">				      
				  	   		<cf_tl id="Categorised Activities">						
					   </font>
				  </td>
				  </tr>
				  
				  --->
				  
				</cfif>  
													
				<cfif Parameter.enableIndicator eq "1">
				
				   <tr>
				   <td>-</td>
				   <td id="viewmode3" class="labelmedium" style="height:20px;padding-left:4px;cursor: pointer;<cfif CLIENT.Programmode eq 'Indicator'>font-weight:bold</cfif>"
				   	 onclick="document.getElementById('Mode').value='indicator';view('3');updatePeriod(document.getElementById('PeriodSelect').value,document.getElementById('MandateNo').value,'1');refreshListing();">				     
						<cf_tl id="Program Indicator Score Card">					
					 </font>	
				  </td>
				  </tr>	
				  
				</cfif>
				
				<cfif Parameter.IndicatorAuditWorkflow eq "1">
				  
				   <tr>
				   <td>-</td>
				   <td id="viewmode4" class="labelmedium" style="height:20px;padding-left:4px;cursor: pointer;<cfif CLIENT.Programmode eq 'Submission'>font-weight:bold</cfif>"
					   onclick="document.getElementById('Mode').value='submission';view('4');updatePeriod(document.getElementById('PeriodSelect').value,document.getElementById('MandateNo').value,'1');refreshListing()">					   
						<cf_tl id="Indicator Measurement Submission">												
				   </td>
				  </tr>	
								  
				</cfif>						  
			 
			  </td></tr>
			</table>
				  
		   </td>
	 </tr>
	 
	 </cfoutput>		  
			  
	 <tr><td class="line" height="1" colspan="2"></td></tr>  
	 
	  <tr><td height="2"></td></tr>
					  
	  <cfelseif Parameter.enableIndicator eq "1">	  
		  	<input type="hidden" name="Mode" id="Mode" value="Indicator"> 		
	  <cfelseif Parameter.enableGANTT eq "1">		  
		    <input type="hidden" name="Mode" id="Mode" value="Progress"> 	  
	  </cfif>
	  
	  <tr>
        <td colspan="2" style="padding-top:4px;padding-left:0px" id="filtercontent">		
			<cfinclude template="ProgramViewTreeFilter.cfm">		
		</td>
	  </tr>	  
	  
	   
	  
	  <tr>
        <td colspan="2" style="padding-left:10px" id="reviewcontent">				    
			<cfinclude template="ProgramViewTreeCycle.cfm">		
		</td>
	  </tr>			   
	  	 	  	 
      <tr>
        <td colspan="2" style="padding-top:4px;padding-left:9px" id="treecontent"> 	
			<cfinclude template="ProgramViewTreeContent.cfm">
		</td>
	  </tr>
	  	  
	  <tr>
        <td height="1" style="padding-top:3px" colspan="2" class="line"></td>
      </tr>
	
  
    </table></td>
	
  </tr>
     	  
</table>

</cfif>
 
