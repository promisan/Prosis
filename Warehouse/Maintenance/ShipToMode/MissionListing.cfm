
<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  DISTINCT Mission
    FROM  	Warehouse 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" >
<tr>

<td colspan="2">

<table id="missionListing" width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding" >

<tr><td height="1" colspan="4" class="line"></td></tr>

<tr>
    <TD height="23" align="center" width="10%">
	    <!---
		<cfoutput>
		<A href="javascript:editMission('#url.id1#','')">
		<font color="0080FF">[add]</font></a>
		</cfoutput>
		--->
	</TD>
    <TD>Entity</TD>
</TR>

<tr><td colspan="4" align="right" class="line" valign="middle"></td></tr>

<cfif list.recordCount eq 0>

	<tr><td height="25" colspan="4" class="labelit" align="center"><font color="808080"><b>No entities recorded</b></font></td></tr>

<cfelse>

<cfoutput query="List">
	
	<TR class="navigation_row">	
			
		<TD height="22" align="center" style="padding-top:3px">			
		    <cf_img icon="edit" navigation="Yes" onclick="editMission('#url.id1#','#mission#');">
		</TD>
		
		<TD class="labelit">#Mission#</TD>
	</TR>

</cfoutput>

</cfif>

<tr><td colspan="4" align="right" class="line" valign="middle"></td></tr>

</TABLE>

</td>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	
