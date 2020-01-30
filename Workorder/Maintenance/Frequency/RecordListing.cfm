
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    select *, (select count(*) from serviceItemUnit where frequency = f.code) as serviceItemUnitOccurrences
	from Ref_Frequency f
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 


<table width="100%" align="center" cellspacing="0" cellpadding="0" >  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 400, height= 225, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 400, height= 225, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr>
	<td colspan="2" class="line"></td>
</tr>
	
<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="1" align="center" class="navigation_table">

<tr class="labelmedium line" style="height:20px;">
    <td></td> 
    <td>Code</td>
	<td>Description</td>
	<td>Units</td>
    <td>Entered</td>
  
</tr>

<cfoutput query="SearchResult">

    <tr class="labelmedium line navigation_row" height="20" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"> 
	<td width="5%" align="center" style="padding-top:3px;">
		  <cf_img icon="select" navigation="yes" onclick="recordedit('#code#', '#serviceItemUnitOccurrences#')">
	</td>		
	<td>#code#</td>
	<td>#description#</td>
	<td>#serviceItemUnitOccurrences#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
   
</cfoutput>

</TABLE>


</td>

</TABLE>

<cf_divscroll>
