<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM  	#client.lanPrefix#Status
ORDER BY Class, StatusClass, Status
</cfquery>

<cf_divscroll>

<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">
 
<cfoutput>
 
<script>

function recordedit(id1,id2){
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&ID2=" + id2, "EditStatus", "left=80, top=80, width= 600, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td height="4"></td></tr>

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <TD width="5%">&nbsp;</TD>
	<TD>Status</TD>
	<TD>Description</TD>
	<TD>Label</TD>
	<TD>Role</TD>
    <TD>Entered</TD>
</TR>

<tr><td colspan="6" class="line"></td></tr>
<tr><td height="5"></td></tr>

<cfoutput query="SearchResult" group="Class">
	<tr><td height="25" colspan="6" style="font-size:14px; font-weight:bold;">#Class#</td></tr>

	<cfoutput group="StatusClass">
		<tr><td height="25" colspan="6" class="labelit"><font face="Calibr" size="3">#StatusClass#</td></tr>
		<tr><td colspan="6" class="line"></td></tr>
		<cfoutput>
		    <TR class="labelit"> 
				<TD style="padding-top:3px;" align="center">
					 <cf_img icon="select" onclick="recordedit('#StatusClass#', '#Status#')">
				</TD>			
				<TD>#Status#</TD>
				<TD>#StatusDescription#</TD>
				<TD>#Description#</TD>
				<TD>#Role#</TD>
				<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
			
			<cfif currentrow neq recordcount>
			    <tr><td height="1" colspan="6" class="linedotted"></td></tr>
			</cfif>
		</cfoutput>
		<tr><td height="5"></td></tr>
	</cfoutput>
	<tr><td height="5"></td></tr>
</CFOUTPUT>

</TABLE>

</td>

</TABLE>

</cf_divscroll>
