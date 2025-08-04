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
<cfparam name="Attributes.minIE"         	default="12">	 
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

