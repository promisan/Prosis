<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Generic Logon</proDes>
21sep07 - adjusted references to "../../images/" to "../../../images"; changed input button to use class="input.button1" and class="input.button3"	
 <proCom>Changed release no</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!--- 
	DocumentListingTravel.cfm

	1. View all document actions [deplaying the exact step that is due for easy reference!],
	by mission using different views : pending, etc. and different sorting
	2. Provide hyperlink to the Request Details
	3. This is the view to be used by TRAVEL UNIT

	Revision History:
	30Sep04 - adapted from DocumentListing.cfm (main view for Monitor Request)
	21sep07 - adjusted references to "../../images/" to "../../../images"				
			- changed input button to use class="input.button1" and class="input.button3"
--->
<html><head><title>Personnel Requests</title></head>

<div class="screen">

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>">

<cfset CLIENT.DataSource = "AppsTravel">

<cf_PreventCache>

<script language = "JavaScript">
// 29Jul03 - added params docno, lastname, and lo
function reloadForm(docno,olastname,ilastname,perm,group,page,mission,st2,fill,tustaff,area3,lo) {
    window.location="DocumentListingTravel.cfm?IDDocumentNo=" + docno + 
									   "&IDoLastName=" + olastname +
									   "&IDiLastName=" + ilastname +
									   "&IDP_Mission=" + perm + 
									   "&IDSorting=" + group + 
									   "&Page=" + page + 
									   "&IDMission=" + mission + 
									   "&IDStatus=" + st2 + 
	                                   "&IDClass=" + fill + 
									   "&IDTuStaff=" + tustaff + 
									   "&IDArea=" + area3 + 
									   "&IDLayout=" + lo;
}

function my_alert() {
	alert("Icon indicates that request was submitted to travel unit within 21 days of expected deployment.");
}

// start of 29Jul04 additions
function clearname() {
	document.forms.result.olast.value,ilast.value = ""
}

function clearno() {
	document.forms.result.doc.value = ""
}

function search() {
	if (window.event.keyCode == "13") {
		document.forms.result.submitgo.click()
	}
}
// end of 29Jul04 additions
</script>	

<cf_dialogStaffing>
<cfinclude template="Dialog.cfm">

<cfparam name="URL.IDDocumentNo" 	default="">
<cfparam name="URL.IDoLastName"   	default="">
<cfparam name="URL.IDiLastName"   	default="">
<cfparam name="URL.IDP_Mission" 	default=0>
<cfparam name="URL.IDMission" 		default="All">
<cfparam name="URL.IDInbox"   		default="false">
<cfparam name="URL.IDClass"   		default="">
<cfparam name="URL.IDStatus"  		default="0">
<cfparam name="URL.IDTuStaff"  		default="All">
<cfparam name="URL.IDArea"  		default="All">
<cfparam name="URL.IDSorting" 		default="DocumentNo">
<cfparam name="URL.IDLayout"  		default="Listing">

<!--- dropdown for field mission 
      1. check if user is authorized to access all field missions --->
<cfquery name="AuthorizedForAllMissions" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT A.Mission FROM ActionAuthorization A INNER JOIN FlowAction F ON A.ActionId = F.ActionId
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
	WHERE D.Status = #URL.IDStatus#
	<cfif #URL.IDClass# NEQ ""><cfoutput>
	AND   D.ActionClass = '#URL.IDClass#'
	</cfoutput></cfif>
	AND   EXISTS (SELECT AA.*
				  FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
				  WHERE AA.ActionId = FA.ActionID
				  AND   FA.ActionClass = RT.TravellerTypeCode
				  AND   RT.TravellerType = RC.TravellerType
			  	  AND   AA.AccessLevel <> '9'
				  AND   AA.UserAccount = '#SESSION.acc#'
				  <cfif NOT #CanAccessAllMissions#><cfoutput>AND AA.Mission = D.Mission</cfoutput></cfif>
				  AND   RC.Category = D.PersonCategory )
	ORDER BY D.Mission
</cfquery>	

