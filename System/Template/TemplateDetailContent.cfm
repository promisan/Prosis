

<cfquery name="Template" 
	datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE TemplateId = '#URL.TemplateId#'
</cfquery>	

<cfoutput>

<cfif Template.TemplateSize gt 40000>

	<!--- size is too big so it would be too slow --->

	<cfif find("textarea","#Template.TemplateContent#")>
		 <cfset content = "#replace(Template.TemplateContent,'textarea','_textarea','ALL')#">
    <cfelse>
		 <cfset content = "#Template.TemplateContent#">
	</cfif>
		
	<textarea class="regular" style="font-family:verdana; font-size: 8pt; width:100%; height:#client.height-270#; color: blue; background: white;">
		#content#
	</textarea>
	
<cfelse>
	
	<cfinvoke component="Service.Presentation.ColorCode"  
		   method="colorstring" 
		   datastring="#Template.TemplateContent#" 
		   returnvariable="result">		
		   	
	       <cfset result = replace(result, "Â", "", "all")/>
		   <table><tr><td>#result#</td></tr></table>
	
</cfif>

</cfoutput>	
	