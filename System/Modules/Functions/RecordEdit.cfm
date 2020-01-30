<cfinclude template="../InquiryBuilder/InquiryScript.cfm">

<cfparam name="url.mission" default="">

<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM Ref_ModuleControl L
	WHERE SystemFunctionId = '#URL.ID#'
</cfquery>

<cf_textareascript>
<cfajaximport tags="cfform,cfdiv,cfwindow">
<cf_dialogorganization>
<cf_dialoglookup>

<cf_screentop height="100%" 	    
	 border="0"
	 scroll="Yes"
	 band="No"	
	 html="Yes"	 
	 layout="webapp"
	 jQuery="Yes"
	 banner="blue"
	 line="no"	 
	 label="#Line.SystemModule# - Registration Form"
	 close="self.returnValue='1';window.close()">

		 
<cf_divscroll>

<table width="100%" height="100%" align="center">

<tr><td height="6"></td></tr>

<tr><td align="center">

<cfparam name="Status" default="1">

<cf_menuscript>
		
		<table width="97%"
	       border="0"
	       cellspacing="0"
	       cellpadding="0"
	       align="center"><tr>
		   
		    <cfset wd = "64">
			<cfset ht = "64">
			
			<cfset itm = "0">
				
			
			<cfif Line.functionClass neq "Window">	
			
			<cfset itm = itm + 1>
		   
		   	<cf_menutab item  = "#itm#" 
	            iconsrc    = "Logos/System/Maintain.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 
	            class      = "highlight1"
				name       = "Function Settings"
				source     = "FunctionSetting.cfm?id=#URL.ID#&mission=#url.mission#">
				
			</cfif>	
				
			<cfif Line.functionClass neq "SelfService" and Line.FunctionClass neq "Window">	
			
				 <cfif Line.MenuClass eq "Builder"
				    or Line.MenuClass eq "Implementation" 
					or Line.FunctionPath eq "Listing/Inquiry.cfm">
				 
				 	<cfset itm = itm + 1>
				 
				 	<cf_menutab item  = "#itm#" 
		            iconsrc    = "Builder.png" 
					iconwidth  = "#wd#" 
					targetitem = "1"
					iconheight = "#ht#" 
					name       = "Listing builder"
					source     = "../InquiryBuilder/InquiryEdit.cfm?systemfunctionid=#URL.ID#">					 
				 					 
		     	 </cfif> 	
			 
				<cfset itm = itm + 1>	   
		
				<cf_menutab item  = "#itm#" 
		            iconsrc    = "Logos/Roles.png" 
					iconwidth  = "#wd#" 
					targetitem = "1"
					iconheight = "#ht#" 
					name       = "Roles & Usergroups"
					source     = "FunctionRole.cfm?id=#URL.ID#">	
			
		  </cfif>
		  
		    <cfset itm = itm + 1>	
			
			<cfif itm eq "1">
			  <cfset cl = "highlight">
			<cfelse>
			  <cfset cl = "regular">  
			</cfif>
							
			<cf_menutab item  = "#itm#" 
	            iconsrc    = "Logos/System/Info.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 
				class      = "#cl#"
				name       = "About this function"
				source     = "FunctionMemo.cfm?id=#URL.ID#">	
				
			<cfset itm = itm + 1>		
			
			<cf_menutab item  = "#itm#" 
	            iconsrc    = "Check.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 
				name       = "Validations"
				source     = "Validation/FunctionValidation.cfm?id=#URL.ID#">		
				
				
			<cfset itm = itm + 1>		
			<cf_menutab item  = "#itm#" 
	            iconsrc    = "Help-Reference.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				iconheight = "#ht#" 
				name       = "Help and Reference"
				source     = "../HelpBuilder/RecordListing.cfm?systemfunctionid=#URL.ID#">		
		  
		  <cfset itm = itm + 1>	   
		  <cf_menutab item  = "#itm#" 
		      iconsrc    = "Logos/System/Secure.png" 
			  iconwidth  = "#wd#" 
			  targetitem = "1"
			  iconheight = "#ht#" 
			  name       = "Authorization Codes"
			  source     = "Authorization/AuthorizationRoles.cfm?id=#URL.ID#">	  
		 	 		
		</tr>
		</table>
	
	</td>
	
	</tr>
	
	<tr><td height="10"></td></tr>
	
	<cfinclude template="FunctionScript.cfm">	
	
	<cf_menucontainer item="1" class="regular">	
		
		<cfif Line.functionClass neq "Window">				
			<cfdiv bind="url:FunctionSetting.cfm?id=#URL.ID#&mission=#url.mission#"></cfdiv>
		<cfelse>
		    <cfdiv bind="url:FunctionMemo.cfm?id=#URL.ID#?id=#URL.ID#&mission=#url.mission#"></cfdiv>	
		</cfif>	
		
	</cf_menucontainer>	
		
	</table>
	
</cf_divscroll>	
	
<cf_screenbottom layout="webapp">	

<!--- incompatible/old approach
<script>
	document.getElementById("menu1").click()
</script>
--->


  	
