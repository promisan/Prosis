<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Settlement
</cfquery>

<table width="95%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Settlement">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfajaximport tags="cfform">

<cfoutput>

<script>

	function recordadd(grp) {
         ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
         ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

	function show(cde) {

		se = document.getElementById(cde)	
		if (se.className == "hide") {
			se.className  = "labelmedium" 
			ptoken.navigate('List.cfm?code='+cde,cde+'_list')
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

<tr><td colspan="2">

<cf_divscroll>

	<table width="100%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	    <TD align="left"></TD>
	    <TD>Code</TD>
		<TD>Description</TD>
		<TD>Mode</TD>
		<TD>Operational</TD>
		<TD>Officer</TD>
	    <TD>Entered</TD>
	</TR>
	
	
	<cfoutput query="SearchResult">
		    
	    <TR class="navigation_row labelmedium2 line"> 
			<TD align="center" style="padding-top:1.3px">
				<table cellspacing="0" cellpadding="0">
					<tr class="labelmedium2">
						<td style="padding-top:8px;padding-right:3px"><cf_img icon="expand" toggle="Yes" onclick="show('#code#')"></td>
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
	   		<TD colspan="7" id="#code#_list">
			</TD>
		</TR>	
	</cfoutput>
	
	</TABLE>

</cf_divscroll>

</td>

</tr>

</TABLE>
