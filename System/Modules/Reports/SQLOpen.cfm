
<cf_screentop title="SQL.cfm" height="100%" scroll="Yes" layout="innerbox">

<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   Ref_ReportControl L
	WHERE  ControlId = '#URL.ID#'	
</cfquery>

<cfoutput>
	
	<cfif Line.ReportRoot eq "Report">
	  <cfset rt = "#SESSION.rootreportpath#">
	<cfelse>
	  <cfset rt = "#SESSION.rootpath#">
	</cfif>
	    
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" rules="groups">
						
			<tr><td valign="top" colspan="2" height="100%" height="100%" style="font-family : arial; font-size : 9pt;">
			<cfinvoke component="Service.Presentation.ColorCode"  
			      method="colorfile" 
			      filename="#rt#\#Line.ReportPath#\SQL.cfm" 
			      returnvariable="result">			
	              <cfset result = replace(result, "Â", "", "all") />			   			  
				  #result#						
			</td></tr>		
			  			
		</table>
					
	</cfoutput>
	
<cf_screenbottom layout="innerbox">	