<!--- dropdown select mission for view --->
<cfquery name="p_mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT D.PermanentMissionId, PM.Description FROM Document D, Ref_PermanentMission PM
	WHERE D.PermanentMissionId = PM.PermanentMissionId
	AND   D.Status = #URL.IDStatus#
	AND   EXISTS (SELECT AA.*
				  FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
				  WHERE AA.ActionId = FA.ActionID
				  AND   FA.ActionClass = RT.TravellerTypeCode
				  AND   RT.TravellerType = RC.TravellerType
			  	  AND   AA.AccessLevel <> '9'
				  AND   AA.UserAccount = '#SESSION.acc#'
				  <cfif NOT #CanAccessAllMissions#><cfoutput>AND AA.Mission = D.Mission</cfoutput></cfif>				  
				  AND   RC.Category = D.PersonCategory )
	<cfif #URL.IDClass# NEQ ""><cfoutput>
	AND   D.ActionClass = '#URL.IDClass#'
	</cfoutput></cfif>
	ORDER BY PM.Description
</cfquery>

<!--- TravellerType --->
<cfquery name="AuthorizedPostType" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT RT.TravellerType AS PostType
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY RT.TravellerType
</cfquery>

<!--- FlowClass --->
<cfquery name="Class" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#" cachedWithin="#CreateTimeSpan(0,0,2,0)#">
	SELECT DISTINCT FC.ActionClass, FC.Description
	FROM ActionAuthorization AA, FlowAction FA, FlowClass FC
	WHERE FA.ActionClass = FC.ActionClass
	AND   AA.ActionId = FA.ActionID
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
</cfquery>

<!--- Request Status --->
<cfquery name="Status" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#" cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT * FROM  Ref_Status WHERE Class = 'Document'
</cfquery>

<!--- TU Staff responsible -- added 040202 --->
<!--- List only TU staff for documents and status currently displayed --->
<cfquery name="TuStaff" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#" cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT DISTINCT T.* FROM TuStaff T, Document D 
	WHERE T.TuStaff = D.TuStaff
	AND   D.Status = #URL.IDStatus#
	ORDER BY FullName
</cfquery>

<!--- start of 29Jul04 additions --->
<cfif #URL.IDiLastName# neq "">
    <cfset actilast = "%#URL.IDiLastName#%">
<cfelse>
	<cfset actilast = "%%">
</cfif>

<cfif #URL.IDoLastName# neq "">
    <cfset actolast = "%#URL.IDoLastName#%">
<cfelse>
	<cfset actolast = "%%">
</cfif>

<cfif #URL.IDDocumentNo# neq "">
    <cfset actdocument = "#URL.IDDocumentNo#">
	<cfset actdocument1 = "#URL.IDDocumentNo#">
<cfelse>
	<cfset actdocument = "0">
	<cfset actdocument1 = "9999999">
</cfif>
<!--- end of 29Jul04 additions --->

<cfif #URL.IDClass# neq "">
    <cfset actclass = #URL.IDClass#>
<cfelse>
	<cfset actclass = "%%">
</cfif>

<!--- drop temp table that might be still on the server --->
<CF_DropTable dbName="#CLIENT.Datasource#" tblName="tmp#SESSION.acc#">

<!--- show all or only requests for field missions that user has access to --->
<cfif #CanAccessAllMissions#>
	<cfset select = "spActionListingAllMissions">
<cfelse>	
	<cfset select = "spActionListing">
</cfif>
<cfstoredproc procedure="#select#" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
 
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERID"  	  value="#SESSION.acc#" 		null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@STATUS"  	  value="#URL.IDStatus#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SORT"    	  value="#URL.IDSorting#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MISSION" 	  value="#URL.IDMission#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INT"     dbvarname="@PERMMISSION" value="#URL.IDP_Mission#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLASS"  	  value="#actclass#"   		null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TUSTAFF"  	  value="#URL.IDTuStaff#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@AREA"  	  value="#URL.IDArea#" 		null="No">
   <!--- start of 29Jul04 additions --->
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@iLASTNAME"	  value="#actilast#"		null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@oLASTNAME"	  value="#actolast#"		null="No">   
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@DOCNO"       value="#actdocument#" 	null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@DOCNO1" 	  value="#actdocument1#" 	null="No">   
   <!--- end of 29Jul04 additions --->
   <cfprocresult name="SearchResult" resultset="1">    
</cfstoredproc>

