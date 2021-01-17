
<cfparam name="url.code" default="">	

<cfoutput>

<script>
 
function recordadd(grp) {
    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 690, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function edit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 690, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}
 
</script>

</cfoutput>

<cfset page = '0'>
<cfparam name="add"  default="0">

<cf_screentop html="no" jQuery="Yes">

<cfinclude template="../HeaderParameter.cfm">

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Attachment
	WHERE    DocumentPathName not like '%travel/%' AND DocumentPathName not like '%vacancy/%'
	ORDER BY DocumentPathName
</cfquery>

<cf_PresentationScript>

<cf_divscroll>

<table width="96%" align="center" class="navigation_table">

<tr><td colspan="2" style="height:40">

<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:15px;height:25;width:120"
			   rowclass         = "filter_row"
			   rowfields        = "filter_content">

</td></tr>

<tr class="line labelmedium2 fixrow">
    <TD align="left" width="5%"></TD>
	<td>Key</td>
    <TD align="left">Document path</TD>	
	<TD align="left" width="100">System Module</TD>    
    <TD align="left">Doc. server login</TD>
	<TD align="left">Att. multiple</TD>
	<TD align="left">Att. logging</TD>
	<TD align="left">Created</TD>
</TR>

<cfoutput query="List">
		
	<tr bgcolor="white" style="height:21px" class="line labelmedium2 navigation_row filter_row">	
		<td align="center" style="padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onclick="edit('#DocumentPathName#')">
		</td>
		
		<td class="filter_content">#DocumentPathName#</td>
		<td class="filter_content">#DocumentFileServerRoot##DocumentPathName#</td>	
		<td>#SystemModule#</td>
		<td>#DocumentServerLogin#</td>
		<td><cfif AttachMultiple eq 1>yes<cfelse>no</cfif></td>
		<td><cfif AttachLogging eq 1>yes<cfelse>no</cfif></td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>	
		
</CFOUTPUT>	

</TABLE>

</cf_divscroll>