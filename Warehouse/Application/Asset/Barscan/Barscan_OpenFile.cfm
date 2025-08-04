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


<!--- security check --->
<CFIF Find( '..', URL.ServerFile )
	or Find( '\', URL.ServerFile )
	>
	Error: You are not allowed to access this file
	<CFABORT>
</CFIF>



<!--- parameters --->
<CFSET LibraryDirectory = #SESSION.rootPath#&"\asset\barscanFiles">
<CFSET FilePath = "#LibraryDirectory#\#URL.ServerFile#">


<!--- extract the file extension --->
<CFSET SeparatorPos = Find( '.', Reverse(URL.ServerFile) )>
<CFIF SeparatorPos is 0> <!--- separator not found --->
	<CFSET FileExt = ''>
<CFELSE>
	<CFSET FileExt = Right( URL.ServerFile, SeparatorPos - 1 )>
</CFIF>


<!--- find the proper MIME type --->
<CFIF FileExt is ''>			<CFSET FileType = "unknown">
<CFELSEIF FileExt is 'pdf'>		<CFSET FileType = "application/pdf">
<CFELSEIF FileExt is 'aif'>		<CFSET FileType = "audio/aiff">
<CFELSEIF FileExt is 'aiff'>	<CFSET FileType = "audio/aiff">
<CFELSEIF FileExt is 'art'>		<CFSET FileType = "image/x-jg">
<CFELSEIF FileExt is 'cil'>		<CFSET FileType = "application/vnd.ms-artgalry">
<CFELSEIF FileExt is 'gif'>		<CFSET FileType = "image/gif">
<CFELSEIF FileExt is 'htm'>		<CFSET FileType = "text/html">
<CFELSEIF FileExt is 'html'>	<CFSET FileType = "text/html">
<CFELSE>						<CFSET FileType = "unknown">
</CFIF>


<!--- return requested file --->
<CFCONTENT TYPE="#FileType#" 
	FILE="#FilePath#"
>
