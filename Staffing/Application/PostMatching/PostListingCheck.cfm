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


<!--- check if post exists --->

<cfquery name="Check" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Position
   WHERE  PositionNo = '#URL.PositionNo#'
</cfquery>

<cfoutput>

<cfif check.recordcount eq "1">
   <img src="#SESSION.root#/Images/join.gif" alt="Associate a position to this external post" border="0">						
<cfelse>
   <img src="#SESSION.root#/Images/delete5.gif" alt="Deleted" border="0">						

</cfif>

</cfoutput>