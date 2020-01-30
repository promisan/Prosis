<HTML><HEAD>
	<TITLE>Parameters - Edit Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 

<cf_preventCache>

<cfquery name="Get" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter 
</cfquery>

<CFFORM action="ParameterSubmit.cfm" method="post">

<!--- Entry form --->

<br>

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td colspan="2">

	<table width="100%" align="center">
	<TD><font face="Calibri" size="4"><b>Recruitment request parameters:</b></font></TD>
	<TD><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/parameter.jpg" alt="" border="0" align="absmiddle"></TD>
	</table>

</td></tr>

<tr><td colspan="2" class="linedotted"></td></tr>

 <!--- Field: Prosis Applicantion Root --->
    	
	<!--- Field: ProgramNo --->
    <TR>
    <td width="180" class="labelmedium">Last Assigned track No:&nbsp;</b></td>
    <TD>
  	    <cfoutput query="get">
		<input type="hidden" name="Identifier" value="#Identifier#">
		<input type="text" class="regularxl" name="DocumentNo" value="#DocumentNo#" size="4" maxlength="10" style="text-align: center;">
		</cfoutput>
    </TD>
	</TR>
	
			
    <!--- Field: Prosis Document Root --->
    <TR>
	<cf_UIToolTip tooltip="Alert officer if candidate exceeds the listed age in years.">
     <td style="cursor: pointer;" width="160" class="labelmedium">Candidate maximum age:</td>
	</cf_UIToolTip>
    <TD width="60%">
  	    <cfoutput query="get">
		<cfinput type="Text" name="MaximumAge" value="#MaximumAge#" style="text-align: center;" message="Please enter a valid age" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxl">
		</cfoutput>
    </TD>
	</TR>
	
	<!--- Field: Prosis Document Root --->
    <TR>
    <td class="labelmedium">Interview step enabled:</td>
    <TD class="labelmedium">
	  	
		<input type="radio" name="InterviewStep" value="1" <cfif Get.InterviewStep eq "1">checked</cfif>>Yes
		<input type="radio" name="InterviewStep" value="0" <cfif Get.InterviewStep eq "0">checked</cfif>>No
	
    </TD>
	</TR>
	
	<!--- Field: Prosis Document Root --->
    <TR>
	<cf_UIToolTip tooltip="Prevent selection of elsewhere shortlisted candidates to enforce mutual communication between recruitment officers prior to selection">
    <td style="cursor: pointer;" class="labelmedium">Prevent Selection of Shortlisted candidates:</td>
	</cf_UIToolTip>
    <TD class="labelmedium">
	  	
		<input type="radio" name="ShortlistConflict" value="1" <cfif Get.ShortlistConflict eq "1">checked</cfif>>Prevent both shortlisted and Selected
		<input type="radio" name="ShortlistConflict" value="0" <cfif Get.ShortlistConflict eq "0">checked</cfif>>Only Selected	
		
    </TD>
	</TR>
		
    <TR>
	<cf_UIToolTip tooltip="Show option to attach files for shortlisted candidates">
    <td style="cursor: pointer;" class="labelmedium">Show Attachment:</td>
	</cf_UIToolTip>
	
    <TD class="labelmedium">
	  	
		<input type="radio" name="ShowAttachment" value="1" <cfif Get.ShowAttachment eq "1">checked</cfif>>Yes
		<input type="radio" name="ShowAttachment" value="0" <cfif Get.ShowAttachment eq "0">checked</cfif>>No
	
    </TD>
	</TR>
	
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<tr>
		<td colspan="2" height="30" align="left">
		<input type="submit" name="Update" value="Save" class="button10g">
		</td>
	</tr>
	
</TABLE>


	
</CFFORM>


</BODY></HTML>