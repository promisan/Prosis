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

<cfif fld eq "">
    <cf_screentop jquery="Yes" height="100%" scroll="no" layout="webapp" label="Lookup" user="no" html="No">
<cfelse>
	<cf_screentop jquery="Yes" height="100%" scroll="no" layout="webapp" label="#fld#" user="no" html="No">
</cfif>
	 
<cfoutput>

<cfparam name="URL.Script"       default="">
<cfparam name="URL.FilterString" default="">
<cfparam name="URL.FilterValue"  default="">
<cfparam name="URL.selected"     default="">

<cfset url.filterstring = replaceNoCase(url.filterstring,"'","|","ALL")>

<cfajaximport>
<cf_comboMultiScript>

<table width="100%" height="100%" align="center">

	 <input type="hidden" 
	 value="#url.Selected#" 
	 name="value" id="value"
	 class="regular">
	 
</cfoutput>		 

<tr style="height:20">
  
   <td class="labelit" style="padding-top:4px;padding-left:15px;padding-bottom:5px">
 
    <cfoutput>
	
    <table><tr>  
	<td>
   	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/search_blue2.png?id=1" 
								height="32" 
								title="find" 
								style="cursor:pointer;"
								onclick="document.getElementById('find').focus();">								
    </td>
    <td style="padding-left:5px">
      <input type="text" style="width:300px; height:30px; font-size:14px; font-face:calibri;" value="" class="regularxl" name="find" id="find" size="20" onKeyUp="search('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#URL.filterstring#','#URL.filtervalue#')">   
    </td>
    <td style="padding-left:3px">
      <input type="checkbox" name="variant" id="variant" value="1" onClick="search('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#URL.filterstring#','#URL.filtervalue#')">
	</td>
	<td style="padding-left:5px" class="labelmedium">advanced</td>    
    </tr>
    </table>
   
    </cfoutput>
   
   </td>
      
</tr> 	

<tr><td class="line" colspan="2"></td></tr> 	

<tr valign="top" height="100%">
	<td colspan="2" style="height:100%;padding:20px">
	<cf_divscroll style="height:100%" id="result"/>
	</td>
</tr>	 

<tr><td style="padding-left:20px;padding-right:20px">
<table width="100%" cellspacing="0" cellpadding="0">	 	 
<tr><td height="100" colspan="2" id="select" style="background-color:f4f4f4;padding:10px;border:0px solid silver;border-radius:0px">
	 <cfset mode = "edit">		
	 <cfinclude template="ComboMultiSelected.cfm">	
	 </td>
</tr>	
</table></td></tr>
		 
 
<tr><td colspan="2" align="center" height="45">
	<cfoutput>	
	
	  <button type="button" onclick="purge('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#URL.filterstring#','#URL.filtervalue#')" 
	  class="button10g" 
	  name="Purge" id="Purge"><cf_tl id="Clear"></button>
	  
	  <input type="button" class="button10g" name="TestReturn" id="TestReturn" onclick="finishSelection('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#URL.filterstring#','#URL.filtervalue#')" value="Finish">
	</cfoutput>
	  
</td></tr>	

</table>	

<cfoutput>

<script>
    	
	combosearch('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#URL.filterstring#','#URL.filtervalue#')
	
</script>
</cfoutput>


