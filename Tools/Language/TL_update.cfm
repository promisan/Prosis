
<cfparam name="url.cls" default="Label">
<cfparam name="Attributes.Class"  default="#url.cls#">

<cfparam name="url.clsid" default="">
<cfparam name="Attributes.Id"     default="#url.clsid#">

<cfparam name="url.var" default="0">
<cfparam name="Attributes.var"    default="#url.var#">

<!--- retrieve from database --->

<!--- step 1 we check if there is an application server specific language label --->
	
<cfquery name="qSite" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#'  
</cfquery>

<!--- specific for this site --->

<cfquery name="qSelect" 
datasource="AppsInit">
	SELECT *
	FROM   InterfaceSite
	WHERE  ApplicationServer = '#qSite.ApplicationServer#'
	AND    TextClass         = '#Attributes.Class#'
	AND    TextId            = '#Attributes.Id#'
</cfquery>
	
<cfif qSelect.recordcount eq "0">

	<!--- then we check one level up which is generic --->
		
	<cfquery name="qSelect" 
	datasource="AppsInit">
		SELECT *
		FROM   InterfaceText
		WHERE  TextClass = '#Attributes.Class#'
		AND    TextId    = '#Attributes.Id#'
	</cfquery>	
		 
	<cfset t = evaluate("qSelect.Text" & "#CLIENT.LanguageId#")>
	
<cfelse>
	 
	<cfset t = evaluate("qSelect.Text" & "#CLIENT.LanguageId#")>	
				
</cfif>	

<cfoutput><i>#t#</cfoutput>

<cf_compression>
	