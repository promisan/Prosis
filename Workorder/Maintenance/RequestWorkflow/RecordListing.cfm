
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	R.*, 
			T.Description as requestTypeDescription, 
			S.Description as serviceDomainDescription,
			(SELECT C.EntityClassName 
			 FROM   Organization.dbo.Ref_EntityClass C
			 WHERE  R.entityClass = C.entityClass 
			 AND    C.EntityCode = 'WrkRequest') as EntityClassName
	FROM 	Ref_RequestWorkflow R,
			Ref_Request T,
			Ref_ServiceItemDomain S
	WHERE 	R.requestType = T.Code	
	AND		R.serviceDomain = S.Code
	ORDER BY ServiceDomain, requestType, requestAction
</cfquery>

<cf_divscroll>

<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="99%" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 850, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2, id3) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&ID2=" + id2 + "&ID3=" + id3, "Edit", "left=80, top=80, width=850, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="1" align="center" class="navigation_table">

<tr class="labelit line">
    <td width="60"></td> 
	<td></td>
	<td>Action</td>
	<td>Name</td>
	<td>Custom Form</td>
    <td>Custom Form Condition</td>
	<td>Workflow Class</td>
	<td align="center">Oper.</td>
	<td>Officer</td>
	<td>Created</td>
  
</tr>

<tr><td class="line" colspan="10"></td></tr>

<cfoutput query="SearchResult" group="serviceDomain">

	<tr><td height="30" colspan="10" class="labelmedium"><b>#serviceDomain# - #serviceDomainDescription#</b></td></tr>
	
	<cfoutput group="requestType">
	
	<tr><td colspan="10" class="line labelmedium">#requestType# - #requestTypeDescription#</td></tr>
	
	<cfoutput>
	  
	    <tr class="navigation_row line labelit""> 
		<td></td>
		<td width="20" align="center">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#serviceDomain#','#requestType#','#requestAction#')">
		</td>		
		<td>#requestAction#</td>
		<td>#requestActionName#</td>
		<td>#customForm#</td>
		<td>#customFormCondition#</td>
		<td>#EntityClassName#</td>	
		<td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	    	
	</cfoutput>
	
	</cfoutput>
	
</cfoutput>

</table>

</td>
</tr>

</table>

</cf_divscroll>