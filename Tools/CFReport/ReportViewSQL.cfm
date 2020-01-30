
<!--- identify layout --->
<cfquery name="UserReport" 
    datasource="AppsSystem">
	 SELECT     R.*, 
	 			L.LayoutId,
	            L.TemplateReport, 
				L.LayoutCode, 
				L.LayoutClass, 
				L.LayoutName 
	 FROM       Ref_ReportControl R, Ref_ReportControlLayout L
	 WHERE      L.LayoutId = '#url.LayoutId#' 
	 AND        R.ControlId = L.ControlId
</cfquery>
	
<cfoutput>

<table width="100%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
    
	<!---
	<tr>
	   <cf_tl id="Refresh" var="1">
	   <td height="30">&nbsp;&nbsp;
	   <input type = "button" 
	      onclick="perform('sql')" 
		  class="button10g" style="width:100px"
		  name="sql" id="sql"
		  value = "#lt_text#" 
		  style="cursor : pointer;"></td>
    </tr>	
	--->
	<tr>
		<td valign="top" height="30" style="padding-left;4px" align="center">
	    <table width="95%" cellspacing="0"  cellpadding="0" align="center" class="navigation_table">
	    <tr class="line">
	      <td class="labelmedium" width="180"><cf_tl id="Type"></td>
	      <td class="labelmedium" width="120" style="padding-right:4px"><cf_tl id="Name"></td>
		  <td class="labelmedium" width="180"><cf_tl id="Value passed"></td>
	    </tr>			
	      #session.parscript#		
	    </table> 	
        </td>
	</tr>
	
	<tr>
       <td valign="top" height="100%">
	   <table width="100%" height="100%" align="center" align="right">
		   <tr class="labelmedium">
		    <td height="20" align="left" style="padding:2px; padding-left:10px">
		    <cf_tl id="Report Query Script">
			<font face="Verdana" color="gray">(#UserReport.ReportPath#/#UserReport.TemplateSQL#)</font> 
		    <select name="format" id="format" class="regularxl"><option value="Yes" selected>Line</option><option value="No">No lines</select></b>
			</td>
			</tr>	
			<tr><td height="1" bgcolor="C0C0C0"></td></tr>						
			<tr><td height="100%" width="95%" align="center">
						
				<cfdiv bind="url:ReportViewSQLContent.cfm?id=#userreport.controlid#&format={format}" id="sqlcontent" style="height:100%;"/>			
					 
			</td>
			</tr>		
		</table> 
	</td></tr>	 

	</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>