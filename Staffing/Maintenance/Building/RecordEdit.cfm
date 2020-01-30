<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Address Building" 
			  option="Maintain Address Building" 
			  banner="yellow" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
	  

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM 	Ref_AddressBuilding
WHERE 	Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Building ?")) {	
	return true 	
	}	
	return false
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" border="0" align="center" class="formpadding formspacing">

     <tr><td height="6"></td></tr>
	 
    <cfoutput>
    <TR>
    <TD class="labellarge"><cf_tl id="Code">:</TD>
    <TD class="labellarge">
  	   #get.code#
	   <input type="Hidden" name="Code" id="Code" value="#get.code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labellarge"><cf_tl id="Name">:</TD>
    <TD>
  	   <cfinput type="Text" name="Name" id="Name" value="#get.Name#" message="Please enter a code" required="Yes" size="10" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labellarge"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="no" size="40" maxlength="100" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labellarge"><cf_tl id="Levels">:</TD>
    <TD>
  	   <cfinput type="Text" name="Levels" id="Levels" value="#get.Levels#" message="Please enter the building levels" validate="integer" required="Yes" size="2" maxlength="3" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
	</cfoutput>
		
</TABLE>

<cf_dialogBottom option="edit">
	
</CFFORM>

