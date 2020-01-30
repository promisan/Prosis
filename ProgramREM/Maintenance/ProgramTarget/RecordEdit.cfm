<HTML><HEAD>
	<TITLE>Reference Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_TargetClass
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this Program Class?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Edit">

<!--- edit form --->

<table width="92%">

    <cfoutput>
    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20"class="regular">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="40" 
	   maxlenght = "40" class= "regular">
    </TD>
	</TR>
	</cfoutput>
	
	
</TABLE>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button7" type="submit" name="Update" value=" Update ">
	</td>	
	
</TABLE>
	
</CFFORM>


</BODY></HTML>