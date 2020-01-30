
<cf_tl id="Recruitment" var="1">
<cfset tRecruitment=#lt_text#>

<cf_tl id="Incumbent" var="1">
<cfset tIncumbent=#lt_text#>

<cf_tl id="Initiate Recruitment" var="1">
<cfset tInitiateRecruitment=#lt_text#>

<cf_tl id="No candidate information available" var="1" class="message">
<cfset tNoCandidateInfo=#lt_text#>

<cfinclude template="../../Template/IndicatorTarget.cfm">

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  *,
	        1 as Positions,
			CASE WHEN PersonNo is NULL THEN 0 
				 ELSE 1 END AS Incumbent,	
			CASE WHEN PersonNo is NULL THEN 1 
				 ELSE 0 END AS Vacant		 			
	FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE   Mission         = '#Target.OrgUnitCode#' 
	AND     SelectionDate   = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	</cfif>
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>	
	#preservesingleQuotes(OrgFilter)#
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#'	
	</cfif>
	<cfif url.OrgUnitOperational neq "">
	AND OrgUnitOperational = '#URL.OrgUnitOperational#'
	</cfif>
	<cfif url.Nationality neq "">
	AND Nationality = '#URL.Nationality#'
	</cfif>	
	ORDER BY HierarchyCode	
</cfquery> 
 
<cfquery name="List" dbtype="query">
	SELECT  *
	FROM    Base
	WHERE   1= 1 
	<cfif URL.Nationality neq "">
	AND     Nationality = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	ORDER BY HierarchyCode	
</cfquery> 

<table width="100%" border="0" cellpadding="0" class="formpadding">
<tr>
	<td align="right">
		<cfinclude template="../../Template/ListingMenu.cfm">
	</td>
</tr>
<tr><td class="line"></td></tr>

<tr><td valign="top">

<table width="98%" cellspacing="0" cellpadding="0" align="center">

<cfif list.recordcount eq "0">
	<tr><td colspan="6" align="center"><b>No records found</b></td></tr>
</cfif>

<cfoutput query="List" group="HierarchyCode">

	<cfquery name="get"
	   dbtype="query">
		SELECT  sum(Positions) as Positions, 
				sum(Incumbent) as Incumbered,
				sum(Vacant) as Vacant
		FROM    Base
		WHERE OrgUnitOperational = #OrgUnitOperational#
	</cfquery> 

	<tr>
		<td colspan="6">#OrgUnitName#</td>
		<td align="right">
		<table align="right">
		<tr>
		<td width="20"><b>#get.Positions#</b></td>
		<td width="20"><font color="green">#get.Incumbered#</td>
		<td width="20"><b><font color="FF0000">#get.Vacant#</font></b></td>
		</tr>
		</table>
		</td>
	</tr>	
	<tr><td colspan="7" class="line"></td></tr>
	
	<cfoutput>
	
		<cfif PersonNo eq "">
		<cfset cl = "FF5B5B">
		<cfelse>
		<cfset cl = "ffffdf">
		</cfif>
		
		<tr bgcolor="#cl#">
			<td height="18" width="20"></td>
			<td width="20">#currentrow#.</td>
			<td><a href="javascript:EditPost('#PositionNo#')">#FunctionDescription#</a></td>
			<td>#PostClass#</td>
			<td>#PostGrade#</td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#FullName#</a></td>
		</tr>
					
		
		<tr><td colspan="7" bgcolor="d0d0d0"></td></tr>
		
		  <cfquery name="Check" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   EmployeeSnapShot.dbo.HRPO_CurrentTracks
				WHERE  Mission         = '#Target.OrgUnitCode#' 	
				AND    PositionNo      = '#PositionNo#'			
		  </cfquery>	
		  
		  <cfif check.recordcount gte "1">	
		  		  		  				
			    <cfquery name="Doc" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				<!--- current mandate --->
				SELECT   D.*			
				FROM     Document D INNER JOIN
						 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
						 Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
				WHERE    D.Status = '0'
					AND  P.PositionNo = '#PositionNo#'
					AND  D.EntityClass is not NULL					
				UNION
				<!--- next mandate --->
				SELECT   D.*
				FROM     Document D INNER JOIN
		                 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
		                 Employee.dbo.Position P ON DP.PositionNo = P.SourcePositionNo
				WHERE    D.Status = '0'		 
					AND  P.PositionNo = '#PositionNo#'				
					AND  D.EntityClass is not NULL									
				</cfquery>		
				
				<cfloop query="doc">	
				
				<tr bgcolor="D6FED9">
				<td></td>
				<td><img src="#SESSION.root#/Images/pointer2.jpg" alt="Recruitment action" width="9" height="9" border="0" align="middle" style="cursor: pointer;" onClick="javascript:showdocument('#DocumentNo#')"></td>
				<td colspan="3"><a href="javascript:showdocument('#DocumentNo#')">#tRecruitment#: #DocumentNo# (#officerUserFirstName# #OfficerUserLastName# : #dateformat(created,CLIENT.DateFormatShow)#)</a></td>
									 
					 <cfquery name="Candidate" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  PersonNo, LastName, FirstName, StatusDate
						FROM    DocumentCandidate P
						WHERE   DocumentNo = '#DocumentNo#' 
						  AND   Status = '2s'
					</cfquery>	
					
					<cfset cpl = DateFormat(Candidate.StatusDate, CLIENT.DateFormatShow)>
																			
					<cfif Candidate.recordcount gte "1">
						<td colspan="3" bgcolor="D6FED9">
						<cfloop query = "Candidate">
						&nbsp;<a href="javascript:ShowCandidate('#Candidate.PersonNo#')">#Candidate.FirstName# #Candidate.LastName# - #cpl#</a>
						</cfloop>
						</td>
					<cfelse>
						<td colspan="3"> - #tNoCandidateInfo# -</a></td>
					</cfif>
					</tr>
					
				</cfloop>	
				
			</cfif>		
			
			<cfif id neq "">
				<cfset id = "#id#,'#recordno#'">	
			<cfelse>
			    <cfset id = "'#recordno#'">	
			</cfif>
		
	</cfoutput>
	<tr><td height="20"></td></tr>
	
</cfoutput>
</table>

<cfinclude template="../../Template/ListingBottom.cfm">


</td></tr></table>
