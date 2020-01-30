<HTML><HEAD>
	<TITLE>User - Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cf_PreventCache>
 
<cfquery name="Get" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM FlowClass
WHERE ActionClass = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this record ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<TD><font size="4"><b>Edit:</b></font></TD>
<TD><img src="../../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>

<!--- Entry form --->

<table border="0" cellspacing="0" cellpadding="0">

  
    <!--- Field: Description --->
    <TR>
    <TD class="Header">&nbsp;Description:</TD>
    <TD>&nbsp;
  	    <cfoutput query="get">
		<cfinput class="regular" type="Text" name="Description" value="#Description#" message="Please enter a vacancy class description" required="Yes" size="45" maxlength="50">
		<input type="hidden" name="VacancyActionClassId" value="#ActionClass#">
		</cfoutput>
    </TD>
	</TR>

  
    <!--- Field: ListingOrder
   <TR>
    <TD class="Header">&nbsp;Listing Order:</TD>
    <TD>&nbsp;
	    <cfoutput query="get">
		<cfinput class="regular" type="Text" name="ListingOrder" value="#ListingOrder#" required="No" size="4" maxlength="4">
		</cfoutput>
	</TD>
	</TR> --->

</TABLE>
<HR>	
<input class="input.button1" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
<input class="input.button1" type="submit" name="Delete" value=" Delete " onclick="return ask()">
<input class="input.button1" type="submit" name="Update" value=" Update ">

</CFFORM>


</BODY></HTML>