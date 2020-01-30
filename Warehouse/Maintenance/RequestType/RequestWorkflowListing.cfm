
<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_RequestWorkflow
	WHERE	RequestType = '#URL.ID1#'
	ORDER BY Created
</cfquery>

<table width="99%"  border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0"  >  

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
	<td align="left" colspan="8">
		<cfoutput>
		  <cf_button type="Button" id="AddRecord" value="Add Workflow" onclick="editworkflow('#URL.ID1#','')">	
		</cfoutput>
	</td>
</tr>

<tr><td colspan="8" height="8"></td></tr>

<tr class="labelmedium">
    <TD></TD> 
	<TD></TD>
    <TD>Action</TD>
	<td>Name</td>
	<td>Workflow</td>
	<td align="center">Ope.</td>
	<TD>Officer</TD>
    <TD>Entered</TD>
</tr>

<cfoutput query="SearchResult">

   
    <TR class="labelmedium line"> 
	<td width="3%" align="center" style="padding-top:3px;padding-right:3px">
	   <cf_img icon="edit" onclick="editworkflow('#URL.ID1#','#RequestAction#');">
	</td>
	<td width="3%" align="left" style="padding-left:3px;padding-top:3px">
	   <cf_img icon="delete" onclick="deleteworkflow('#URL.ID1#', '#RequestAction#');">
	</td>
	<TD>#RequestAction#</TD>
	<TD>#RequestActionName#</TD>	
	<td>#EntityClass#</td>
	<td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td> 
	<TD>#OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
</CFOUTPUT>

<tr><td height="1" class="line" colspan="8"></td></tr>

</TABLE>

</td>

</TABLE>
