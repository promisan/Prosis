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

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.role" default="">
<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cf_divscroll style="height:100%">

<table width="95%" align="center">
   	 			
	  <tr><td style="padding-top:17px; padding-left:5px">	
	  	  	  	    	   
		    <cf_EntitlementTreeData
				 mission     = "#URL.Mission#"
				 period      = "#URL.Period#"				 
				 destination = "EntitlementViewOpen.cfm">
			
	 </td></tr>	
		 		 
</table>		 

</cf_divscroll>

