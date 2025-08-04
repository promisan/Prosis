<!--
    Copyright © 2025 Promisan

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
<cfparam name="Attributes.size" 	default="">

<cftry>

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'  
    </cfquery>
	
	<cfinvoke component="Service.Image.CFImageEffects" method="init" returnvariable="effects">  
		
	<cfif find(":",parameter.logopath)> 	
	
				
		  <cfimage action="read" source="#parameter.logopath#\#parameter.logofilename#" name="img">				 
			
		   <cfset roundedImage = effects.applyRoundedCornersEffect(img, "white", 20)>

		   <cfif trim(attributes.size) neq "">
			   <cfimage action="resize" 
			       source="#roundedImage#" 
				   height="#attributes.size#"
				   width=""
				   name="roundedImage">
			</cfif>	
												
		   <cfimage action="WRITETOBROWSER" 
		       source="#roundedImage#" 
			   format="PNG">  
			
	<cfelse>
	
		  <cfimage action="read" source="#SESSION.root#/#parameter.logopath#/#parameter.logofilename#" name="img">				 
		  			
		   <cfset roundedImage = effects.applyRoundedCornersEffect(img, "white", 20)>
		
		   <cfif trim(attributes.size) neq "">
			   <cfimage action="resize" 
			       source="#roundedImage#" 
				   height="#attributes.size#"
				   width=""
				   name="roundedImage">
			</cfif>

		   <cfimage action="WRITETOBROWSER" 
		       source="#roundedImage#" 
			   format="PNG">  
			
	</cfif>
	
	<cfcatch>No Logo found</cfcatch>
	
</cftry>	