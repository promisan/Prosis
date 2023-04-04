
<cf_tl id="Interview Panel Members" var="panel"> 
<cf_screentop html="No" label="#panel#">

<cf_dialogPosition>
<cf_dialogStaffing>

<cfform action="CandidatePanelEntrySubmit.cfm?PersonNo=#URL.PersonNo#&InterviewId=#URL.InterviewId#" method="POST" enablecab="Yes" name="panel">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="e4e4e4">

    <tr>
    <td width="100%" style="height:35px" align="left" valign="middle" class="labellarge">
	   	&nbsp;<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/position_duplicate.gif" alt="" align="absmiddle" width="16" height="15" border="0">
		&nbsp;<cf_tl id="Register interview panel members"></b>
    </td>
  </tr> 	
  
  <tr><td class="line"></td></tr>
    
  <tr>
    <td width="100%">
    <table width="97%" align="center" class="formpadding">
	 
	<TR class="labelmedium2">
	    <td></td>
	    <td style="padding-left:4px"><cf_tl id="Name">:</TD>
		<td><cf_tl id="Interview panel role"></td>
	</tr>
		
	<cfquery name="Employee" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT E.PersonNo, Max(F.Panelmemo) as PanelMemo, E.LastName, E.FirstName
	   FROM ApplicantInterviewpanel F, Employee.dbo.Person E
	   WHERE F.PanelPersonNo   =  E.PersonNo
	   AND   F.InterviewId     = '#URL.InterviewId#'
	    GROUP BY E.PersonNo, E.LastName, E.FirstName
	</cfquery>
	
	<cfoutput query="Employee">
	
	<tr><td>
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   ApplicantInterviewpanel F
	   WHERE  F.InterviewId = '#URL.InterviewId#'
	</cfquery>
		<input type="checkbox" name="PersonNo_#CurrentRow#" value="#PersonNo#"
	  <cfif Check.recordcount eq "1">checked</cfif>>&nbsp;#FirstName# #LastName#
	</td>
	<TD><input style="height:21" class="regular" type="text" value="#PanelMemo#" name="PanelMemo_#CurrentRow#" size="20" maxlength="50"> </TD>
	</tr>
	
	</cfoutput>
	
	<cfoutput>
	<input type="hidden" name="Row" value="9">
	
	<cfset ln = Employee.recordcount+1>
	
	<cfloop index="itm" from="#ln#" to="7">
	
	<tr>	
    <td height="24">			
	<input type="button" style="width:24px;height:24px" class="button10s" name="search0" value=" ... " onClick="selectperson('webdialog','personno_#itm#','indexno#itm#','lastname#itm#','firstname#itm#','name#itm#')"> 
	</td>
	<td>
	<input type="text" style="height:24px" name="name#itm#" id="name#itm#" class="regularxl" size="34" maxlength="80" readonly>
	<input type="hidden" name="indexno#itm#"  id="indexno#itm#" value="" class="disabled" size="10" maxlength="10" readonly>
    <input type="hidden" name="personno_#itm#" id="personno_#itm#" value="" class="disabled" size="10" maxlength="10" readonly>
    <input type="hidden" name="lastname#itm#" id="lastname#itm#" value="" class="disabled" size="10" maxlength="10" readonly>
    <input type="hidden" name="firstname#itm#" id="firstname#itm#" value="" class="disabled" size="10" maxlength="10" readonly>
	</td>
    <TD><input style="height:24px" class="regularxl" type="text" name="PanelMemo_#itm#" id="PanelMemo_#itm#" size="17" maxlength="50"> </TD>

	</TR>	
	
	</cfloop>
	
	</cfoutput>
		
	</table>
	</td></tr>
	
	</table>
	
   <table width="100%"><td style="padding-left:10px;padding-top:5px">
   	<input class="button10g" type="submit" name="Submit" value="&nbsp;&nbsp;&nbsp;&nbsp;Save&nbsp;&nbsp;&nbsp;&nbsp;">&nbsp;
   </td>
   </table>

</CFFORM>

