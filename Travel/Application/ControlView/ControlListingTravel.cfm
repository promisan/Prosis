
<!--- the purpose of this template is

1. View all document actions [deplaying the exact step that is due for easy 
reference!],
by mission using different views : pending, etc. and different sorting

2. Provide an option to show only those vacacies/candidate that require 
action of the
person this is currently logged (SESSION.acc) in

3. Provide hyperlink to the actual document action or candidate action

--->

<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<!--- tools : verify is user is authenticated through login menu --->


<!--- tools : prevent caches, disabled back button --->
<cf_PreventCache>

<HTML>

<HEAD>

<TITLE>Document Listing</TITLE>

</HEAD>

<cfoutput>

<SCRIPT LANGUAGE = "JavaScript">

function reloadForm(layout,last,index,group,page,fill,inbox)

{

if (layout !== "Vacancy")

{
   window.location="DocumentListingTravel.cfm?IDLayout=" + layout + 
"&IDLastName=" + last + "&IDIndexNo=" + index + "&IDInbox=" + inbox + 
"&IDClass=" + fill + "&IDSorting=" + group + "&Page=" + page + "&ID1=#URL.ID1#&ID2=#URL.ID2#";
}

else

{
    window.location="DocumentListing.cfm?IDInbox=" + inbox + "&IDClass=" + 
fill + "&ID1=#URL.ID1#&ID2=#URL.ID2#";
}

}

function clearname()

{

document.forms.result.slast.value = ""

}

function clearno()

{

document.forms.result.sindex.value = ""

}


function search()

{

if (window.event.keyCode == "13")

{

document.forms.result.submitgo.click()

}

}


</SCRIPT>
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog 
screens --->
<cf_dialogStaffing>
<cfinclude template="../Dialog.cfm">

<cfparam name="URL.IDInbox"    default="false">
<cfparam name="URL.IDStatus"   default="0">
<cfparam name="URL.IDClass"    default="">
<cfparam name="URL.IDSorting"  default="LastName">
<cfparam name="URL.IDLayout"   default="Detail">
<cfparam name="URL.IDLastName" default="">
<cfparam name="URL.IDIndexNo"  default="">

<!--- dropdown --->
<cfquery name="Status"
datasource="#CLIENT.Datasource#"
username="#SESSION.login#"
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT *
	FROM  Ref_Status
	WHERE Class = 'Document'
</cfquery>

<!--- dropdown --->
<cfquery name="Class"
datasource="#CLIENT.Datasource#"
username="#SESSION.login#"
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT *
	FROM  FlowClass
</cfquery>

<!--- define database filter criteria --->

<cfparam name="URL.IDMission" default="%%">

<cfif #URL.ID1# neq "">
    <cfset actmission = #URL.ID1#>
<cfelse>
	<cfset actmission = "%%">
</cfif>

<cfif #URL.IDClass# neq "">
    <cfset actclass = #URL.IDClass#>
<cfelse>
	<cfset actclass = "%%">
</cfif>

<cfif #URL.IDLastName# neq ''>
    <cfset actlast = "#URL.IDLastName#">
<cfelse>
	<cfset actlast = "">
</cfif>

<cfif #URL.IDIndexNo# neq ''>
    <cfset actindex = "#URL.IDIndexNo#">
<cfelse>
	<cfset actindex = "">
</cfif>

<!--- drop temp table that might be still on the server --->
<CF_DropTable dbName="#CLIENT.Datasource#" tblName="tmp#SESSION.acc#">

<!--- show all or only vacancies that require action from the user --->
<cfif #URL.IDInbox# is "false">
  <cfset select = "spActionListingTravel">
<cfelse>
  <cfset select = "spActionListingTravel">
