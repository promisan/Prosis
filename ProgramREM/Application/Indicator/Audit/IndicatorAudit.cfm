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
<cfparam name="URL.ReviewId"    default="">
<cfparam name="URL.filter"      default="">

<!--- if workflow action the below value is set, otherwise no value --->
<cfparam name="Object.ObjectkeyValue4" default="">

<cfif url.reviewId neq "">

	<cfquery name="Review" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramPeriodAudit 
		WHERE    ReviewId = '#URL.ReviewId#' 
	</cfquery>
	
	<cfset url.orgUnit = Review.OrgUnit>
	<cfset url.period  = Review.Period>
	<cfset url.auditid = Review.AuditId>
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#URL.OrgUnit#' 
	</cfquery>
	
	<cfset url.mission = org.mission>	
		
<cfelseif Object.ObjectkeyValue4 neq "">

	<cfquery name="Review" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramPeriodAudit 
		WHERE    ReviewId = '#Object.ObjectkeyValue4#'  
	</cfquery>
	
	<cfset url.orgUnit = Review.OrgUnit>
	<cfset url.period  = Review.Period>
	<cfset url.auditid = Review.AuditId>
	<cfset url.mode    = "edit">
	<cfset url.filter  = url.wparam>
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization
		WHERE   OrgUnit = '#url.orgunit#'
	</cfquery>
	
	<cfoutput>
			
		<input name="Key1" id="Key1" type="hidden" value="#Object.ObjectKeyValue4#">
		<input name="AuditId" id="AuditId" type="hidden" value="#url.auditid#">
	
		<input name="savecustom" id="savecustom" 
			type="hidden"  
			value="programrem/application/indicator/audit/IndicatorAuditSubmit.cfm">
			
	</cfoutput>	
	
</cfif>

<cfparam name="URL.ID"          default="PRG">
<cfparam name="URL.Mode"        default="View">
<cfparam name="URL.ProgramCode" default="">
<cfparam name="URL.OrgUnit"     default="">
<cfparam name="URL.auditid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.Layout"      default="">
<cfparam name="gh"              default="240">

<cfif url.ProgramCode neq "">

	<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramPeriod
		WHERE    ProgramCode = '#URL.ProgramCode#' 
		AND      Period      = '#URL.Period#'
	</cfquery>
	
	<cfset url.orgunit = Program.OrgUnit>

</cfif>


