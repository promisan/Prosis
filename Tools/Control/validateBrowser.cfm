<cfparam name="Attributes.minIE"         	default="11">	 
<cfparam name="Attributes.minDocumentmode"  default="#Attributes.minIE#">
<cfparam name="Attributes.minFF"        	default="60">
<cfparam name="Attributes.minChrome"     	default="60">
<cfparam name="Attributes.minEdge"       	default="14">
<cfparam name="Attributes.minSafari"     	default="8">
<cfparam name="Attributes.minOpera"      	default="5">
<cfparam name="Attributes.setDocumentMode" 	default="0">

<cfinvoke component     = "Service.Process.System.Client"  
		method          = "getBrowser"  
		browserstring   = "#CGI.HTTP_USER_AGENT#"
		minIE           = "#Attributes.minIE#" 
		minDocumentmode = "#Attributes.minDocumentmode#" 
		minFF           = "#Attributes.minFF#" 
		minEdge         = "#Attributes.minEdge#" 
		minChrome       = "#Attributes.minChrome#" 
		minSafari       = "#Attributes.minSafari#" 
		minOpera        = "#Attributes.minOpera#" 
		setDocumentMode = "#Attributes.setDocumentMode#"
		returnvariable  = "clientbrowser">
		
<cfset caller.clientbrowser = clientbrowser>

