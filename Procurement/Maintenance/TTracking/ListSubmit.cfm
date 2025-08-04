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

<cfparam name="Form.Operational"     default="0">
<cfparam name="Form.Description"     default="">
<cfparam name="Form.TrackingOrder"   default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_TransportTrack
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#',
				 TrackingOrder       = '#Form.TrackingOrder#'
		  WHERE  TrackingId   = '#URL.ID2#'
	</cfquery>
	
	<cfset url.id2 = "">
				
<cfelse>
		
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_TransportTrack
			         (TransportCode,
					 Description,
					 TrackingOrder,
					 Operational)
			      VALUES ('#URL.Code#',
				      '#Form.Description#',
					  '#Form.TrackingOrder#',
					  '#Form.Operational#')
			</cfquery>
			
	<cfset url.id2 = "new">
			   	
</cfif>


<cfoutput>
  <script>
    ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=new','#url.code#_list')	
  </script>	
</cfoutput>

