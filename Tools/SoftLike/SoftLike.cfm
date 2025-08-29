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
<cfparam name="attributes.left"         default="">
<cfparam name="attributes.right"        default="">
<cfparam name="attributes.collate"      default="Cyrillic_General_CI_AI">
<cfparam name="attributes.language"     default="">
<cfparam name="url.var"                 default  = "0">
<cfparam name="Attributes.var"          default  = "#url.var#">

<cfset sanitized = "">

<cf_softLikeSanitize 
    field="#attributes.left#" 
    type="db" 
    language="#attributes.language#">
	
<cfset vLeft = sanitized>

<cfset sanitized = "">

<cf_softLikeSanitize 
    field="#attributes.right#" 
    type="text" 
    language="#attributes.language#">
	
<cfset vRight = sanitized>

<cfif attributes.var eq "1">

	<cfset caller.softstring = "( (CONVERT(varchar(max), #vLeft#) COLLATE #attributes.collate#) LIKE (CONVERT(varchar(max),'%#vRight#%') COLLATE #attributes.collate#) )">

<cfelse>
	
	<cfoutput> 
	( (CONVERT(varchar(max), #vLeft#) COLLATE #attributes.collate#) 
	   LIKE (CONVERT(varchar(max),'%#vRight#%') COLLATE #attributes.collate#) )
	</cfoutput>

</cfif>
