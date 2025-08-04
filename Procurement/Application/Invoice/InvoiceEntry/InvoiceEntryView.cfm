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

<!--- container --->
<cf_screentop height="100%" html="no" layout="webapp" banner="gray" scroll="no" label="Register Invoice">
	
<cfoutput>
<cf_divscroll>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td valign="top">
    <!--- passthru --->
	<iframe src="InvoiceEntry.cfm?#CGI.QUERY_STRING#" 
	   name="base" id="base" 
	   width="100%" height="99%" 
	   marginwidth="0" 
	   marginheight="0" 
	   scrolling="no" 
	   frameborder="0"></iframe>
</td></tr>
</table>
</cf_divscroll>
</cfoutput>