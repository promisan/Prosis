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

<cf_screentop height="100%" html="No">

<cf_dialogStaffing>

<cfparam name="URL.Dialog" default="0">

<cfoutput>

<script>

function recordadd(grp) {
          window.open("CandidatePanelEntry.cfm?PersonNo=#URL.PersonNo#&InterviewId=#URL.InterviewId#", "Add", "left=80, top=80, width=450, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table><tr><td height="1"></td></tr>

<cfquery name="Employee" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT F.*, E.*
   FROM ApplicantInterviewPanel F, Employee.dbo.Person E
   WHERE F.PanelPersonNo   =  E.PersonNo
   AND   F.InterviewId     = '#URL.InterviewId#'
</cfquery>

<table width="97%" border="0" cellspacing="0" cellpadding="0">

  <cfset cnt="50">
   
  <tr>
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
    <tr class="linedotted">
       <td height="15" class="labelit"><cf_tl id="IndexNo"> </td>
	   <TD height="15" class="labelit"><cf_tl id="Name"></TD>
	   <TD height="15" class="labelit"><cf_tl id="Gender"></TD>
	   <TD height="15" class="labelit"><cf_tl id="Nationality"></TD>
	   <td width="20%" height="15"><cf_tl id="Role">&nbsp;</td>
     
   </TR>   
   <cfoutput query="Employee">
   
	   <cfset cnt = cnt+22>
	   
	   <tr class="linedotted">
	      <td height="20" class="labelit"><a href="javascript:EditPerson('#PanelPersonNo#')"><font color="0080C0">#IndexNo#</a></td>
		  <td class="labelit"><a href="javascript:EditPerson('#PanelPersonNo#')">#FirstName# #LastName#</a></td>
		  <td class="labelit">#Gender#</td>
		  <td class="labelit">#Nationality#</td>
		  <td class="labelit">#PanelMemo#</td>
	   </tr> 	  
      
   </CFOUTPUT>
   
   <cfif URL.Dialog eq '1'>
	   <tr><td colspan="6" class="linedotted"></td></tr> 
	   <tr><td height="4" colspan="6" class="labelit">
		<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/position_duplicate.gif" alt="" align="absmiddle" width="16" height="15" border="0">
		&nbsp;
		<a href="javascript:recordadd()"><cf_tl id="Add/Edit panel members"></b></a>
		</td></tr>
   </cfif>	
   
</TABLE>
</td>
</tr>
</table>

<cfoutput>
<cfif URL.Dialog eq '1'>

	<script language="JavaScript">
	
	{
	frm  = parent.document.getElementById("panel");
	frm.height = #cnt#;
	}
	
	</script>

</cfif>
</cfoutput>
