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
<html>

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Program</title>
</head>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<link href="../../../../print.css" rel="stylesheet" type="text/css" media="print">


<!--- headers and necessary Params for recommendations --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfparam name="URL.AuditId" default="">



<cfset #CLIENT.Verbose# = #URL.Verbose#>

<cfset cnt = "40">

<table><tr><td height="1"></td></tr>


<cfquery name="GetObservations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
   FROM ProgramAudit.dbo.AuditObservation
   WHERE AuditId='#URL.AuditId#'
</cfquery>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
  <tr>
  	<td height="24" valign="middle" class="top3nd">&nbsp;
	<b>Observations </b></td>
		

	
  </tr>
  
  <cfif GetObservations.recordcount eq "0">
  
  	<TR><td height="15" colspan="4" align="center">&nbsp;<b>No details recorded</b></td><TR>
	<cfset cnt = #cnt#+25>
  <cfelse>

  <cfset cnt = #cnt#+19>

  
  <tr>
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse">
	
    <TR>

       <td widht="5%" class="top3N">&nbsp;</td>
	   <TD width="80%" class="top3N">&nbsp;Description</TD>
   	   <TD width="15%" class="top3N">&nbsp;Target Date</TD>

     
   </TR>

 
   <cfoutput query="GetObservations">
  <cfset cnt = #cnt#+19>
   <tr>
      <td class="regular">&nbsp;&nbsp;</td>
	  <td class="regular">&nbsp;#Description#</td>
	  <td class="regular">&nbsp;#DateFormat(TargetDate,CLIENT.DateFormatShow)#</td>
   </tr> 	  
   <tr><td height="1" colspan="7" class="header"></td></tr>
   
   </CFOUTPUT>
   
   </cfif>
   
   
</TABLE>
</td>
</table>



<cfoutput>

	<script language="JavaScript">
	
	{
	
	frm  = parent.document.getElementById("i#URL.row#");
	he = #cnt#;
	frm.height = he;
	}
	
	</script>
	
</cfoutput>

</body>

</html>