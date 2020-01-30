<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Settlement
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="95%" align="center" cellspacing="0" cellpadding="0" >

<cfajaximport tags="cfform">

<cfoutput>

<script>

	function recordadd(grp) {
	         window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
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
	   ColdFusion.navigate('List.cfm?action=new&code='+code,code+'_list')
	}
	
	function saveMission(code) {
		   form_id = 'settlement_'+code;
		   alert(form_id);
		   document.forms[form_id].onsubmit() 
			if( _CF_error_messages.length == 0 ) {
		       	ColdFusion.navigate('ListSubmit.cfm',code+'_list','','','POST',form_id);
			}  
			 
	} 
	
</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0.1" align="center" class="navigation_table">

<tr>
    <TD align="left"></TD>
    <TD class="labelmedium" align="left">Code</TD>
	<TD class="labelmedium" align="left">Description</TD>
	<TD class="labelmedium" align="left">Mode</TD>
	<TD class="labelmedium" align="left">Operational</TD>
	<TD class="labelmedium" align="left">Officer</TD>
    <TD class="labelmedium" align="left">Entered</TD>
</TR>
<cfoutput>
<cfloop query="SearchResult">

	<TR><TD height="1" colspan="7" class="line"></TD></TR>
    
    <TR class="navigation_row"> 
		<TD align="center" style="padding-top:1.3px">
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td style="padding-right:3px"><cf_img icon="expand" toggle="Yes" onclick="show('#code#')"></td>
					<td><cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');"></td>
				</tr>
			</table>
		</TD>
		<TD class="labelmedium">#Code#</TD>
		<TD class="labelmedium">#Description#</TD>
		<TD class="labelmedium">#Mode#</TD>
		<TD class="labelmedium"><cfif #Operational# eq 1>Yes<cfelse>No</cfif></TD>
		<TD class="labelmedium">#OfficerFirstName# #OfficerLastName#</TD>
		<TD class="labelmedium">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>

   <TR id="#code#" class="hide">
   		<TD></TD>
   		<TD colspan="7" id="#code#_list">
		</TD>
	</TR>
</cfloop>
</cfoutput>


</TABLE>

</td>

</tr>

</TABLE>

</cf_divscroll>