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

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cf_screentop height="100%" 
    html="Yes" 
	scroll="Yes" 
	label="Locate Employee" 
	option="Enter your search criteria" 
    layout="webapp" 
	banner="gray" 
	bannerforce="Yes">
	
<table width="100%" height="100%" class="formpadding">

<tr>
<td width="100%" height="100%" style="overflow:hidden">

<cfoutput>

<cfparam name="url.formname"     default="">
<cfparam name="url.fldpersonno"  default="">
<cfparam name="url.fldlastname"  default="">
<cfparam name="url.fldfirstname" default="">
<cfparam name="url.fldfull"      default="">
<cfparam name="url.fldindexno"   default="">
<cfparam name="url.orgunit"      default="">
<cfparam name="url.mission"      default="">
<cfparam name="url.fldnationality"  default="">
<cfparam name="url.flddob"          default="">
<cfparam name="url.fnselected"      default="">
<cfparam name="url.showadd"         default="1">

<iframe src="LookupSearchSelect.cfm?FormName=#URL.FormName#&fldpersonno=#URL.fldpersonno#&fldindexno=#URL.fldindexno#&fldlastname=#URL.fldlastname#&fldfirstname=#URL.fldfirstname#&fldfull=#URL.fldfull#&flddob=#URL.flddob#&fldnationality=#URL.fldnationality#&OrgUnit=#URL.OrgUnit#&Mission=#url.mission#&fnselected=#url.fnselected#&showadd=#url.showadd#&mid=#mid#" name="result" id="result" width="100%" height="98.5%" scrolling="no" frameborder="0"></iframe>

</cfoutput>	  
</td></tr>
</table>

<cf_screenbottom layout="webapp">