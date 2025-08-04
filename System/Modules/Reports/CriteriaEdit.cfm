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
<cf_screentop height="100%" 
  html="yes" 
  scroll="Yes" 
  jquery="Yes"
  label="Edit Report Parameter Definition" 
  layout="webapp" 
  line="no"
  banner="gray">

<cfajaximport tags="cfform,cfinput-autosuggest">

<cf_criteriascript>
	
<table width="99%"       
	   align="center"
	   height="100%"	  
	   class="formpadding">
	   
<tr class="hide"><td id="fields"></td></tr>	   
	
<tr><td colspan="2" bgcolor="white" valign="top">	

  <cf_divscroll>   
	
	<cfinclude template="CriteriaEditForm.cfm">
	
  </cf_divscroll>	
	
</td></tr>

</table>

<cf_screenbottom layout="webapp">