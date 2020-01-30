<!--- the purpose of this template is 
DocumentListing.cfm

1. View all document actions [deplaying the exact step that is due for easy reference!],
by mission using different views : pending, etc. and different sorting

2. Provide an option to show only those vacacies/candidate that require action of the
person this is currently logged (SESSION.acc) in 

3. Provide hyperlink to the actual document action or candidate action

--->
<html><head><title>Personnel Requests</title></head>

<link href="../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfset CLIENT.DataSource = "AppsTravel">

<cf_PreventCache>

<cfoutput>
<script language = "JavaScript">
function reloadForm(perm,group,page,mission,status,fill,inbox) {
    window.location="DocumentListing.cfm?IDP_Mission=" + perm + "&IDClass=" + fill + "&IDSorting=" + group + "&Page=" + page + "&IDMission=" + mission + "&IDStatus=" + status + "&IDInbox=" + inbox;
}
</script>	
</cfoutput>

<cfinclude template="../Dialog.cfm">

<cfparam name="URL.IDP_Mission" default=0>
<cfparam name="URL.IDMission" 	default="ALL">
<cfparam name="URL.IDInbox"   	default="false">
<cfparam name="URL.IDClass"   	default="">
<cfparam name="URL.IDStatus"  	default="0">
<cfparam name="URL.IDSorting" 	default="DocumentNo">

<!--- dropdown select mission for view --->
<cfquery name="p_mission" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT D.PermanentMissionId, PM.Description
	FROM Document D, Ref_PermanentMission PM
	WHERE D.PermanentMissionId = PM.PermanentMissionId
	ORDER BY PM.Description
</cfquery>

<!--- dropdown for field mission 
      1. check if user is authorized to access all field missions --->
<cfquery name="AuthorizedForAllMissions" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT A.Mission
	FROM ActionAuthorization A INNER JOIN FlowAction F ON A.ActionId = F.ActionId
	WHERE A.Mission LIKE 'All%' 
	AND A.AccessLevel<>'9' 
	AND A.UserAccount='#SESSION.acc#'
</cfquery>
<cfset CanAccessAllMissions = "False">
<cfoutput query="AuthorizedForAllMissions">
	<cfif #AuthorizedForAllMissions.RecordCount# GT 0>
		<cfset CanAccessAllMissions = "True">
	</cfif>
</cfoutput>
<!--- 2. If no, limit missions droplist to those missions and PersonCategories in Document table 
	  for which the current user has authorization --->
<cfquery name="mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT D.Mission FROM Document D
	WHERE EXISTS (SELECT AA.*
				  FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
				  WHERE AA.ActionId = FA.ActionID
				  AND   FA.ActionClass = RT.TravellerTypeCode
				  AND   RT.TravellerType = RC.TravellerType
			  	  AND   AA.AccessLevel <> '9'
				  AND   AA.UserAccount = '#SESSION.acc#'
				  <cfif NOT #CanAccessAllMissions#><cfoutput>AND AA.Mission = D.Mission</cfoutput></cfif>
				  AND   RC.Category = D.PersonCategory)
	ORDER BY D.Mission
</cfquery>	

<!--- dropdown --->
<cfquery name="Class" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#"
 cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT * FROM  FlowClass
</cfquery>

<!--- dropdown --->
<cfquery name="Status" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#"
 cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT * FROM  Ref_Status WHERE Class = 'Document'
</cfquery>

<cfif #URL.IDClass# neq "">
    <cfset actclass = #URL.IDClass#>
<cfelse>
	<cfset actclass = "%%">
</cfif>

<!--- drop temp table that might be still on the server --->
<CF_DropTable dbName="#CLIENT.Datasource#" tblName="tmp#SESSION.acc#">

<!--- show all or only vacancies that require action from the user --->
<cfif #URL.IDInbox# is "false">
  <cfset select = "spActionListingNew">
<cfelse>
  <cfset select = "spActionListingNew">
</cfif>

<cfstoredproc procedure="#select#" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERID"  	  value="#SESSION.acc#" 		null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@STATUS"  	  value="#URL.IDStatus#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SORT"    	  value="#URL.IDSorting#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MISSION" 	  value="#URL.IDMission#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INT"     dbvarname="@PERMMISSION" value="#URL.IDP_Mission#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLASS"  	  value="#actclass#"   		null="No">
   <cfprocresult name="SearchResult" resultset="1">    
</cfstoredproc>

<!---cfstoredproc procedure="#select#"
datasource="#CLIENT.Datasource#"
username="#SESSION.login#"
password="#SESSION.dbpw#">

   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERID" value="#SESSION.acc#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@STATUS" value="#URL.ID2#"    null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SORT"   value="#URL.IDSorting#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MISSION" value="#URL.ID1#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLASS"  value="#actclass#"	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@AREA"   value="#actarea#"	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SEARCH" value="#actsearch#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@OFFICER" value="#actofficer#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LASTNAME" value="#actlast#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@DOCNO"  value="#actdocument#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@DOCNO1" value="#actdocument1#" null="No">

   <!--- identify all actions --->
   <cfprocresult name="SearchResult" resultset="1">

