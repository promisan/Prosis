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
<table width="100%" height="100%" cellpadding="0" cellspacing="0">

	<tr><td height="20" style="padding-top:4px;padding-left:20px">
		<cfoutput>
		<table cellspacing="0" cellpadding="0">
		<tr><td style="padding:2px" height="20px">
		
		<input type="radio" 
		       name="servicemenu" 
			   id="servicesummary"
			   value="Requests" 
			   checked
			   onclick="ColdFusion.navigate('Request/ServiceSummary.cfm?mission=#url.mission#&webapp=#url.id#','servicecontent')">	
			   
			   </td><td>Service Summary</td>
		
		
			   
		<td style="padding:2px 2px 2px 10px">	   
		
		<input type="radio" 
		       name="servicemenu" 
			   id="servicerequest"
			   value="Summary" 
			   onclick="ColdFusion.navigate('Request/RequestListing.cfm?mission=#url.mission#&webapp=#url.id#','servicecontent')">
			   
			   </td><td>Show Requests</td>
		
		</tr>
		</table>
		</cfoutput>
		   
	</td></tr>
	
	<tr><td height="1px" class="line"></td></tr>
	
	<tr><td id="servicecontent" height="99%">	
		<cfinclude template="ServiceSummary.cfm">
	</td></tr>

</table>