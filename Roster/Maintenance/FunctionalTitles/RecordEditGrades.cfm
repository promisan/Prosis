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
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM        Parameter
</cfquery>
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM FunctionTitle
WHERE FunctionNo= '#URL.ID1#'
</cfquery>

<cfif Get.recordcount eq "0">

<table align="center"><tr><td height="40"><font color="FF0000">Title was removed.</font></td></tr></table>
<cfabort>

</cfif>

<cfquery name="Parent" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM FunctionTitle
WHERE FunctionNo= '#Get.ParentFunctionNo#'
</cfquery>

<cfquery name="Occ"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    OccupationalGroup, Description
	FROM      OccGroup
	WHERE     Status = '1'
	ORDER BY  Description
</cfquery>

<cfquery name="SelectGrade"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    R.*
	FROM      Ref_GradeDeployment R
	WHERE     R.PostGradeBudget IN (SELECT PostGradeBudget FROM Employee.dbo.Ref_PostGradeBudget)
	ORDER BY  Listingorder
</cfquery>

<cfquery name="FunctionClass"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     FunctionClass
	FROM       Ref_FunctionClass
	WHERE      (FunctionClass = '#Get.FunctionClass#' OR Operational = 1)	
	<cfif SESSION.isAdministrator eq "No">
	AND       
	           (
			   
			   	FunctionClass = '#Get.FunctionClass#' OR 
	
		          Owner IN (SELECT ClassParameter
                            FROM   Organization.dbo.OrganizationAuthorization
			                WHERE  Role = 'FunctionAdmin' 
			                AND    UserAccount = '#SESSION.acc#')
				)
						  
	</cfif>		
</cfquery>

<cfquery name="MissionClass"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     GroupListCode as MissionClass
	FROM       Ref_GroupMissionList
	WHERE      GroupCode = 'Size'
</cfquery>

<cfoutput>

<cfform name="formentrygrade">

<input type="Hidden" name="FunctionNoOld" value="#Get.FunctionNo#">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
<tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td height="16"></td></tr>
			
	 <tr>
	   <td colspan="2" valign="top" height="100%">
	   	    
	  <table width="97%"
	       border="0"
	       cellspacing="0"
	       cellpadding="0"
	       align="center">
	  
	  <cfset row = 1>
	  
      <cfloop query="SelectGrade">
	   
	   <cfif row eq 1><tr></cfif> 	  
	      			
			  <cfquery name="check"
              datasource="AppsSelection" 
              username="#SESSION.login#" 
              password="#SESSION.dbpw#">
	          	  SELECT   *, 
				           (SELECT count(*) FROM FunctionTitleGradeProfile WHERE FunctionNo = F.FunctionNo and GradeDeployment = F.GradeDeployment) as Profile
		          FROM     FunctionTitleGrade F
		          WHERE    GradeDeployment = '#SelectGrade.GradeDeployment#'
				  AND      FunctionNo = '#Get.FunctionNo#'
				  AND      Operational = 1
             </cfquery>
			 
		    <td align="left" width="3%" valign="top" bgcolor="<cfif #check.recordcount# neq "0">yellow</cfif>">
		  		  
				<input type="checkbox" 
				   onclick="ColdFusion.navigate('RecordSubmitGrades.cfm?action=save','result','','','POST','formentrygrade')"
				   name="selected" 
				   value="#SelectGrade.GradeDeployment#" <cfif check.recordcount gte "1">checked</cfif>>
						   
			 </td>			
			 
			 <td width="17%" class="labelit" bgcolor="<cfif #check.recordcount# gte "1">yellow</cfif>">#SelectGrade.Description#</td>
			 <td bgcolor="<cfif #check.recordcount# gte "1">yellow</cfif>"><cfif Check.Profile gte "1">*</cfif></td>
			 <!--- check --->
			
			<cfset row = row + 1>
		    <cfif row eq "5">
	          </tr>
	          <cfset row = 1>
    	    </cfif>
	  </cfloop> 
	  </table>
	 	  
	  </td>
	</tr>
	
	<cfquery name="checkJP" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	FunctionTitleGrade
			WHERE  	FunctionNo  = '#URL.ID1#' 
			AND     Operational = 1
	</cfquery>
		
	<tr><td height="3"></td></tr>	
	
	<tr>
		<td id="result" colspan="3" class="labelmedium">
			<table>
				<cfif checkJP.recordCount gt 0>
				<tr><td height="5"></td></tr>
				<TR>
				    <td height="30" style="padding-left:10px" class="labellarge">
					  	<cfoutput>
					   	<img src="#SESSION.root#/images/finger.gif"><a href="javascript:maintain('#URL.ID1#')"><font color="0080FF">Maintain Job Profiles</b></a>
						</cfoutput>
					</td>
				</TR>
				</cfif>
			</table>
		</td>
	</tr>
	
	
</table>	

</td></tr>
		
</table>
	
</CFFORM>

</cfoutput>

