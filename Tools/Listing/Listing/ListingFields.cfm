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
<cfoutput>

<cf_divscroll>
<form method="post" name="fieldform" id="fieldform" style="height:98%">

	 <table width="99%"
	       height="100%"      
	       align="center">
	     	   	   
		   <tr class="hide"><td id="fieldaction"></td></tr>  
		   
		   <cfloop array="#attributes.listlayout#" index="current">
			   <tr>
			   <td style="padding:2px">
				  <input type="checkbox" 
				      onclick="ptoken.navigate('ListingFieldsSubmit.cfm','fieldaction','','','POST','fieldform')"
				      name="selfields" 
					  id="my#current.field#"
				 	  value="#current.field#" <cfif current.display eq "1">checked</cfif>>
			   </td>
			   <td class="labelit" style="cursor:pointer" width="99%" onclick="document.getElementById('my#current.field#').click()">#current.label#</td>
			   </tr>
		   </cfloop>	
		   
		   <tr><td height="90%"></td></tr>   
		   
	</table>

</form>  	
</cf_divscroll>

</cfoutput>