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
<cfparam name="url.action" default="">
<cfparam name="url.panelType" default="Junta">

<cfquery name="Activity" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   ProgramActivity
	  WHERE  ActivityId = '#url.activityid#'	
</cfquery>

<cfif url.action eq "Insert">

	<cfquery name="Member" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM ProgramActivityPerson
	  WHERE ProgramCode    = '#activity.ProgramCode#'
	  AND   ActivityPeriod = '#Activity.ActivityPeriod#'
	  AND   ActivityId     =  '#url.activityId#'
	  AND   PersonNo       = '#URL.PersonNo#'
	</cfquery>
	
	<cfif Member.recordcount eq "0">

		<cfquery name="Employee" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO ProgramActivityPerson
		
		     (
			 ProgramCode,
			 ActivityPeriod,
			 ActivityId,
			 PersonNo,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName
			 )
		
		VALUES (	
			'#activity.ProgramCode#',
			'#Activity.ActivityPeriod#',
			'#URL.ActivityId#',
			'#URL.PersonNo#',		
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#') 
			
		</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	  DELETE FROM  ProgramActivityPerson
	  WHERE ProgramCode     = '#activity.ProgramCode#'
	  AND   ActivityPeriod  = '#Activity.ActivityPeriod#'
	  AND   ActivityId      =  '#url.activityId#'
	  AND   PersonNo        = '#URL.PersonNo#'
	  
	</cfquery>
	
</cfif>

	<cfquery name="Employee" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	   SELECT DISTINCT F.*, E.*
	   FROM   ProgramActivityPerson F, Employee.dbo.Person E
	   WHERE  ProgramCode    = '#activity.ProgramCode#'
	   AND    ActivityPeriod = '#Activity.ActivityPeriod#'
	   AND    ActivityId     =  '#url.activityId#'
	   AND    F.PersonNo     =  E.PersonNo 
	   
	</cfquery>
	
    <table width="90%" class="navigation_table formpadding" align="center" border="0" cellspacing="0" cellpadding="0">	
			
	    <tr class="linedotted labelmedium">
		   <td></td>
	       <td height="15"><cf_tl id="Index"> </td>
		   <TD height="15"><cf_tl id="Name"></TD>
		   <TD height="15"><cf_tl id="Gender"></TD>
		   <TD height="15"><cf_tl id="Nationality"></TD>
		   <td width="20%" height="15"><cf_tl id="Role"></td>  
		   <td width="2%"></td>   
		   <td width="2%"></td>  
	   </tr>
   
	   <cfif Employee.recordcount eq "0">
	   
		   <tr>
		   <td colspan="7" align="center" class="labelmedium" style="height:40">There are no records to show in this view</td>
		   </tr>
	   
	   </cfif>
	   			   
	   <cfoutput query="Employee">
	      
		   <tr class="navigation_row labelmedium linedotted">
		   
		   	  <td height="20" style="padding-left:3px" width="30">#currentrow#</td>
		      <td width="10%">#IndexNo#</td>
			  <td>#FirstName# #LastName#</td>
			  <td>#Gender#</td>
			  <td>#Nationality#</td>
			  <td>----</td>
			  
			  <td>			
			   	<cf_img icon="edit" navigation="Yes" onclick="javascript:EditPerson('#PersonNo#')">			
			  </td>
			  
			  <td style="padding-top:3px">			  
			  	<cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/programrem/application/program/activityperson/EmployeeListing.cfm?action=delete&ActivityId=#URL.ActivityId#&PersonNo=#PersonNo#','member')">						  
			  </td>
			  
		   </tr> 
	   
			<cfquery name="Param" 
			    datasource="AppsProgram" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT * FROM  Parameter
			</cfquery>
		   
		   <tr>
		   		     			 
			  <td colspan="8" style="padding-top:5px;padding-left:40px;padding-bottom:4px">
			  	  
			  <cf_filelibraryN
					DocumentPath="#Param.DocumentLibrary#"
					SubDirectory="#ProgramCode#" 
					Filter="per#personno#"
					Insert="yes"
					Box="att#personno#"
					loadscript="no"
					Remove="yes"
					Highlight="no"
					Rowheader="no"
					Width="100%"
					Listing="yes">		
			  
			  </td>
		   </tr>
	   
		   <!--- future recorded work drill down 
		   
		   <cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  DISTINCT J.JobNo, J.CaseNo, J.CaseName
				FROM    stJobReviewPanel F INNER JOIN
			            Job J ON F.JobNo = J.JobNo
				WHERE   F.JobNo  !=  '#url.jobno#'
				AND     F.PersonNo = '#PersonNo#'
				AND     J.ActionStatus = 1
		 	</cfquery>
		   
		   <cfloop query="Check">
		   <tr>
		   	<td></td>
		    <td><a href="javascript:ProcQuote('#JobNo#','view')"><cfif CaseNo eq "">#CaseNo#<cfelse>#JobNo#</cfif></a></td> 
			<td>#CaseName#</td>
		   </tr>
		   </cfloop>
		   
		   --->
	       
	   </cfoutput>  
   
   </table>   
	       
<cfset ajaxonload("doHighlight")>   

   