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
	
 <cfif dob neq "">
	 
	 <cfset age =  year(now()) - year(DOB)>
	 <cfif dayOfYear(DOB) gt dayOfYear(Now())>
	  <cfset age = age-1>
	 </cfif>
	 
	 <cfif age gte "90">
	 
		 <cfset age = "">
		 
	 <cfelse>
	 
		 <cfset age = "#age#">
	 
	 </cfif>			 
	 
 <cfelse>
 
 	<cfset age = "">
 	 
 </cfif>	 

<table style="width:100%" class="formpadding">

	<tr><td class="labelmedium"><b>#LastName# #FirstName# [#Age#]</b></td></tr>
	
	<cfquery name="Nation" 
     datasource="AppsSystem" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Nation
	 WHERE    Code = '#Nationality#'		
	</cfquery>	
	
	<tr>	
	
	  <td style="padding-left:5px">
	  
		  <table style="width:100%">
		  <tr class="labelmedium2">
		  	  <td>#dateformat(DOB,client.dateformatshow)#</td>		
			  <td style="padding-left:5px"><cfif gender eq "M">Male<cfelse>Female</cfif></td>	
			  <td align="right" style="padding-right:2px">#Nation.Name#</td>		
		  </tr>
		  </table>
	  
	  </td>
	</tr>
	
</table>

</cfoutput>	