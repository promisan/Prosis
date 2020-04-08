
<cfparam name="Attributes.Mission"   	     default="">
<cfparam name="Attributes.Warehouse"   	     default="">
<cfparam name="Attributes.InitWarehouse"     default="">
<cfparam name="Attributes.SystemFunctionId"  default="">
<cfparam name="Attributes.AccessLevel"       default="'0','1','2'">

<cfparam name="Attributes.Name"      	     default="warehouse">
<cfparam name="Attributes.Style"             default="font:12px; width:224px">
<cfparam name="Attributes.OnChange"   	     default="">
<cfparam name="Attributes.Grouping"   	     default="City">

<!--- check for mission access --->

<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#attributes.mission#" 	  
	   anyUnit           = "No"
	   role              = "'WhsPick'"
	   parameter         = "#attributes.systemfunctionid#"
	   accesslevel       = "#attributes.accesslevel#"
	   returnvariable    = "globalmission">	
	   
<cfif globalmission neq "Granted">	

		<!--- check access on the level of the mission --->
			
		<cfinvoke component  = "Service.Access"  
		   method            = "RoleAccessList" 
		   role              = "'WhsPick'"
		   mission           = "#attributes.mission#" 	  
		   warehouse         = "#attributes.warehouse#"		  
		   parameter         = "#attributes.systemfunctionid#"
		   accesslevel       = "#attributes.accesslevel#"
		   returnvariable    = "accesslist">	
		   
		  <cfif accessList.recordcount eq "0">
	
			<table width="100%" 
			       border="0" 
				   height="100%"
				   cellspacing="0" 			  
				   cellpadding="0" 
				   align="center">
			   <tr><td align="center" height="40" valign="top" class="labelit">
			    <font color="FF0000">
				<cf_tl id="You were not been granted any access" class="Message">
				</font>
				</td></tr>
			</table>	
			<cfabort>
	
		</cfif>		 
		   
</cfif>		   

<cfquery name="WarehouseList" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Warehouse W, Ref_WarehouseCity C									  
		  WHERE  W.Mission   = '#URL.Mission#'
		  AND    C.Mission   = W.Mission
		  AND    C.City      = W.City
		  <cfif attributes.warehouse neq "">
		  AND    Warehouse = '#url.warehouse#'
		  </cfif>
		  AND   Operational = 1
		  AND   W.Warehouse IN (SELECT Warehouse 
		                        FROM   WarehouseLocation 
								WHERE  Warehouse = W.Warehouse 
								AND    Operational = 1)
		  									  
		  <cfif globalmission eq "Denied">
		 
			AND  W.MissionOrgUnitid IN
			
			           (					   
		                  SELECT DISTINCT MissionOrgUnitId 
		                  FROM   Organization.dbo.Organization
						  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
					   )	
					   
			</cfif>		
			
			ORDER BY C.ListingOrder, W.City, W.WarehouseClass 			
					  
</cfquery>	
	
<cfif warehouseList.recordcount eq "0">
	
		<table width="100%" 
		       border="0" 
			   height="100%"
			   cellspacing="0" 			  
			   cellpadding="0" 
			   align="center">
		   <tr><td align="center" height="40" valign="top">
		    <font face="Verdana" color="FF0000">
			<cf_tl id="Detected a Problem with your access"  class="Message">
			</font>
			</td></tr>
		</table>	
		
		<cfset caller.selWarehouse = "">
		<cfset caller.selMission   = "">
			
<cfelse>		
	
	<cfif attributes.Grouping eq "City">
		
			<cfform>																			
													
				<cfselect name="#attributes.name#" id="#attributes.name#" 
				    style    = "#attributes.style#"  
					query    = "warehouselist" 
					selected = "#attributes.initwarehouse#"
					display  = "warehousename" 
					value    = "warehouse" 
					group    = "city"   
			        onChange = "#preservesingleQuotes(attributes.onchange)#"/>
				
			</cfform>	
		
	<cfelse>
		
			<cfoutput>
		
				<select name="#attributes.name#" id="#attributes.name#" 
				    style="#attributes.style#"  						
			        onChange="#preservesingleQuotes(attributes.onchange)#">
					<cfloop query="WarehouseList">
					<option value="#Warehouse#" <cfif attributes.initwarehouse eq warehouse>selected</cfif>>#Warehousename#</option>
					</cfloop>
				</select>	
				
			</cfoutput>	
		
	</cfif>
		
	<cfif attributes.initwarehouse neq "">	
		<cfset caller.selWarehouse = attributes.initwarehouse>
	<cfelse>	
		<cfset caller.selWarehouse = warehouseList.Warehouse>
	</cfif>	
	<cfset caller.selMission   = warehouseList.mission>
	
</cfif>		