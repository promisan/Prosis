<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   *
  FROM     UserError 
  WHERE    ErrorId = '#url.ajaxid#'
</cfquery> 

<cfset link = "System/Portal/Exception/ExceptionView.cfm?errorid=#url.ajaxid#">

<cf_ActionListing 
	EntityCode       = "SysError"
	EntityGroup      = "#get.HostServer#"
	EntityClass      = "#get.HostServer#"
	EntityStatus     = ""
	OrgUnit          = ""
	PersonNo         = "" 
	ObjectReference  = "Exception Error #get.ErrorTemplate#"
	ObjectReference2 = "#SESSION.first# #SESSION.last#"
	ObjectKey4       = "#get.ErrorId#"
	ajaxid           = "#get.ErrorId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">	
	
<cfoutput>

<script>
  	
	<!--- refreshes the listing --->	
	try {	
	opener.applyfilter('','','#get.ErrorId#') } catch(e) {}
		
</script>	

</cfoutput>
		
<!--- refresh the opener status --->