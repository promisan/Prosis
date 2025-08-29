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
<cfquery name="getHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   TOP 1 *,   (SELECT TOP 1 PriceSchedule 
				  FROM   CustomerRequestLine 
				  WHERE  RequestNo = P.RequestNo) as PriceSchedule
	FROM     CustomerRequest P
	WHERE    RequestNo = '#url.requestNo#'				
</cfquery>

<cfquery name="mySchedule" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_PriceSchedule
	   WHERE     Operational = 1  	
	   ORDER BY  ListingOrder   
</cfquery>
 		
<cfoutput>

<select name="priceschedulequote" class="regularxxl" style="background-color:f1f1f1;border-bottom:0px" onchange="setpriceschedule(this.value,'#url.requestno#')">

	<cfloop query = "myschedule">	
  		<option value="#Code#" <cfif getHeader.priceschedule eq Code>selected</cfif>>#Description#</option>				
	</cfloop>
	
</select>
</cfoutput>
	
