<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AssignmentType
	WHERE AssignmentType = '#URL.ID1#'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">


<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

   <tr><td height="4"></td></tr>

    <cfoutput>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="AssignmentType" value="#get.assignmentType#" size="10" maxlength="10"class="regularxl">
	   <input type="hidden" name="AssignmentTypeOld" value="#get.assignmentType#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	</cfoutput>
	
</TABLE>

<cf_dialogBottom option="edit" delete="Assignment type">

</CFFORM>

