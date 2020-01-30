
<!--- the purpose of this template is 

1. View all document actions [deplaying the exact step that is due for easy reference!],
by mission using different views : pending, etc. and different sorting

2. Provide an option to show only those vacacies/candidate that require action of the
person this is currently logged (SESSION.acc) in 

3. Provide hyperlink to the actual document action or candidate action

--->

<cfset CLIENT.DataSource = "AppsTravel">

<link href="../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<!--- tools : verify is user is authenticated through login menu --->


<!--- tools : prevent caches, disabled back button --->
<cf_PreventCache>

<HTML>

<HEAD>

<TITLE>Rotation Plan</TITLE>

</HEAD>

<cfoutput>

<SCRIPT LANGUAGE = "JavaScript">

function reloadForm(page,mission,fill,inbox)
{
    window.location="StaffAssignmentListing.cfm?IDMission=" + mission + "&Page=" + page;
}

</SCRIPT>	
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog screens --->
<!--- <cf_dialogStaffing> *NOT NEEDED* --->
<cfinclude template="Dialog.cfm">

<cfparam name="URL.IDInbox"   default="false">
<cfparam name="URL.IDSorting" default="Mission">

<!--- dropdown select mission for view 
<cfquery name="p_mission" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT SA.PermanentMissionId, PM.Description
	FROM StaffAssignment SA, Ref_PermanentMission PM
	WHERE SA.PermanentMissionId = PM.PermanentMissionId	
	UNION
	SELECT PermanentMissionId, Description
	FROM Ref_PermanentMission
	WHERE PermanentMissionId = 0
	ORDER BY Description
</cfquery>
--->

<!--- dropdown select mission for view --->
<cfquery name="mission" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Mission
	FROM StaffAssignment
	ORDER BY Mission
</cfquery>

<!--- query for person detail records
<cfquery name="SearchResult" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Person
    ORDER BY Nationality, LastName, FirstName
</cfquery>
--->

<!--- define database filter criteria 
<cfparam name="URL.IDP_Mission" default="#p_mission.PermanentMissionId#">
--->

<cfparam name="URL.IDMission" default="#Mission.Mission#">

<!--- drop temp table that might be still on the server 
<CF_DropTable dbName="#CLIENT.Datasource#" tblName="tmp#SESSION.acc#">
--->

<!--- toggle list contents based on My Inbox value  --->
<cfif #URL.IDInbox# is "false">
  <cfset select = "spStaffAssignmentListing">
<cfelse>
  <cfset select = "spStaffAssignmentListingInbox">
</cfif>  

<!--- Execute select stored procedure based on My Inbox value --->
<cfstoredproc procedure="#select#" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   <cfprocparam type="In" 
   cfsqltype="CF_SQL_VARCHAR" 
   dbvarname="@USERID" 
   value="#SESSION.acc#" null="No">

   <cfprocparam type="In" 
   cfsqltype="CF_SQL_VARCHAR" 
   dbvarname="@SORT" 
   value="#URL.IDSorting#" null="No">
  
   <cfprocparam type="In" 
   cfsqltype="CF_SQL_VARCHAR" 
   dbvarname="@MISSION" 
   value="#URL.IDMission#" null="No">
  
   <!--- identify all actions --->
   <cfprocresult name="SearchResult" resultset="1"> 
   
</cfstoredproc>

<!--- Query returning search results --->

<body class="main" onload="javascript:document.forms.result.page.focus();">

