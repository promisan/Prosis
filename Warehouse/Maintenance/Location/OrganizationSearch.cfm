<HTML><HEAD>
    <TITLE>Organization</TITLE>
   <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
   
</HEAD><body leftmargin="1" topmargin="1" rightmargin="1" bottommargin="1" class="main" onLoad="window.focus()">

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Distinct M.Mission
    FROM Ref_Mission M
</cfquery>

<cfquery name="Class" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Distinct OrgUnitClass
    FROM Ref_OrgUnitClass
</cfquery>

<!--- Search form --->

<cfform action="OrganizationSearchResult.cfm" method="POST" target="result" enablecab="Yes" name="organizationsearch">

<cfoutput>
<INPUT type="hidden" name="FormName" id="FormName"            value="#URL.FormName#">
<INPUT type="hidden" name="fldOrgUnit" id="fldOrgUnit"          value="#URL.fldOrgUnit#">
<INPUT type="hidden" name="fldOrgUnitCode" id="fldOrgUnitCode"      value="#URL.fldOrgUnitCode#">
<INPUT type="hidden" name="fldMission" id="fldMission"          value="#URL.fldMission#">
<INPUT type="hidden" name="fldOrgUnitName" id="fldOrgUnitName"      value="#URL.fldOrgUnitName#">
<INPUT type="hidden" name="fldOrgUnitClass" id="fldOrgUnitClass"     value="#URL.fldOrgUnitClass#">
</cfoutput>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">

  <tr>
  
   <td class="top3n">&nbsp;&nbsp;<b><cf_tl id="Search"></b></td>
   
   <td align="right" height="26" class="top3n">
   
   <!---
  
<CF_DialogHeaderSub 
MailSubject="Organization" 
MailTo="" 
MailAttachment="" 
ExcelFile=""
Style="Button7"> 
--->

</td></tr> 	
 
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
   		  
	<TR><td height="30"></td>
	<TD align="left">
       <b><cf_tl id="Tree">:</b>
    </TD>
	<TD>
		    	
    	<select name="MissionSelect" id="MissionSelect" size="1">
	    <cfoutput query="Mission">
		<option value="#Mission#">
    		#Mission#
		</option>
		</cfoutput>
	    </select>
	    </TD>
		
	</TR>
		
	<TR><td height="30"></td>
	<TD align="left"><b><cf_tl id="Class">:</b>
    </TD>
	<TD>
		
    	<select name="OrgUnitClass" id="OrgUnitClass" size="1">
		<option value="all"></option>
	    <cfoutput query="Class">
		<option value="'#OrgUnitClass#'">
    		#OrgUnitClass#
		</option>
		</cfoutput>
	    </select>
				
	</TD>
		
	</TR>
	
	<TR><td height="30"></td>
	<TD align="left"><b><cf_tl id="Name">:</b></TD>
	<TD>
	  	<input type="text" name="OrgUnitName" id="OrgUnitName" size="40" maxlength="40">
	</TD>
		
	</TR>
	<tr valign="top"><td colspan="3" align="right" height="5"></td></tr>
	<tr valign="top"><td colspan="3" align="right" height="1" bgcolor="silver"></td></tr>
	<tr valign="top"><td colspan="3" align="right" height="5"></td></tr>
	<tr valign="top"><td height="15" colspan="3" align="right">
	<input class="button7" type="submit" name"Search" id="Search" value=" Submit Search  ">&nbsp;
	</td></tr>
	<tr valign="top"><td colspan="3" align="right" height="4"></td></tr>
		
     </TABLE>

</td></tr>

<TR>
  <td colspan="2" class="regular">
	 <iframe src="" name="result" id="result" width="100%" height="535" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="yes" frameborder="0" style="scrollbar-face-color: Gray;"></iframe>
  </td>
</TR>

</table>

</CFFORM>

</BODY></HTML>