</cfstoredproc---->

<!--- Query returning search results --->

<body class="main" onload="javascript:document.forms.result.page.focus();">
<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350" height="25" valign="middle">
    <td><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;SHOW:</b></font></td>
	<td><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;Permanent Mission:&nbsp;&nbsp;</b></font>
    <select name="p_mission" style="background: #C9D3DE;" accesskey="P" title="Permanent Mission Selection" 
	onChange="javascript:reloadForm(this.value,group.value,page.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	<option value=0 <cfif '#URL.IDP_Mission#' eq "">selected</cfif>><font face="Tahoma" size="2">All</font>
    <cfoutput query="p_mission">
	<option value="#PermanentMissionId#" <cfif #PermanentMissionId# is '#URL.IDP_Mission#'>selected</cfif>>	
	<font face="Tahoma" size="2">#Description#</font>
	</option>
	</cfoutput>
    </select>
    </td>

    <td><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;Field Mission:</b></font></td>
	<td>	
	<!--- dropdown to select a different mission --->
	<cfif #CanAccessAllMissions#>
	    <select name="mission" style="background: #C9D3DE;" accesskey="P" title="Field Mission Selection" 
		onChange="javascript:reloadForm(p_mission.value,group.value,page.value,this.value,status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
 		<option value="ALL"><font face="Tahoma" size="2">All</font>
	    <cfoutput query="Mission">
		<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
			<font face="Tahoma" size="2">#Mission#</font>
		</option>
		</cfoutput>
	    </select>
	<cfelse>
	    <select name="mission" style="background: #C9D3DE;" accesskey="P" title="Field Mission Selection" 
		onChange="javascript:reloadForm(p_mission.value,group.value,page.value,this.value,status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	    <cfoutput query="Mission">
		<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
			<font face="Tahoma" size="2">#Mission#</font>
		</option>
		</cfoutput>
	    </select>
	</cfif>	
    </td>
    
    <td><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;Status:</b></font></td>
	<td>	
	<!--- drop down to filter on a document status --->
	<select name="status" style="background: #C9D3DE;" accesskey="P" title="Status Selection" 
		onChange="javascript:reloadForm(p_mission.value,group.value,page.value,mission.value,this.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
	    <cfoutput query="Status">
		<option value="#Status#" <cfif #Status# is '#URL.IDStatus#'>selected</cfif>>
			<font face="Tahoma" size="2">#Description#</font>
		</option>
		</cfoutput>
	</select>	
	</td>	
	
    <td align="right"><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;Travelled by:</b></font></td>
	<td align="right">
	<!--- drop down to select a action class list --->	
	<select name="fill" style="background: #C9D3DE;" accesskey="P" title="Action Class Selection" 
	onChange="javascript:reloadForm(p_mission.value,group.value,page.value,mission.value,status.value,this.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    	<option value="" <cfif '#URL.IDClass#' eq "">selected</cfif>>
		<font face="Tahoma" size="2">
		All
		</font>
		</option>
	    <cfoutput query="Class">
		<option value="#ActionClass#" <cfif #ActionClass# is '#URL.IDClass#'>selected</cfif>>
		<font face="Tahoma" size="2">
		#Description#
		</font></option>
		</cfoutput>
	</select>
	&nbsp;
	</td>
  </tr> 	
  
 <tr>
  <table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
   <tr bgcolor="#6688AA" height="30" valign="middle">
	<td><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;GROUP/SORT BY:</b></font>
	<!--- drop down to order the screen list --->	
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(p_mission.value,this.value,page.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    	 <OPTION value="Created" <cfif #URL.IDSorting# eq "Created">selected</cfif>>Group by record creation date
    	 <OPTION value="PlannedDeployment" <cfif #URL.IDSorting# eq "PlannedDeployment">selected</cfif>>Group by Planned Deployment
	     <OPTION value="DutyLength" <cfif #URL.IDSorting# eq "DutyLength">selected</cfif>>Group by Length of TOD
    	 <OPTION value="RequestDate" <cfif #URL.IDSorting# eq "RequestDate">selected</cfif>>Group by Request date
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
		 <OPTION value="Description" <cfif #URL.IDSorting# eq "Description">selected</cfif>>Group by Permanent Mission
		 <OPTION value="DocumentNo" <cfif #URL.IDSorting# eq "DocumentNo">selected</cfif>>Sort by Request No
	</select> 
	</td>

    <!--- option to select only requests that user has access to 
    <td align="left">
    <input type="checkbox" name="inbox" value="1" <cfif #URL.IDInbox#>checked</cfif> 
	onClick="javascript:reloadForm(result.p_mission.value,result.group.value,result.page.value,result.mission.value,result.status.value,result.fill.value,this.checked)">
	<font face="Tahoma" size="1" color="#FFFFFF"><b>Show only Requests that I am authorized to access</b></font>&nbsp;
	</td>   --->

	<td bgcolor="#6688AA" align="right" colspan="2">
	<!--- drop down to select only a number of record per page using a tag in tools --->	
	<cfinclude template="../../../Tools/PageCount.cfm">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(p_mission.value,group.value,this.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
		 <cfloop index="Item" from="1" to="#pages#" step="1">
    		  <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	     </cfloop>	 
	</select> &nbsp;  	
	</td>
   </tr>

   <!--- Detail column headers --->
   <tr>
   <td colspan="4">
   <table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

   <tr bgcolor="#8EA4BB">
    <td width="1%"></td>
	<td width="4%"></td>
	<td width="5%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Req #</font></td>
    <td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Field Mission</font></td>
	<td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Perm Mission</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Request Date</font></td>
	<td width="9%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Pers Type</font></td>	
    <td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF"># of pers</font></td>
	<td width="5%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">TOD</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Planned</font></td>
    <td width="19%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Created by</font></td>
    <td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Created on</font></td>
   </tr>

   <tr bgcolor="#8EA4BB">
    <td width="1%"></td>
	<td width="4%"></td>
	<td width="5%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>	
    <td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Action Status</font></td>
	<td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
	<td width="9%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>	
    <td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
	<td width="5%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Deployment</font></td>
    <td width="19%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
    <td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
   </tr>

   <cfset vac     = "0">
   <cfset action  = "9999">
   <cfset amtT    = 0>

   <cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

   <cfset amt  = 0>
    
   <!--- Display ROW containing record group headers --->
   <tr bgcolor="f6f6f6">
   	<cfswitch expression = #URL.IDSorting#>
     <cfcase value = "Created">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(Created, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "PlannedDeployment">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "RequestDate">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(Requestdate, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "DutyLength">
	 <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#DutyLength#</b></font></td>
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     </cfcase>	
     <cfcase value = "Description">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Description#</b></font></td> 
     </cfcase>	
   	</cfswitch>   
   </tr>

   <!--- DETAIL RECORD SECTION --->     
   <cfoutput>

   <cfif (#DocumentNo# eq #vac# and #ActionOrder# eq #action#) 
      or (#ActionStatus# eq "1" and #Status# eq "0")>

     <!--- don't show line --->
	 
   <cfelse>

	<cfif #PersonNo# eq "0">
		<tr bgcolor="C0C0C0"><td height="1" colspan="12" class="top2"></td></tr>	
		<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">		
			<td rowspan="1" align="left"></td>	
			<td rowspan="2" align="center">
				<a href="javascript:showdocument('#DocumentNo#','ZoomIn')">
				<img src="../../Images/folder2.jpg" alt="" width="28" height="28" border="1" align="bottom">
				</a>	
			</td>	
			<td class="regular">#DocumentNo#</td>
			<td class="regular">#Mission#</td>
			<td class="regular">#Description#</td>
			<td class="regular">#DateFormat(RequestDate,client.dateformatshow)#</td>
	    	<td class="regular">#PersonCategory#</td>		
    		<td class="regular">#PersonCount#</td>
	    	<td class="regular">#DutyLength#</td>
		    <td class="regular">#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</td>	
    		<td class="regular">#OfficerUserFirstName# #OfficerUserLastName#</td>
	    	<td class="regular">#Dateformat(Created, "#CLIENT.dateformatshow#")#</td>			
    	</tr>
		
		<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		<td></td>
		<cfset Amt = Amt + 1>
	    <cfset AmtT = AmtT + 1>

	<cfelse>
    	<cfif #Status# eq "0">
    	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
    	<td colspan="2" align="center"></td>
		<td>
	    <button class="button2" onClick="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#','#ActionOrder#')">
      	  <img src="../../Images/user.JPG" alt="" width="14" height="14" border="0" align="bottom">
    	</button>
    	</td>	
    	</cfif>
	</cfif>
	
	<!--- Print second (action status) line in the record detail --->
	<cfif #Status# neq "1">
    	<td colspan="1" align="left" class="regular">
    	<td colspan="10" align="left" class="regular"><font color="800000"><b>
     	<cfif #Status# eq "0">&nbsp;#ActionDescription# (#ActionArea#)</cfif>
	   	</td>
    	</tr>
    </cfif>		

	<cfset vac = #DocumentNo#>
	<cfset action = #ActionOrder#>

   </cfif>
   </cfoutput>

   <cfif #URL.IDSorting# neq "DocumentNo">

	<tr><td colspan="11" align="center"><td align="right"><hr></td></tr>   
    <tr>
	    <td colspan="11" align="center">	<!--- Print the sub-total --->
		<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
    </tr>
	<tr><td height="10" colspan="11"></td></tr>
   </cfif>

   </cfoutput>
	
   <tr bgcolor="f7f7f7">
	<td colspan="11" align="center">
	<td align="right"><hr></td>	
   </tr>
 
   <tr bgcolor="f7f7f7">
   	<td colspan="11" align="center">
   	<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>	
   </tr>
  </table>

  <!--- Print a dark blue border --->
  <tr><td height="10" colspan="11" bgcolor="#002350"></td></tr>
  </table> 
  </td>
  </tr>
</table>

<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</form>
</body></html>