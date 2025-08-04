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
<cf_screentop html="yes" label="Customer view #url.mission#" layout="webapp" jquery="yes">

<cf_ListingScript>
<cf_dialogmaterial>

<table width="97%" height="100%" align="center">
 
 <tr> 
   <td height="100%" style="padding-top:5px;padding-bottom:5px">
    <cfset url.systemfunctionid = url.idmenu>
    <cfinclude template="CustomerViewListing.cfm"> 
   </td>
 </tr>
 
</table>