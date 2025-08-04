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
<cfparam name="URL.mode" default="descriptive">
<cfoutput>

<cfif License eq 1>
	
	<cfset c = "#year(now())##quarter(now())#">	
	
	<cfoutput>
	
	<table class="formpadding">
	
	<tr>
		<td class="labelmedium2" style="width:10px">
		<cfif c GT "#vyear##vquarter#">			
		    <!--- <img src="#SESSION.root#/Images/delete5.gif" height="13" width="13" alt="Expiration" border="0" align="absmiddle"> --->
			<font color="FF0000">
				<cfif vyear eq ""><cf_tl id="Expired"></cfif>		
			</font>
		<cfelse>	
		    <img src="#SESSION.root#/Images/check_icon.gif" style="height:20px" alt="License is in order" border="0" align="absmiddle">	
			<font color="008080">				
		</cfif>	
		</td>
	
		<cfif url.mode eq "descriptive">
			<td class="labelmedium2" style="padding-left:4px">
			<cfswitch expression="#vquarter#">
			  <cfcase value="1">
			   Mar #vyear#
			  </cfcase>
			  <cfcase value="2">
			   Jun #vyear#
			  </cfcase>
			  <cfcase value="3">
			   Sep #vyear#
			  </cfcase>
			  <cfcase value="4">
			   Dec #vyear#
			  </cfcase>
			</cfswitch>
			</td>
		</cfif>												
	
	</table>
	
	</cfoutput>	
	
<cfelse>	

     <cfoutput>
	 <table class="formpadding"><tr><td>
     <!--- <img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0" align="absmiddle">	--->
	 </td><td class="labelmedium2">
	 <font color="FF0000"><cf_tl id="Invalid"></font>	
	 </td></tr>
	 </table>
	 </cfoutput>		
	 
</cfif>
</cfoutput>