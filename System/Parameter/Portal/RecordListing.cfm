<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" html="No" scroll="Vertical">

<cfsavecontent variable="option">
<button class="button10g" onClick="javascript:recordadd()">Add Link</button>
</cfsavecontent>

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<cfinclude template="../HeaderParameter.cfm">

<cfoutput>

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
 
<cfquery name="SearchResult"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   L.*, R.FunctionName
	FROM     PortalLinks L LEFT OUTER JOIN Ref_ModuleControl R
	ON       L.SystemFunctionId = R.SystemFunctionId	
	ORDER BY Class, FunctionName, ListingOrder
</cfquery>

<script>

function recordadd(grp) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=790, height=580, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=790, height=580, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
</cfoutput>
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="line">   
    <TD class="labelit" height="20">Class</TD>
	<td class="labelit" width="70">Language</td>
	<TD class="labelit" width="30%">Description</TD>
	<TD class="labelit">Target</TD>
	<TD class="labelit">Servers</TD>
	<TD class="labelit" align="center">Order</TD>
	<TD class="labelit">Entered</TD>  
</TR>

<cfoutput query="SearchResult" group="Class">

    <tr><td height="4"></td></tr>
    <tr>
    <td colspan="7" class="labellarge" style="height:34;padding-left:10px"><cfif Class eq "Custom">Self Service Top Menu<cfelseif Class eq "CustomLeft">Self Service left menu<cfelse>#Class#</cfif></b></td>
    </tr>
	<tr><td height="1" colspan="7" class="linedotted"></td></tr>
	
<cfoutput group="FunctionName">

 <cfif FunctionName neq "">

    <tr><td colspan="5" style="font-size:25px" height="30" class="labellarge">#FunctionName#</b></td> </tr>
	<tr><td height="1" colspan="7" class="line"></td></tr>
	
 </cfif>
	
<cfoutput>    
	
	<TR bgcolor="white" class="navigation_row">
		<td width="5%" rowspan="2" style="padding-top:1px" align="center">		
			<cfset rec = "record">			
			<cf_img icon="edit" navigation="Yes" onclick="#rec#edit('#PortalId#')">						
									  
		</td>		
		<td class="labelit" rowspan="2"><cfif LanguageCode eq "">Any<cfelse>#LanguageCode#</cfif></td>
		<TD class="labelit"  height="20" width="40%">#Description#</TD>	
		<TD class="labelit" >#LocationTarget#</TD>
		<td class="labelit" >#HostNameList#</td>
		<td class="labelit"  align="center">#ListingOrder#</td>
		<TD class="labelit" >#Dateformat(Created, "#CLIENT.DateFormatShow#")#&nbsp;</TD>		
    </TR>
	
	<tr><td style="border-top:1px dotted silver; border-left:1px dotted silver;padding-left:3px" bgcolor="ffffdf" colspan="5" class="labelit">
	<a href="#LocationURL#<cfif LocationString neq "">?#LocationString#</cfif>"
	   target="_blank" 
	   title="Go to Link">
	   <font color="gray">#LocationURL#<cfif LocationString neq "">?#LocationString#</cfif>
    </a>
	</td></tr>
	<tr><td height="1" colspan="7" class="line"></td></tr>
		
</CFOUTPUT>	
	
</CFOUTPUT>	

</CFOUTPUT>

</TABLE>

</td>

</TABLE>
</BODY></HTML>