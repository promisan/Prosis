
<cfparam name="URL.ObjectKeyValue4"    default="">
<cfparam name="URL.ReviewId"    default="">

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
	
<cfelseif url.ObjectkeyValue4 neq "">
	
	<cfquery name="Review" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramPeriodAudit 
		WHERE    ReviewId = '#url.ObjectkeyValue4#' 
	</cfquery>
	
	<cfset url.orgUnit = Review.OrgUnit>
	<cfset url.period  = Review.Period>
	<cfset url.auditid = Review.AuditId>
	<cfset url.mode    = url.wparam>
	
	<cfoutput>
	
		<input name="Key1" id="Key1" type="hidden" value="#url.ObjectKeyValue4#">
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
<cfparam name="URL.auditid"     default="">
<cfparam name="URL.Layout"      default="">
<cfparam name="gh"              default="240">

<cfoutput>

<cfinclude template="IndicatorAuditScript.cfm">

<cfif url.ObjectkeyValue4 eq "">
	
	<cfajaxImport>

	<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

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
		SELECT    '#url.OrgUnit#', 
		          '#URL.Period#',
				  AuditId,
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#'			   
		FROM      Ref_Audit
		WHERE     Period = '#URL.Period#' 
		AND       AuditId NOT IN
	                     (SELECT  AuditId
	                       FROM   ProgramPeriodAudit
	                       WHERE  Period  = '#url.Period#' 
						    AND   OrgUnit = '#url.OrgUnit#')
	</cfquery>	
	
	<cfif url.auditid eq "">
	
		<cfquery name="Last"
		datasource="AppsProgram"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		  SELECT A.* FROM ProgramPeriodAudit A, Ref_Audit R
		  WHERE A.Period  = '#url.Period#'
		  AND   A.OrgUnit = '#url.OrgUnit#'
		  AND   A.AuditId = R.AuditId	
		  ORDER BY A.ActionStatus, R.AuditDate	
		</cfquery>		
		
		<cfset url.auditId = last.AuditId>
	
	</cfif>

</cfif>

<!--- generate default entries, do we need this sunday 15/9/2008 ???????? 
			
<cfquery name="DefaultEntries" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO ProgramIndicatorAudit 
			(TargetId, AuditId, Source, AuditTargetValue)
	SELECT  '#Target.TargetId#', AuditId, 'Manual',''
	FROM    Ref_Audit 
	WHERE   Period = '#URL.Period#'
	AND     AuditId NOT IN (SELECT AuditId 
	                       FROM   ProgramIndicatorAudit 
						   WHERE  TargetId = '#Target.TargetId#'
						   AND    Source = 'Manual') 
</cfquery>

--->


</cfoutput>

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
	WHERE     AuditId ='#URL.AuditId#'
</cfquery>

<cfif Audit.recordcount eq "0">

       <cf_message message = "Sorry, but we are experiencing a problem. Please come back later!"
    return="No">
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
	AND     A.AuditStatus = '0'
	AND     I.RecordStatus != '9'
	AND     A.Source = 'Manual'
	AND     R.AuditDate < '#DateFormat(Audit.AuditDate, CLIENT.DateSQL)#'
	AND     R.Period =  '#URL.Period#'
	</cfquery>

	<cfif Check.AuditDate gt "">

		<cfquery name="Check"
		datasource="AppsProgram"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT  AuditId
		FROM Ref_Audit
		WHERE AuditDate = '#DateFormat(Check.AuditDate,CLIENT.DateSQL)#'
		</cfquery>
	  	   
	   <tr><td height="1">&nbsp;<font color="#FF0000"><b><cf_tl id="Alert">:</b></font> <cf_tl id="Prior periods are not completed yet"></td></tr>
							
	</cfif>
	
