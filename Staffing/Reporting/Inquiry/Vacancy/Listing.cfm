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
<cf_tl id="Recruitment" var="1">
<cfset tRecruitment=#lt_text#>

<cf_tl id="Incumbent" var="1">
<cfset tIncumbent=#lt_text#>

<cf_tl id="Initiate Recruitment" var="1">
<cfset tInitiateRecruitment=#lt_text#>

<cf_tl id="No candidate information available" var="1" class="message">
<cfset tNoCandidateInfo=#lt_text#>

<!--- does not have to be changed usually --->
<cfparam name="url.Nationality" default="">
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.OfficerUserId" default="">
<cfparam name="url.Print" default="0">
<cfparam name="url.page" default="1">
<cfparam name="url.mode" default="">
<cfparam name="url.scope" default="all">

<cfquery name="Base" 
    datasource="AppsQuery" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  *,
	        1 as Positions,
			CASE WHEN PersonNo is NULL THEN 0 
				 ELSE 1 END AS Incumbent,	
			CASE WHEN PersonNo is NULL THEN 1 
				 ELSE 0 END AS Vacant		 			
	FROM    #SESSION.acc#_AppStaffingDetail_#url.fileno#	
	WHERE   1=1	
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>	
	<!---
	#preservesingleQuotes(OrgFilter)#
	--->
	<cfif url.item neq "">
	AND    #URL.Item# = '#URL.Select#'	 
	</cfif>
	<cfif url.OrgUnitOperational neq "">
	AND    OrgUnitOperational = '#URL.OrgUnitOperational#'
	</cfif>
	<cfif url.Nationality neq "">
	AND    Nationality = '#URL.Nationality#'
	</cfif>	
	ORDER BY HierarchyCode	
</cfquery> 

<cf_pagecountN show="250" count="#Base.recordcount#">
			   
<cfset counted  = base.recordcount>		

<cfif url.print eq "1" or url.mode eq "drillbox">
  <cfset last = 9999>
</cfif>	
 
<cfquery name="List" maxrows="#last#" dbtype="query">
    SELECT  *
	FROM    Base
	WHERE   1= 1 
	<cfif URL.Nationality neq "">
	AND     Nationality        = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	ORDER BY HierarchyCode
</cfquery> 

<table width="100%" height="100%" bgcolor="white" border="0" cellpadding="0" cellspacing="0">
	
	<tr class="line">
		<td height="20" align="right">
			<cfinclude template="../Template/ListingMenu.cfm">
		</td>
	</tr>
		
	<tr><td height="100%" valign="top" style="padding:12px">
	
	<cf_divscroll style="width:100%;height:100%">
		
	<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<cfif list.recordcount eq "0">
	
		<tr><td colspan="6" height="30" align="center" class="labelmedium">No records found to show in this view</td></tr>
		<cfabort>
		
	<cfelseif url.print eq "0" or url.mode eq "drillbox">
	
		<tr class="line"><td height="14" colspan="7" style="padding:1px">
							 
		 <cfinclude template="ListingNavigation.cfm">
		 				 
		</td></tr>
				
	</cfif>
	
	<cfset row = 1>
	
	<cfoutput query="List" group="HierarchyCode">
	
		<cfif row gte first>
	
		<cfquery name="get"
		   dbtype="query">
			SELECT  sum(Positions) as Positions, 
					sum(Incumbent) as Incumbered,
					sum(Vacant) as Vacant
			FROM    Base
			WHERE OrgUnitOperational = #OrgUnitOperational#
		</cfquery> 
	
		<tr class="line">
			<td style="padding-left:4px" class="labelmedium" colspan="6">#OrgUnitName#</td>
			<td align="right">
				<table align="right">
				<tr>
				<td class="labelmedium" width="20"><b>#get.Positions#</b></td>
				<td class="labelmedium" width="20"><font color="green">#get.Incumbered#</td>
				<td class="labelmedium" width="20"><b><font color="FF0000">#get.Vacant#</font></b></td>
				</tr>
				</table>
			</td>
		</tr>	
				
		</cfif>
		
		<cfoutput>
		
			<cfset row = row+1>
			
			<cfif row gte first>
											
				<cfif PersonNo eq "">
				<cfset cl = "e99755">
				<cfset st = "padding:1px;color: white;">
				<cfelse>
				<cfset cl = "5e98bd">
				<cfset st = "padding:1px;color: white;">
				</cfif>
								
				<tr class="labelmedium line navigation_row">
				
					<td width="20"></td>
					<td width="20">#currentrow#.</td>					
					<td><cfif url.print neq "yes"><a class="navigation_action" href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')">#FunctionDescription#</a></cfif></td>
					<td>#PostClass#</td>
					<td>#PostGrade#</td>
					<cfif PersonNo eq "">
					<td bgcolor="#cl#" style="#st#;padding-left:8px" colspan="2"><cf_tl id="Vacant"></td>					
					<cfelse>
					<td bgcolor="#cl#" style="#st#;padding-left:8px">#IndexNo#</td>
					<td bgcolor="#cl#" style="#st#;padding-left:8px"><a href="javascript:EditPerson('#PersonNo#')"><font color="FFFFFF"><u>#FullName#</a></td>
					</cfif>
				</tr>							
										  
				  <cfif documentNo gte 1 or documentNextNo gte 1>	
				 		  		  		  				
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
						
						<tr bgcolor="D6FED9"  class="line labelit navigation_row_child">
						<td></td>
						<td><img src="#SESSION.root#/Images/join.gif" alt="Recruitment action" width="9" height="9" border="0" align="middle" style="cursor: pointer;" onClick="javascript:showdocument('#DocumentNo#')"></td>
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
				
				</cfif>
			
		</cfoutput>
		
		<cfif row gte first>
		<tr><td height="5"></td></tr>
		</cfif>
		
	</cfoutput>
	
	<cfif url.print eq "0" or url.mode eq "drillbox">
		<tr><td height="14" colspan="7">						 
			 <cfinclude template="ListingNavigation.cfm">	 				 
		</td></tr>
	</cfif>
		
	</table>
	
	</cf_divscroll>
	
	<cfinclude template="../Template/ListingBottom.cfm">
	
	</td></tr>
	</table>
	
<cfset ajaxonload("doHighlight")>	
