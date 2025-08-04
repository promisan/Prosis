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
<title>Progress View General</title>

<HTML><HEAD>
    <TITLE>Search - Search Result</TITLE>

</HEAD>

<style type="text/css">
   body {
    height: 8in;
    width: 10.5in;
    margin: .25in;
   }
</style>

<body>
<!---
<cfdocument 
   format = "FlashPaper">
--->

<cfsavecontent variable="SavedOutput">


<link rel="stylesheet" type="text/css" href="../../../../<cfoutput>#client.style#</cfoutput>">


<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort" default="ListingOrder">
<cfparam name="URL.View" default="None">
<cfparam name="URL.Lay" default="Show">
<cfparam name="URL.ID2" default="Template">
<cfparam name="URL.Unit" default="0">
<cfparam name="URL.Caller" default="Progress">
<cfparam name="URL.ID3" default="">

<!---<cfif URL.Caller eq "Progress">
    <body leftmargin="2" topmargin="2" rightmargin="1" bottommargin="0">
<cfelse>
    <body leftmargin="6" topmargin="5" rightmargin="4" bottommargin="0">
</cfif>	
--->

<input type="hidden" name="mission" value="<cfoutput>#URL.ID2#</cfoutput>">

<cfoutput>


</cfoutput>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
</cfquery>

<cfif Parameter.stPeriodUpdated+1 lt #now()#>

	<cfinclude template="ObservationPeriod.cfm">
   
	<cfquery name="UPDATE" 
		datasource="AppsProgram">
   		UPDATE Ref_ParameterMission
		SET stPeriodUpdated = '#DateFormat(now(), CLIENT.DateSQL)#'
	</cfquery>

</cfif>

<cfquery name="LastSubPeriod" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT TOP 1 SubPeriod 
	FROM   Ref_SubPeriod 
	Order by DisplayOrder Desc
</cfquery>

<cfquery name="DisplayPeriod" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_Period 
	WHERE  Period='#URL.Period#'
</cfquery>

<cfquery name="DisplaySubPeriod" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_SubPeriod 
	WHERE  SubPeriod='#URL.Sub#'
</cfquery>

<cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT OrgUnit, HierarchyRootUnit
   FROM Organization
   WHERE OrgUnitCode = '#URL.ID1#'
   	AND MandateNo = '#URL.ID3#'
	AND Mission = '#URL.ID2#'
   </cfquery>
   
  <cfquery name="Root" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM #CLIENT.LanPrefix#Organization
   WHERE OrgUnitCode = '#Org.HierarchyRootUnit#'
     AND MandateNo = '#URL.ID3#'
     AND Mission = '#URL.ID2#'
   </cfquery>

<!---   
<cf_dialogSpell>
--->

<cf_dialogREMProgram>
<cf_dialogOrganization>


<!--- get user Authorization level for adding programs --->

<cfif URL.ID eq "PRG">

    <cfset OrgAccess = "All">
	<cfset URL.Unit = "0">

<cfelse>

<cfinvoke component="Service.AccessGlobal"
    Method="global"
  	Role="AdminProgram"
	ReturnVariable="ManagerAccess">	

  <cfif #ManagerAccess# is "EDIT" OR #ManagerAccess# is "ALL">
      <cfset OrgAccess = "ALL">
   <cfelse>
	   <cfinvoke component="Service.Access"
		Method="organization"
		OrgUnit="#URL.Unit#"
		Period="#URL.Period#"
		ReturnVariable="OrgAccess">	
   </cfif>

</cfif>

<!--- get user Authorization level for adding programs --->

<CFIF #OrgAccess# NEQ "NONE">

<cfif #URL.ID# eq "ORG">
   <cfset cond = "AND O.OrgUnitCode = '#URL.ID1#'">
<cfelse>
   <cfset cond = "AND O.ProgramCode = '#URL.ID1#'">
</cfif>   

<!--- Query returning search results: get all top level programs from temporary query in AppsQuery --->

<cfquery name="SearchResult" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT P.*, Pe.OrgUnit, Pe.Reference, Pe.Period, Pe.ProgramId
    FROM   #CLIENT.LanPrefix#Program P, 
	      ProgramPeriod Pe, 
		  Organization.dbo.Organization O
	WHERE P.ProgramClass= 'Program' 
	  AND P.ProgramCode = Pe.ProgramCode
   	  AND Pe.RecordStatus != 9
	  AND Pe.Period   = '#URL.Period#'
	  AND O.OrgUnit   = Pe.OrgUnit
 	  AND O.MandateNo = '#URL.ID3#'
	  AND O.Mission   = '#URL.ID2#' 
	   #PreserveSingleQuotes(cond)#
	ORDER by ListingOrder
