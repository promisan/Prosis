<!--
    Copyright Â© 2025 Promisan B.V.

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
	