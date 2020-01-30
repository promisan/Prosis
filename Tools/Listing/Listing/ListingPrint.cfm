
 <cfif Attributes.printShow eq "yes">
 
	 <td class="labelit" style="height:28px;padding-left:6px;padding-right:3px;">
	 
	 	<cf_tl id="Print" var="vPrintTooltip">
		<cf_tl id="Listing" var="vDefaultTitle">
		<cfset vListingTitleLabel = vDefaultTitle>
		
	 	<cfif trim(URL.SystemFunctionId) neq "">
		
		 	<cfquery name="getFunctionDef" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   xl#Client.LanguageId#_Ref_ModuleControl R
					WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
			</cfquery>
			<cfset vListingTitleLabel = "#vListingTitleLabel#: #getFunctionDef.FunctionName#">
			
		</cfif>
		
		<cfif trim(attributes.printshowtitle) neq "">
			<cfset vListingTitleLabel = trim(attributes.printshowtitle)>
		</cfif>
		
		<cfoutput>
			
			<div id="processPrint" style="display:none;"></div>
			<span id="printTitle" style="display:none;">#vListingTitleLabel#</span>
			
			<cf_button2 
				mode		= "icon"
				type		= "button"
				image		= "Print.png"
				title       = "#vPrintTooltip#" 
				id          = "Print"					
				height		= "30px"
				width		= "30px"
				imageheight  = "20px"
				onclick	 	= "printListing('#attributes.printshowrows#', 'processPrint');">
				
				
		</cfoutput>

	</td>
 </cfif>