<cfif url.mode eq "Submission">
	
	<!--- create audit records for all periods --->
	
	<cfquery name="InsertWFObject"
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		INSERT INTO ProgramPeriodAudit
	             (OrgUnit,
				  Period, 
				  AuditId,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		SELECT    '#URL.OrgUnit#', 
		          '#URL.Period#',
				  AuditId,
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#'			   
		FROM      Ref_Audit
		WHERE     Period = '#URL.Period#' 
		AND       AuditId NOT IN ( 
						    SELECT AuditId
	                        FROM   ProgramPeriodAudit
	                        WHERE  Period  = '#url.Period#' 
						    AND    OrgUnit = '#url.OrgUnit#'
							)
	</cfquery>	
	
	<!--- first due workflow in this period --->
	
	<cfquery name="Param" 
		datasource="AppsProgram"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ParameterMission
			WHERE    Mission = '#url.Mission#'
	</cfquery>
			
	<!--- first due workflow in this period  --->		
	
	<!--- ATTENTION
	
	and the end of the workflow once the status = 1 it then triggers a new workflow
	for the next audit moment to be reviewed --->
	
	
	<cfquery name="StartWF"
		datasource="AppsProgram"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT    TOP 1 A.* 
			FROM      ProgramPeriodAudit A, Ref_Audit R
			WHERE     A.Period  = '#url.Period#'
			AND       A.OrgUnit = '#url.OrgUnit#'
			AND       A.AuditId = R.AuditId	
			AND       R.AuditDate >= '#Param.IndicatorAuditWorkflowStart#' 
			AND       A.ActionStatus = 0
			ORDER BY  R.AuditDate	
	</cfquery>	
			
	<cfif url.auditid eq "00000000-0000-0000-0000-000000000000">
						
		<!--- associate to the very first due workflow as the sorting is by status so 
		0 comes first --->		
				
		<cfset url.auditId = startWF.AuditId>
				
		<!--- but if first audit date lies outside the scope; just show the last of that period --->
		
		<cfif startWF.recordcount eq "0">
		
			<cfquery name="Last"
				datasource="AppsProgram"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT    A.* 
				FROM      ProgramPeriodAudit A, Ref_Audit R
				WHERE     A.Period  = '#url.Period#'
				AND       A.OrgUnit = '#url.OrgUnit#'
				AND       A.AuditId = R.AuditId	
				ORDER BY  R.AuditDate DESC	
				</cfquery>		
		
				<cfset url.auditId = last.AuditId>						
		
		</cfif>	
	
	</cfif>

</cfif>

<cfif url.mode neq "fullview">
	<cfinclude template="IndicatorAuditScript.cfm">
	<cfajaxImport>
</cfif>

<cfparam name="url.mycl" default="0">

<cfif url.mycl eq "1">

	<cf_screenTop height="100%" menuaccess="context" bannerheight="60" banner="gray" layout="webapp" html="yes" scroll="yes" flush="Yes" label="Program Indicator Audit Review">

<cfelseif Object.ObjectkeyValue4 eq "" and url.mode neq "fullview">
		
	<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

</cfif>

<cfquery name="Program"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program
	WHERE   ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfquery name="PeriodList"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT    Period, 
	          DateEffective as Start, 
			  DateExpiration EndDate
	FROM      Ref_Period
	WHERE     Period = '#URL.Period#'
</cfquery>

<cfquery name="Audit"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Audit
	WHERE     AuditId = '#URL.AuditId#'
</cfquery>

<cfif Audit.recordcount eq "0">
	<cfoutput>
	<cf_tl id="Sorry, but we are experiencing a problem. Please come back later!" var="1">
       <cf_message message = "#lt_text#"
    return="No">
	</cfoutput>
	<cfabort>

</cfif>

<table width="99%" align="center" cellspacing="0" cellpadding="0">

<cfif url.id eq "PRG">
	<tr>
		<td><cfinclude template="../../Program/Header/ViewHeader.cfm"></td>
	</tr>
</cfif>

<cfif URL.Mode eq "Edit">

	<!--- check if entries can indeed be made --->

	<cfquery name="Check"
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  MIN(R.AuditDate) as AuditDate
		FROM    ProgramIndicatorAudit A INNER JOIN
		        ProgramIndicator I ON A.TargetId = I.TargetId INNER JOIN
		        Ref_Audit R ON A.AuditId = R.AuditId
		WHERE   I.ProgramCode = '#URL.ProgramCode#'
		AND	    I.Period      = '#URL.Period#'
		<!--- audit measurements which are not cleared yet --->
		AND     A.AuditStatus = '0'
		AND     I.RecordStatus != '9'
		AND     A.Source = 'Manual'
		<!--- consider only audit dates that lie prior to above defined active audit --->		
		AND     R.AuditDate < '#DateFormat(Audit.AuditDate, CLIENT.DateSQL)#'
		AND     R.Period =  '#URL.Period#'
	</cfquery>

	<cfif Check.AuditDate gt "">

		<cfquery name="Check"
		datasource="AppsProgram"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT  AuditId
			FROM    Ref_Audit
			WHERE   AuditDate = '#DateFormat(Check.AuditDate,CLIENT.DateSQL)#'
		</cfquery>
	  	   
	   <tr><td height="1">&nbsp;<font color="#FF0000"><b>
	   <cf_tl id="Alert">:</b></font> <cf_tl id="Prior periods are not completed yet" class="Message">.</td></tr>
							
	</cfif>
	
<!--- ----------------------------------------------------------- --->	
<!--- mode is through entry of the mainscreen which is wf enabled --->
<!--- ----------------------------------------------------------- --->	
	
<cfelseif url.mode eq "Submission" and Object.ObjectKeyValue4 eq "">	
	
	    <!--- workflow is due for an audit moment in this period --->
	
		<cfif startWF.recordcount gte "1">
		
		    <cfquery name="Check"
			datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    ProgramPeriodAudit
			WHERE   OrgUnit = '#Org.OrgUnit#'
			AND     Period  = '#URL.Period#'
			AND     AuditId = '#URL.AuditId#'
			</cfquery>
					
			<cfset guid = check.ReviewId>	
					
		<tr><td height="4"></td></tr>	
		
		<tr><td class="labellarge" style="height:35px;font-size:20px;padding-top:4px;padding-left:9px"><cf_tl id="Indicator Measurements"></td></tr>		
		
		<!---	
		<cf_ProcessActionTopic name="myflow" 
		       mode="Expanded" 
			   line="no"
			   title="Workflow"
			   click="maxme('myflow')">		 	
	   --->
				  	   	
		<tr id="myflow">
			<td colspan="2" style="padding-right:10px">
			
				<cfoutput>
			
				<input type="hidden" 
				   name="workflowlink_#guid#" 
				   id="workflowlink_#guid#" 				   
				   value="#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditWorkflow.cfm">	
		   
			   </cfoutput>
			   
			    <cfdiv id="#guid#">   
					
					<cfset url.ajaxid = guid>
					<cfinclude template="IndicatorAuditWorkflow.cfm">
					
			   </cfdiv>			
						
			</td>
		</tr>   
		
		</cfif>

</cfif>

<tr><td colspan="2">

<table width="100%" border="0" align="center"><tr><td>

<cfif url.id eq "PRG" and object.objectkeyvalue4 eq "">

	<!--- subsection indicators, which is for the old mode --->
	
	<cfquery name="Indicator"
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT DISTINCT C.Area AS Area, 
		       I.*, 
			   Pe.ProgramCode,
			   Pe.Period,
			   Pe.OrgUnit AS OrgUnit
		FROM   Ref_ProgramCategory C INNER JOIN
		       Ref_Indicator I ON C.Code = I.ProgramCategory INNER JOIN
		       ProgramIndicator PI ON I.IndicatorCode = PI.IndicatorCode 
			   INNER JOIN ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode 
			   AND PI.Period = Pe.Period 
		WHERE  PI.RecordStatus  != '9' 	   
		AND    Pe.RecordStatus  != '9'
		AND    Pe.Period        = '#URL.Period#'		
		AND    Pe.ProgramCode   = '#URL.ProgramCode#' 
		ORDER BY C.Area  
	</cfquery>
	
	<cfset access = "0">
	
<cfelse>

	<!--- all indicators --->
	
	<cfquery name="Indicator"
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
		       C.Area AS Area, 
			   I.*, 
			   Pe.ProgramCode, 
			   Pe.Period, 
		       Pe.OrgUnit AS OrgUnit, 
			   P.ProgramName AS ProgramName
		FROM   Ref_ProgramCategory C INNER JOIN
               Ref_Indicator I ON C.Code = I.ProgramCategory INNER JOIN
               ProgramIndicator PI ON I.IndicatorCode = PI.IndicatorCode INNER JOIN
               ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode AND PI.Period = Pe.Period INNER JOIN
               Program P ON Pe.ProgramCode = P.ProgramCode
		WHERE  PI.RecordStatus  != '9' 	   
		AND    Pe.RecordStatus  != '9'
		<cfif url.filter neq "" and url.filter neq "Edit">
		AND    I.IndicatorCode IN (SELECT IndicatorCode 
		                           FROM   Ref_IndicatorMission
								   WHERE  AuthorizationClass = '#url.filter#'
								   AND    Mission = '#Org.Mission#')
		
		</cfif>
		AND    Pe.Period        = '#URL.Period#'
		AND    Pe.OrgUnit       = '#URL.OrgUnit#'		
		ORDER BY Pe.ProgramCode, C.Area  
		
	</cfquery>
	
	<cfset access = "1">	
		
</cfif>	

<cfquery name="Location"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT  P.*, L.LocationName
	FROM    ProgramLocation P, 
	        Employee.dbo.Location L
	WHERE   P.ProgramCode = '#URL.ProgramCode#'
	AND     P.LocationCode = L.LocationCode
	ORDER BY L.LocationName 
</cfquery>

<cfform action="#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditSubmit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&AuditId=#URL.AuditId#" 
   method="POST" 
   name="targetentry">

<cfoutput>
	<input type="hidden" name="indicator" id="indicator" value="#Indicator.recordcount#">
	<input type="hidden" name="location"  id="location"  value="#Location.recordcount#">		
</cfoutput>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

   <tr class="line">
   	<td height="34" valign="middle">
		<cfoutput>
		<cf_tl id="Measurement">: #Audit.Description# <font size="4"><b>#DateFormat(Audit.AuditDate, CLIENT.DateFormatShow)#</font>
		</b></font>
		&nbsp;
		[#dateFormat(PeriodList.Start, CLIENT.DateFormatShow)#-#dateFormat(PeriodList.EndDate, CLIENT.DateFormatShow)#]
		</cfoutput>		
	</td>			
	<td align="right">
	
		<cfset ind = "'#Indicator.IndicatorCode#'">
		
		<cfloop query="Indicator" startrow="2">
		   <cfset ind = "#ind#,'#Indicator.IndicatorCode#'">
		</cfloop>
	
		<!--- determine if the user has access to change the indicator --->
		
		<cfif Object.ObjectKeyValue4 eq "">
		
			<cfinvoke component= "Service.Access"
				Method             = "indicator"
				OrgUnit            = "#URL.OrgUnit#"
				Indicator          = "#ind#"
				Role               = "ProgramAuditor"
				ReturnVariable     = "Access">
			
			<cfif Access eq "EDIT" or Access eq "ALL">
				<cfoutput>
				<cfif URL.Mode eq "Submission">
				
				<cfelseif URL.Mode eq "View">
					<cf_tl id="Update" var="1">
				    <input type="button" name="Edit" value="#lt_text#" class="button10g" onClick="recordedit()">&nbsp;				
				<cfelseif URL.Mode eq "Edit">
					<cf_tl id="Submit" var="1">
				    <input type="submit" name="Submit" value="#lt_text#" class="button10g">&nbsp;				
				</cfif>
				</cfoutput>
			</cfif>
			
		<cfelse>
		
		<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr>		
			<td>
			<cfoutput>
			<img src="#SESSION.root#/Images/select4.gif" alt="" align="absmiddle" border="0">
			<a title="Save recorded values sofar" 
			  href="javascript:ColdFusion.navigate('#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditSubmit.cfm?wf=1&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&AuditId=#URL.AuditId#','indicatorsave','','','POST','processaction')">
			<b>
			<font color="0080FF">
			<cf_tl id="Save Entries">
			</font>
			</a>
			</cfoutput>
			</td>	
			<td>
			<cfdiv id="indicatorsave">
			</td>
			</tr>
		</table>	
		
		</cfif>

	</td>
  </tr>
  
<tr>
<td width="100%" colspan="2">

   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

   <cfif URL.Mode eq "View">

   	<tr>
	   <td width="3%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	   <td width="3%"></td>
	   <td width="30%" 	class="labelit"><cf_tl id="Description"></td>
	   <td width="8%" 	class="labelit"><cf_tl id="Target"></td>
	   <td width="20%" 	colspan="3" align="left" class="labelit"><cf_tl id="Measurement"></td>
	   <td width="20%" 	class="labelit"><cf_tl id="UoM"></td>
	</TR>
	<tr><td height="1" colspan="8" class="line"></td></tr>

	</cfif>
	
	<cfset FileNo = round(Rand()*100)>
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Indicator_#FileNo#">	
		
	<cfquery name="BaseTarget" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT PI.*, T.TargetValue, T.SubPeriod
	   INTO   userQuery.dbo.#SESSION.acc#Indicator_#FileNo#
	   FROM   ProgramIndicator PI, 
	          ProgramIndicatorTarget T,
			  ProgramPeriod Pe	 
	   WHERE  Pe.OrgUnit       = '#URL.OrgUnit#'
	   AND    Pe.Period        = '#URL.Period#'
	   AND    PI.ProgramCode   = Pe.ProgramCode
	   AND    PI.Period        = Pe.Period
	   AND	  PI.RecordStatus  != '9'	 
	   AND    PI.TargetId       = T.TargetId	   
	</cfquery>
		
   <cfif Location.recordcount neq "0">
   
	   	   <!--- if location enable per location --->
		   <cfoutput query="Location" group="LocationName">
		       <cfset loc = location.locationcode>
			   <cfset lor = location.currentrow>
			   <cfif locationName neq "">
			   <tr>
				   <td colspan="6" height="20"><b>#LocationName#</b></td>
			   </TR>
			   </cfif>
			  <cfinclude template="IndicatorAuditDetail.cfm">
		   </cfoutput>
	   
	<cfelse>
	
	       <cfset loc = "">
		   <cfset lor = 0>
		   <cfinclude template="IndicatorAuditDetail.cfm">
		  
	</cfif>
		
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Indicator_#FileNo#">		

</TABLE>

</td>
</tr>

</table>

</cfform>

</td></tr>

</table>

</td></tr>

</table>

<cf_screenbottom layout="webapp">



