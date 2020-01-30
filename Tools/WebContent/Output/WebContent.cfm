
<!--- outputting webcontent --->

<cfparam name="Attributes.SystemFunctionId"  default="">
<cfparam name="Attributes.ContentId"         default="">
<cfparam name="Attributes.LanguageId"        default="ENG">

<cfif attributes.systemfunctionid neq "">
	
	<cfquery name="getContent" 
		 datasource="AppsSystem">
		  SELECT Text#attributes.LanguageId# as Content
		  FROM  Ref_ModuleControlContent
		  WHERE SystemFunctionId = '#attributes.SystemFunctionId#'
		  AND   ContentId = '#attributes.ContentId#'		
	</cfquery>
	
	<cfoutput>#getContent.Content#</cfoutput>

</cfif>