</cfif>

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
   dbvarname="@STATUS"
   value="#URL.ID2#" null="No">

   <cfprocparam type="In"
   cfsqltype="CF_SQL_VARCHAR"
   dbvarname="@SORT"
   value="#URL.IDSorting#" null="No">

   <cfprocparam type="In"
   cfsqltype="CF_SQL_VARCHAR"
   dbvarname="@MISSION"
   value="#actmission#" null="No">

   <cfprocparam type="In"
    cfsqltype="CF_SQL_VARCHAR"
	dbvarname="@CLASS"
	value="#actclass#" null="No">

	<cfprocparam type="In"
    cfsqltype="CF_SQL_VARCHAR"
	dbvarname="@LASTNAME"
	value="%#actlast#%" null="No">

	<cfprocparam type="In"
    cfsqltype="CF_SQL_VARCHAR"
	dbvarname="@INDEXNO"
	value="%#actindex#%" null="No">

   <!--- identify all actions --->
   <cfprocresult name="SearchResult" resultset="1">

</cfstoredproc>

<!--- Query returning search results --->

<body class="dialog" onload="javascript:document.forms.result.page.focus();">

<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" 
bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
    <td height="20" class="bannerN">&nbsp;
	
	<cfoutput><b>#URL.ID1# #URL.ID2#<b></b></cfoutput></b>
	
    </td>

  <td align="right" class="bannerN">

    <!--- option to select only vacancies that require action of the user
    <input type="checkbox" name="inbox" value="1" <cfif "1" is 
'#URL.IDInbox#'>checked</cfif>
	onClick="javascript:reloadForm(result.group.value,result.page.value,result.mission.value,result.status.value,result.fill.value,this.checked)"
	style="background: #002350; font: larger; color: White;">

	<font face="Tahoma" size="2" color="#FFFFFF"><b>Show only Vacancies that 
require my Action</b></font>&nbsp;&nbsp;
	--->

  </td>

  </tr>

  <tr><td width="2"></td>

<table width="100%" border="1" cellspacing="0" cellpadding="0" 
align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: 
collapse">
<tr>
<TD bgcolor="#6688AA" height="30">&nbsp;

<!--- drop down to select a action class list --->
<select name="fill" style="background: #C9D3DE;" accesskey="P" title="Status 
Selection"
onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,page.value,this.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    <option value="" <cfif '#URL.IDClass#' eq "">selected</cfif>>
	<font face="Tahoma" size="1">
	All
	</font>
	</option>
    <cfoutput query="Class">
	<option value="#ActionClass#" <cfif #ActionClass# is 
'#URL.IDClass#'>selected</cfif>>
	<font face="Tahoma" size="1">
	#Description#
	</font></option>
	</cfoutput>
    </select>

<!--- drop down to order the screen list --->
<select name="group" size="1" style="background: #C9D3DE;"
onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,this.value,1,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
	 <OPTION value="LastName" <cfif #URL.IDSorting# eq 
"LastName">selected</cfif>>Sort by LastName
     <OPTION value="Created" <cfif #URL.IDSorting# eq 
"Created">selected</cfif>>Sort by Vacancy Creation date
     <option value="Mission" <cfif #URL.IDSorting# eq 
"Mission">selected</cfif>>Group by Mission
	 <option value="ActionOrder" <cfif #URL.IDSorting# eq 
"ActionOrder">selected</cfif>>Group by Status
     <OPTION value="PostGrade" <cfif #URL.IDSorting# eq 
"PostGrade">selected</cfif>>Group by Post grade
	 <OPTION value="DocumentNo" <cfif #URL.IDSorting# eq 
"DocumentNo">selected</cfif>>Sort by Document No

</SELECT>

</TD>
<td bgcolor="#6688AA" align="right">

<!--- drop down to select only a number of record per page using a tag in 
tools --->
    <cfinclude template="../../../Tools/PageCount.cfm">
<select name="page" size="1" style="background: #C9D3DE;"
onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,this.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq 
"#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>
</SELECT> &nbsp;
</TD>
</tr>
<TR>

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="1" 
align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <TD colspan="4" class="top2">Name</TD>
	<TD align="left" class="top2">IndexNo</TD>
	<TD width="7%" align="left" class="top2">Level</TD>
	<TD align="left" class="top2">Reass.from</TD>
	<td colspan="3" align="right" class="top2">Action last completed&nbsp;</td>
</TR>

