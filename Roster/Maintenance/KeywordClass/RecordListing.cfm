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

<cf_screentop html="no" height="100%" scroll="yes" jquery="yes">
			   
<cfset add          = "1">
<cfset Header       = "PHP Keyword class">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfquery name="SearchResult"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   R.*, 
		         (SELECT count(*) FROM Ref_Experience WHERE ExperienceClass = R.ExperienceClass) as Keywords,
				 (SELECT count(*) FROM Ref_ExperienceClassOwner WHERE ExperienceClass = R.ExperienceClass) as Owners,
		         O.DescriptionFull
		FROM     Ref_ExperienceClass R LEFT OUTER JOIN Occgroup O ON R.OccupationalGroup = O.OccupationalGroup
		ORDER BY R.Parent, R.ListingOrder, R.Description
</cfquery>

<cfoutput>

	<script>
	
	function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=650, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=650, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function show(cde) {

		se = document.getElementById(cde)
		if (se.className == "hide") {
			se.className  = "regular" 
			ptoken.navigate('List.cfm?code='+cde,cde+'_list')
		} else {
			se.className  = "hide"
		}
	}
	
	</script>	

</cfoutput>

<cf_presentationScript>

<cfajaximport tags="cfform">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
<tr><td height="10"></td></tr>
<tr>
	<td colspan="8">
	
		<cfinvoke component = "Service.Presentation.TableFilter"  
		   method           = "tablefilterfield" 
		   name             = "linesearch"				  
		   filtermode       = "enter"
		   style            = "font-size:16px;height:25px;width:130px;"
		   rowclass         = "clsRow"
		   rowfields        = "clsFields">
		
	</td>
</tr>

<tr><td height="10"></td></tr>

<tr class="fixrow line labelmedium2">   
	<td></td>
	<td></td>
    <td>&nbsp;&nbsp;&nbsp;<cf_tl id="Code"></td>
	<td><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Keywords"></td>
	<td align="center"><cf_tl id="Order"></td>	
	<td align="center"><cf_tl id="Owners"></td>	
	<td><cf_tl id="Occ. group"></td>
	<td></td>
</tr>

<cfoutput query="SearchResult" group="Parent">
 
	<tr class="line">
		<td colspan="8" class="labelmedium2" style="height:35px;font-size:20px;padding-left:5px">#Parent#</b></td>
	</tr>

<cfoutput>
    
	<tr class="labelmedium2 line navigation_row clsRow">
	<td class="clsFields" style="display:none;">
		#Parent# #ExperienceClass# #Description# #DescriptionFull#
	</td>
	<td style="padding-top:8px" align="center">
		<cf_img icon="expand" toggle="Yes" onclick="show('#ExperienceClass#')">
	</td>
	<td style="padding-top:2px">
		<cf_img icon="select" onclick="recordedit('#ExperienceClass#')" navigation="Yes">
	</td>
	<td style="padding-left:4px">#ExperienceClass#</td>
	<td>#Description#</td>
	<td align="center">#KeyWords#</td>
	<td align="center">#ListingOrder#</td>	
	<td align="center">#Owners#</td>	
	<td>#DescriptionFull#</td>
    </tr>
	
	 <tr class="hide" id="#ExperienceClass#">
	    <td colspan="8" id="#ExperienceClass#_list"></td></tr>

</cfoutput>

    <tr><td height="3" colspan="8"></td></tr>
	
</cfoutput>	

</table>