<cfelseif url.mode eq "Submission" and url.ObjectKeyValue4 eq "">	
	
	    <cfquery name="Check"
		datasource="AppsProgram"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    ProgramPeriodAudit
		WHERE   OrgUnit = '#url.OrgUnit#'
		AND     Period = '#URL.Period#'
		AND     AuditId = '#URL.AuditId#'
		</cfquery>
				
		<cfif Check.recordcount eq "0">
		
			<cf_assignId>
			
			<cfquery name="Insert"
			datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			INSERT INTO ProgramPeriodAudit
			(ReviewId,Orgunit,Period,AuditId,OfficerUserId)
			VALUES
			('#rowguid#','#url.OrgUnit#','#URL.Period#','#URL.AuditId#','#SESSION.acc#')
			</cfquery>
			
		<cfelse>
		
		   <cfset rowguid = check.ReviewId>	
		
		</cfif>
		
	<tr><td height="4"></td></tr>	
		
	 <cf_ProcessActionTopic name="myflow" 
	       mode="Expanded" 
		   line="no"
		   title="Workflow"
		   click="maxme('myflow')">		 	
			  	   	
	<tr id="myflow">
		<td colspan="2">
		
		    <cfoutput>
		
			<input type="hidden" 
			   name="workflowlink_#rowguid#" 
			   id="workflowlink_#rowguid#" 			   
			   value="#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditWorkflow.cfm">	
	   
		   </cfoutput>		   
		   					
		   <cfdiv id="#rowguid#">   
				
				<cfset url.ajaxid = rowguid>
				<cfinclude template="IndicatorAuditWorkflow.cfm">
				
		   </cfdiv>					
						
		</td>
	</tr>   

</cfif>

<tr><td colspan="2">

<table width="100%" border="0" align="center" bordercolor="silver"><tr><td>

<cfif url.id eq "PRG" and url.objectkeyvalue4 eq "">

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
		AND    Pe.Period        = '#URL.Period#'
		AND    Pe.OrgUnit       = '#URL.OrgUnit#'		
		ORDER BY Pe.ProgramCode, C.Area 
	</cfquery>
		
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

<cfform action="#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditSubmit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&AuditId=#URL.AuditId#" method="POST" name="TargetEntry">

<cfoutput>
	<input type="hidden" name="indicator" id="indicator" value="#Indicator.recordcount#">
	<input type="hidden" name="location" id="location" value="#Location.recordcount#">
		
</cfoutput>

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" frame="all">
   <tr>
   	<td height="34" valign="middle">&nbsp;
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
	
	<cfif url.ObjectKeyValue4 eq "">
	
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
				<cf_tl id="Update" var="1">
			    <input type="submit" name="Submit" value="#lt_text#" class="button10g">&nbsp;				
			</cfif>
			</cfoutput>
		</cfif>
	
	</cfif>

	</td>
  </tr>
  <tr><td colspan="2" class="line"></td></tr>

<tr>
<td width="100%" colspan="2">

   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

   <cfif URL.Mode eq "View">

   	<tr>
	   <td width="3%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	   <td width="3%"></td>
	   <td width="30%"><cf_tl id="Description"></td>
	   <td width="8%"><cf_tl id="Target"></td>
	   <td width="20%" colspan="3" align="left"><cf_tl id="Measurement"></td>
	   <td width="20%"><cf_tl id="UoM"></td>
	</TR>
	<tr><td height="1" colspan="8" class="line"></td></tr>

	</cfif>
	
		
	<cfquery name="BaseTarget" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   ProgramIndicator P, 
	          ProgramIndicatorTarget T,
			  ProgramPeriod Pe	 
	   WHERE  Pe.OrgUnit      = '#URL.OrgUnit#'
	   AND    P.Period        = '#URL.Period#'
	   AND    P.ProgramCode = Pe.ProgramCode
	   AND    P.Period      = Pe.Period
	   AND    Pe.RecordStatus != '9'
	   AND	  P.RecordStatus != '9'	 
	   AND    P.TargetId      = T.TargetId
	   
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
	

</TABLE>

</td> </tr>

</table>

</cfform>

</td></tr>

</table>

</td></tr>

</table>



