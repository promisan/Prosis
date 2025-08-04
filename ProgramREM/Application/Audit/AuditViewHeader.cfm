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
<link href="../../../print.css" rel="stylesheet" type="text/css" media="print">

<script>

function reload()
{ 
   opener.location.reload();
   window.close();
}

function entry()

{
  window.open("AuditEntry.cfm?ParentCode=#ProgramCode#&Period=#Period#&AuditId=#AuditId#&EditCode=#ProgramCode#","_blank")
}

function more(bx,PC,PERIOD,AUDIT)
	
	 {
	 
		se   = document.getElementById(bx);
		frm  = document.getElementById("i"+bx);
			 		 
		if (se.className=="hide")
		 {
			 se.className = "regular";
			 window.open("Observation/ObservationView.cfm?now=#now()#&row="+bx+"&ProgramCode="+PC+"&Period="+PERIOD+"&AuditId="+AUDIT, "i"+bx)
	         window.scrollBy(30,30)
		 }
		 
		 else
		 
		 {
			 se.className  = "hide";
		 }
			 		
 }	

</script>

<!--- get user Authorization level for adding programs --->

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    ProgramAudit.dbo.ProgramAudit
WHERE   ProgramCode='#URL.ProgramCode#'
and Period='#URL.Period#'
</cfquery>

<body onLoad="window.focus()">

<cfparam name="URL.Layout" default="Program">
<cfset Caller = "../Audit/AuditViewHeader.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">

<cfif #URL.Layout# eq 'Program'>
	<cfinclude template="../Program/ProgramViewHeader.cfm">
<cfelse>
	<cfinclude template="../Program/ComponentViewHeader.cfm">
</cfif>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#C0C0C0" rules="rows">

<tr><td>

  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
  
  <tr>
  	<td height="28" class="def" bgcolor="fafafa">&nbsp;
  	<cfoutput>
		       &nbsp;|&nbsp;
			   <button onClick="javascript:mail('mail','#URL.ProgramCode#')" class="button3">
			     <img src="#SESSION.root#/Images/email_send.gif" alt="eMail project"  border="0" align="absmiddle">
			   </button>&nbsp;|&nbsp;
			   <button onClick="javascript:mail('print','#URL.ProgramCode#')" class="button3">
			     <img src="#SESSION.root#/Images/print_small3.gif" alt="Print project" border="0" align="absmiddle">
			   </button>&nbsp;|
			
	<cf_tl id="Add Audit" var="1">
	<input type="button" name="Add" id="Add" value="#lt_text#" class="regular" onClick="javascript:AddAudit('URL.Period','URL.ProgramCode');">&nbsp;
	</cfoutput>
			
	
  </td></tr>

  <tr>
    <td width="100%" colspan="3">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse">

	<TR>
    <td width="3%" height="18" align="center"></td>
	<TD width="5%"><cf_tl id="No."></TD>
	<TD width="5%"><cf_tl id="Reference"></TD>
	<TD width="34%"><cf_tl id="Description"></TD>
	<TD width="34%"><cf_tl id="Objective"></TD>
	<td width="6%"><cf_tl id="Start Date"></td>
	<td width="6%"><cf_tl id="Target Date"></td>
	</TR>	
   	 	
	 <cfoutput query="Audit"> 
     <tr>
	 	<td>
  
         <img src="#SESSION.root#/Images/contract.gif" 
		    alt="" 
			name="img0_#AuditNo#"  
			width="14" 
			height="14" 
			border="0" 
			align="absmiddle"
			onclick="javascript:entry()"
			onMouseOver="document.img0_#AuditNo#.src='#SESSION.root#/Images/button.jpg'" 
		    onMouseOut="document.img0_#AuditNo#.src='#SESSION.root#/Images/contract.gif'">
   		
		</td>
        <td>
   		   <A HREF ="javascript:more('#CurrentRow#','#ProgramCode#','#Period#','#AuditId#')" 
		   title="Show/Hide details">
		   #AuditNo#
		   </A></td>		
        <td>#Reference#</td>		
        <td>#Description#</td>
        <td>#Objective#</td>
        <td>#Dateformat(StartDate, CLIENT.DateFormatShow)#</td>
        <td>#Dateformat(EndDate, CLIENT.DateFormatShow)#</td>
      </tr>
       <tr id="#CurrentRow#" class="hide">
	    <td colspan="7">
	   <iframe name="i#CurrentRow#" id="i#CurrentRow#" 
	     width="100%" align="middle" scrolling="no" frameborder="0"></iframe>
	   </td>
	  </tr>	
	  <tr><td colspan="7" bgcolor="e4e4e4"></td></tr>
	   
	  </cfoutput>	  
	   
    </table>
	
	</tr>
	
	</table>
		
	</tr>
	
	</table>
   
</body>

</html>