
<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Request
	ORDER BY ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table width="96%"  border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0">  
<tr><td colspan="2">
<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>

<cfoutput>

<script>

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddRequestType", "left=80, top=80, width= 800, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditRequestType", "left=80, top=80, width=1200, height=800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="96%" align="center" class="navigation_table">

<tr class="fixrow labelmedium2 line">
    <TD></TD> 
    <TD><cf_tl id="Code"></TD>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Template"></td>
	<td align="center"><cf_tl id="WF"></td>
	<td align="center"><cf_tl id="Sort"></td>	
	<td align="center"><cf_tl id="Ope."></td>
	<TD><cf_tl id="Officer"></TD>
    <TD><cf_tl id="Entered"></TD>
	<td></td>
  
</TR>

<cfoutput query="SearchResult">
   
    <TR class="line labelmedium2 navigation_row"> 
	<td width="5%" align="center">
	   <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
	</td>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>	
	<td>#templateApply#	
	<!--- <cfif templateApply eq "RequestApplyService.cfm">New Service
	     <cfelseif templateApply eq "RequestApplyAmendment.cfm">Service Amendment
		 <cfelseif templateApply eq "RequestApplyTerminate.cfm">Service Termination</cfif> --->
	</td>
	<td align="center">
		<cfquery name="CountWorkflows"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	Count(1) as NumberRecords
				FROM 	Ref_RequestWorkflow
				WHERE	RequestType = '#Code#'
			</cfquery>
		#CountWorkflows.NumberRecords#
	</td>
	<td align="center">#listingOrder#</td>
	<td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td> 
	<TD>#OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	<td align="center">
		<!--- <cfquery name="CountRec" 
	      datasource="AppsMaterials" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      	SELECT TOP 1 RequestType
	     	FROM  	RequestHeader
	      	WHERE 	RequestType = '#Code#' 		
	    </cfquery>
		<cfif CountRec.recordCount eq 0>
			<img src="#SESSION.root#/Images/delete5.gif"
			style="cursor: pointer;" alt="delete" width="11" height="11" border="0" align="absmiddle"					
			onclick="if (confirm('Do you want to remove this record ?')) alert('remove this record')">
		</cfif> --->
	</td>	
    </TR>
  

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>