<!---body class="main" onload="javascript:document.forms.result.page.focus();"--->
<BODY class="main" onload="window.focus()" top="0", bottom="0">

<FORM name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350" height="25" valign="middle">
	<td><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;PM:&nbsp;&nbsp;</font>
    <select name="p_mission" style="background: #C9D3DE;" accesskey="P" title="Permanent Mission Selection" 
	onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,this.value,group.value,page.value,mission.value,stat2.value,fill.value,tustaff.value,area2.value,lay.value)">
	<option value=0 <cfif '#URL.IDP_Mission#' eq "">selected</cfif>><font face="Tahoma" size="1">All</font>
    <cfoutput query="p_mission">
	<option value="#PermanentMissionId#" <cfif #PermanentMissionId# is '#URL.IDP_Mission#'>selected</cfif>>	
	<font face="Tahoma" size="1">#Description#</font>
	</option>
	</cfoutput>
    </select>
    </td>

    <td><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;Field Miss:</font></td>
	<td>	
	<!--- dropdown to select a different mission --->
	<cfif #CanAccessAllMissions#>
	    <select name="mission" style="background: #C9D3DE;" accesskey="P" title="Field Mission Selection" 
		onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,this.value,stat2.value,fill.value,tustaff.value,area2.value,lay.value)">
 		<option value="ALL"><font face="Tahoma" size="1">All</font>
	    <cfoutput query="Mission">
		<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
			<font face="Tahoma" size="1">#Mission#</font>
		</option>
		</cfoutput>
	    </select>
	<cfelse>
	    <select name="mission" style="background: #C9D3DE;" accesskey="P" title="Field Mission Selection" 
		onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,this.value,stat2.value,fill.value,tustaff.value,area2.value,lay.value)">
	    <cfoutput query="Mission">
		<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
			<font face="Tahoma" size="1">#Mission#</font>
		</option>
		</cfoutput>
	    </select>
	</cfif>	
    </td>
    
    <td><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;Stat:</font></td>
	<td>	
	<!--- drop down to filter on a document status --->
	<select name="stat2" style="background: #C9D3DE;" accesskey="P" title="Status Selection" 
		onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,this.value,fill.value,tustaff.value,area2.value,lay.value)">
	    <cfoutput query="Status">
		<option value="#Status#" <cfif #Status# is '#URL.IDStatus#'>selected</cfif>>
			<font face="Tahoma" size="1">#Description#</font>
		</option>
		</cfoutput>
	</select>	
	</td>	
	
    <td align="right"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;Workflow:</font></td>
	<td align="right">
	<!--- drop down to select a action class list --->	
	<select name="fill" style="background: #C9D3DE;" accesskey="P" title="Action Class Selection" 
	onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,stat2.value,this.value,tustaff.value,area2.value,lay.value)">
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
	&nbsp;
	</td>
	
    <td align="right"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;Proc by:</font></td>
	<td align="right">
	<!--- drop down to select TU staff who processed/is processing this request --->	
	<select name="tustaff" style="background: #C9D3DE;" accesskey="P" title="Processed by" 
	onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,stat2.value,fill.value,this.value,area2.value,lay.value)">
    	<option value="" <cfif '#URL.IDTuStaff#' eq "">selected</cfif>>
		<font face="Tahoma" size="1">
		All
		</font>
		</option>
	    <cfoutput query="TuStaff">
		<option value="#TuStaff#" <cfif #TuStaff# is '#URL.IDTuStaff#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#Fullname#
		</font></option>
		</cfoutput>
	</select>
	&nbsp;
	</td>	
  </tr> 	

  <!--- SECOND HEADER LINE --->  
  <tr>
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
   <tr bgcolor="#002350" height="25" valign="middle">
	<td><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;GROUP/SORT BY:</font>
	<!--- drop down to order the screen list --->		
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,this.value,page.value,mission.value,stat2.value,fill.value,tustaff.value,area2.value,lay.value)">
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
		 <OPTION value="Description" <cfif #URL.IDSorting# eq "Description">selected</cfif>>Group by Permanent Mission
    	 <OPTION value="RequestDate" <cfif #URL.IDSorting# eq "RequestDate">selected</cfif>>Group by Request date
    	 <OPTION value="ExpectedDeployment" <cfif #URL.IDSorting# eq "ExpectedDeployment">selected</cfif>>Group by Expected Deployment		 
	     <OPTION value="DutyLength" <cfif #URL.IDSorting# eq "DutyLength">selected</cfif>>Group by Length of TOD
    	 <OPTION value="Created" <cfif #URL.IDSorting# eq "Created">selected</cfif>>Group by record creation date
    	 <OPTION value="ActionDescription" <cfif #URL.IDSorting# eq "ActionDescription">selected</cfif>>Group by workflow step
		 <OPTION value="DocumentNo" <cfif #URL.IDSorting# eq "DocumentNo">selected</cfif>>Sort by Request No
	</select> 
	</td>
	
   	<td align="right"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;Show records for:&nbsp;</font>
	<select name="area2" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,stat2.value,fill.value,tustaff.value,this.value,lay.value)">
		 <OPTION value="All" <cfif #URL.IDArea# eq "All">selected</cfif>>All
		 <cfif #AuthorizedPostType.RecordCount# EQ 1>							<!--- Equal to 1 if user can only access either MILITARY of CIVPOL --->
			<cfif #AuthorizedPostType.PostType# EQ "MILITARY">
				<OPTION value="FGS-All" <cfif #URL.IDArea# eq "FGS-All">selected</cfif>>FGS-All
				<OPTION value="FGS-DO" <cfif #URL.IDArea# eq "FGS-DO">selected</cfif>>FGS-DO
				<OPTION value="FGS-RC" <cfif #URL.IDArea# eq "FGS-RC">selected</cfif>>FGS-RC
			<cfelse>
				<OPTION value="CPD" <cfif #URL.IDArea# eq "CPD">selected</cfif>>CPD
			</cfif>
		 <cfelse>
			<OPTION value="CPD" <cfif #URL.IDArea# eq "CPD">selected</cfif>>CPD
			<OPTION value="FGS-All" <cfif #URL.IDArea# eq "FGS-All">selected</cfif>>FGS-All
			<OPTION value="FGS-DO" <cfif #URL.IDArea# eq "FGS-DO">selected</cfif>>FGS-DO
			<OPTION value="FGS-RC" <cfif #URL.IDArea# eq "FGS-RC">selected</cfif>>FGS-RC
		 </cfif>
    	 <OPTION value="TU" <cfif #URL.IDArea# eq "TU">selected</cfif>>TU
	</select> 
	</td>
	
	<cfinclude template="../../Tools/PageCount.cfm">
	
	<td align="right">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,this.value,mission.value,stat2.value,fill.value,tustaff.value,area2.value,lay.value)">
			 <cfloop index="Item" from="1" to="#pages#" step="1">
    			<cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>#Item# of #pages#</option></cfoutput>
		     </cfloop>	 
	</select>&nbsp;&nbsp;
	</td>
   </tr>
   </table>
   </tr>

   <!--- start of 29Jul04 additions --->
   <!--- THIRD HEADER LINE --->
   <tr>
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
   <tr bgcolor="#D7D7D7" height="25" valign="middle">
	<td colspan="2" class="regular">


	<b>&nbsp;&nbsp;Rotating Person:</b>
    <input type="text" name="olast" value="<cfoutput>#URL.IDoLastName#</cfoutput>" size="15" class="regular" 
	onClick="javascript:clearname()" onKeyUp="javascript:search()">

	<b>&nbsp;&nbsp;Nominee:</b>
    <input type="text" name="ilast" value="<cfoutput>#URL.IDiLastName#</cfoutput>" size="15" class="regular" 
	onClick="javascript:clearname()" onKeyUp="javascript:search()">
	
	<b>&nbsp;&nbsp;Req No:</b>
   	<input class="regular" type="text" name="doc" value="<cfoutput>#URL.IDDocumentNo#</cfoutput>" size="4" 
	 onClick="javascript:clearno()" onKeyUp="javascript:search()">
    
	<input type="button" name="submitgo" value="go" class="input.button1"    
	 onClick="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,stat2.value,fill.value,tustaff.value,area2.value,lay.value)">
	</td>

	<td align="right" class="regular">&nbsp;Layout:&nbsp;
	    <input type="radio" name="layout" value="Listing" <cfif "Listing" is '#URL.IDLayout#'>checked</cfif>     
			onClick="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,stat2.value,fill.value,tustaff.value,area2.value,this.value)"> Listing
	    <input type="radio" name="layout" value="Detail" <cfif "Detail" is '#URL.IDLayout#'>checked</cfif>
			onClick="javascript:reloadForm(doc.value,olast.value,ilast.value,p_mission.value,group.value,page.value,mission.value,stat2.value,fill.value,tustaff.value,area2.value,this.value)"> Detail&nbsp;

		<input type="hidden" name="lay" value="<cfoutput>#URL.IDLayout#</cfoutput>">&nbsp;
	</td>

   </tr>
   </table>
   </tr>
   <!--- start of 29Jul04 additions --->
			
   <!--- Detail column headers --->
   <tr>
   	<td colspan="4">
   	<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

	<!--- Display column static headers --->
	<tr bgcolor="#6688AA" bordercolor="#808080">

	<td width="4%" class="BannerN"></td>
	<td width="6%" class="BannerN">Req #</font></td>
    <td width="17%" class="BannerN">Field Mission / Stat</td>
	<td width="11%" class="BannerN">Perm Mission</td>
	<td width="6%" class="BannerN">Pers Typ</td>	
	<td width="4%" class="BannerN">TOD</td>
	<td width="2%" class="BannerN">&nbsp;</td>
	<td width="2%" class="BannerN">&nbsp;</td>	
	<td width="8%" class="BannerN">Expected Deployment</td>
	<td width="2%" class="BannerN">&nbsp;</td>
    <td width="4%" class="BannerN"># of pers</td>
    <td width="9%" class="BannerN">TA#(s)</td>
    <td width="*" class="BannerN">Created by</td>
	</tr>
   
   	<cfset vac     = "0">
   	<cfset action  = "9999">
   	<cfset amtT    = 0>

	<!--- START OF DATA OUTPUT SECTION --->
	<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

	<cfset amt  = 0>
    
   	<!--- Display ROW containing record group headers --->
	<tr bgcolor="f6f6f6">
   	<cfswitch expression = #URL.IDSorting#>
	     <cfcase value = "Created">
		     <td colspan="13" bgcolor="##FFFFFF"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(Created, "#CLIENT.dateformatshow#")#</b></font></td>
    	 </cfcase>
	     <cfcase value = "ExpectedDeployment">
		     <td colspan="13"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(ExpectedDeployment, "#CLIENT.dateformatshow#")#</b></font></td>
    	 </cfcase>		 
	     <cfcase value = "RequestDate">
		     <td colspan="13"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(Requestdate, "#CLIENT.dateformatshow#")#</b></font></td>
    	 </cfcase>
	     <cfcase value = "DutyLength">
			 <td colspan="13"><font face="Tahoma" size="2"><b>&nbsp;#DutyLength#</b></font></td>
    	 </cfcase>
	     <cfcase value = "Mission">
      		 <td colspan="13"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     	</cfcase>	
     	<cfcase value = "Description">
     		 <td colspan="13"><font face="Tahoma" size="2"><b>&nbsp;#Description#</b></font></td> 
     	</cfcase>	
	     <cfcase value = "ActionDescription">
		     <td colspan="13">
			 	<cfif #ActionArea# eq "TU">
					<cfif #ActionDescription# EQ "Review travel request">
						<font color="FF00FF" face="Tahoma" size="2">
					<cfelseif #ActionDescription# EQ "Initiate travel authorization">
						<font color="FF6600" face="Tahoma" size="2">
					<cfelse>
						<font color="009966" face="Tahoma" size="2">
					</cfif>
					<cfif #ActionDescription# EQ "Close Request">
						<font color="FF0000" face="Tahoma" size="2">
						<b>&nbsp;#ActionDescription#
					<cfelseif #URL.IDTuStaff# EQ "All" OR #URL.IDTuStaff# EQ "TBA">
						<b>&nbsp;#ActionDescription# (#ActionArea#)
					<cfelse>
						<b>&nbsp;#ActionDescription# (#ActionArea#-#TuStaff#)					
					</cfif>
				<cfelseif #ActionArea# eq "FGS-RC">
					<font color="0000CC" face="Tahoma" size="2"><b>&nbsp;#ActionDescription# (#ActionArea#)
				<cfelse>
					<font color="800000" face="Tahoma" size="2"><b>&nbsp;#ActionDescription# (#ActionArea#)			
				</cfif>
				</b></font>
			</td>
    	 </cfcase>
   	</cfswitch>   
   	</tr>

	<!--- DETAIL RECORD SECTION  --->
	<cfoutput>
		
	<cfif (#DocumentNo# eq #vac# and #ActionOrder# eq #action#) or (#ActionStatus# eq "1" and #Status# eq "0")>

     <!--- don't show line --->
	 
	<cfelse>
   		<!--- If displaying grouped records ... --->
		<cfif #PersonNo# eq "0">
			<tr bgcolor="C0C0C0"><td height="1" colspan="13" class="top2"></td></tr>	

			<!--- 26Apr04 - if Attention flag is true, display whole line in RED 
			<cfif #Attention#>
			<tr bgcolor="FF3300">
			<cfelse>
			<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">		
			</cfif>			--->
			<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">

				<!--- 30Jul04 - if Attention flag is true, display doc icon in red, else yellow --->
				<td align="center" valign="middle">
				<cfif #Attention#>
					<a href="javascript:showdocument('#DocumentNo#','ZoomIn')">
					<img src="../../../Images/" alt="" width="15" height="12" border="0" align="top">
					</a>
				<cfelse>
					<a href="javascript:showdocument('#DocumentNo#','ZoomIn')">
					<img src="../../../Images/document.jpg" alt="" width="15" height="12" border="0" align="top">
					</a>	
				</cfif>
				<!--- end of 30Jul04 modification --->				
				</td>	
				<td class="regular">#DocumentNo#</td>
				<td class="regular">#Mission#</td>
				<td class="regular">#Description#</td>
	    		<td class="regular">#PersonCategory#</td>		
		    	<td class="regular">#DutyLength#</td>
				<td class="regular">&nbsp;</td>
			    <td class="regular">&nbsp;</td>	
	    		<td class="regular">&nbsp;</td>				
				<td align="left">
				<cfif #SearchResult.SubmitToTu# AND (#SearchResult.ProcDaysGiven# LT 22 AND #SearchResult.ProcDaysGiven# GT 0)>
					<a href="javascript:my_alert()" title="Icon indicates that request was submitted to travel unit within 21 days of expected deployment.">
					<img src="../../../Images/alert.jpg" alt="" width="13" height="12" border="0" align="top">
					</a>	
				<cfelse>
					&nbsp;
				</cfif>
				</td>
	    		<td class="regular">&nbsp;</td>
		    	<td class="regular">#TaNumber#</td>				
    			<td class="regular">#OfficerUserFirstName# #OfficerUserLastName#</td>
				<!---
		    	<td class="regular">#Dateformat(Created, "#CLIENT.dateformatshow#")#</td>
				--->
    		</tr>
		
			<cfset Amt = Amt + 1>
	    	<cfset AmtT = AmtT + 1>
		
		<cfelse>

	    	<cfif #Status# eq "0">
    			<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	    		<!---td colspan="2" align="center"></td--->
				<td>
			    <button class="input.button3" onClick="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#','#ActionOrder#')">
      			  <img src="../../../Images/user.JPG" alt="" width="14" height="14" border="0" align="bottom">
		    	</button>
    			</td>
    		</cfif>
		
		</cfif>
	
		<!--- Print second (action status) line in the record detail --->
		<cfif #Status# EQ "0" AND #URL.IDSorting# NEQ "ActionDescription">
			<!--- 26Apr04 - if Attention flag is true, display whole line in RED 
			<cfif #Attention#>
			<tr bgcolor="FF3300">		
			<cfelse>
			<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">		
			</cfif>
			--->
			<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">		
				<td>&nbsp;</td>		
				<td colspan="4" align="left" class="regular">
				  <cfif #ActionArea# eq "TU">
					<cfif #ActionDescription# EQ "Review travel request">
						<font color="FF00FF">
					<cfelseif #ActionDescription# EQ "Initiate travel authorization">
						<font color="FF6600">
					<cfelse>
						<font color="009966">
					</cfif>
					<cfif #ActionDescription# EQ "Close Request">
						<font color="FF0000">
						<b>&nbsp;#ActionDescription#
					<cfelse>
						<b>&nbsp;#ActionDescription# (#ActionArea#-#TuStaff#)
					</cfif>	
				  <cfelseif #ActionArea# eq "FGS-RC">
					<font color="0000CC"><b>&nbsp;#ActionDescription# (#ActionArea#)
				  <cfelse>
					<font color="800000"><b>&nbsp;#ActionDescription# (#ActionArea#)			
				  </cfif>
					</b></font>
				</td>				
				<!--- print substantive office remarks if not null --->
				<td colspan="9" class="regular" align="left">
				<cfif #sRemarks# NEQ "">
					<cfif #ActionClass# EQ "1" OR #ActionClass# EQ "2">FGS: <cfelse>CPD: </cfif>
					#sRemarks#
				<cfelse>
					&nbsp;
				</cfif>
				</td>    	
			</tr>
		<cfelse>
			<!--- print line for substantive office remarks only if NOT null --->
			<cfif #sRemarks# NEQ "">
				<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">				
					<td colspan="4" class="regular">&nbsp;</td>
					<td colspan="9" class="regular" align="left">
					<cfif #sRemarks# NEQ "">
						<cfif #ActionClass# EQ "1" OR #ActionClass# EQ "2">FGS: <cfelse>CPD: </cfif>
						#sRemarks#
					</cfif>
					</td>    	
				</tr>
			</cfif>
			
		</cfif>			
			
		<!--- If Travel Remarks field is not NULL, display Travel Unit remarks in another line --->
		<cfif #sRemarksTvl# NEQ "">
			<cfif #Attention#>
				<tr bgcolor="FF3300">		
			<cfelse>
				<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">		
			</cfif>
				  <cfif #URL.IDSorting# EQ "ActionDescription">
					<cfif #sRemarks# EQ "">
						<td colspan="4" align="left" class="regular">&nbsp;</td>
					<cfelse>
						<td colspan="4" align="left" class="regular">&nbsp;</td>
					</cfif>
				  <cfelse>
						<td colspan="4" align="left" class="regular">&nbsp;</td>
				  </cfif>
				  <td colspan="9" class="regular" align="left">&nbsp;TU: #sRemarksTvl#</td>
		   		</tr>
		</cfif>
    </cfif>		

	<cfset DocCurrentRow = #CurrentRow#>

	<!--- Display nominee details section --->
	<cfif #URL.IDLayout# EQ "Detail">	
		<!-- Get expected deployment dates from candidate of current document --->
		<cfquery name="GetCandidateDate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    		SELECT PlannedDeployment, Count(PersonNo) AS PersCount
			FROM  DocumentCandidate	
			WHERE DocumentNo = #DocumentNo#
			AND  (Status = '0' OR Status = '3')
			GROUP BY PlannedDeployment
			ORDER BY PlannedDeployment
		</cfquery>
		
		<cfif #GetCandidateDate.RecordCount# GT 0>
			<tr bgcolor="#IIf(DocCurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
				<td colspan="13">
				<cfinclude template="DocumentExpDeploymentTravel.cfm">
				</td>
			</tr>
		</cfif>
	</cfif>
		
	<cfset vac = #DocumentNo#>
	<cfset action = #ActionOrder#>

	</cfoutput>
	<!--- END OF DETAIL RECORD SECTION --->     
	
	<!--- If grouped records, display subtotal section --->
	<cfif #URL.IDSorting# neq "DocumentNo">
		<tr><td colspan="12" align="center"><td align="right"><hr></td></tr>   
    	<tr>
			<td colspan="12" align="center">	
			<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
    	</tr>
		<tr><td  colspan="13" height="10"></td></tr>
	</cfif>

	</cfoutput>
   <!--- END OF DATA OUTPUT SECTION --->
	
   <tr bgcolor="f7f7f7">
	<td colspan="12" align="center">
	<td align="right"><hr></td>	
   </tr>
 
   <tr bgcolor="f7f7f7">
   	<td colspan="12" align="center">
   	<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>	
   </tr>
  </table>

  <!--- Print a dark blue border --->
  <tr><td colspan="13" height="10"bgcolor="#002350"></td></tr>
  </table> 
  </td>
  </tr>
</table>

<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</FORM>
</BODY>
</div>
</html>