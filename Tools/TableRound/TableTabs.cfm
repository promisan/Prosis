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
<cfparam name="attributes.tabs" default="4">

<cfoutput>
	<script language="JavaScript">
	
	function hl(tab)
	
	{
				
	cnt = 1
	
	{  while (cnt <= #attributes.tabs#)
	
	    {
	    se = document.getElementById(cnt)
		if (se.className != "top4n")
    		{se.className = "regular"}
		cnt++
		}
	
	}
		
	se = document.getElementById(tab)
	if (se.className != "top4n")
		{se.className = "top2n"}
		
	}	
		
	function sel(tab)
	
	{
	
	s = document.getElementById("tabselect")
	s.value = "tab"+tab
				
	cnt = 1
	
	{  while (cnt <= #attributes.tabs#)
	
	    {
	    se = document.getElementById(cnt)
		se.className = "regular" 
		tb = document.getElementById("tab"+cnt)
		tb.className = "hide"
		cnt++
		}
	
	}
		se = document.getElementById(tab)
	    se.className = "top4n"
		tb = document.getElementById("tab"+tab)
		tb.className = "regular"
	}	
	
	</script>
</cfoutput>

<input type="hidden" name="tabselect" id="tabselect" value="<cfoutput>#URL.Tab#</cfoutput>">

<cfoutput>
	<table width="100%" border="1" cellspacing="0" cellpadding="0">
	<tr>
	<cfloop index="ind" from="1" to="#attributes.tabs#">
	    <cfset text = #evaluate("Attributes.Text#ind#")#>
		<td height="20" 
		align="center" 
		style="cursor: pointer;"
		bgcolor="DCDCB8" 
		id="#ind#" 
		onClick="javascript:sel('#ind#')" 
		onMouseOver="javascript:hl('#ind#')">#text#</td>
	</cfloop>
	</tr>
	</table>
</cfoutput>
