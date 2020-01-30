<!--
	ContingentActivityEntry.cfm
	
	Contingent activity entry form.
	
	Called by: ContingentActivityListing.cfm
	Calls: ContingentActivityEntrySubmit.cfm
	
	Modification History:

-->
<HTML><HEAD><TITLE>Contingent Activity - Entry</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.ContingentActivityEntry.focus();">
<!---
<cf_preventCache>

--->
<cfparam name="URL.CONT_ID" default="0">

<cfset CLIENT.Datasource="AppsTravel">

<SCRIPT LANGUAGE = "JavaScript">
function OpenPage_ContDetail(cont_id) {
    window.location="ContingentDetail.cfm?CONT_ID=" + cont_id;
}
</SCRIPT>

<cfquery name="qEvent" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Id AS ContingentEvent_Id, Name AS ContingentEvent_Name
	FROM ContingentEvent
	ORDER BY Name
</cfquery>

<CFFORM action="ContingentActivityEntrySubmit.cfm" method="POST" name="ContingentActivityEntry">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="40" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Contingent Activity Entry</strong></font>
	</td>
	<td align="right" valign="middle" bgcolor="002350">
	  <cfoutput>
      <input type="hidden" name="ContingentId" value="#URL.CONT_ID#" size="5" maxlength="5">
   	  <input type="submit" class="button8" name="Submit" value=" Save Entry ">
  	  <input type="button" class="button8" name="Close" value="Close" 
		onClick="javascript:OpenPage_ContDetail(#URL.CONT_ID#)">
	  </cfoutput>		
	 &nbsp;&nbsp;&nbsp;
	</td>
</tr> 	
  
  
<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	<!-- space row -->
	<tr><td class="header" height="10"></td></tr>

    <tr> 
	<td class="header">&nbsp;Effective date (dd/mm/yy)*:</td>
	<td><cfset end = DateAdd("m",  0,  now())> 
   	   	<cf_intelliCalendarDate
		FormName="documentactivityentry"
		FieldName="DateEffective" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(end, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	</td>
	</tr>

	<tr><td height="10"></td></tr>
	
    <tr>
	  <td class="header">&nbsp;Event*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="contingenteventid" required="Yes">
	    	<cfoutput query="qEvent">
			<option value="#ContingentEvent_Id#">#ContingentEvent_Name#</option>
			</cfoutput>
		    </cfselect>			
	  </td>
	</tr>

	<tr><td height="10"></td></tr>

	<tr>
	  <td class="header">&nbsp;Person Count:</td>
	  <td>
	  <cfinput type="Text" name="personcount" required="No" size="5" maxlength="5">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>

	<tr>
	  <td class="header">&nbsp;Number of females:</td>
	  <td>
	  <cfinput type="Text" name="femalecount" required="No" size="5" maxlength="5">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
		
	<tr>
	  <td valign="top" class="header">&nbsp;Remarks (200 chars max):</td>
	  <td>
		 <textArea name="remarks" cols="50" rows="4" wrap="virtual"></textarea>
	  </td>
	</tr>

	<tr>
  	  <td class="header">	
	  &nbsp;
   	  <input type="submit" class="button8" name="Submit" value="Save Entry">
	  <cfoutput>
 	  <input type="button" class="button8" name="Close" value="Close" 
		onClick="javascript:OpenPage_ContDetail(#URL.CONT_ID#)">
	  </cfoutput>		
	  </td>
	  <td colspan="2">
	  &nbsp;
	  <font face="tahoma" color="#000000" size="1.5">Note: An asterisk (*) after the field label indicates a mandatory field.</font>
	  </td>
	</tr>
	<!-- spacer row -->
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
</table>
</td>
</tr>
<!-- End of data entry block -->
</table>
<!-- End of main table -->

</CFFORM>
</BODY>
</HTML>