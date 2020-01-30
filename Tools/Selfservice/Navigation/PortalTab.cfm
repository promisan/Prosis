<cfparam name="Attributes.Mode"              default="GoTo">	
<cfparam name="Attributes.Icon"              default="">	
<cfparam name="Attributes.Content"           default="">	
<cfparam name="Attributes.Opener"            default="parent.">
<cfparam name="Attributes.Reload"            default="false">
<cfparam name="Attributes.Style"             default="">
<cfparam name="Attributes.SystemModule"      default="SelfService">	
<cfparam name="Attributes.MenuClass"         default="Process">	
<cfparam name="Attributes.Id"                default="">	
<cfparam name="Attributes.FunctionName"      default="">	

<cfswitch expression="#attributes.Mode#">

	<cfcase value="GoTo">
	
		<cfquery name="getTab" 
			datasource="appsSystem">     
		       SELECT   *
		       FROM     Ref_ModuleControl
		       WHERE    SystemModule = '#attributes.SystemModule#' 
			   AND 		MenuClass = '#attributes.MenuClass#'
		       AND      FunctionClass = '#attributes.id#'        
		       AND      FunctionName = '#attributes.FunctionName#'      
		</cfquery> 
		  
		<cfif getTab.recordcount eq "1">
		    <cfif attributes.icon neq "">
			   <cf_img icon="#attributes.icon#" onclick="javascript:#Attributes.Opener#_goToTab('#getTab.systemFunctionId#', #Attributes.Reload#)">	
			<cfelse>
			<cfoutput>
				<cf_tl id="Go" var="1">
				<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#_goToTab('#getTab.systemFunctionId#', #Attributes.Reload#)"><u>#attributes.Content#</u></a>	  
			</cfoutput>
			</cfif>
		</cfif>
	
	</cfcase>
	
	<cfcase value="Prior">
		<cfoutput>
			<cf_tl id="Previous Tab" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#_goToPreviousTab(#Attributes.Reload#)">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Next">
		<cfoutput>
			<cf_tl id="Next Tab" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#_goToNextTab(#Attributes.Reload#)">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Login">
		<cfoutput>
			<cf_tl id="Login" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#showLogin()">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Menu">
		<cfoutput>
			<cf_tl id="Open Menu" var="1">
			<a style="#Attributes.Style#" title="#lt_text#" href="javascript:#Attributes.Opener#showMainMenu()">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>
	
	<cfcase value="Preferences">
		<cfoutput>
			<cf_tl id="Open Preferences" var="1">
			<a style="#Attributes.Style#" href="javascript:#Attributes.Opener#showOptions()">#attributes.Content#</a>	  
		</cfoutput>
	</cfcase>

</cfswitch>