</cfquery>

<cfquery name="Status" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM  Ref_Status
	WHERE ClassStatus = 'Progress'
</cfquery>


 <cfif SearchResult.recordCount lt "1">
					
	  <cf_message message = "No progress reports found for this orgunit.  Please select another." return="No">
	  <cfabort>
		
</cfif>
 
<cfform >
	  
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="silver">

  <tr>
    <td class="top3nd">&nbsp;<b>Progress report   	
		<cfoutput>
		<cfif Len(Root.OrgUnitName) gt 40>
	     &nbsp;#Left(Root.OrgUnitName, 40)#...
	    <cfelse>
	     &nbsp;#Root.OrgUnitName#
	    </cfif>
		</cfoutput>
	
	</td>
	<td align="right" class="top3nd">
	
		<cfoutput query="DisplayPeriod">
			<b>#Description#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b>
		</cfoutput>

    </TD>
	
  </tr>
    
  </table>
  
  <!--- section 2 --->
  						   
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<TR bgcolor="f4f4f4">
		    <td width="3%"></td>
		    <TD width="10%"><cf_tl id="Code"></TD>
		    <td width="57%" colspan="3"><cf_tl id="Program Name"></td>
		    <TD width="20%"><cf_tl id="Entered by"></TD>
		    <TD width="10%"><cf_tl id="Initated"></TD>
			<td></td>
		</TR>
		
		<cfset Rec = 0>
		
		<cfoutput query="SearchResult">
		
		<!---
		<cf_WaitNext frm="report">
		--->
		
		<tr bgcolor="e4e4e4"><td height=1 colSpan=8></td></tr>
		<tr><td height=5 ColSpan=8></td></tr>
		   
		<TR>
		<td width="5%" align="center">
<!---	         <img src="../../../../Images/view.JPG" alt="" name="img0_#programid#" id="img0_#programid#" width="13" height="16" border="0" align="absmiddle"
			 onMouseOver="document.img0_#programid#.src='../../../../Images/button.jpg'" onMouseOut="document.img0_#programid#.src='../../../../Images/view.JPG'"
			 onclick="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','Program')">
