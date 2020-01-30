
<!--- the purpose of this template is

1. View all document actions [deplaying the exact step that is due for easy 
reference!],
by mission using different views : pending, etc. and different sorting

2. Provide an option to show only those vacacies/candidate that require 
action of the
person this is currently logged (SESSION.acc) in

3. Provide hyperlink to the actual document action or candidate action

--->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML>

<HEAD>

<TITLE>Document Listing</TITLE>

</HEAD>

<cfoutput>

<script>

function reloadForm(layout,last,index,group,page,fill,inbox)

{

if (layout !== "Vacancy")

{
   window.location="ControlListingTravel.cfm?IDLayout=" + layout + 
"&IDLastName=" + last + "&IDIndexNo=" + index + "&IDInbox=" + inbox + 
"&IDClass=" + fill + "&IDSorting=" + group + "&Page=" + page + "&ID1=#URL.ID1#&ID2=#URL.ID2#";
}

else

{
    window.location="ControlListing.cfm?IDInbox=" + inbox + "&IDClass=" + 
fill + "&ID1=#URL.ID1#&ID2=#URL.ID2#";
}

}

function clearname(){
document.forms.result.slast.value = ""
}

function clearno(){
document.forms.result.sindex.value = ""
}


function search() {
if (window.event.keyCode == "13") {
document.forms.result.submitgo.click()
}
}


</script>
</cfoutput>

<cf_wait>

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
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT *
	FROM  Ref_Status
	WHERE Class = 'Document'
</cfquery>

<!--- dropdown --->
<cfquery name="Class"
datasource="AppsVacancy"
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
<CF_DropTable dbName="AppsVacancy" tblName="tmp#SESSION.acc#">

<!---  select first only the candidates that meet the condition for the view --->

<cfset FileNo = "">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp1"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp10">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp11">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp12">

<cfquery name="Step1"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#">
SELECT DISTINCT VA.DocumentNo, VA.PersonNo, A.IndexNo
INTO  userQuery.dbo.#SESSION.acc#tmp1
FROM  DocumentCandidateAction VA, 
      FlowActionView VW,
      Applicant.dbo.Applicant A
WHERE  VW.ActionId = VA.ActionId
 AND   VW.ConditionForView = 'Select'
 AND   VW.ConditionActionStatus = VA.ActionStatus
 AND   A.PersonNo = VA.PersonNo
</cfquery>
 
