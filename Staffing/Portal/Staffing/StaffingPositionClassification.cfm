
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#positionparentid#'	 
</cfquery>

<cfoutput>

<table width="96%" align="center">

	<cf_wfActive entityCode="PostClassification" objectkeyvalue1="#positionparentid#">	
	
	<tr class="labelmedium">
		<td><cf_tl id="Classification">:</td>
		<td style="width:70%"><cfif wfexist eq "1">Has prior classification</cfif></td>
	</tr>
	
	<cfif wfexist eq "1">
	
		<tr><td colspan="2" style="padding-left:4px;padding-right:4px">
		
			<cf_filelibraryN
					DocumentPath="PostClassification"
					SubDirectory="#wfObjectId#" 
					Filter=""			
					Insert="no"
					Remove="no"			
					Loadscript="no"
					width="100%"	
					showsize="0"		
					border="1">	
			
		</td></tr>
	
	</cfif>

	<tr class="labelmedium">
		<td><cf_tl id="Prior Reference">:</td>
		<td style="width:70%">#Parent.ApprovalReference# #Parent.ApprovalPostGrade#</td>
	</tr>
		
	<tr class="labelmedium">
		<td><cf_tl id="Loan history">:</td>
		<td>--</td>
	</tr>
	
	<tr><td colspan="2" align="center">	
		<input type="button" name="Initiate request" class="botton10g" style="width:200px;height:25px" value="Initiate request"
		onclick="ptoken.navigate('#SESSION.root#/Staffing/Portal/Staffing/StaffingPositionWorkflowClassification.cfm?positionparentid=#url.positionparentid#&ajaxid=#url.ajaxid#&portal=1&init=1','#url.ajaxid#')">					
	</td></tr>
</table>

</cfoutput>