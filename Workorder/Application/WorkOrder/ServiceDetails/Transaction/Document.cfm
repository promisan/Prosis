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

<cfparam name="url.scope" default="edit">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
  <cfif url.scope eq "entry">
	<iframe src="#session.root#/workorder/application/workorder/ServiceDetails/Transaction/DocumentForm.cfm?scope=entry&mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#" 
	  width="100%" height="100%" frameborder="0"></iframe>
  <cfelse>
   <iframe src="#session.root#/workorder/application/workorder/ServiceDetails/Transaction/DocumentForm.cfm?scope=edit&drillid=#url.drillid#" 
	  width="100%" height="100%" frameborder="0"></iframe>  
  </cfif>	  
</td></tr>
</table>
</cfoutput>