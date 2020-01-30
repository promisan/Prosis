<!--- Create Criteria string for query from data entered thru search form --->
 
<cfparam name="url.action" default="view">
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostType
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfajaximport tags="cfform">

<cfoutput>

<script>

	function recordadd(grp) {
	    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
		// ColdFusion.navigate('RecordListing.cfm?code=new','listing')
	}
	
	function recordedit(id1) {
	     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height= 390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function show(ptype) {
		se = document.getElementById(ptype)	
		if (se.className == "hide") {
			se.className  = "regular" 
			ColdFusion.navigate('List.cfm?posttype='+ptype,ptype+'_list')
		} else {
			se.className  = "hide"		
		}
	}

	function editMission(posttype){
		window.open("Mission/RecordListing.cfm?idmenu=#url.idmenu#&posttype=" + posttype, "Edit", "left=80, top=80, width= 470, height= 390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function submitPostType(posttype){
		ColdFusion.navigate('ListSubmit.cfm?posttype='+posttype,'submit_'+posttype,'','','POST','posttype_'+posttype);
	}
	
	function toogleGroup(group,set){
		var types = document.getElementsByName('postgrade_'+group);
		for (i=0; i<types.length; i++)
			types[i].checked = set;
	}
	
</script>	

</cfoutput>


<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium line">
    <td></td>
    <td>Code</td>
	<td>Description</td>
	<td>WF</td>
	<td>Ext</td>
	<td>PAS</td>
	<td>Officer</td>
    <td>Entered</td>  
</tr>

<cfif url.action eq "new">
	<tr>
		<td colspan="8">
			<cfinclude template="RecordAdd.cfm">
		</td>
	</tr>
</cfif>

<cfoutput query="SearchResult">
		
    <tr height="25" class="labelmedium navigation_row"> 
		<td width="7%" align="center" style="padding-right:5px">
			<table>
				<tr>
					<td style="padding-left:5px;padding-top:2px"><cf_img icon="edit" navigation="Yes" onclick="recordedit('#PostType#')"></td>
					<td style="padding-left:2px;padding-top:3px"><cf_img icon="open" onclick="javascript: editMission('#PostType#')"></td>
					<td style="padding-left:5px;padding-top:6px"><cf_img icon="expand" toggle="Yes" onclick="show('#PostType#')"></td>
				</tr>
			</table>
		</td>		
		<td>#PostType#</td>
		<td>#Description#</td>
		<td><cfif EnableWorkflow eq "0">No</cfif></td>
		<td><cfif EnableAssignmentreview eq "1">Yes</cfif></td>
		<td><cfif EnablePAS eq "1">Yes</cfif></td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
   <tr id="#PostType#" class="hide">
   		<td colspan="7" style="padding-left:10px" id="#PostType#_list"></td>
   </tr>
   
   <tr><td height="1" colspan="8" class="line"></td></tr>					 
	
</cfoutput>

</table>

</cf_divscroll>