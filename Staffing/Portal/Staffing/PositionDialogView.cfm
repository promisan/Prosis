
<cfquery name="Parent"
        datasource="AppsEmployee"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
        SELECT * FROM PositionParent
        WHERE PositionParentId = '#URL.PositionParentId#'
	</cfquery>

<cfoutput>

<table style="width:97%" align="center">

    <!---
    <tr><td style="padding-top:5px"></td></tr>
	<tr style="background-color:e1e1e1">
	    <td colspan="2" style="padding-top:20px;padding:10px;font-size:20px" class="labelmedium">#Position.SourcePostNumber#</td>
	</tr>
	--->
	
	<cf_wfActive entityCode="PostClassification" objectkeyvalue1="#url.positionparentid#">	
	
	<cfif Parent.ApprovalPostGrade neq "">
	
		<tr class="labelmedium">
			<td><cf_tl id="Classified as">:</td>
			<td style="width:70%">#Parent.ApprovalPostGrade# #Parent.FunctionDescription#</td>
		</tr>
			
		<tr class="labelmedium">
			<td><cf_tl id="Approval date">:</td>
			<td style="width:70%"><cfif parent.ApprovalDate eq ""><cf_tl id="Not available"><cfelse>#dateformat(Parent.ApprovalDate,client.dateformatshow)#</cfif></td>
		</tr>
				
		<tr class="labelmedium line">
			<td><cf_tl id="Classification Code">:</td>
			<td style="width:70%">#Parent.ApprovalReference#</td>
		</tr>
		
	</cfif>
	
	<cfif wfexist eq "1">
	
		<tr class="labelmedium">
			<td valign="top" style="padding-top:6px"><cf_tl id="Classification documents">:</td>
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
				
	<cfelse>		
	
		<cfquery name="Position"
        datasource="AppsEmployee"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
	        SELECT   * 
			FROM     Position
	        WHERE    PositionParentId = '#URL.PositionParentId#'
			ORDER BY Created DESC
	   </cfquery>	
	
		<tr><td colspan="2" style="padding-right:20px">
			
			 <cf_filelibraryN
			    Box="primary"
				DocumentPath="Position"
				SubDirectory="#Position.PositionNo#" 
				Filter=""
				ShowSize="0"
				Insert="no"
				Remove="no"
				Highlight="no"
				Listing="1">
		
		</td></tr>
		
	</cfif>
		
	</table>
	
<cfquery name="Position"
      datasource="AppsEmployee"
      username="#SESSION.login#"
      password="#SESSION.dbpw#">
       SELECT * FROM Position
       WHERE PositionParentId = '#URL.PositionParentId#'
	ORDER BY Created DESC
  </cfquery>		
	
<cfset AjaxOnLoad("function(){ProsisUI.setWindowTitle('Post number ## #Position.SourcePostNumber#');}")>

</cfoutput>


<!---
<cfsavecontent variable="vScript">
	ProsisUI.doTooltipPositioning(300);
</cfsavecontent>

<cfset ajaxOnLoad("function(){#vScript#}")>
--->

