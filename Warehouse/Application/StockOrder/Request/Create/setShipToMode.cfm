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
<cfquery name="update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE    RequestHeader
   SET       RequestShipToMode = '#url.mode#'
   WHERE     Mission = '#url.mission#'  
   AND       Reference = '#url.reference#'
</cfquery>



<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      RequestHeader
   WHERE     Mission = '#url.mission#'  
   AND       Reference = '#url.reference#'
</cfquery>

<cfoutput>

<cfif get.RequestShipToMode eq "Deliver">
					
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/request/create/setShipToMode.cfm?mission=#mission#&reference=#reference#&mode=Collect','shiptomode')">						
	<font color="0080C0">COLLECTION</font>
	</a>
		
<cfelse>
	
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/request/create/setShipToMode.cfm?mission=#mission#&reference=#reference#&mode=Deliver','shiptomode')">												
	<font color="0080C0">DELIVERY</font>
	</a>
	
</cfif>		


<cfquery name="label" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Ref_ShipToMode
   WHERE     Code = '#url.mode#'    
</cfquery>

	
<script>
	 document.getElementById('shiptomodename').innerHTML = '#label.description#'
</script>	

</cfoutput>