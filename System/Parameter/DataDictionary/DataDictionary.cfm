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
<cf_screenTop height="100%" 
    title="#SESSION.welcome# Data dictionary of CF datasources" 
    label="#SESSION.welcome# <b>Data dictionary</b> of CF datasources" 
	option="#SESSION.welcome# datasources" 
	html="Yes" 
	band="No" 
	scroll="no" 	
	MenuAccess="Yes" 
	layout="webapp" 
	banner="gray">

<cfoutput>	

<table width="98%" height="100%" align="center">

<cfif CGI.HTTPS eq "off">
     <cfset protocol = "http">
<cfelse> 
  	<cfset protocol = "https">
</cfif>

<cfset protocol = "http">

<tr class="hide"><td height="0">
  <iframe name="flex2gateway" src="#protocol#://#CGI.HTTP_HOST#/flex2gateway"
   frameborder="0" scrolling="no" width="22" height="0">
   </iframe> 
</td></tr>

<tr><td align="center" width="100%" style="padding-top:10px">

		<iframe src="DataDictionaryContent.cfm" name="invokedetail" id="invokedetail" width="100%" height="100%" scrolling="no" frameborder="0">				
		</iframe>	
			
								
</td></tr>
</table>	
</cfoutput>