<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  	<!----
    <td width="150"><font face="Tahoma" size="2" color="#FFFFFF"><b>Permanent Mission:</b></font></td>
	<td>	
	<!--- dropdown to select a different mission --->
    <select name="p_mission" style="background: #002350; color: White;" accesskey="P" title="Permanent Mission Selection" 
	onChange="javascript:reloadForm(this.value,group.value,page.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">	
    <cfoutput query="p_mission">
	<option value="#PermanentMissionId#" <cfif #PermanentMissionId# is '#URL.IDP_Mission#'>selected</cfif>>	
	<font face="Tahoma" size="3">
	#Description#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>
	--->

    <td><font face="Tahoma" size="4" color="#FFFFFF"><b>Field Mission:  </b></font>
	<!--- dropdown to select a different mission --->
    <select name="mission" style="background: #002350; color: White;" accesskey="P" title="Field Mission Selection" 
	onChange="javascript:reloadForm(page.value,this.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">	
    <cfoutput query="Mission">
	<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
	<font face="Tahoma" size="4">
	<b>#Mission#</b>
	</font>
	</option>
	</cfoutput>
    </select>
    </td>
    
    <td align="right" class="bannerN">  
    <!--- option to select only requests that require action of the user --->
    <input type="checkbox" name="inbox" value="1" <cfif "1" is '#URL.IDInbox#'>checked</cfif> 
	onClick="javascript:reloadForm(result.page.value,result.mission.value,result.fill.value,this.checked)"
	style="background: #002350; font: larger; color: White;">	
	<font face="Tahoma" size="2" color="#FFFFFF"><b>Show only Requests that require my action</b></font>&nbsp;&nbsp;
	</td>  
	
  </tr> 	
  
  <tr><td colspan="5">

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
<!--- Start row containing the TYPE, STATUS, GROUPING, and PAGE OF drop-down lists --->
<tr>
	<td bgcolor="#6688AA" height="30">&nbsp;
	<!--- drop down to filter on a document status
	<select name="status" style="background: #C9D3DE;" accesskey="P" title="Status Selection" 
		onChange="javascript:reloadForm(p_mission.value,group.value,page.value,mission.value,this.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
	    <cfoutput query="Status">
		<option value="#Status#" <cfif #Status# is '#URL.IDStatus#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#Description#
		</font></option>
		</cfoutput>
	</select>
	--->
	
	<!--- drop down to select a action class list 
	<select name="fill" style="background: #C9D3DE;" accesskey="P" title="Action Class Selection" 
	onChange="javascript:reloadForm(p_mission.value,group.value,page.value,mission.value,status.value,this.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    	<option value="" <cfif '#URL.IDClass#' eq "">selected</cfif>>
		<font face="Tahoma" size="1">
		All
		</font>
		</option>
	    <cfoutput query="Class">
		<option value="#ActionClass#" <cfif #ActionClass# is '#URL.IDClass#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#Description#
		</font></option>
		</cfoutput>
	</select>	
	--->

	<!--- drop down to order the screen list --->	
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(p_mission.value,this.value,page.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    	 <OPTION value="Created" <cfif #URL.IDSorting# eq "AssignmentNo">selected</cfif>>List by Assignment Number
    	 <OPTION value="PlannedDeployment" <cfif #URL.IDSorting# eq "AssignmentStart">selected</cfif>>Group by Assignment Start
    	 <OPTION value="PlannedDeployment" <cfif #URL.IDSorting# eq "DOD">selected</cfif>>Group by Date of Departure	
	     <OPTION value="DutyLength" <cfif #URL.IDSorting# eq "DutyLength">selected</cfif>>Group by Length of TOD
    	 <OPTION value="RequestDate" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Nationality
	</select> 
	</td>

	<td bgcolor="#6688AA" align="right">
	<!--- drop down to select only a number of record per page using a tag in tools --->	
	<cfinclude template="../../Tools/PageCount.cfm">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(p_mission.value,group.value,this.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
		 <cfloop index="Item" from="1" to="#pages#" step="1">
    		  <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	     </cfloop>	 
	</select> &nbsp;  	
	</td>
</tr>

<!--- ROW containing column headers --->
<tr>
<td colspan="2">
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <TD width="5%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Country</font></TD>
	<TD width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Rank</font></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">First Name</font></TD>
    <TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Last Name</font></TD>
    <TD width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">TOD</font></TD>
	<TD width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOA</font></TD>
	<TD width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOD</font></TD>
	<TD width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOR</font></TD>
	<TD width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Replacement</font></TD>
	<TD width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">PDOA</font></TD>
	<TD width="18%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Comments</font></TD>	
</tr>

<!---
<tr bgcolor="f6f6f6">
<cfif #searchresult.status# is "0" or  #searchresult.status# is "1" >
<td height="25" colspan="9" valign="middle">
<input type="submit" name="Add" value="Process"></td>
</cfif>
</tr>
--->

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<CFOUTPUT query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

 <!--   <cfset amt  = 0>
    
	<!--- Display ROW containing record group headers --->
   <tr bgcolor="f6f6f6">
   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "Nationality">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Nationality#</b></font></td> 
     </cfcase>
     <cfcase value = "Rank">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Rank#</b></font></td> 
     </cfcase>	
     <cfcase value = "Gender">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Gender#</b></font></td> 
     </cfcase>	
     <cfcase value = "DOA">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(DOA, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "DOD">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(DOD, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "PDOA">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(PDOA, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
   </cfswitch>   
   </tr>
   -->
   
<CFOUTPUT>

	<!--- display data rows --->
	<tr bgcolor="C0C0C0"><td height="1" colspan="11" class="top2"></td></TR>
	
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<TD class="regular">#Nationality#</TD>
	<TD class="regular">#ShortDesc#</TD>
	<TD class="regular">#FirstName#</TD>
	<TD class="regular">#LastName#</TD>
   	<TD class="regular">#DutyLength#</TD>
	<TD class="regular">#DateFormat(AssignmentStart, "#CLIENT.dateformatshow#")#</TD>
	<TD class="regular">#DateFormat(DOD, "#CLIENT.dateformatshow#")#</TD>	
    <TD class="regular">#OfficerFirstName# #OfficerLastName#</TD>
    <TD class="regular">#Replacement#</TD>
   	<TD class="regular">#Dateformat(PDOA, "#CLIENT.dateformatshow#")#</TD>	
    <TD class="regular">#Comments#</TD>	
    </TR>
</CFOUTPUT>   

</CFOUTPUT>

</TABLE>

 </td></tr>
 <tr><td height="10" colspan="2" bgcolor="#002350"></td></tr>

</TABLE>

 </td></tr>
  
</table>
 
<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>