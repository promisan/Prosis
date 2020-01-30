
<cf_screentop height="100%" scroll="No" label="Organization" html="No">

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Distinct M.Mission
    FROM  Ref_Mission M
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
<INPUT type="hidden" name="FormName" id="FormName"           value="#URL.FormName#">
<INPUT type="hidden" name="fldOrgUnit" id="fldOrgUnit"         value="#URL.fldOrgUnit#">
<INPUT type="hidden" name="fldOrgUnitCode" id="fldOrgUnitCode"     value="#URL.fldOrgUnitCode#">
<INPUT type="hidden" name="fldMission" id="fldMission"         value="#URL.fldMission#">
<INPUT type="hidden" name="fldOrgUnitName" id="fldOrgUnitName"     value="#URL.fldOrgUnitName#">
<INPUT type="hidden" name="fldOrgUnitClass" id="fldOrgUnitClass"    value="#URL.fldOrgUnitClass#">
<cfparam name="URL.fldRole" default="None">
<INPUT type="hidden" name="Role" id="Role"  value="#URL.fldRole#">
</cfoutput>

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">
  <tr>
  
   <td class="bannerXLN">&nbsp;&nbsp;<b>Search</b></td>
   
   <td align="right" class="bannerN">
	  
	<CF_DialogHeaderSub 
		MailSubject="Organization" 
		MailTo="" 
		MailAttachment="" 
		ExcelFile=""
		Style="Button1"> 

</td></tr> 	

</table>

<cf_tableTop size = "96%" omit="true">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
 
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
   		  
	<TR><td height="30"></td>
	<TD align="left" class="regular">
       <b>Tree:</b>
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
	<TD align="left" class="regular"><b>Class:</b>
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
	<TD align="left" class="regular"><b>Name:</b>
    </TD>
	<TD>
	  	<input type="text" name="OrgUnitName" id="OrgUnitName" size="40" maxlength="40">
	</TD>
		
	</TR>
	<tr valign="top"><td height="15" colspan="3" align="right"><hr></td></tr>
	<tr valign="top"><td height="15" colspan="3" align="right">
	<input class="button8" type="button" name="OK" id="OK"    value="    Close    " onClick="window.close()">
	<input class="button8" type="submit" name"Search" ID="Search" value="      Submit Search      ">
	</td></tr>
		
     </TABLE>

</td></tr>

</table>

<cf_tableBottom size = "96%">

<cf_tableTop size="96%" margin="0">

<table width="98%" align="center">

<TR>
        <TD class="regular">
		   <iframe src="" name="result" id="result" width="100%" height="500" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="yes" frameborder="0" style="scrollbar-face-color: Gray;"></iframe>
	    </TD>
</TR>

</table>

<cf_tableBottom size="96%" margin="0">

</CFFORM>
