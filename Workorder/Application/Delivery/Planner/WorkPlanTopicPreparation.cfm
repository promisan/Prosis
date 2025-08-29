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
<cfparam name="URL.PositionNo" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>
	
 <cfquery name="gettopic"
   datasource="appsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">  
   SELECT    PositionNo, 
             PersonNo, 
       
       (SELECT TOP 1 ListCode 
        FROM   WorkPlanTopic  
        WHERE  WorkPlanId = W.WorkPlanId 
        AND    Topic = 'f004' 
        AND    Operational = 1 ) as ListCode
       
      
   FROM      WorkPlan W     
   WHERE     
   <cfif URL.positionNo neq "">
	   PositionNo = '#url.positionno#'
	   AND       
   </cfif> 
   Mission    = '#url.mission#'
   AND       DateEffective = #DTS#
   AND       DateExpiration = #DTS#
  </cfquery> 
  
  <cfoutput>
  <cfloop query="gettopic">
  	<input type="hidden" name="f004_#gettopic.positionNo#" id="f004_#gettopic.positionNo#" value="#gettopic.ListCode#">
  </cfloop>
  </cfoutput>
 