<cfif #URL.IDLayout# eq "Detail">
    <tr bgcolor="#8EA4AA">

	<TD class="top"></TD>
	<TD align="left" class="top">VA</TD>
	<TD align="left" class="top">Grade</TD>
	<td colspan="2" align="left" class="top">Position</td>
	<TD align="left" class="top">Mission</TD>
	<TD align="left" class="top">ETA</TD>
    <TD align="right" class="top">Officer</TD>
	<td align="right" class="top">Date</td>
	<TD class="top"></TD>
    </TR>
</cfif>

<tr bgcolor="#D7D7D7">

<td colspan="6">
   <font size="1" face="Tahoma"><b>&nbsp;&nbsp;&nbsp;Name:</b>
   <input class="regular" type="text" name="slast" 
value="<cfoutput>#URL.IDLastName#</cfoutput>" size="15" 
onClick="javascript:clearname()" onKeyUp="javascript:search()">

   <font size="1" face="Tahoma"><b>&nbsp;&nbsp;&nbsp;IndexNo:</b>
   <input class="regular" type="text" name="sindex" 
value="<cfoutput>#URL.IDIndexNo#</cfoutput>" size="8" 
onClick="javascript:clearno()" onKeyUp="javascript:search()">
   <input type="button" name="submitgo" value="Go" class="input.button1"
   
onClick="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,1,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
</td>
	<td colspan="4" align="right" class="regular">
	&nbsp;
    <input type="radio" name="layout" value="Vacancy"
     <cfif "Vacancy" is '#URL.IDLayout#'>checked</cfif>
     
onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,1,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	 Vacancy
     <input type="radio" name="layout" value="Listing"
    <cfif "Listing" is '#URL.IDLayout#'>checked</cfif>
	onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,page.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	Listing&nbsp;
	 <input type="radio" name="layout" value="Detail"
    <cfif "Detail" is '#URL.IDLayout#'>checked</cfif>
	onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,page.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	Detail&nbsp;
	<input type="hidden" name="lay" 
value="<cfoutput>#URL.IDLayout#</cfoutput>">

	</td>

</tr>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# 
maxrows=#No#>

   <cfset amt    = 0>

   <tr bgcolor="f6f6f6">

   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "Duedate">
     <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#Dateformat(Duedate, 
"#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "Created">
     <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#Dateformat(Created, 
"#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "ActionOrder">
     <!--- <td colspan="9"><font face="Tahoma" 
size="2"><b>&nbsp;#Dateformat(Duedate, 
"#CLIENT.dateformatshow#")#</b></font></td>--->
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#Mission#</b></font></td>
     </cfcase>
     <cfcase value = "DocumentNo">
     <!--- <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#Mission#</b></font></td>  --->
     </cfcase>
     <cfcase value = "LastName">
     <!--- <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#LastName#</b></font></td>  --->
     </cfcase>
     <cfcase value = "PostGrade">
	 <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#PostGrade#</b></font></td>
     </cfcase>
   </cfswitch>

   </tr>

<CFOUTPUT>

    <cfif #URL.IDLayout# eq "Detail">
	<tr><td height="1" colspan="2" bgcolor=""></td></tr>
	<tr bgcolor="C0C0C0"><td height="1" colspan="10" class="top2"></td></TR>
	<tr><td height="1" colspan="2" bgcolor=""></td></tr>
	<TR bgcolor="EBEBEB">
	<cfelse>
	<TR bgcolor="EBEBEB">
	</cfif>

	<TR bgcolor="EBEBEB">

	<cfset Amt = Amt + 1>
    <cfset AmtT = AmtT + 1>

	<cfif #Status# neq "1">

	<cfif #URL.IDLayout# eq "Detail">

    	<td colspan="4" align="left" class="regular">
	    <font color="000080"><b><a 
href="javascript:showdocumentcandidatearea('#DocumentNo#','#PersonNo#','Travel 
Unit')">&nbsp;#LastName#, #FirstName#</a></b>
    	</td>
		 <td colspan="1" align="left" class="regular">
	       <font color="000080"><b><a 
