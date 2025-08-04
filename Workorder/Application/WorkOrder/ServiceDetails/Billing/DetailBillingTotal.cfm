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

<!--- convert the entered rate amount --->
<cfset rate = replace(url.rate,",","","ALL")>
<cfset rate = replace(rate," ","","ALL")>

<cfset qty = replace(url.quantity,",","","ALL")>
<cfset qty = replace(qty," ","","ALL")>

<cftry>

	<cfset total = qty*rate>
	<cfoutput>#numberformat(total,'__,__.__')#</cfoutput>
	
	<cfcatch><font color="FF0000">Err!</font></cfcatch>

</cftry>	