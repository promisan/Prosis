<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Settlement
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">


<table height="100%" width="95%" align="center">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfajaximport tags="cfform">

<cfoutput>

<script>

	function recordadd(grp) {
	    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=650, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=650, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

	function show(cde) {

		se = document.getElementById(cde)	
		if (se.className == "hide") {
			se.className  = "labelmedium" 
			ColdFusion.navigate('List.cfm?code='+cde,cde+'_list')
		} else {
			se.className  = "hide"		
		}
	}

	function addMission(code) {
	     ptoken.navigate('List.cfm?action=new&code='+code,code+'_list')
	}
	
	function saveMission(code) {
		 form_id = 'settlement_'+code;
		 alert(form_id);
		 document.forms[form_id].onsubmit() 
		 if( _CF_error_messages.length == 0 ) {
		       	ptoken.navigate('ListSubmit.cfm',code+'_list','','','POST',form_id);
		 }  
			 
	} 
	
</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td style="height:100%">

<cf_divscroll>

<table width="100%" align="center" class="navigation_table">

<tr class="fixrow labelmedium line">
    <TD align="left"></TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>Mode</TD>
	<TD>Operational</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
</TR>

	<cfoutput>
	<cfloop query="SearchResult">
				    
	    <TR class="navigation_row line labelmedium"> 
			<TD align="center">
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td style="padding-top:7px;padding-right:1px"><cf_img icon="expand" toggle="Yes" onclick="show('#code#')"></td>
						<td><cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');"></td>
					</tr>
				</table>
			</TD>
			<TD>#Code#</TD>
			<TD>#Description#</TD>
			<TD>#Mode#</TD>
			<TD><cfif #Operational# eq 1>Yes<cfelse>No</cfif></TD>
			<TD>#OfficerFirstName# #OfficerLastName#</TD>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
	
	   <TR id="#code#" class="hide">
	   		<TD></TD>
	   		<TD colspan="8" id="#code#_list">
			</TD>
		</TR>
	</cfloop>
	</cfoutput>

</TABLE>

</cf_divscroll>

</td>

</tr>

</TABLE>

