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
<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.Order" default="DESC">

<cfset dependentshow = "0">

<cfajaximport tags="cfdiv">
<cf_FileLibraryScript>

<cf_screentop height="100%" scroll="Yes" html="No" menuAccess="context" jquery="Yes">

<table width="100%" border="0" ccellspacing="0" ccellpadding="0" align="center" class="formpadding">

<tr>
	<td height="10" style="padding-left:7px">	
	  <cfset ctr      = "1">		
	  <cfset openmode = "open"> 
	  <cfinclude template="PersonViewHeaderToggle.cfm">		  
	</td>
</tr>	

</table>
