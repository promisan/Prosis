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

<cfquery name="qItem" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE	ItemNo = '#URL.ID#'
 </cfquery>

<cfoutput>

<cf_tl id="Incorrect value. Operation aborted" var = "vAlready">
<cf_tl id="UoM updated!" var = "vUpdated">

<cfif url.action eq "add"> 

	<cfset StandardCost      = replace("#Form.StandardCost#",",","")>
	
	<cfif not LSIsNumeric(StandardCost) or not LSIsNumeric(Form.UoMMultiplier)>
	
	   <script>
	   	alert("#vAlready#")
	   </script>
	
	<cfelse>	
	
	   <cf_AssignUoM itemNo = "#URL.ID#" UoMDescription = "#UoMDescription#">
	 	   		
		<cftransaction>
			
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
				  ItemUoMWeight,				
				  ItemUoMVolume,
				  StandardCost,
				  ItemUoMDetails,
				  ItemUoMSpecs,
				  EnablePortal,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		  VALUES ('#URL.ID#',
		          '#UoM#',
				  <cfif Form.UoMCode neq "">
				  '#Form.UoMCode#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#Form.UoMMultiplier#',
		          '#Form.UoMDescription#',
				  '#Form.ItemBarCode#', 
				  '#form.ItemUoMWeight#',						  
				  '#form.ItemUoMVolume#',
		          '#StandardCost#', 
				  '#Form.ItemUoMDetails#',
				  '#Form.ItemUoMSpecs#',
				  '#Form.EnablePortal#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		  </cfquery>
		  
		  <!--- <cfloop query="qMissions"> --->		  	
		  
		  	<cfquery name="InsertMission" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ItemUoMMission
				           (ItemNo,
				           UoM,
				           Mission,
				           OfficerUserId,
				           OfficerLastName,
				           OfficerFirstName)
				     VALUES
				           ('#URL.ID#',
				           '#UoM#',
						   '#qItem.Mission#',
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#')
				
			</cfquery>
		  
		  <!--- </cfloop> --->		  
		  
		  </cftransaction>
		  
	</cfif>
	
	<cfoutput>
		<script>	
		   ptoken.navigate('ItemUoMTabMenu.cfm?id=#url.id#&uom=#uom#','menubox')	
		   ptoken.navigate('ItemUoMEdit.cfm?id=#url.id#&uom=#uom#','divmenu1')		
		   opener.document.getElementById('refresh_uomlist').click();				  
		</script> 
	</cfoutput>   
		  
<cfelseif url.action eq "update"> 

	<cfset StandardCost      = replace("#Form.StandardCost#",",","")>
	
	<cftransaction>
		
		<cfquery name="Check" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ItemUoM		
			WHERE  ItemNo = '#URL.id#'
			AND    UoM    = '#URL.UoM#'
	    </cfquery>
	
		<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   UPDATE  ItemUoM
		   SET     UoMDescription = '#Form.UoMDescription#',
				   <cfif Form.UoMCode neq "">
		           UoMCode        = '#Form.UoMCode#',
				   <cfelse>
				   UoMCode        = NULL,
				   </cfif>
				   UoMMultiplier  = '#Form.UoMMultiplier#',
				   ItemUoMWeight  = '#Form.ItemUoMWeight#',						  
				   ItemUoMVolume  = '#Form.ItemUoMVolume#',
				   StandardCost   = '#StandardCost#',
				   ItemUoMDetails = '#Form.ItemUoMDetails#',
				   ItemBarCode    = '#Form.ItemBarCode#',
				   EnablePortal   = '#Form.EnablePortal#',
				   ItemUoMSpecs   = '#Form.ItemUoMSpecs#'
		   WHERE   ItemNo         = '#URL.id#'
		   AND     UoM            = '#URL.UoM#'
	    </cfquery>
		
		<!--- 18/1/2014 also sync the standard cost of the children if the UoMcode is filled and is the same --->
		
		<cfif Form.UoMCode neq "">
		
			<cfquery name="Update" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   UPDATE  ItemUoM
			   SET     UoMDescription = '#Form.UoMDescription#',					  			          	 
					   UoMMultiplier  = '#Form.UoMMultiplier#',				   
					   StandardCost   = '#StandardCost#'
					   <!---
					   ItemUoMDetails = '#Form.ItemUoMDetails#',
					   ItemBarCode    = '#vBarCode#',				   
					   EnablePortal   = '#Form.EnablePortal#',
					   ItemUoMSpecs   = '#Form.ItemUoMSpecs#'
					   --->
			   WHERE   ItemNo  IN (SELECT ItemNo 
			                       FROM   Item 
								   WHERE  ParentItemNo = '#URL.id#')
			   AND     UoMCode = '#Form.UoMCode#'			 
		    </cfquery>			
		
		</cfif>			
		
		<!--- this is no longer relevant as we manage through the stadnard cost of the mission 
		
		<cfif check.standardcost neq standardcost>		
		
		 <cfinvoke component = "Service.Process.Materials.Stock"  
			   method           = "setStockPrice" 
			   mission          = ""
			   ItemNo           = "#url.id#"			  
			   UoM              = "#url.uom#"			   
			   Price            = "#standardcost#">	    
					
		</cfif>
		
		--->
				
	</cftransaction>
	
	<cfoutput>
	<script>			
		 //alert('#vUpdated#');
		
		 parent.ptoken.navigate('ItemUoMEdit.cfm?id=#url.id#&uom=#url.uom#','contentbox1');		 
		 try {
		 opener.document.getElementById('refresh_uomlist').click();		
		 } catch(e) {}
		
	</script> 
	</cfoutput> 
	
<cfelseif url.action eq "delete"> 

	<cfquery name="Delete" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ItemUoM
		WHERE   ItemNo = '#URL.id#'
		AND     UoM    = '#URL.UoM#' 
    </cfquery>	
	
	<cfoutput>
	<script>	
		parent.window.close();
	</script> 
	</cfoutput> 

</cfif>		

<script>
	Prosis.busy('no')
</script>

</cfoutput>
