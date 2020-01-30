<!-- 
	PersonSearchList.cfm
	
	The purpose of this query is to display a list of persons having the same
	lastname and index number entered in the Person Search page (PersonSearch.cfm)
	
	Modification History:
	15Oct03 - code adapted by MM from Vacancy/Application/CandidateEntryList.cfm
-->	

<cfparam name="PersonNo" default="0">

<script language="JavaScript">
function selectcandidate(docno,persno,indexno,last,first)
{
 	window.open("PersonSearchListSubmit.cfm?ID=" + docno + "&ID1=" + persno + "&ID2=" + indexno + "&ID3=" + last + "&ID4=" + first, "list", "width=500, height=500, toolbar=no, scrollbars=yes, resizable=no");
}
</script>

<!---
<cfset cond = "WHERE LastName LIKE '%%' ">
--->
<cfset cond = "">

<cfif #FORM.LastName# neq "">
   <cfset sLast = trim(#FORM.LastName#)>
   <cfset sLast2 = Replace( #sLast#, "'", "''", "ALL" )>
   <cfset cond = #cond# & " AND LastName LIKE '%#sLast2#%'">
</cfif>

<cfif #FORM.FirstName# neq "">
   <cfset sFirst = trim(#FORM.FirstName#)>
   <cfset sFirst2 = Replace( #sFirst#, "'", "''", "ALL" )>   
   <cfset cond = #cond# & " AND FirstName LIKE '%#sFirst2#%'">
</cfif>

<cfif #FORM.IndexNo# neq "">
   <cfset sIdx = trim(#FORM.IndexNo#)>
   <cfset cond = #cond# & " AND IndexNo LIKE '%#sIdx#%'">
</cfif>

<cfif #FORM.Gender# neq "">
   <cfset cond = #cond# & " AND Gender = '#FORM.Gender#'">
</cfif>

<cfif #FORM.Nationality# neq "-">
   <cfset cond = #cond# & "AND Nationality LIKE '%#FORM.Nationality#%'">
</cfif>

<cf_dialogStaffing>

<!--- Query returning search results --->
<cfquery name="SearchResult" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  P.PersonNo, P.IndexNo, P.FirstName, Upper(P.LastName) AS sLastName, P.MiddleName, 
       		P.Nationality, P.Gender, P.BirthDate, PO.Mission, PA.DateArrival, PA.DateDeparture
    FROM    Person P INNER JOIN PersonAssignment PA ON P.PersonNo = PA.PersonNo
					 INNER JOIN Position PO ON PA.PositionNo = PO.PositionNo
					 INNER JOIN TRAVEL.DBO.Ref_Category C ON P.Category = C.Category
	WHERE   C.TravellerType = 'MILITARY'
  	    	#preserveSingleQuotes(cond)#
	ORDER BY LastName, FirstName
</cfquery>	

<HTML><HEAD>
    <TITLE>Person Search Results</TITLE>
	<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">
</HEAD>	

<body class="dialog" onLoad="window.focus()">

<form action="" method="post" name="documentedit" id="documentedit">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
	<td height="30" class="label">&nbsp;<b>Matching deployed persons</b></td>
  
  	<!---
	<td align="right" class="BannerXL">
    <CF_DialogHeaderSub 
    MailSubject="Employee" 
    MailTo="" 
    MailAttachment="" 
    ExcelFile=""
    CloseButton="Yes">
  	</td>
	--->  
  </tr>
  
  <tr>
  	<td colspan="2">  
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

	<!-- print col headers -->
	<TR bgcolor="#6688aa">
    	<TD class="top"></TD>
	    <TD class="top">PersonNo</TD>
		<TD class="top">IndexNo</TD>
    	<TD class="top">LastName</TD>
	    <TD class="top">FirstName</TD>
    	<TD class="top">Nat.</TD>
	    <TD class="top">Gender</TD>
    	<TD class="top">DOB</TD>   
		<TD class="top">Mission</TD>
	    <TD class="top">Duty Start</TD>
    	<TD class="top">Duty End</TD>   		
	</TR>

	<!-- print any matching records -->
	<cfif SearchResult.recordCount neq 0>
	  <CFOUTPUT query="SearchResult">
	  <cfset sLast3 = Replace( #LastName#, "'", "", "ALL" )>
	  <cfset sFirst3 = Replace( #FirstName#, "'", "", "ALL" )>	  
	  <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
   		<td class="regular">&nbsp;
	    <a href ="javascript:selectcandidate('#Form.DocumentNo#','#PersonNo#','#IndexNo#','#sLast3#','#sFirst3#')">
    	     <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
        </a>&nbsp;
		</td>	

<!---
		<TD class="regular"><A HREF ="javascript:ShowCandidate('#PersonNo#')">#PersonNo#</A></TD>
		<TD class="regular"><A HREF ="javascript:ShowPerson('#IndexNo#')">#IndexNo#</A></TD>
--->
		<TD class="regular">#PersonNo#</TD>
		<TD class="regular">#IndexNo#</TD>
		<TD class="regular">#sLastName#</TD>
		<TD class="regular">#FirstName#</TD>
		<TD class="regular">#Nationality#</TD>
		<TD class="regular">&nbsp;#Gender#</TD>
		<TD class="regular">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>
		<TD class="regular">#Mission#</TD>		
		<TD class="regular">#DateFormat(DateArrival, CLIENT.DateFormatShow)#</TD>
		<TD class="regular">#DateFormat(DateDeparture, CLIENT.DateFormatShow)#</TD>				
	  </TR>
 	  </CFOUTPUT>

	  <TR bgcolor="">
    	<td height="16" colspan="11" class="bannerN"></td>
	  </TR>
	</cfif>
	</table>
	</td>
  </tr>
</table>

</FORM>
</BODY></HTML>