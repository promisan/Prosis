
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#positionparentid#'	 
</cfquery>

<cfoutput>

<table width="96%" align="center" class="formpadding formspacing">

	<cf_wfActive entityCode="PostClassification" objectkeyvalue1="#positionparentid#">	
			
	<cfif Parent.ApprovalPostGrade eq "">
	
		<tr class="labelmedium line">
			<td style="font-size:18px" align="center" colspan="2">Has NO prior classification recorded</td>		
		</tr>
	
	<cfelse>
	
		<cfif wfexist eq "1">
		<tr class="labelmedium line">
			<td style="font-size:18px" colspan="2" align="center">Has prior classification approval flow</td>		
		</tr>
		</cfif>
		
		<tr><td style="height:5px"></td></tr>
			
		<tr class="labelmedium">
			<td><cf_tl id="Classified as">:</td>
			<td style="width:70%">#Parent.ApprovalPostGrade# #Parent.FunctionDescription#</td>
		</tr>
		
		<tr class="labelmedium">
			<td><cf_tl id="Approval date">:</td>
			<td style="width:70%"><cfif parent.ApprovalDate eq ""><cf_tl id="Not available"><cfelse>#dateformat(Parent.ApprovalDate,client.dateformatshow)#</cfif></td>
		</tr>
			
		<tr class="labelmedium">
			<td><cf_tl id="Classification Code">:</td>
			<td style="width:70%">#Parent.ApprovalReference#</td>
		</tr>
		
		<cfif wfexist eq "1">
			
			<tr class="labelmedium">
				<td valign="top" style="padding-top:6px"><cf_tl id="Classification document">:</td>
				<td>
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
				</td>
			</tr>
		
		</cfif>
		
	</cfif>
	
	<cf_tl id="Initiate Request" var="1">
	
	<tr><td colspan="2" align="center" style="padding-top:7px;border-top:1px solid silver">	
		<input type="button" name="Initiate request" class="botton10g" style="width:220px;height:29px" value="#lt_text#"
		onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Staffing/Portal/Staffing/StaffingPositionWorkflowClassification.cfm?positionparentid=#url.positionparentid#&ajaxid=#url.ajaxid#&portal=1&init=1','#url.ajaxid#');ProsisUI.closeWindow('classify')">					
	</td></tr>
</table>

</cfoutput>