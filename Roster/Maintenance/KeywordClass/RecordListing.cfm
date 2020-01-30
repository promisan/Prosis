
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
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=650, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=650, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function show(cde) {

		se = document.getElementById(cde)
		if (se.className == "hide") {
			se.className  = "regular" 
			ColdFusion.navigate('List.cfm?code='+cde,cde+'_list')
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

<tr class="labelheader line">   
	<td></td>
	<td></td>
    <td class="labelit">&nbsp;&nbsp;&nbsp;<cf_tl id="Code"></td>
	<td class="labelit"><cf_tl id="Description"></td>
	<td class="labelit" align="center"><cf_tl id="Keywords"></td>
	<td class="labelit" align="center"><cf_tl id="Order"></td>	
	<td class="labelit" align="center"><cf_tl id="Owners"></td>	
	<td class="labelit"><cf_tl id="Occ. group"></td>
	<td></td>
</tr>

<cfoutput query="SearchResult" group="Parent">
 
	<tr class="linedotted">
		<td colspan="8" class="labelmedium" style="padding-left:5px"><b>#Parent#</b></td>
	</tr>

<cfoutput>
    
	<tr class="cellcontent linedotted navigation_row clsRow">
	<td class="clsFields" style="display:none;">
		#Parent# #ExperienceClass# #Description# #DescriptionFull#
	</td>
	<td align="center">
		<cf_img icon="expand" toggle="Yes" onclick="show('#ExperienceClass#')">
	</td>
	<td >
		<cf_img icon="Edit" onclick="recordedit('#ExperienceClass#')" navigation="Yes">
	</td>
	<td style="padding-left:4px">#ExperienceClass#</td>
	<td>#Description#</td>
	<td align="center">#KeyWords#</td>
	<td align="center">#ListingOrder#</td>	
	<td align="center">#Owners#</td>	
	<td>#DescriptionFull#</td>
    </tr>
	
	 <tr class="hide" id="#ExperienceClass#">
	    <td colspan="8">
		<cfdiv id="#ExperienceClass#_list"/>				
	</td></tr>

</cfoutput>

    <tr><td height="3" colspan="8"></td></tr>
	
</cfoutput>	

</table>