--->	    </td>
		<TD>
		     <cfif #Reference# neq "">#SearchResult.Reference#<cfelse>#SearchResult.ProgramCode#</cfif>
		</TD>
		<TD colspan="3">
		   #SearchResult.ProgramName#
		</TD>
		<TD>#SearchResult.OfficerFirstName# #SearchResult.OfficerLastName#</TD>
		<td>#DateFormat(SearchResult.Created, CLIENT.DateFormatShow)#</td>
		</TR>
				
		<cfset FileNo = round(Rand()*100)>
		<cf_droptable dbname="AppsProgram" tblname="#SESSION.acc#Comp#FileNo#">
		
		<cfquery name="Comp" 
		datasource="AppsProgram"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT P.*, Pe.Period, Pe.ProgramId 
		INTO  dbo.#SESSION.acc#Comp#FileNo#  
		    FROM #Client.LanPrefix#Program P, ProgramPeriod Pe
			WHERE ProgramClass= 'Component'
			AND P.ParentCode = '#ProgramCode#'
			AND	Pe.RecordStatus != 9
			AND P.ProgramCode = Pe.ProgramCode
			AND Pe.Period = '#URL.Period#'
		</cfquery>
		
		<cfquery name="Components" 
		datasource="AppsProgram"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM #SESSION.acc#Comp#FileNo# 
		UNION ALL
		SELECT P.*, Pe.Period, Pe.ProgramId 
		    FROM  #Client.LanPrefix#Program P, ProgramPeriod Pe
			WHERE ProgramClass= 'Component'
			AND P.ParentCode IN (SELECT ProgramCode FROM #SESSION.acc#Comp#FileNo#)
			AND	Pe.RecordStatus != 9
			AND P.ProgramCode = Pe.ProgramCode
			AND Pe.Period = '#URL.Period#'
		</cfquery>
		
		<cf_droptable dbname="AppsProgram" tblname="#SESSION.acc#Comp#FileNo#">
		
		<cfif #Components.RecordCount# neq 0>
		<tr><td height="1" colSpan="8" class="line"></td></tr>
		</cfif>
		<cfloop query="Components">
		
		<!--- component code and name --->
		
		   <tr bgcolor="e4e4e4">
		    <td colspan="2" valign="top">&nbsp;#Components.ProgramCode#</td>
			<td colspan="5" valign="top">#Components.ProgramName#</td>
			<td></td>
			</tr>
		
			<!--- Begin new block for outputs --->
		
			<!--- 1 select activities of this period 
			      2.select activities prior period
				  3.select activities prior not reported  
			--->
		
		  <cfquery name="Output" 
			datasource="AppsProgram" >
			SELECT PA.ActivityPeriod, PA.ProgramCode, PA.ActivityDescription, PA.ActivityId, PO.ActivityPeriodSub,
			       PO.OutputId, PO.ActivityOutput, PO.ActivityOutputDate, PA.Reference, 'Current' as recordType, 
			       '0' as ProgressId, P.DescriptionShort
		    FROM   #Client.LanPrefix#ProgramActivity PA, #Client.LanPrefix#ProgramActivityOutput PO, 
							Ref_SubPeriod P
			WHERE  PA.ProgramCode    = '#Components.ProgramCode#'
			AND    PA.ActivityPeriod = '#URL.Period#'
			AND    PO.ActivityPeriodSub = '#URL.Sub#'
			AND    P.SubPeriod = PO.ActivityPeriodSub 
			AND    PA.ActivityId = PO.ActivityId
			AND	   (PO.RecordStatus <> 9 OR PO.RecordStatus is NULL)	
				
			UNION 
			
			SELECT PA.ActivityPeriod, PA.ProgramCode, PA.ActivityDescription, PA.ActivityId, PO.ActivityPeriodSub,
			       PO.OutputId, PO.ActivityOutput, PO.ActivityOutputDate, PA.Reference, 'Prior1' as RecordType,
      			   0 as ProgressId, P.DescriptionShort
		    FROM   #Client.LanPrefix#ProgramActivity PA, 
			       #Client.LanPrefix#ProgramActivityOutput PO, 
				   ProgramActivityProgress PG, 
				   Ref_SubPeriod P
			WHERE  PA.ProgramCode    = '#Components.ProgramCode#'
			AND    PA.ActivityPeriod = '#URL.Period#'
			AND    PO.ActivityPeriodSub < '#URL.Sub#'
			AND    PA.ActivityId = PO.ActivityId
			AND	   (PO.RecordStatus <> 9 OR PO.RecordStatus is NULL)	
			AND    PO.OutputId = PG.OutputId
			AND    P.SubPeriod =  PO.ActivityPeriodSub
			AND    PG.ProgressStatus != '#Parameter.ProgressCompleted#'
			AND	   (PG.RecordStatus != 9 or PG.RecordStatus IS NULL)
			
			UNION 
			
			SELECT PA.ActivityPeriod, PA.ProgramCode, PA.ActivityDescription, PA.ActivityId, PO.ActivityPeriodSub,
			PO.OutputId, PO.ActivityOutput, PO.ActivityOutputDate, PA.Reference, 'Prior0' as recordType,
			(SELECT TOP 1 ProgressId FROM ProgramActivityProgress WHERE OutputId = PO.OutputId) as ProgressId, 
			P.DescriptionShort
		    FROM   #Client.LanPrefix#ProgramActivity PA, 
			       #Client.LanPrefix#ProgramActivityOutput PO, 				  
				   Ref_SubPeriod P
			WHERE  PA.ProgramCode    = '#Components.ProgramCode#'
			AND    PA.ActivityPeriod = '#URL.Period#'
			AND    PO.ActivityPeriodSub < '#URL.Sub#'
			AND    PA.ActivityId = PO.ActivityId
			AND	   (PO.RecordStatus <> 9 OR PO.RecordStatus is NULL)				
			AND	   (PG.RecordStatus != 9 or PG.RecordStatus IS NULL)
			AND    P.SubPeriod =  PO.ActivityPeriodSub
			ORDER BY PA.ActivityId, PO.ActivityPeriodSub
			
		  </cfquery>
		  
		  <!--- define if person has view or edit access--->
		 
		<cfif Output.RecordCount gt 0>
		
		  <cfloop query="Output">
		       
		    <cfif (#ProgressId# eq "" and #RecordType# eq "Prior0") or #RecordType# neq "Prior0">
			
			<cfif RecordType eq "Current">
			   <cfset BGColor = "FFFFCF">
			<cfelse>
			   <cfset BGColor = "FBC7AE">
			</cfif>
			
			<cfif RecordType neq "Current" and #URL.Lay# eq "Hide">
			
			<!--- skip --->
			
			<cfelse>
			
		   	 <tr bgcolor= "#BGColor#">
		      <td colspan="8"></td>
			</tr>
				
		   	<tr bgcolor= "#BGColor#">
			  <td valign="top" colspan="1">&nbsp;&nbsp;<b>Activity:</b></A></td>
			  <td valign="top" colspan="1"><cfif RecordType neq "Current">Due in #DescriptionShort#</cfif></A></td>
		      <td valign="top" colspan="6">#ActivityDescription#</A></td>
			</tr>
			<tr><td height="1" colspan="8" bgcolor="e4e4e4"></td></tr>
						
			<!--- Prior report lines --->
			
			<cfif #URL.Lay# eq "Show">
			
			<tr>  
			
			<td bgcolor="FFFFFF"></td>
			<td colspan="7">
				
			<cfquery name="ProgressCurrent" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
		    FROM ProgramActivityProgress A, Ref_Status S 
		    WHERE A.OutputId     = '#Output.OutputId#' 
		    AND A.ProgramCode    = '#Output.ProgramCode#' 
		    AND A.ProgressStatus = S.Status 
		    AND S.ClassStatus    = 'Progress'
			AND	(A.RecordStatus != 9 or A.RecordStatus IS NULL)
			ORDER BY Created
		    </cfquery>
				
			<cfset ProgressNum = 0>
			
			<cfif ProgressCurrent.recordcount gt "0">
					
				<table width="98%" border="0" cellspacing="0" cellpadding="0">
				<tr><td>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
			    <cfloop query="ProgressCurrent">
				
					<cfif ProgressCurrent.Status neq "0">
					
					<cfset ProgressNum = #ProgressNum# + 1>
					<cfif #ProgressNum# gt 1>
						<tr><td colspan="6" bgcolor="e4e4e4"></td></tr>
					</cfif>
				  
				    <tr>
				    <td width="1%" valign="top" class="regular"></td>
					<TD width="7%" valign="top" class="regular">&nbsp;&nbsp;&nbsp;
<!---					     <cfif #ProgressStatus# eq 0>
					     <img src="#SESSION.root#/Images/arrow.gif" alt="Pending" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
						 <cfelseif #ProgressStatus# eq 1>
						 <img src="#SESSION.root#/Images/check.gif" alt="Completed" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
						 <cfelseif #ProgressStatus# eq 2>
						 <img src="#SESSION.root#/Images/pending.gif" alt="Pending" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
						 <cfelse>
						 <img src="#SESSION.root#/Images/pending.gif" alt="" width="10" height="10" border="0" align="bottom"></A>&nbsp;&nbsp;
						 </cfif>
--->								 
					</TD>
					<td width="10%" align="left" valign="top">#ProgressCurrent.Description#&nbsp;</td>
					<td width="10%" align="left" valign="top">#DateFormat(ProgressCurrent.ProgressStatusDate, CLIENT.DateFormatShow)#&nbsp;</td>
					<td width="50%" Colspan="2" valign="top">#ProgressCurrent.ProgressMemo#&nbsp;</a></td>
					</tr> 
					<tr>
					<td colspan="1"></td>
					<td colspan="3"  valign="top"><cfif #ProgressStatus# gte "2">New target: #DateFormat(ProgressCurrent.RevisedOutputDate, CLIENT.DateFormatShow)#</cfif></td>
					<td width="50%" align="left" valign="top">Reported by : <b>#ProgressCurrent.OfficerFirstName# #ProgressCurrent.OfficerLastName#</b></td>
					<td width="20%" align="left" valign="top">On: <b>#DateFormat(ProgressCurrent.Created, CLIENT.DateFormatShow)#</b></td>
				    </tr>
						
					</cfif>
					
			    </cfloop>	
				</table>
				</td></tr>
			    </table>
				</td></tr>
				
				</cfif>
			
			</cfif>
			
			<!--- identify the last progress entered for this output --->
			
			<cfquery name="LastProgress" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT ProgressId
		    FROM   ProgramActivityProgress PR
			WHERE  PR.OutputId   = '#Output.OutputId#'
			AND	   (PR.RecordStatus != 9 or PR.RecordStatus IS NULL) 
			</cfquery>
				
			<!--- create dummy record --->
			
			<cfif #LastProgress.recordCount# eq 0>
				
				<cfquery name="Insert" 
			    datasource="AppsProgram" 
			    username=#SESSION.login# 
			    password=#SESSION.dbpw#>
			    INSERT INTO ProgramActivityProgress  
			         (ProgramCode, ActivityPeriod,
					  OutputId, 
					  ProgressStatus,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  Created)
			    VALUES ('#output.programcode#', 
				      '#output.activityperiod#',
			          '#output.outputid#',
			  		  '0',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  getDate())
			      </cfquery>		
			   	
			</cfif>
			
			<!--- define the status of the last progress that was submitted --->
			
						
			<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastProgress#FileNo#">
			
			<cfquery name="LastProgress" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT OutputId, 
				       max(Created) as Created
				INTO   userQuery.dbo.#SESSION.acc#LastProgress#FileNo#
			    FROM   ProgramActivityProgress PR
				WHERE  PR.OutputId       = '#Output.OutputId#'
				AND	   (PR.RecordStatus != 9 or PR.RecordStatus IS NULL)	
				GROUP BY OutputId
			</cfquery>
			
			<cfquery name="Progress" 
			datasource="AppsProgram" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT ProgressStatus, 
				       OfficerLastName, 
					   OfficerFirstName, 
					   PR.Created
			    FROM   ProgramActivityProgress PR, 
				       userQuery.dbo.#SESSION.acc#LastProgress#FileNo# LP
				WHERE  PR.OutputId = LP.OutputId
				AND	   (PR.RecordStatus != 9 or PR.RecordStatus IS NULL)
				AND    PR.Created = LP.Created
			</cfquery>
			
		    <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastProgress#FileNo#">
							
			<!--- Begin new block for registered or new outputs --->
			
			<cfif #URL.View# eq "All" or 
			      (#URL.View# eq "Pending" AND #Progress.ProgressStatus# neq "#Parameter.ProgressCompleted#") or
				  (#URL.View# eq "Only" AND #Progress.ProgressStatus# eq "0") or
				  (#Progress.ProgressStatus# eq "2" AND #Parameter.DefaultPeriodSub# eq #LastSubPeriod.SubPeriod#)
				   >
			
			<cfset Rec = Rec + 1>
			<cfset #Client.RecordNo# = #Rec#>
					
			<tr><td width="100%" colspan="8">
			
			   <cfinclude template="ProgressInputPrint.cfm">
					
			</td></tr>
			
			
		
	</table>
		
	</td>
	</tr>
		
	</cfif>
			
	</tr>
		
	</cfif>
	
	</cfif>
     
  </cfloop> 
    
<tr><td height="4"></td></tr>

</cfif>  
  
</cfloop>

<!--- End new block --->

</td></tr>

</cfoutput>

	<tr bgcolor="f4f4f4">	
    <td></td>
	<td colspan="7" align="right" valign="middle">

<CFIF #Rec# gt 0> 

	<!--- get user Authorization level for adding programs --->

	<cfinvoke component="Service.AccessGlobal"
    Method="global"
  	Role="AdminProgram"
	ReturnVariable="ManagerAccess">	

    <cfif #ManagerAccess# is "EDIT" OR #ManagerAccess# is "ALL">
     	<cfset AccessLevel = "ALL">
	<cfelse>
		<cfinvoke component="Service.Access"
			Method="organization"
			OrgUnit="#SearchResult.OrgUnit#"
			ReturnVariable="AccessLevel">	
	</cfif>
<!---
    <cfif #AccessLevel# eq "EDIT" OR #AccessLevel# eq "ALL">
     	<input type="submit" value="Submit progress report" class="button7">
	<cfelse>
	    You have NO submission rights.	
	</cfif>
--->	
	&nbsp;</td>
	  	
</CFIF>

 </cfform>

	</tr>

	</table>

	</tr>

	</table>

</cfif>

<!---
</cfdocument>
--->

</cfsavecontent>


<cfdocument 
   format = "PDF"
   orientation = "landscape"
   scale = "75">

<cfoutput>#SavedOutput#</cfoutput>
</cfdocument>
</BODY></HTML>