href="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a></b>
         </td>

		 <cfquery name="Level"
          datasource="AppsVacancy"
          maxrows=1
          username="#SESSION.login#"
          password="#SESSION.dbpw#">
          SELECT *
       	  FROM  StaffGrade
     	  WHERE IndexNo = '#IndexNo#'</cfquery>

		 <td colspan="1" align="left" class="regular">
	       <b>#Level.Grade#<cfif #Level.Step# neq "">/#Level.Step#</cfif></b>
         </td>

		  <td colspan="1" align="left" class="regular">
	       <b>#ReassignmentFrom#</b>
         </td>

    	<td colspan="3" align="right" class="regular">
    	<cfif #Status# eq "0">&nbsp;#ActionCompleted#&nbsp;</cfif>
    	</td>

	<cfelse>

	   	<td colspan="4" align="left" class="regular">
	      <a 
href="javascript:showdocumentcandidatearea('#DocumentNo#','#PersonNo#','Travel 
Unit')">&nbsp;#LastName#, #FirstName#</a>
    	</td>
		 <td colspan="1" align="left" class="regular">
	       <a href="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a>
         </td>

		 <cfquery name="Level"
          datasource="AppsVacancy"
          maxrows=1
          username="#SESSION.login#"
          password="#SESSION.dbpw#">
          SELECT *
       	  FROM  StaffGrade
     	  WHERE IndexNo = '#IndexNo#'</cfquery>

		 <td colspan="1" align="left" class="regular">
	       #Level.Grade#<cfif #Level.Step# neq "">/#Level.Step#</cfif>
         </td>

		  <td colspan="1" align="left" class="regular">#ReassignmentFrom#</td>

    	<td colspan="3" align="right" class="regular">
        	<cfif #Status# eq "0">&nbsp;#ActionCompleted#&nbsp;</cfif>
    	</td>

	</cfif>

    </tr>
    </cfif>

	</tr>

	<cfif #URL.IDLayout# eq "Detail">

	<TR bgcolor="EBEBEB">

	<td rowspan="1" align="left">

	</td>

	</td>

	<TD class="regular">&nbsp;<a 
href="javascript:showdocument('#DocumentNo#','ZoomIn')">#DocumentNo#</a></TD>
	<TD class="regular">#PostGrade#</TD>
	<td colspan="2" class="regular">

	#FunctionalTitle#

	</td>

    <TD class="regular"><cfif #URL.IDMission# neq 
#Mission#>&nbsp;&nbsp;#Mission#</cfif></TD>
	<TD class="regular">
	<cfif #Status# eq "0"><b>&nbsp;#DateFormat(DateArrivalExpected, 
CLIENT.DateFormatShow)#&nbsp;</b></cfif>
	</TD>
    <TD class="regular" align="right">#ActionFirstName# 
#ActionLastName#</TD>
    <td class="regular" align="right">#Dateformat(ActionDate, 
"#CLIENT.dateformatshow#")#&nbsp;</td>
	<td class="regular"></td>


    </TR>

	</cfif>

	<cfset vac = #DocumentNo#>
	<cfset action = #ActionOrder#>

</CFOUTPUT>

<cfif #URL.IDSorting# neq "DocumentNo" and #URL.IDSorting# neq "LastName" >

<TR>
    <td colspan="10" align="center">
	<td align="right"><hr></td>
   </TR>

    <TR>
    <td colspan="10" align="center">
	<td align="right"><font size="1" 
face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>
    </TR>

<tr><td height="10" colspan="10"></td></tr>

</cfif>

</CFOUTPUT>

<TR bgcolor="f7f7f7">
    <td colspan="9" align="center">
	<td align="right"><hr></td>
   </TR>

   <TR bgcolor="f7f7f7">
    <td colspan="9" align="center">
	<td align="right"><font size="1" 
face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>
  </TR>

</TABLE>

</td></tr>
<tr><td height="10" colspan="2" bgcolor="#002350"></td></tr>

</TABLE>

</td></tr>

</table>

<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> 
</p>

</form>

</BODY></HTML>
