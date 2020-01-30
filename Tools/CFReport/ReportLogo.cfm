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