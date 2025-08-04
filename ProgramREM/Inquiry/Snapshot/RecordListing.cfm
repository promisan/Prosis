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
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     E.Mission, 
	           E.Version, 
			   E.Description, 
			   R.Period, 
			   R.Snapshotdate, 
			   R.SnapshotBatchId,
			   A.Fund, 
			   R.Memo,
			   SUM(A.RequestAmountBase) AS Amount, 
			   COUNT(*) AS Lines,
			   R.OfficerLastName
	FROM       Ref_Snapshot R INNER JOIN
               Ref_AllotmentEdition E ON R.EditionId = E.EditionId LEFT OUTER JOIN
               ProgramAllotmentrequestSnapshot A ON R.SnapshotBatchId = A.SnapshotBatchId AND A.ActionStatus <> '9'
	GROUP BY   E.Mission, E.Version, E.Description, R.Period, R.Snapshotdate, A.Fund, R.Memo, R.SnapshotBatchId, R.OfficerLastName
    ORDER BY   E.Mission, R.Period, R.Snapshotdate DESC, A.Fund   
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
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=350, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width= 550, height= 350, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium line">
	<td height="25"></td>
	<td style="padding-left:20px"><cf_tl id="Date"></td>
	<td><cf_tl id="Edition"></td>	
	<td><cf_tl id="Fund"></td>
	<td align="right"><cf_tl id="Entries"></td>
    <td align="right"><cf_tl id="Amount"></td>
</tr>

<cfoutput query="SearchResult" group="Mission">
		
		<cfoutput group="Period">
		
		<tr><td height="5"></td></tr>
		<tr>
		    <td style="font-size:20px;height:30px" class="labellarge" colspan="6">#Mission# - #Period#</td>	
		</tr>
			
			<cfoutput group="Snapshotdate">
					
			
			<tr class="line navigation_row labelmedium">
				<td></td>
				<td style="padding-left:20px"><a href="javascript:recordedit('#SnapshotBatchId#')" class="navigation_action"><font color="0080C0">#Dateformat(Snapshotdate, "#CLIENT.DateFormatShow#")#</a></td>
				<td>#Description#</td>
				<td colspan="2">#Memo#</td>		
				<td align="right" style="padding-right:3px" colspan="1">#OfficerLastName#</td>	
			</tr>
			
				<cfoutput>
				
					<tr class="cellcontent">
						<td></td>
					    <td></td>	
						<td></td>
						<td bgcolor="f1f1f1">#Fund#</td>	
						<td bgcolor="f1f1f1" align="right">#Lines#</td>
						<td bgcolor="f1f1f1" align="right" style="padding-right:3px">#numberformat(Amount,",.__")#</td>
					</tr>
				
				</cfoutput>
				
			<tr class="line"><td colspan="6"></td></tr>	
						
			</cfoutput>
		
		</cfoutput>
	
	</cfoutput>
	
</table>

</cf_divscroll>