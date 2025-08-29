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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries for BOM levels">

	<cffunction name="BOMGeneration" access="public" >
	  
	    <cfargument name = "Mission"  type="string"  required="true"   default="">		
		<cfargument name = "BaseItemNo"	  type="string"  required="true"   default="">							
		<cfargument name = "BaseUoM"      type="string"  required="true"   default="">	
		
			<cfquery name="clearBOM" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 			
				password="#SESSION.dbpw#">				
				DELETE FROM      stItemBOM  
				WHERE     ItemNo  = '#BaseItemNo#'	
				<cfif BaseUoM neq "">
				AND       Uom     = '#BaseUom#'
				</cfif>
				AND       Mission = '#mission#'						
			</cfquery>		
			
			<cfquery name="Item" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 			
				password="#SESSION.dbpw#">				
				SELECT    *
				FROM      ItemUoM  
				WHERE     ItemNo  = '#BaseItemNo#'	
				<cfif BaseUoM neq "">
				AND       Uom     = '#BaseUom#'
				</cfif>				
			</cfquery>													
		
		    <cfloop query="Item">
			
				<cfquery name="BOM" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 			
					password="#SESSION.dbpw#">				
					SELECT    *
					FROM      ItemBOM  
					WHERE     ItemNo  = '#ItemNo#'	
					AND       Uom     = '#Uom#'
					AND       Mission = '#mission#'
					ORDER BY  DateEffective DESC			
				</cfquery>			
													
			    <cfquery name="ItemBoM" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 			
					password="#SESSION.dbpw#">				
					SELECT    BD.MaterialItemNo, 
							  BD.MaterialUoM, 
							  BD.MaterialQuantity
					FROM      ItemBOM B INNER JOIN
		            	      ItemBOMDetail BD ON B.BOMId = BD.BOMId
					WHERE     B.ItemNo        = '#ItemNo#'	
					AND       B.Uom           = '#Uom#'
					AND       B.Mission       = '#Mission#'
					AND       B.DateEffective = '#BOM.DateEffective#'	
				</cfquery>	
								
				<cfloop query="ItemBom">
				
					<cfif currentrow lte "9">
					  <cfset row = "0#currentrow#">
					<cfelse>
					  <cfset row = "#currentrow#">
					</cfif>
					
					 <cfquery name="InsertBOM" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 			
					password="#SESSION.dbpw#">				
						INSERT INTO stItemBOM  
											
							(Mission,
							 ItemNo,
							 UoM,
							 BOMHierarchy,						
							 MaterialItemNo,
							 MaterialUoM,
							 Quantity)
						
						VALUES
						
						('#Mission#',
						 '#BoM.ItemNo#',
						 '#BOM.UoM#',					 
						 '#row#',
						 '#MaterialItemNo#',
						 '#MaterialUoM#',
						 '#MaterialQuantity#')
						
					 </cfquery>						 
									 
					<cfinvoke component = "Service.Process.Materials.BOM"  
					   method           = "BOMIteration" 
					   mission          = "#mission#" 
					   ItemNo           = "#BoM.ItemNo#"
					   UoM              = "#BoM.UoM#"
					   Level            = "2"
					   BOMItemno        = "#MaterialItemNo#" 
					   BOMUom           = "#MaterialUoM#" 
					   Hierarchy        = "#row#">	  
									
				</cfloop>		
				
			</cfloop>															
			 
	</cffunction>	
	
	<cffunction name="BOMIteration" access="public">
	
		<cfargument name = "Mission"         type="string"  required="true"     default="">		
		<cfargument name = "ItemNo"	         type="string"  required="true"     default="">							
		<cfargument name = "UoM"             type="string"  required="true"     default="">		
		<cfargument name = "BOMItemNo"	     type="string"  required="true"     default="">							
		<cfargument name = "BOMUoM"          type="string"  required="true"     default="">		
		<cfargument name = "Hierarchy"       type="string"  required="true"     default="">	
		<cfargument name = "Level"           type="string"  required="true"     default="2">	
		<cfargument name = "MaxLevel"        type="string"  required="true"     default="8">
					
		  <cfquery name="Sub#level#" 
			  datasource="appsMaterials" 
			  username="#SESSION.login#" 			
			  password="#SESSION.dbpw#">				
					SELECT    TOP 1 DateEffective 
					FROM      ItemBOM B 
					WHERE     B.ItemNo   = '#BOMItemNo#'	
					AND       B.Uom      = '#BOMUoM#'
					AND       B.Mission  = '#Mission#'
					ORDER BY  DateEffective DESC			
		  </cfquery>	
		  
		  <cfset qry = evaluate("Sub#level#")>	
		  
								
		   <cfif qry.recordcount eq "0">
		   		  		   
		   <cfelse>
		   
		   				 
			 	 <!--- get Bom items but only if that item is not already in the BOM created sofar --->
			
				 <cfquery name="Item#level#" 
				 datasource="appsMaterials" 
				 username="#SESSION.login#" 			
				 password="#SESSION.dbpw#">						
					SELECT    BD.MaterialItemNo, 
							  BD.MaterialUoM, 
							  BD.MaterialQuantity
							  
					FROM      ItemBOM B INNER JOIN
		            	      ItemBOMDetail BD ON B.BOMId = BD.BOMId
							  
					WHERE     B.Mission       = '#Mission#'
					AND       B.ItemNo        = '#BOMItemNo#'	
					AND       B.Uom           = '#BOMUoM#'						
					AND       B.DateEffective = '#qry.DateEffective#'	
					
					<!---
					AND       NOT EXISTS (SELECT 'X'
					                      FROM   stItemBOM 
										  WHERE  Mission         = '#Mission#'
										  AND    ItemNo          = '#ItemNo#'	
									      AND    Uom             = '#UoM#'	
										  AND    MaterialItemNo  = BD.MaterialItemNo	
									      AND    MaterialUoM     = BD.MaterialUoM)	
										  
										  --->
					
								
				</cfquery>	
				
				<cfset qry = evaluate("Item#level#")>	
													
				<cfloop query="Item#level#">
				
					<cfif currentrow lte "9">
					  <cfset row = "0#currentrow#">
					<cfelse>
					  <cfset row = "#currentrow#">
					</cfif>
					
					<cfquery name="InsertBOM" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 			
						password="#SESSION.dbpw#">				
							INSERT INTO stItemBOM  
							
								(Mission,
								 ItemNo,
								 UoM,								
								 BOMHierarchy, 
								 MaterialItemNo,
								 MaterialUoM,
								 Quantity)
							
							VALUES
							
							('#Mission#',
							 '#ItemNo#',
							 '#UoM#',							 
							 '#Hierarchy#.#row#',
							 '#qry.MaterialItemNo#',
							 '#qry.MaterialUoM#',
							 '#qry.MaterialQuantity#')
							
					</cfquery>		
															 
					<cfif maxlevel gte level>	
										 
						 <cfinvoke component = "Service.Process.Materials.BOM"  
						   method           = "BOMIteration" 
						   mission          = "#mission#" 
						   ItemNo           = "#ItemNo#"
						   UoM              = "#UoM#"
						   BOMItemno        = "#qry.MaterialItemNo#" 
						   BOMUom           = "#qry.MaterialUoM#" 
						   Level            = "#Level+1#"
						   Hierarchy        = "#Hierarchy#.#row#">	  
					
						   
					</cfif>	  							 
							
				 </cfloop>	
				 
			</cfif>	 			
	
	</cffunction>	

</cfcomponent>