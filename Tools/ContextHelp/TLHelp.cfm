
<!--- HANNO prevent javascript to be repeated all the time, better to make it central code --->

<!--- example
<cf_helpfile code     = "TravelClaim" 
			 id       = "1" 
			 class    = "General">
			 name     = "topicname"
			 display  = "Both"
			 displayText = "My description"
			 color    = "blue">
--->

<cfparam name="Attributes.systemfunctionid"   default="">

<cfparam name="loaded"                   default="No">

<cfparam name="Attributes.TopicId"       default="">
<cfparam name="Attributes.SystemModule"  default="">
<cfparam name="Attributes.Code"          default="#attributes.SystemModule#">

<cfparam name="Attributes.Class"         default="General">

<cfparam name="Attributes.HelpId"        default="">
<cfparam name="Attributes.Id"            default="#attributes.helpid#">
<cfparam name="Attributes.LabelId"       default="">
<cfparam name="Attributes.TopicName"     default="#attributes.LabelId#">

<cfparam name="Attributes.StyleClass"    default="labelmedium">
<cfparam name="Attributes.Mode"          default="tooltip">

<cfparam name="Attributes.TopicLabel"    default="#attributes.TopicName#">
<cfparam name="Attributes.Display"       default="Both">

<cfparam name="Attributes.Color"         default="">

<cfparam name="Attributes.IconFile"      default="">
<cfparam name="Attributes.Mode"          default="Tooltip">

<cfparam name="client.editing"           default="0">
<cfparam name="attributes.edit"          default="#client.editing#">

<cfparam name="Attributes.Align"         default="">

<cfquery name="Help" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   HelpProject
	WHERE  ProjectCode = '#Attributes.Code#'
</cfquery>


<cfquery name="HelpId" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  HelpProjectTopic
	<cfif attributes.topicid neq "">
	WHERE TopicId       = '#attributes.TopicId#'  
	<cfelse>
	WHERE ProjectCode   = '#Attributes.Code#'
	AND   TopicClass    = '#Attributes.Class#'
	AND   TopicCode     = '#Attributes.Id#'
	AND   LanguageCode  = '#CLIENT.LanguageId#' 
	</cfif>
</cfquery>

<!--- ----------------- --->
<!--- auto registration --->
<!--- ----------------- --->

<cfif Help.recordcount eq "1" and Helpid.recordcount eq "0">

	<!--- auto registration --->
	<cfinclude template="HelpFileAuto.cfm">
		
	<!--- retrieve id again --->	
	<cfquery name="HelpId" 
	datasource="AppsSystem"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  HelpProjectTopic
		WHERE ProjectCode   = '#Attributes.Code#'
		AND   TopicClass    = '#Attributes.Class#'
		AND   TopicCode     = '#Attributes.Id#'
		AND   LanguageCode  = '#CLIENT.LanguageId#' 
	</cfquery>
			 	
</cfif>		

<cfif attributes.labelid neq "">
    <cf_tl id="#attributes.LabelId#" var="label">
	<cfset label = attributes.labelid>	
<cfelse>	
	<cfset label = helpid.UITextHeader>		
</cfif>
	
<cfset show  = "local">
<cfset link  = "">
	
<cfif HelpId.UITextHeaderIcon eq "">
	  <cfset icon = "help3.png">
<cfelse>
	  <cfset icon = "#HelpId.UITextHeaderIcon#">
</cfif>

<cfoutput>
	
<table width="100%">
		
	<cfif HelpId.TopicPresentation eq "Embed">
	
	<tr class="line">
	<td style="padding-top:6px;font-size:16px;font-weight:bold">#HelpId.TopicName#</td>
	</tr>
	
	<tr>
	<td style="padding-left:10px;padding-top:4px">#HelpId.UITextAnswer#</td>
	</tr>
													
	<cfelseif HelpId.TopicPresentation eq "Tooltip" or HelpId.TopicPresentation eq "Dialog">	
	
	<tr>
											
	        <!--- tooltip --->		
															
			<cfif (Attributes.Display eq "Both" or Attributes.Display eq "Text")>
																	
					<cfif Attributes.Align eq "">
						<td style="padding:0px;cursor:pointer;" class="#attributes.styleclass#">
					<cfelse>
						<td style="padding:0px;cursor:pointer;" class="#attributes.styleclass#" align="#Attributes.Align#">
					</cfif>			
					    										
						<a href="javascript:setProsisHelp('#SESSION.root#/Tools/ContextHelp/HelpContent.cfm?topicid=#HelpId.topicid#', function(){ showProsisHelp(); });">																			   
							<font color="#attributes.color#" style="font-size:12px">#label#</font>							
						</a>						
						
					</td>
					
					<cfif Attributes.Display eq "Both">
					
					<td style="padding-left:3px;padding-right:3px" 
					   onclick="setProsisHelp('#SESSION.root#/Tools/ContextHelp/HelpContent.cfm?topicid=#HelpId.topicid#', function(){ showProsisHelp(); });">
					
						<img src="#SESSION.root#/Images/#icon#"	border="0" align="absmiddle" style="cursor: pointer;">
						 
					</td>	 
					
					</cfif>
					
			<cfelseif Attributes.Display eq "Icon">
			
					<td style="padding-left:3px;padding-right:3px" 
					   onclick="setProsisHelp('#SESSION.root#/Tools/ContextHelp/HelpContent.cfm?topicid=#HelpId.topicid#', function(){ showProsisHelp(); });">
					
						<img src="#SESSION.root#/Images/#icon#"	border="0" align="absmiddle" style="cursor: pointer;">
						 
					</td>	 
					
			</cfif>		
			
			<!---
					
				<cfelseif Attributes.Display eq "Both" or Attributes.Display eq "Icon">
				
				    <cfif attributes.display eq "both">
					    
						<td width="2"></td>
						
					</cfif>			
									
					<td>
																	
					<a href="javascript:setProsisHelp('#SESSION.root#/Tools/ContextHelp/HelpContent.cfm?topicid=#HelpId.topicid#', function(){ showProsisHelp(); });">																
						<img src="#SESSION.root#/Images/#ic#"									    	 
							 border="0"							 
							 align="absmiddle"
							 style="cursor: pointer;">
					</a>
								 
					</td>			 
							 
				</cfif>		
			
			--->
			
	</cfif>									
	
	</tr>
</table>
	
</cfoutput>
 