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
<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template="../Parameter/HeaderParameter.cfm"> 	
	
<cf_screentop height="100%" scroll="Yes" html="No" label="Exchange Attachments" layout="innerbox">

<cfajaximport tags="cfdiv">

<table width="97%" height="100%" align="center">
<tr><td style="padding-top:20px" valign="top">
	<cf_filelibraryN
			DocumentPath="Exchange"
			SubDirectory="" 
			Filter=""
			Insert="yes"
			Remove="yes"
			width="99%"		
			AttachDialog="yes"
			align="left"
			border="1">	
</td></tr></table>	
			
<cf_screenbottom layout="innerbox">			
	