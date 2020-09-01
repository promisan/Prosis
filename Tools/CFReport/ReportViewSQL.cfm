
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

<table style="width:98.5%" height="100%">
    
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
		<td valign="top" height="30" style="padding-left:4px" align="center">
	    <table width="100%" align="center" class="navigation_table">
	    <tr class="line labelmedium fixrow">
	      <td style="font-size:16px;padding-left:3px"><cf_tl id="Type"></td>
		  <td style="padding-right:4px;font-size:16px"><cf_tl id="Name"></td>
	      <td style="padding-right:4px;font-size:16px"><cf_tl id="Variable"></td>
		  <td style="font-size:16px"><cf_tl id="Value passed"></td>
	    </tr>			
	    #session.parscript#		
	    </table> 	
        </td>
	</tr>
	
	<tr>
       <td valign="top" height="100%">
	   <table width="100%" height="100%" align="center" align="right">
		   <tr class="labelmedium fixrow line">
		    <td height="20" align="left" style="height:40px;font-size:20px;padding-left:10px">
		    <cf_tl id="Report Query Script">
			</td>
			<td>
			<select style="font-size:20px;height:35px;" name="format" id="format" class="regularxl"><option value="Yes" selected>Line</option><option value="No">Hide lines</select></b>
			</td>
			<td align="right" style="padding-right:8px;font-size:16px">
			Path: #session.rootpath##UserReport.ReportPath##UserReport.TemplateSQL#</font> 
			</td>
		    </td>
			</tr>	
								
			<tr><td height="100%" colspan="3" width="95%" align="center">						
				<cf_securediv bind="url:ReportViewSQLContent.cfm?id=#userreport.controlid#&format={format}" id="sqlcontent" style="height:100%;">								 
			</td>
			</tr>		
		</table> 
	</td></tr>	 

	</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>