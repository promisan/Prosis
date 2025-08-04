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

<cf_assignid>
<cfparam name="Form.ItemUoMId"     default="#rowguid#">	

<cfquery name="Insert" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ItemUoM
            (ItemNo,
			 UoM,
			 UoMCode,
			 UoMMultiplier,
			 UoMDescription,
			 ItemBarCode, 
			 StandardCost,
			 ItemUoMId,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#No#',
	          '#UoM#',
			  <cfif form.UoMCode neq "">
			  '#Form.UoMCode#',
			  <cfelse>
			  NULL,
			  </cfif>
			  '1',
	          '#Form.UoMDescription#',
			  '#vBarCode#', 
	          '#Form.StandardCost#', 
			  '#form.ItemUoMId#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
  </cfquery>
  
  <!--- Mission standard cost --->
  
  <cfquery name="MissionSelect" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    DISTINCT Mission
		FROM      Warehouse
		-- WHERE     Mission = '#form.mission#'
		WHERE     Operational = 1	
		<cfif form.Warehouse eq "">
		AND       1 = 0
		<cfelse>
		AND       Warehouse IN (#preservesingleQuotes(form.warehouse)#)
		</cfif>					
</cfquery>	

<cfloop query="MissionSelect">
  
  <cfquery name="UoMMission" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ItemUoMMission
		       (ItemNo,
		        UoM,
		        Mission,
				StandardCost,
		        OfficerUserId,
		        OfficerLastName,
		        OfficerFirstName)
		VALUES ('#No#',
		        '#UoM#',
		        '#Mission#',
			    '#Form.StandardCost#', 
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')				
	</cfquery>
	
</cfloop>	

<cfif Mis.BundleUoM neq "" and Mis.BundleUoM neq UoM>	
	
	<cfquery name="qUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_UoM
		WHERE   Code = '#Mis.BundleUoM#'
	</cfquery>					
	
	<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ItemUoM
		            (ItemNo,
					 UoM,
					 UoMCode,
					 UoMMultiplier,
					 UoMDescription,
					 ItemBarCode, 
					 StandardCost,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		  VALUES ('#No#',
		          '#Mis.BundleUoM#',
				  '#qUoM.Description#',
				  '1',
		          '#qUoM.Description#',
				  '#vBarCode#', 
		          '#Form.StandardCost#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	  </cfquery>
	  
	  <cfquery name="UoMMission" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ItemUoMMission
			       (ItemNo,
			        UoM,
			        Mission,
					StandardCost,
			        OfficerUserId,
			        OfficerLastName,
			        OfficerFirstName)
			VALUES ('#No#',
			        '#Mis.BundleUoM#',
			        '#Form.Mission#',
				    '#Form.StandardCost#', 
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')				
		</cfquery>

</cfif>