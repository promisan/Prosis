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
<cfparam name="Attributes.mode" 			default="">
<cfparam name="Attributes.maxTextLength" 	default="100">

<cfif thisTag.ExecutionMode is 'start'>

<cfelse>

	<cfif Attributes.mode eq 'cut'>
		 
		<cfset textstr = REReplace(ThisTag.GeneratedContent,'<head[^>]*>(.*?)</head>',' ','all')>
		<cfset textstr = REReplace(textstr,'<table[\s]*[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'</table[\s]*[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'<thead[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'</thead[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'<font[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'</font[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'<a[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'</a>',' ','all')>
		<cfset textstr = REReplace(textstr,'<[^>]*>',' ','all')>
		<cfset textstr = REReplace(textstr,'</[^>]*>',' ','all')>
		
		<cfset mem = "#left(textstr,Attributes.maxTextLength)# ...">
				   
		<CFSET ThisTag.GeneratedContent = mem>
	
	<cfelse>

		<!--- Process text --->
		<CFSET output=ReReplace(ThisTag.GeneratedContent, '[f|F][a|A][c|C][e|E][\s]*=[\s]*"[S|s][y|Y][m|M][b|B][o|O][l|L]"', '', "ALL")>
		<CFSET output=ReReplace(ThisTag.GeneratedContent, '[\s]*<[\s]*[t|T][e|E][x|X][t|T][a|A][r|R][e|E][a|A]', '<cftextarea', "ALL")>	
		<!--- Update content --->
		<CFSET ThisTag.GeneratedContent=output>
		
	</cfif>
	
</cfif>  
