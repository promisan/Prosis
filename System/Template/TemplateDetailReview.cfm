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
<cfquery name="Template" 
		  datasource="AppsControl" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_TemplateContent
		  WHERE  Templateid  = '#url.templateid#'		 
	</cfquery>
	
<!--- check entry --->

<cfquery name="Check" 
		  datasource="AppsControl" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      SELECT * FROM ParameterSiteVersion
		  WHERE ApplicationServer = '#Template.ApplicationServer#'
		  AND   VersionDate       = '#dateformat(Template.VersionDate,client.dateSQL)#'
</cfquery>	

<cfif check.recordcount eq "0">
	
	<cfquery name="Insert" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO ParameterSiteVersion
		  (ApplicationServer,VersionDate,ActionStatus,OfficerUserId)
		  VALUES
		  ('#Template.ApplicationServer#','#Template.VersionDate#','1','#SESSION.acc#')		
	</cfquery>	

</cfif>

<cfquery name="Check" 
		  datasource="AppsControl" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   SiteVersionReview
		  WHERE  ApplicationServer  = '#Template.ApplicationServer#'		 
		  AND VersionDate = '#Template.VersionDate#'
		  AND PathName = '#Template.PathName#'
		  AND FileName = '#Template.FileName#'
</cfquery>	
	
		
<cfif check.recordcount eq "0">

	<cfquery name="Insert" 
		  datasource="AppsControl" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      INSERT INTO SiteVersionReview
		  (ApplicationServer, 
		   VersionDate, 
		   DestinationServer, 
		   PathName, 
		   FileName, 
		   OfficerUserid, 
		   OfficerLastname, 
		   OfficerFirstname)
		  VALUES
		  ('#Template.ApplicationServer#',
		   '#dateformat(Template.VersionDate,client.datesql)#',
		   '#URL.site#',
		   '#Template.PathName#',
		   '#Template.FileName#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')		
	</cfquery>	
	
	<cfquery name="Check" 
		  datasource="AppsControl" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   SiteVersionReview
		  WHERE  ApplicationServer  = '#Template.ApplicationServer#'		 
		  AND    VersionDate = '#Template.VersionDate#'
		  AND    PathName = '#Template.PathName#'
		  AND    FileName = '#Template.FileName#'
	</cfquery>	

</cfif>
	
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td>
	
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfform name="eval" method="POST">

<tr>
	<td height="35">&nbsp;Template Change Review Status:</td>
	<td width="80%">
	<table cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	<td><input type="radio" name="ActionStatus" id="ActionStatus" value="0" <cfif Check.actionStatus eq "0">checked</cfif>></td>
	<td>Pending</td>
	<td><input type="radio" name="ActionStatus" id="ActionStatus" value="1" <cfif Check.actionStatus eq "1">checked</cfif>></td>
	<td>Re-evaluate</td>
	<td><input type="radio" name="ActionStatus" id="ActionStatus" value="3" <cfif Check.actionStatus eq "3">checked</cfif>></td>
	<td>Cleared</td>
	<td width="200" align="right">Risk Assessment:</td>	
	<td><input type="radio" name="AssessmentRisk" id="AssessmentRisk" value="Low" <cfif Check.AssessmentRisk eq "Low">checked</cfif>></td>
	<td>Low</td>
	<td><input type="radio" name="AssessmentRisk" id="AssessmentRisk" value="Medium" <cfif Check.AssessmentRisk eq "Medium">checked</cfif>></td>
	<td>Medium</td>
	<td><input type="radio" name="AssessmentRisk" id="AssessmentRisk" value="High" <cfif Check.AssessmentRisk eq "High">checked</cfif>></td>
	<td>High</td>
	</tr>
	</table>
	</td>

</tr>

<tr>
	<td height="30">&nbsp;Modification Classification:</td>
	<td>
	<select name="AssessmentClass" id="AssessmentClass">
	<option value="Cosmetic" <cfif Check.AssessmentClass eq "Cosmetic">checked</cfif>>Cosmetic</option>
	<option value="Substantive" <cfif Check.AssessmentClass eq "Substantive">checked</cfif>>Substantive</option>
	</select>		
	</td>
	
</tr>

<tr><td height="3"></td></tr>

<tr><td colspan="2" style="border: 1px solid Silver;">

	<cf_textarea name="AssessmentNotes"                 
           toolbaronfocus = "No"
           bindonload     = "No" 			 
		   tooltip        = "Summary/Assessment"   			 			 				          
           richtext       = "Yes"             
           toolbar        = "Basic"
           skin           = "Silver">	
		   
		   <cfoutput>#check.AssessmentNotes#</cfoutput>					
		
	 </cf_textarea>

</td></tr>

<cfoutput>
	
	<tr><td colspan="2" height="32" align="center">
	
	<input type="button" 
	    name="Save" 
		id="Save"
		value="Save" 
		class="button10s" style="width:150"
		onclick="ColdFusion.navigate('TemplateDetailReviewSubmit.cfm?templateid=#url.templateid#&reviewid=#check.reviewid#','resultsave','','','POST','eval')">
		
	<input type="button" name="Close" id="Close" value="Return" style="width:150" class="button10s" onclick="ColdFusion.navigate('TemplateDetailReviewSubmit.cfm?templateid=#url.templateid#&reviewid=#check.reviewid#&mode=close','resultsave','','','POST','eval')">
	
	<input type="hidden" name="reviewid" id="reviewid" value="#Check.reviewid#">	
	</td>
	
	</tr>
		
</cfoutput>

<tr><td colspan="2" height="1" bgcolor="silver"></td></tr>

<tr><td height="20">Last updated by:</td><td id="resultsave"><cfoutput>#Check.OfficerfirstName# #Check.OfficerLastName# - #dateformat(Check.created,CLIENT.DateFormatShow)# #timeformat(Check.created,"HH:MM")#</cfoutput></td></tr>

</cfform>
</table>	

</td></tr>
</table>
	
	