<!--- Create Criteria string for query from data entered thru search form 

Calls: RecordAdd.cfm    (via local Javascript functions)
	   RecordEdit.cfm

--->

<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<HTML>

<HEAD>

<TITLE>Contingent Unit</TITLE>
	
</HEAD>

<body onload="javascript:document.forms.result.page.focus();">

<form action="" method="post" name="result" id="result">

<cfquery name="SearchResult"
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM ContingentUnit
</cfquery>

<table width="100%" border="1" cellspacing="0" cellpadding="0" rules="rows" >

<cfset Page = "1">
<cfset Header = "Contingent unit">
<cfinclude template="../ReferenceHeader.cfm">  

<SCRIPT LANGUAGE = "JavaScript">

function reloadForm(page)
{
     window.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(grp)
{
          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width= 475, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id1)
{
          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width= 475, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</SCRIPT>	
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" bgcolor="#ffffcf" rules="rows">

<tr>
    <TD align="left" class="top4N"></TD>
    <TD align="left" class="top4n">&nbsp;Name</TD>
	<TD align="left" class="top4n">Officer</TD>
    <TD align="left" class="top4n">Entered</TD>
</TR>

<cfoutput query="SearchResult" startrow=#first# maxrows=#No#>
    
    <!--- <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#"> --->
	<TR bgcolor="white">
	<td width="5%" align="center">
	 <img src="#CLIENT.Root#/Images/locate.jpg" alt="" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#CLIENT.Root#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#CLIENT.Root#/Images/locate.jpg'"
				  style="cursor: pointer;" alt="" width="14" height="14" border="0" align="middle" 
				  onClick="javascript:recordedit('#Id#')">
	</td>			
	<TD class="regular">#Name#</TD>
	<TD class="regular">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="regular">#Dateformat(Created, "#CLIENT.dateformatshow#")#</TD>
    </TR>
    <tr bgcolor="E9E9E9"><td height="1" colspan="7"></td></tr>	
	
</CFOUTPUT>

</TABLE>

</td>

</TABLE>

</form>

</BODY></HTML>