<!--- Create Criteria string for query from data entered thru search form --->
 
 <cf_screentop html="no" jquery="yes">
 
<cfquery name="SearchResult"
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    Code, 
	          Mission, 
			  PASPeriodStart, 
			  PASPeriodEnd, 
			  PASEvaluation, 
			  ContractClass,
			  (    SELECT count(*) 
				   FROM   Contract 
				   WHERE  Period = P.Code 
				   AND    Operational = 1 
				   AND    ActionStatus <= '3') as Counted,
			  Operational,
			  OfficerUserId,
			  OfficerLastName,
			  Created
    FROM       Ref_ContractPeriod P	
    ORDER BY   Mission, Code   
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function reloadForm(page) {
     ptoken.location="RecordListing.cfm?Page=" + page; 
}

function recordadd() {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=450, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width=600, height= 450, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="94%" align="center" class="navigation_table">

<tr class="fixrow labelmedium line">
	<td height="25"></td>
	<td style="padding-left:4px"><cf_tl id="Period"></td>
	<td style="padding-left:4px"><cf_tl id="Class"></td>
	<td style="padding-left:5px"><cf_tl id="Effective"></td>	
	<td style="padding-left:5px"><cf_tl id="Expiration"></td>	
	<td style="padding-left:5px"><cf_tl id="Evaluation"></td>		
	<td align="right"><cf_tl id="Entries"></td>  
	<td align="right" style="padding-right:4px"><cf_tl id="Officer"></td>  
	<td align="right" style="padding-right:4px"><cf_tl id="Date"></td>  
</tr>

<cfoutput query="SearchResult" group="Mission">		
			
		<tr><td height="5"></td></tr>
		<tr><td style="font-size:20px;height:30px" class="labellarge" colspan="6">#Mission#</td></tr>
			
		<cfoutput>					
			
			<tr class="line navigation_row labelmedium">
				<td></td>				
				<td style="padding-left:4px"><a href="javascript:recordedit('#code#')" class="navigation_action">#Code#</a></td>
				<td style="padding-left:4px">#ContractClass#</td>
				<td style="padding-left:5px">#Dateformat(PasPeriodStart, "#CLIENT.DateFormatShow#")#</td>
				<td style="padding-left:5px">#Dateformat(PasPeriodEnd, "#CLIENT.DateFormatShow#")#</td>
				<td style="padding-left:5px">#Dateformat(PasEvaluation, "#CLIENT.DateFormatShow#")#</td>
				<td align="right" style="padding-left:5px">#counted#</td>
				<td align="right" style="padding-right:3px">#OfficerLastName#</td>	
				<td align="right" style="padding-right:5px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			</tr>					
		
		</cfoutput>
	
	</cfoutput>
	
</table>

</cf_divscroll>