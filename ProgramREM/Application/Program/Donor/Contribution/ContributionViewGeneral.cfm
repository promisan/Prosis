<cfparam name="url.action"         default="view">
<cfparam name="url.contributionid" default="">
<cfparam name="url.mission"        default="">
<cfparam name="url.id1"            default="">

<cfif url.action eq "new">

<html>
<head>

	<cfajaximport tags="cfform,cfinput-datefield">
	
	<script type="text/javascript" src="Contribution.js"></script>
	<link rel="stylesheet" type="text/css" href="Contribution.css">	
	<cf_filelibraryscript>
	<cf_listingscript>
	<cf_DialogLedger>	
	<cf_DialogPosition>
	<cf_DialogStaffing>
	<cf_ActionListingScript>
    <cf_FileLibraryScript>
	<cf_DialogOrganization>
	
</head>

</cfif>

<cfif url.contributionid eq "">
	<cf_assignid>
	<cfset URL.contributionId = rowguid>
</cfif>

<cfquery name="qCheck" 
   datasource="AppsProgram" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT *
	FROM   Contribution
	WHERE  ContributionId = '#URL.ContributionId#'
</cfquery>

<cfquery name="Class" 
   datasource="AppsProgram" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ContributionClass
	WHERE  Code = '#qCheck.ContributionClass#'
</cfquery>

<cfif url.action eq "new">

<cf_screentop height="100%" 
	  scroll="Yes" 
	  user="yes" 	 
	  banner="green" 
	  line="no"
	  jQuery="Yes"
	  html="Yes"
	  label="Pledge" 
	  layout="webapp">

<body>	  

</cfif>	  

<table width="92%" 
      border="0"
	  height="<cfif url.action eq 'new'>99%</cfif>"
	  cellspacing="0" 
	  cellpadding="0" 
	  align="center">	 
	  
	<tr><td height="4"></td></tr>    	 		
	
	<tr>		
		<td valign="top" height="80" id="result">
		<cfinclude template="ContributionHeader.cfm">
		</td>
	</tr>	

	<cfif url.action neq "new">
	
	<cfif class.execution neq "1">
	
		<tr class="line">
			<td colspan="3" style="padding-left:6px" class="labelmedium"><cf_tl id="Tranches"></td>
		</tr>
		
		<tr>
		<td colspan="3" style="padding-left:8px" id="dlines">		
			<cfinclude template="ContributionLines.cfm">					
		</td>
		</tr>
	
	<cfelse>
	
		<tr class="line">
			<td colspan="3" style="padding-left:7px" class="labelmedium"><cf_tl id="Execution Tranches"></td>
		</tr>
		
		<tr>
		<td colspan="3" style="padding-left:8px" id="dlines">		
			<cfinclude template="ContributionLines.cfm">					
		</td>
		</tr>
	
		<!--- execution grant, which relies on contributions --->
		
		
		<cfquery name="qLines" datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT ( SELECT OrgUnitName 
			         FROM   Organization.dbo.Organization 
					 WHERE  OrgUnit = C.OrgUnitDonor) as Donor,
					 
					  (SELECT Reference
				    FROM   ContributionLine
					WHERE  ContributionLineId = CL.ParentContributionLineId) as ParentReference, 
			       CL.*, 
			       C.ActionStatus as HeaderStatus 
			FROM   ContributionLine CL, 
			       Contribution C
				   
			WHERE  CL.ContributionId = C.ContributionId
			AND    CL.ParentContributionLineId IN (SELECT ContributionLineId 
			                                       FROM   ContributionLine 
												   WHERE  ContributionId = '#url.contributionid#')
		         
			ORDER BY DateReceived ASC, DateEffective ASC	
		</cfquery>
		
		<cfif qLines.recordcount gte "1">
	
			<tr class="line">
				<td colspan="3" style="padding-left:7px" class="labelmedium"><cf_tl id="Income"></td>
			</tr>
					
			<tr>
			<td colspan="3" bgcolor="efefef" id="childrenlines" style="padding-left:8px;padding:4px;border:1px solid silver">		
				<cfinclude template="ContributionLinesChildren.cfm">					
			</td>
			</tr>
		
		</cfif>
			
	</cfif>
	
		
	<cfquery name="qCheckWorkflow" 
	   datasource="AppsProgram" 
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		SELECT *
		FROM  ContributionLine
		WHERE ContributionId = '#URL.ContributionId#'
		AND   HistoricContribution = '1'
	</cfquery>	
	
	<cfif qCheckWorkflow.recordcount eq 0>
		<cfset wflnk = "ContributionWorkflow.cfm">	
		<cfset url.ajaxid = url.contributionid>
	   
	    <cfoutput>
		
	    	<input type="hidden" name="workflowlink_#url.ajaxid#" id="workflowlink_#url.ajaxid#" value="#wflnk#">     
	
			<tr><td height="6"></td></tr>		
			<tr>
				<td colspan="3" style="padding-left:8px" class="labelmedium"><cf_tl id="Donor Contribution flow"></font></td>
			</tr>		
			<tr><td colspan="4" class="linedotted"></td></tr>	
			<tr>
				<td colspan="3" id="#url.ajaxid#" style="padding-left:8px">	
				    <cfinclude template="#wflnk#">	    
				</td>
			</tr>	
			
		</cfoutput>
	<cfelse>
			<tr height="40px">
				<td colspan="3" style="padding-left:8px" align="center">	
				    <cf_tl id="Historical Contribution">	    
				</td>
			</tr>					
	</cfif>
	
<cfelse>	
	</body>
	</html>
</cfif>	
