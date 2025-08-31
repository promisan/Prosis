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
<cfparam name="url.action" default="quantity">
<cfparam name="url.ajaxid" default="">

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Request R, RequestHeader H
		WHERE  R.Mission   = H.Mission
		AND    R.Reference = H.Reference
		AND    R.RequestId = '#URL.ID#'
</cfquery>

<cfoutput>

	<cfif url.action eq "quantity">
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Request
			SET    RequestedQuantity = '#quantity#' 
			WHERE  RequestId = '#URL.ID#'
		</cfquery>
				
		<cfquery name="Line" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Request	
			WHERE  RequestId = '#URL.ID#'
		</cfquery>
	
		<cfoutput>
			#NumberFormat(Line.RequestedAmount,'__,____.__')#
		</cfoutput>
		
	<cfelseif url.action eq "price">	
	
	
	<cfelseif url.action eq "cancel">
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Request
			SET    Status = '9' 
			WHERE  RequestId = '#URL.ID#'
		</cfquery>
		
		<img src="#SESSION.root#/images/light_red3.gif" 
		      alt="Activate" 
			  border="0" 
			  onclick="ColdFusion.navigate('RequestEdit.cfm?id=#url.id#&action=revert','status_#url.id#');">		
		
		<script>	  
			document.getElementById('#url.id#_ref').className = 'blocked'		  				
			document.getElementById('#url.id#_des').className = 'blocked'		
			document.getElementById('#url.id#_uom').className = 'blocked'		
			document.getElementById('#url.id#_itm').className = 'blocked'	
			document.getElementById('#url.id#_amt').className = 'blocked'	
			document.getElementById('amount_#url.id#').className = 'blocked'	
		</script>	
			
	<cfelseif url.action eq "revert">
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Request
			SET    Status = '1' 
			WHERE  RequestId = '#URL.ID#'
		</cfquery>
		
		<img src="#SESSION.root#/images/light_green2.gif" 
		      alt="Activate" 
			  border="0" 
			  onclick="ColdFusion.navigate('RequestEdit.cfm?id=#url.id#&action=cancel','status_#url.id#')">	
			  
		<script>	  
			document.getElementById('#url.id#_ref').className = 'regular'		  			
			document.getElementById('#url.id#_des').className = 'regular'		
			document.getElementById('#url.id#_uom').className = 'regular'		
			document.getElementById('#url.id#_itm').className = 'regular'	
			document.getElementById('#url.id#_amt').className = 'regular'	
			document.getElementById('amount_#url.id#').className = 'regular'				
		</script>		  
			
	</cfif>

    <cfif URL.AjaxId neq "">
	
		<cfquery name = "qCheck" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT COUNT(1) as total
			FROM  	   Materials.dbo.RequestHeader H,
			           Materials.dbo.Request L, 
				 	   Materials.dbo.Item A,
				       Materials.dbo.ItemUoM U,
				       Organization Org,
					   Materials.dbo.Warehouse W		 
			WHERE      L.ItemNo          = A.ItemNo
			AND        H.Mission         = L.Mission
			AND        H.Reference       = L.Reference
			AND        H.RequestHeaderId = '#URL.AjaxId#' 
			AND        L.Warehouse = W.Warehouse
			AND        L.OrgUnit         = Org.OrgUnit 
			AND        A.ItemNo          = U.ItemNo
			AND        L.UoM             = U.UoM	
			AND        L.Status         != '9'
		</cfquery>  
		
		<cfif qCheck.total eq "0">
		
			<script>
			    opener.document.getElementById('treerefresh').click()
				ColdFusion.navigate('DocumentWorkflow.cfm?action=cancel&ajaxid=#URL.AjaxId#','#URL.AjaxId#');
			</script>				
			
		</cfif>	
		
	</cfif>   
	
	<script>	   
	    opener.document.getElementById('treerefresh').click()
		if (document.getElementById('boxoverall')) {
		ColdFusion.navigate('RequestEditTotal.cfm?requestheaderid=#get.requestheaderid#&mission=#get.mission#','boxoverall')
		}
	</script>

</cfoutput>





