
 <cfquery name="UserReport" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControl
	 WHERE  ControlId = '#url.Id#'
	</cfquery>

	<cfif UserReport.ReportRoot eq "Application">
		
			<cfinvoke component="Service.Presentation.ColorCode"  
			   method="colorfile" lineNumbers="#url.format#"
			   filename="#SESSION.rootpath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#" 
			   returnvariable="result">			
	           <cfset result = replace(result, "Â", "", "all") />
				   				  
	<cfelse>
		
		<cfinvoke component="Service.Presentation.ColorCode"  
			   method="colorfile" linenumbers="#url.format#"
			   filename="#SESSION.rootReportPath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#" 
			   returnvariable="result">			
	           <cfset result = replace(result, "Â", "", "all") />
			
	</cfif>		   
		
	<table width="100%" height="100%" align="center">
	<tr><td class="labelit"> 
	
		<cfoutput> 
				
			<font face="Courier"  style="font: 10px;">
				#RESULT#
			</font>

	    </cfoutput>	
				
	</td></tr>    
	</table>