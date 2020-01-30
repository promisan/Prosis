<!--- Create Criteria string for query from data entered thru search form --->

<cfajaximport>

<table style="height:100%;width:100%">

<tr><td style="height:20">

<cfset add          = "1">
<cfset Header       = "Salary Scale Components">
<cfinclude template = "../HeaderPayroll.cfm"> 
<cfparam name="url.trigger" default="">

</td></tr>

<!--- initially set the class --->
 

<cfoutput>

<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=780, height=770, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {	          
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=770, height=770, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<tr><td height="100%">

	<table width="96%" height="100%" align="center">
	
	<tr class="line" style="height:20px">   
		<td style="height:45;font-size:20px;padding-left:10px" class="labelmedium" colspan="12">
		<table>
		<tr>
					
			<cfquery name="SearchResult"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  *,  
				        R.Description as TriggerDescription
				FROM    Ref_PayrollComponent C,
				        Ref_PayrollTrigger R, 
						Ref_PayrollItem I
				WHERE   R.SalaryTrigger = C.SalaryTrigger
				AND     C.PayrollItem = I.PayrollItem	
				ORDER BY R.TriggerGroup,R.SalaryTrigger, C.EntitlementPointer, ListingOrder DESC
			</cfquery>
			
			<cfquery name="Trigger" dbtype="query">
				SELECT  DISTINCT TriggerGroup,SalaryTrigger, TriggerDescription
				FROM   SearchResult
			</cfquery>
	
			<!-- <cfform> -->
			<td style="padding-right:4px"><cf_tl id="Trigger"></td>
			<td>
			<cfselect name="Trigger"
	          group="TriggerGroup"
	          queryposition="below"
	          query="Trigger"
	          value="SalaryTrigger"
	          display="TriggerDescription"
	          visible="Yes"
	          enabled="Yes"
			  onchange="ptoken.navigate('RecordListingDetail.cfm?trigger='+this.value,'content')"
	          style="width:300px"
	          class="regularxxl">
			<option value="" selected>Any</option>		
			</cfselect>
			</td>
			<!-- </cfform> -->
			
		</tr>
		
		</table>	
		
		</td>	
	</tr>
	
	<tr><td height="100%">	
		<cf_divscroll style="height:100%" id="content">		
			<cfinclude template="RecordListingDetail.cfm">
		</cf_divscroll>
	
	</td></tr>
	
	</table>

</td></tr>

</table>