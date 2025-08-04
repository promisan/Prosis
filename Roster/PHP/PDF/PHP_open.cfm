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

<TITLE>Personal History Profile</TITLE>

<HTML><HEAD></HEAD>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_wait text="Preparing Personal History Profile in Adobe Acrobat format" 
    height="0"
	width="100%"
	border="0"
	total=""
	progress="1">
	
	<cfset FileNo = round(Rand()*100)>	

<!--- cf8 --->	
<cfinclude template="PHP_Combined_List.cfm">

<cfoutput>
	<script>
		window.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/php_#fileno#.pdf?ts="+new Date().getTime(),"myPHP", "location=no, toolbar=no, scrollbars=yes, resizable=yes")
		window.close()
	</script>
</cfoutput>



