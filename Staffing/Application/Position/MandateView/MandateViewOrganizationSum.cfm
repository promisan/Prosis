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
 
<!--- define the total for each unit --->
 
<cfquery name="Check" 
      datasource="AppsQuery" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM   #SESSION.acc#PositionSum P
	  WHERE  P.OrgUnit = '#org#' 
</cfquery>
   
<cfoutput>  	
	  
   <cfif Check.post gt 0>
	   
    <cfif find(org, CLIENT.OrgUnitS)>
  		  <img src="../../../../Images/zoomout.jpg" alt="" border="0" align="middle" style="cursor: pointer;" onClick="javascript: zoomForm('del','#org#')">
    <cfelse>	
  		  <img src="../../../../images/zoomin.jpg" alt="" style="cursor: pointer;" border="0" align="middle" onClick="javascript: zoomForm('add','#org#')">
	</cfif>
			
   </cfif>
					
   <a name="#Org#" href="javascript:editOrgUnit('#Org#')">
       <img src="../../../../Images/view.gif" alt="" width="16" height="15" border="0" align="middle" onDblClick="javascript:">
   </a>
   
</cfoutput> 