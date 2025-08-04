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

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

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

<tr><td>

<cf_divscroll>

<table width="96%" align="center" class="navigation_table">

<tr class="fixrow labelmedium2 line">
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
			
			<tr class="line navigation_row labelmedium2">
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

</td>
</tr>
</table>