<cfquery name="Step2"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#"> 
  SELECT DISTINCT VA.DocumentNo, VC.PersonNo, VC.LastName, 
	       VC.FirstName, VW.IndexNo, VC.DateArrivalExpected, VC.ReAssignmentFrom, VC.Remarks,
		   MAX(ActionOrderSub) as ActionOrderSub
	INTO  userQuery.dbo.#SESSION.acc#tmp10
	FROM  Document V, 
	      DocumentCandidate VC,
	      DocumentCandidateAction VA, 
	      userQuery.dbo.#SESSION.acc#tmp1 VW
	WHERE V.DocumentNo    = VA.DocumentNo
	AND   VC.PersonNo     = VA.PersonNo
	AND   VC.DocumentNo   = VA.DocumentNo
	AND   V.Status       <> '9'
	AND   VC.Status       = '0' 
	AND   VA.ActionStatus = '1'
	AND   VW.PersonNo     = VC.PersonNo
	AND   VW.DocumentNo   = VC.DocumentNo
	GROUP BY VA.DocumentNo, VC.PersonNo, VC.LastName, VC.FirstName, VW.IndexNo, VC.DateArrivalExpected, VC.ReAssignmentFrom, VC.Remarks
	ORDER BY VA.DocumentNo, VC.PersonNo, VC.LastName, VC.FirstName, VW.IndexNo, VC.DateArrivalExpected, VC.ReAssignmentFrom, VC.Remarks
	</cfquery>
	
    <!--- search candidates last step details --->

	<cfquery name="Step3"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#"> 
    SELECT 	V.*, C.PersonNo, C.LastName, C.FirstName, C.IndexNo, C.DateArrivalExpected, C.ReAssignmentFrom, C.Remarks AS CandidateRemarks,
			A.ActionOrder, A.ActionCompleted, A.ActionOrderSub, VA.ActionStatus, VA.ActionLastName, 
			VA.ActionFirstName, VA.ActionDate, A.ActionArea
    INTO  	userQuery.dbo.#SESSION.acc#tmp11
    FROM 	Document V, 
       		DocumentCandidateAction VA, 
			userQuery.dbo.#SESSION.acc#tmp10 C, 	
			DocumentFlow A
    WHERE 	V.DocumentNo      =  VA.DocumentNo
    AND    VA.DocumentNo      =  C.DocumentNo
    AND    VA.PersonNo        =  C.PersonNo
    AND    A.ActionOrderSub   =  C.ActionOrderSub
    AND    VA.ActionId        =  A.ActionId
    AND    VA.DocumentNo      =  A.DocumentNo
    AND    V.Mission     LIKE '#actmission#'
    AND    V.Status           =  #URL.IDStatus#
    AND    V.ActionClass LIKE '#actclass#'
    AND    C.LastName    LIKE '%#actlast#%'
    AND   (C.IndexNo     LIKE '%#actindex#%' or C.IndexNo is NULL)
    ORDER BY #URL.IDSorting#
	</cfquery> 
	
	<cfquery name="Step4"
	datasource="appsEmployee"
	username="#SESSION.login#"
	password="#SESSION.dbpw#"> 
	SELECT  DISTINCT P.IndexNo,
	       G.ContractLevel as Grade, 
	       G.ContractStep as Step
   INTO    userQuery.dbo.#SESSION.acc#tmp12		   
   FROM    PersonContract G INNER JOIN
           Person P ON G.PersonNo = P.PersonNo
   WHERE   P.IndexNo IN (SELECT IndexNo 
	                  FROM userQuery.dbo.#SESSION.acc#tmp11 T)
	AND    G.DateEffective < getDate() 
	AND    G.DateExpiration > getDate()				  
	</cfquery>
	
	<cfquery name="SearchResult"
	datasource="appsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#"> 
	SELECT *
	FROM #SESSION.acc#tmp11 V LEFT OUTER JOIN #SESSION.acc#tmp12 P ON V.IndexNo = P.IndexNo
	ORDER BY #URL.IDSorting#
    </cfquery>
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp1"> 
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp10">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp11">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp12">	


<!--- Query returning search results --->

<body leftmargin="4" topmargin="4" rightmargin="1" onLoad="javascript:document.forms.result.page.focus();">

<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" frame="all">
  <tr>
    <td height="20" class="top3n">&nbsp;
	
	<cfoutput><b>#URL.ID1# #URL.ID2#<b></b></cfoutput></b>
	
    </td>

  <td align="right" class="top3n">

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
<TD bgcolor="#6688AA" height="24">&nbsp;

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
	<option value="#ActionClass#" <cfif #ActionClass# is '#URL.IDClass#'>selected</cfif>>
	<font face="Tahoma" size="1">#Description#</font></option>
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

<table width="100%" border="0" cellspacing="0" cellpadding="0" 
align="center" class="formpadding">

<tr bgcolor="#8EA4BB">
    <TD colspan="4" class="top2">Name</TD>
	<TD align="left" class="top2">IndexNo</TD>
	<TD width="7%" align="left" class="top2">Level</TD>
	<TD align="left" class="top2">Reass.from</TD>
	<td colspan="3" align="right" class="top2">Action last completed&nbsp;</td>
</TR>

<cfif #URL.IDLayout# eq "Detail">
    <tr bgcolor="#8EA4AA">

	<TD class="top4n"></TD>
	<TD align="left" class="top4n">VA</TD>
	<TD align="left" class="top4n">Grade</TD>
	<td colspan="2" align="left" class="top4n">Position</td>
	<TD align="left" class="top4n">Mission</TD>
	<TD align="left" class="top4n">ETA</TD>
    <TD align="right" class="top4n">Officer</TD>
	<td align="right" class="top4n">Date</td>
	<TD class="top4n"></TD>
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
   <input type="button" name="submitgo" value="Go" class="button7"
   
onClick="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,1,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
</td>
	<td colspan="4" align="right" class="regular">
	&nbsp;
    <input type="radio" name="layout" value="Vacancy" <cfif "Vacancy" is '#URL.IDLayout#'>checked</cfif>
     onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,1,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	 Vacancy
     <input type="radio" name="layout" value="Listing" <cfif "Listing" is '#URL.IDLayout#'>checked</cfif>
	onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,page.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	Listing&nbsp;
	 <input type="radio" name="layout" value="Detail" <cfif "Detail" is '#URL.IDLayout#'>checked</cfif>
	onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,page.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	Detail&nbsp;
	<input type="hidden" name="lay" value="<cfoutput>#URL.IDLayout#</cfoutput>">

	</td>

</tr>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

   <cfset amt    = 0>

   <tr bgcolor="f6f6f6">

   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "Duedate">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(Duedate, "#CLIENT.DateFormatShow#")#</b></font></td>
     </cfcase>
     <cfcase value = "Created">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(Created, "#CLIENT.DateFormatShow#")#</b></font></td>
     </cfcase>
     <cfcase value = "ActionOrder"></cfcase>
     <cfcase value = "Mission">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td>
     </cfcase>
     <cfcase value = "DocumentNo"></cfcase>
     <cfcase value = "LastName"></cfcase>
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
	    <font color="000080"><b>
		<a href="javascript:showdocumentcandidatearea('#DocumentNo#','#PersonNo#','Travel Unit')">&nbsp;#LastName#, #FirstName#</a></b>
    	</td>
		 <td colspan="1" align="left" class="regular">
	       <font color="000080"><b><a href="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a></b>
         </td>

		<cfquery name="Level"
          datasource="AppsEmployee"
          maxrows=1
          username="#SESSION.login#"
          password="#SESSION.dbpw#">
		  SELECT     Grade.ContractLevel as Grade, Grade.ContractStep as Step
		  FROM       PersonContract Grade INNER JOIN
                      Person P ON Grade.PersonNo = P.PersonNo
		  WHERE IndexNo = '#IndexNo#'
		  ORDER BY Grade.DateExpiration DESC
		  </cfquery>


		 <td colspan="1" align="left">
	       <b>#Level.Grade#<cfif #Level.Step# neq "">/#Level.Step#</cfif></b>
         </td>

		  <td colspan="1" align="left">
	       <b>#ReassignmentFrom#</b>
         </td>

    	<td colspan="3" align="right">
    	<cfif #Status# eq "0">&nbsp;#ActionCompleted#&nbsp;</cfif>
    	</td>

	<cfelse>

	   	<td colspan="4" align="left">
	      <a href="javascript:showdocumentcandidatearea('#DocumentNo#','#PersonNo#','Travel Unit')">&nbsp;#LastName#, #FirstName#</a>
    	</td>
		 <td colspan="1" align="left">
	       <a href="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a>
         </td>

		<cfquery name="Level"
          datasource="AppsEmployee"
          maxrows=1
          username="#SESSION.login#"
          password="#SESSION.dbpw#">
		  SELECT     Grade.ContractLevel as Grade, Grade.ContractStep as Step
		  FROM       PersonContract Grade INNER JOIN
                      Person P ON Grade.PersonNo = P.PersonNo
		  WHERE IndexNo = '#IndexNo#'
		  ORDER BY Grade.DateExpiration DESC
		  </cfquery>

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

	<TD>&nbsp;<a href="javascript:showdocument('#DocumentNo#','ZoomIn')">#DocumentNo#</a></TD>
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
"#CLIENT.DateFormatShow#")#&nbsp;</td>
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
	<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>
  </TR>

</TABLE>

</td></tr>

</TABLE>

</td></tr>

</table>

</form>

<cf_waitEnd>

</BODY></HTML>
