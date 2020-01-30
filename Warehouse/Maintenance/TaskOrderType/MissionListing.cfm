
<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*,
			(SELECT Description 
			 FROM Ref_TaskType 
			 WHERE Code = M.Code) AS TaskTypeDescription
			 
    FROM  	Ref_TaskTypeMission M 
	WHERE   Mission IN (SELECT Mission 
	                    FROM   Organization.dbo.Ref_MissionModule 
						WHERE  SystemModule = 'Warehouse')
	AND  	Code = '#URL.ID1#'
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>

<td colspan="2" style="padding:5px">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium">
    <TD height="23" align="center" width="10%">
		<!--- <cfoutput>
		<A href="javascript:editMission('#url.id1#','')">
		<font color="0080FF">[add]</font></a>
		</cfoutput> --->
	</TD>
    <TD>Entity</TD>
    <TD>Template</TD>
</TR>

<tr><td colspan="3" align="right" class="line" valign="middle"></td></tr>

<cfif list.recordCount eq 0>

	<tr><td height="25" colspan="3" align="center"><font color="808080"><b>No entities recorded</b></font></td></tr>

<cfelse>

<CFOUTPUT query="List">

	<TR class="labelit navigation_row">
					
		<TD align="center" style="padding-top:1px">
			<cf_img icon="edit" navigation="yes" onclick="editMission('#url.id1#','#mission#');">   
		</TD>
		
		<TD>#Mission#</TD>
		<TD>#TaskOrderTemplate#</TD>	
	</TR>

</CFOUTPUT>

</cfif>

<tr><td colspan="3" align="right" class="line></td></tr>

</TABLE>

</td>

</TABLE>

<cfset ajaxonload("doHighlight")>
