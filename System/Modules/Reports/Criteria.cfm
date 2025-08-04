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

<cf_screentop height="100%" html="no" jquery="Yes">

<cfoutput>
	
	<script language="JavaScript">
	
	function criteria(id) {
	    ptoken.open('CriteriaEdit.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1='+id,'box'+id, 'left=20, top=20, width=900, height=900, menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=no');		
	}
	
	function purge(rl) {
		if (confirm("Do you want to remove parameter: [" + rl + "] from this report ?")) {
		  ptoken.location('CriteriaPurge.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1='+rl)	     
		}  
	}
		
	</script>

</cfoutput>

<cfset cnt = "22">

<cfquery name="Clear" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM Ref_ReportControlCriteria
	WHERE  ControlId = '#URL.ID#'
	AND    RecordStatus = 0	
</cfquery>

<cfquery name="Criteria" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.SystemModule, C.*
    FROM   Ref_ReportControl R, 
	       Ref_ReportControlCriteria C
	WHERE  R.ControlId = '#URL.ID#'
	AND    C.ControlId = R.ControlId
	ORDER BY CriteriaClass, CriteriaOrder, CriteriaCluster 
</cfquery>

	<table width="100%" align="center">
	    
	  <tr>
	    <td width="100%">
	    <table width="100%" lass="navigation_table">
		
		<cf_distributer>
		
		<cfif master eq "1" and status eq "0">
		
		    <cfset cnt = cnt+34>
			<tr class="line">
			   <td colspan="9" class="labelmedium" style="padding-left:10px;font-size:17px;padding:7px;font-weight:200">
				<a href="javascript:criteria('')"><cf_tl id="Add Report Criteria"></a>
			   </td>
			</tr>			
			
		</cfif>		
				
		<cfif criteria.recordcount gt "0">
		
		    <TR class="labelmedium line fixrow fixlengthlist">
			   <td></td>
			   <td>Parent</td>
			   <td>Name</td>
			   <td>Cluster</td>
			   <td>Description</td>
			   <td>Type</td>
			   <td>O.</td>
			   <td>Scope</td>
			   <td></td>
		    </TR>	
			
		</cfif>
						
		<cfoutput query="Criteria" group="CriteriaClass">
		
		<tr class="labelmedium line"><td colspan="9">#CriteriaClass# <cf_tl id="criteria">:</td></tr>
		
		<cfset cnt = cnt + 36>
		<cfoutput>
						
		<TR class="navigation_row line labelmedium2 fixlengthlist" style="height:22px">
			  
		   <td align="center" style="padding-left:4px;padding-top:2px">		     
			 <cf_img icon="select" navigation="Yes" onclick="javascript:criteria('#CriteriaName#')">		     		   
		   </td>
		   <td>#CriteriaNameParent#</td>
		   <td>#CriteriaName#</td>
		   <td>#CriteriaCluster#</td>
		   <td>#CriteriaDescription#</td>
		   <td><b>#CriteriaType#&nbsp;</b><cfif LookupTable neq "">:#LookupTable#</cfif></td>
		   <td>#CriteriaOrder#</td>	
		   
		   <cfquery name="Default" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT R.*
			    FROM Ref_ReportControl R, Ref_ReportControlCriteria C
				WHERE R.SystemModule = '#SystemModule#'
				AND   R.FunctionClass = 'System'
				AND   C.ControlId = R.ControlId
				AND   C.CriteriaName = '#CriteriaName#'
			</cfquery>
		   <cfif Default.recordcount eq "1">
		   <td>Global</td>	
		   <cfelse>
		   <td>Local</td>	
		   </cfif>   
		   <td style="padding-top:2px">
		    <cfif status eq "0">
			 <cf_img icon="delete" onclick="purge('#CriteriaName#')">		   
			</cfif>
		  </td>
		</tr> 
				
		</cfoutput>
		</cfoutput>
								
	</table>	
		
	<cfoutput>
	<script language="JavaScript">
	
		{	
		frm  = parent.document.getElementById("icrit");
		he = #cnt#+9+#criteria.recordcount*22#;
		frm.height = he
		
		}
	
	</script>
	</cfoutput>
