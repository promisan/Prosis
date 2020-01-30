<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfajaximport tags="cfform">
<cf_calendarscript>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	
 
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Period
	ORDER BY PeriodClass, DateEffective
	
</cfquery>

<cfoutput>

<script>

function observe() {
     window.location="ObservationPeriod.cfm?idmenu=#url.idmenu#"; 
}

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=20, width=900, height=960, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=20, width=1070, height=960, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function listing(per,box) {

     occur  = document.getElementById("dialog")
     occur.value = occur.value + 1
     se   = document.getElementById("d"+per);
  		 		 
	if (se.className=="hide") {
         se.className  = "regular";
		 ColdFusion.navigate('Audit.cfm?o="+occur.value+"&ID='+per+'&box='+box,box)
	 } else {
     	 se.className  = "hide";
	 }
		 		
  }

</script>	
	
</cfoutput>


<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<input type="hidden" name="dialog" id="dialog" value="0">

<tr class="labelmedium line">
    <td></td>
    <td>Aud.</td>	
	<td>Code</td>
	<td></td>
	<td>Period</td>
	<td>Entity</td>
	<td>Active</td>
	<td>Mode</td>	
	<td>Officer</td>
    <td>Entered</td>    
</tr>


<cfoutput query="SearchResult" group="PeriodClass">

<tr><td height="4"></td></tr>
<tr class="line"><td height="24" colspan="10" class="labelmedium">#PeriodClass#</td></tr>

<cfoutput>

	<cfquery name="Check"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_MissionPeriod
	WHERE  Period = '#Period#'
	</cfquery>
    
	<tr class="cellcontent line navigation_row">
		<td width="20" align="center" style="padding-top:3px;">
			  <cf_img icon="edit" navigation="Yes" onclick="recordedit('#period#')">
	  	 </td>		  
				 
		<td width="30" align="center" style="padding-top:4px">
			 <cf_img icon="expand" toggle="Yes" onclick="listing('#Period#','i#Currentrow#');">
		</td>			
		
		<td class="labelit">#period#</td>
		
		<td class="labelit"><!---#Description#---></td>
		<td class="labelit">#DateFormat(DateEffective,CLIENT.DateFormatShow)#&nbsp;-&nbsp;#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
		<td class="labelit">
		   <cfloop query="Check">#Mission#<cfif currentrow neq recordcount>,</cfif></cfloop>
		    <cfif check.recordcount eq "0">
		    <a href="javascript:recordedit('#period#')"><font color="FF8040">Associate a mission/period</a><b>
		   </cfif>
		</td>
		<td class="labelit" align="center"><cfif IncludeListing eq "1">Yes<cfelse>No</cfif></td>
		<td class="labelit" align="center"><cfif isPlanningPeriod eq "1">Both<cfelse>Edition only</cfif></td>	
		<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
		<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
		
	<tr class="hide" id="d#Period#" name="d#Period#">
	    <td></td>
		<td colspan="9">
		<table width="100%" border="0" align="center">
		<tr><td height="4"></td></tr>
		<tr><td id="i#currentrow#" name="i#currentrow#">
		<td></tr>	
		</table> 
		</td>
	</tr>
	
</cfoutput>	

</CFOUTPUT>

</TABLE>

</cf_divscroll>