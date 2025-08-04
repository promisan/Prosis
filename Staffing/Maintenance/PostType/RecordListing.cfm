<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- Create Criteria string for query from data entered thru search form --->
 
<cfparam name="url.action" default="view">
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostType
</cfquery>


<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfajaximport tags="cfform">

<cfoutput>

<script>

	function recordadd(grp) {
	    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550,height=400,toolbar=no, status=yes, scrollbars=no, resizable=no");
		// ColdFusion.navigate('RecordListing.cfm?code=new','listing')
	}
	
	function recordedit(id1) {
	     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function show(ptype) {
		se = document.getElementById(ptype)	
		if (se.className == "hide") {
			se.className  = "regular" 
			ptoken.navigate('List.cfm?posttype='+ptype,ptype+'_list')
		} else {
			se.className  = "hide"		
		}
	}

	function editMission(posttype){
		ptoken.open("Mission/RecordListing.cfm?idmenu=#url.idmenu#&posttype=" + posttype, "Edit", "left=80, top=80, width= 470, height= 390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function submitPostType(posttype){
		ptoken.navigate('ListSubmit.cfm?posttype='+posttype,'submit_'+posttype,'','','POST','posttype_'+posttype);
	}
	
	function toogleGroup(group,set){
		var types = document.getElementsByName('postgrade_'+group);
		for (i=0; i<types.length; i++)
			types[i].checked = set;
	}
	
</script>	

</cfoutput>

<tr><td>
<cf_divscroll>
	
	
	<table width="94%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
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
						<td style="padding-left:5px;padding-top:3px"><cf_img icon="edit" navigation="Yes" onclick="recordedit('#PostType#')"></td>
						<td style="padding-left:2px;padding-top:2px"><cf_img icon="open" onclick="javascript: editMission('#PostType#')"></td>
						<td style="padding-left:5px;padding-top:9px"><cf_img icon="expand" toggle="Yes" onclick="show('#PostType#')"></td>
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
	   
	   <tr class="line"><td height="1" colspan="8"></td></tr>					 
		
	</cfoutput>
	
	</table>
		
</td></tr>

</table>

</cf_divscroll>