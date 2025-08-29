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
    <cfset this.name = "Execution Queries for stock levels">

	<cffunction name="ProsisRound" returntype="numeric" access="public" output="false">
	    <cfargument name="toRound" 	type="numeric" 	required="true" />
	    <cfargument name="scale" 	type="numeric" 	required="false" default="0"/>
	    <cfscript>
	        var vresult 		= toRound;
	        var scaleMultiplier = 10^scale;
	
	        vresult = vresult * scaleMultiplier;
	        vresult = round(javaCast('string', vresult) );
	        vresult = javaCast('string', vresult/scaleMultiplier);
	        return vresult;
	    </cfscript>
	</cffunction>
			
	<cffunction name="isValidUoM"
         access="public"
         returntype="boolean"
         displayname="Return true if the valid UoM exists if not, it returns false">

		<cfargument name = "ItemNo"	type="string"  required="true"   default="">							
		<cfargument name = "UoM"    type="string"  required="true"   default="">				
		<cfargument name = "dataSource"			type="string"  required="true"   default="AppsPurchase">													
						
		    <cfquery name="checkItemUoM" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT *
				FROM   Materials.dbo.ItemUoM 
				WHERE  ItemNo  = '#ItemNo#'
				AND    UoM     = '#UoM#'
			</cfquery>		
						
			<cfif checkItemUoM.recordcount eq 0>
				<cfreturn FALSE>
			<cfelse>
				<cfreturn TRUE>
			</cfif>	 			 
			 
	</cffunction>	

	<cffunction name="getBarCode"
         access="public"
         returntype="string"
         displayname="Return the barcode for the combination of category ItemNo UoM">

		<cfargument name = "Category"    type="string"  required="false"  default="">						 
		<cfargument name = "ItemNo"	     type="string"  required="true"   default="">							
		<cfargument name = "UoM"         type="string"  required="true"   default="">				
		<cfargument name = "DataSource"	 type="string"  required="true"   default="AppsPurchase">
		<cfargument name = "Mission"     type="string"  required="false"  default="">
		<cfargument name = "Lot" 		 type="string"  required="false"  default="">															
		
		
			<cfif Category eq "">
			
			    <cfquery name="qItem" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT Category
					FROM   Materials.dbo.Item
					WHERE  ItemNo = '#ItemNo#'
				</cfquery>	
				<cfset Category = qItem.Category>
			</cfif>	
		
		    <cfquery name="qCategory" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT Acronym
				FROM   Materials.dbo.Ref_Category
				WHERE  Category = '#Category#'
			</cfquery>	

			<cfif len(qCategory.Acronym) eq 2>
			
				<cfset vBarCode = qCategory.Acronym & ItemNo & UoM>
				
				<cfif Mission neq "" and Lot neq "">
					<cfset vBarCode = vBarcode & Lot>
				</cfif>
				
			<cfelse>
			
				<cfset vBarCode = "">			
				
			</cfif>				
			
			<cfreturn vBarCode>
			 
	</cffunction>		
	
	<cffunction name="getBarCodeAlternate"
         access="public"
         returntype="string"
         displayname="Return the barcode for the combination of category ItemNo UoM">

		<cfargument name = "DataSource"	 type="string"  required="true"   default="AppsPurchase">
		<cfargument name = "Mission"     type="string"  required="false"  default="">
		
		
			<cfif Mission neq "">

				<cfquery name="qMission" datasource="#datasource#"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					SELECT * FROM Organization.dbo.Ref_Mission
					WHERE Mission='#Mission#'
				</cfquery>

				<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
					<cfquery name="Parameter" 
						datasource="#datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT *
					    FROM Materials.dbo.Ref_ParameterMission
						WHERE Mission = '#Mission#' 
					</cfquery>
			
						
					<cfset No = Parameter.BarCodeSerialNo+1>
					<cfif No lt 10000>
					     <cfset No = 10000+#No#>
					</cfif>
						
					<cfquery name="Update" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE Materials.dbo.Ref_ParameterMission
						SET    BarCodeSerialNo = '#No#'				
						WHERE  Mission = '#Mission#'
					</cfquery>
				</cflock>

				<cfset vBarCode = qMission.MissionPrefix & No>
				

			<cfelse>				

				<cfset vBarCode = "">
								
			</cfif>
			
				
			
			<cfreturn vBarCode>
			 
	</cffunction>		
	
	
	
	<cffunction name="GenerateItem"
             access="public"
             returntype="struct"
             displayname="Return the ItemNo and ItemUom of the validated or newly created item">
				
			<cfargument name = "Mission"    		        type="string"  required="true"    default="">											
			<cfargument name = "Category"     		        type="string"  required="true"    default="">				
			<cfargument name = "CategoryItem"     	        type="string"  required="true"    default="">		
			<cfargument name = "ItemMaster"    		        type="string"  required="true"    default="">	
			<cfargument name = "UoM"           		        type="string"  required="true"    default="">	
			<cfargument name = "UoMCode"         	        type="string"  required="true"    default="#UoM#">	
			<cfargument name = "UoMDescription"  	        type="string"  required="true"    default="#UoMCode#">										
			<cfargument name = "Classification"             type="array"   required="true"    default="">						
			<cfargument name = "Cost"     			        type="numeric" required="true"    default="0">										
			<cfargument name = "Currency"  			        type="string"  required="false"   default="USD">													
			<cfargument name = "Price"     			        type="numeric" required="false"   default="0">													
			<cfargument name = "dataSource"			        type="string"  required="true"    default="AppsPurchase">													
			<cfargument name = "InheritedDescription"		type="string"  required="false"   default="">			
			<cfargument name = "InheritedClassification"   	type="string"  required="false"   default="">
			<cfargument name = "ParentItemNo"   			type="string"  required="false"   default="">			
				
			<!---- 1 step. Check for the item Master to exsit in Materials.dbo.Item --->
	
			<cfquery name="getItem" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT * 
				FROM   Materials.dbo.Item
				WHERE  <cfif ParentItemNo neq "">
						  ItemNo IN (SELECT ItemNo FROM Materials.dbo.Item WHERE ParentItemNo = '#ParentItemNo#' )
					   <cfelse>
						  ItemMaster = '#ItemMaster#'						
					   </cfif>
			</cfquery>	
			
			<cfset vItemNo = "">
			<cfset vItemUoM = "">			
		
			<cfif getItem.recordcount neq 0>
		
				<!---- 2 step. Check for the classificators to exsit in Materials.dbo.ItemClassification ---->		
						
						<cfset vl = arrayLen(Classification)>
						<cfset _add_classification = true>
						
						<cfloop query = "getItem">
						
							<cfset vItemNo = getItem.ItemNo>	
													
							<cfset sItem = checkClassification(
												ItemNo  		= vItemNo, 
												Classification	= Classification, 
												DataSource		= datasource)>
							
							<cfquery name="getClassification" 
							datasource="#datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
								SELECT * 
								FROM   Materials.dbo.ItemClassification
								WHERE  ItemNo    = '#vItemNo#'
							</cfquery>		
							
							<cfif vl eq sItem.existing and sItem.existing eq getClassification.recordcount>
								<cfset _add_classification = false>
								<cfbreak>
							</cfif>
							
						</cfloop>	
						
						<cfif _add_classification>
						
							<!---- I have to create a new item for that classification --->
							<cfset vItemNo = createItem(
												Mission		 = Mission,
												ItemMaster	 = ItemMaster,
												Category	 = Category,
												CategoryItem = CategoryItem, 
												Datasource   = datasource,
												ParentItemNo = ParentItemNo)>					
											
							<!---- Create a classification and then returns the itemNo and the ItemDescription in a struct --->					
							<cfset sItem   = createClassification(
												ItemNo			= vItemNo, 
												Classification	= Classification, 
												Datasource		= datasource)>												
							
						<cfelse>
						
							<cfset sItem   = checkClassification(
												ItemNo 			= vItemNo, 
												Classification  = Classification, 
												Datasource 		= datasource)>																										
							
						</cfif>													

						<!---- Updating, the item for the description as the description now is based on all the topic values XL/AM/SM --->					
						<cfset updateDescription(
									ItemMaster				= ItemMaster,
									ItemNo					= vItemNo,
									Description				= sItem.Description,
									Color					= sItem.Color, 
									Datasource				= datasource,
									InheritedDescription	= InheritedDescription,
									InheritedClassification	= InheritedClassification)>							
				
				<cfelse>
				
					<cfset vItemNo = createItem(
										Mission			= Mission,
										ItemMaster		= ItemMaster,
										Category		= Category,
										CategoryItem	= CategoryItem,
										Datasource		= datasource,
										ParentItemNo	= ParentItemNo)>		
					
					<cfset sItem   = createClassification(
										ItemNo			= vItemNo,
										Classification	= Classification,
										DataSource		= datasource)>												
					
					<cfset updateDescription(
										ItemMaster 				= ItemMaster,
										ItemNo     				= vItemNo,
										Description				= sItem.Description,
										Color					= sItem.Color,
										DataSource				= datasource,
										InheritedDescription	= InheritedDescription,
										InheritedClassification = InheritedClassification)>		
										
				</cfif>

				<cfset vBarCode = getBarCode(
									Category	= Category,
									ItemNo		= vItemNo,
									UoM			= UoM, 
									DataSource  = datasource)>						

				<cfset vBarCodeAlternate = getBarCode(
										Mission		 = Mission,
										DataSource  = datasource)>											

				
				<cfif NOT isValidUoM(ItemNo= vItemNo, UoM = UoM, DataSource = datasource)>
					
					<cfset vItemUoM = createItemUoM (
										Mission 		= Mission,
										ItemNo			= vItemNo,
										UoM 			= UoM,
										UoMCode			= UoMCode,
										UoMDescription 	= UoMDescription,
										Cost			= Cost,
										BarCode			= vBarCode,
										BarCodeAlternate = vBarCodeAlternate,
										DataSource		= datasource)>						
				<cfelse>
					<!---Nothing to do, all is fine--->
					<cfset vItemUoM = UoM>
				</cfif>
				
				<cfset vCost = createItemUoMPrice(
									Currency 	= Currency, 
									Mission		= Mission,
									ItemNo		= vItemNo,
									UoM			= UoM,
									Cost		= Cost,
									Price		= Price,
									Category	= Category,
									DataSource	= datasource)>
		
				<cfset sReturn = StructNew()>
				<cfset sReturn.ItemNo         = vItemNo>
				<cfset sReturn.ItemUoM        = vItemUom>						
				<cfset sReturn.BarCode        = vBarCode>						
				<!---- if and only if a price was given, then a estimated/average cost is returned, otherwise 0 --->
				<cfset sReturn.Cost           = vCost>										
				<cfreturn sReturn>
		
	</cffunction>		

	<cffunction name="createItem"
             access="public"
             returntype="numeric"
             displayname="Return the ItemNo of the validate or newly created item">
				
			<cfargument name = "Mission"    		type="string"  required="true"   default="">					
			<cfargument name = "ItemMaster"    		type="string"  required="true"   default="">									
			<cfargument name = "Category"     		type="string"  required="true"   default="ZAP">				
			<cfargument name = "CategoryItem"     	type="string"  required="true"   default="001">								
			<cfargument name = "dataSource"			type="string"  required="true"   default="AppsPurchase">													
			<cfargument name = "ParentItemNo"		type="string"  required="false"  default="">

		    <!---- To create the Item ---->		
			<cfquery name="qItemMaster" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Purchase.dbo.ItemMaster
				WHERE  Code = '#ItemMaster#'
			</cfquery>			

			<cfset No = "">
						
			<cfquery name="qValuation" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  ValuationCode
				FROM    Materials.dbo.Ref_Category
				WHERE   Category = '#Category#'
			</cfquery>		
			
			<cfsilent>
				<cfoutput>
					<cf_logpoint mode="append" filename="ItemCreateLog.txt">
						createItem function: Before AssignItemNo.cfm
					</cf_logpoint>
				</cfoutput>
			</cfsilent>
			
			<cfinclude template = "../../../Warehouse/Maintenance/Item/AssignItemNo.cfm">
			
			<cfsilent>
				<cfoutput>
					<cf_logpoint mode="append" filename="ItemCreateLog.txt">
						createItem function: After AssignItemNo.cfm, returning <cfif isDefined("No")>'#No#'<cfelse>"No" undefined</cfif>
					</cf_logpoint>
				</cfoutput>
			</cfsilent>
			
			<cfset vCommodityCode = "">
			<cfset vPrecision     = "0">
			
			<cfif ParentItemNo neq "">
			
					<!--- added on 7/16/2013 by dev--->
					<cfquery name="qItemParent" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    Materials.dbo.Item
						WHERE   ItemNo = '#ParentItemNo#'
					</cfquery>
					<cfset vCommodityCode = qItemParent.CommodityCode> 			
					<cfset vPrecision     = qItemParent.ItemPrecision> 
					
			</cfif>		
			
			<cfquery name="CreateItem" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				INSERT INTO Materials.dbo.Item
				           (ParentItemNo,
				            ItemNo,
				            ItemDescription,
				            Make,
				            Model,
				            ItemNoExternal,
				            ItemDescriptionExternal,
				            Mission,
				            ItemMaster,
				            Category,
				            CategoryItem,
				            Classification,
				            Destination,
				            ItemPrecision,
				            ValuationCode,
				            ItemClass,
				            <cfif vCommodityCode neq "">
				            	CommodityCode,
				            </cfif>
							Operational,				          
				            OfficerUserId,
				            OfficerLastName,
				            OfficerFirstName)
				     VALUES
				           (
				           <cfif ParentItemNo eq "">
				           		NULL,
						   <cfelse>
						   	   '#ParentItemNo#',		   
				           </cfif>
				           '#No#',
				           '#qItemMaster.Description#',
				           NULL,
				           NULL,
				           NULL,
				           '#qItemMaster.Description#',
				           '#Mission#',
				           '#qItemMaster.Code#',
				           '#Category#',      
				           '#CategoryItem#',  
				           NULL,
				           'Sale',     
				           '#vPrecision#',
				           '#qValuation.ValuationCode#',     
				           'Supply',  
				           <cfif vCommodityCode neq "">
				           		'#vCommodityCode#',
				           </cfif>
						   '1', 				          
				           '#SESSION.acc#',
				           '#SESSION.last#',
				           '#SESSION.first#')
			</cfquery>			

			<!--- Populate language table --->
			<cfquery name="ItemLanguage" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT TableCode
					FROM   System.dbo.LanguageSource
					WHERE  TableCode = 'Item' AND SystemModule = 'Warehouse'
			</cfquery>
			
			<cfif ItemLanguage.RecordCount gt 0>
				
				<cfquery name="Language" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT L.Code
					    FROM   System.dbo.Ref_SystemLanguage L   
						WHERE  L.Operational >= '2' 
						AND    L.SystemDefault != 1
						ORDER  BY SystemDefault DESC, L.Code 
				</cfquery>
				
				<cfloop query="Language">
				
					<cfquery name="Insert" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						INSERT INTO Materials.dbo.Item_Language
							(ItemNo, LanguageCode, ItemDescription, OfficerUserId,Created)
						VALUES ('#No#','#Code#','#qItemMaster.Description#','#SESSION.acc#',getdate())					
					</cfquery>
					
				</cfloop>
			
			</cfif>
			
			<cfreturn No>
	
	</cffunction>
	
	<cffunction name="createItemLot"
             access="public"
             displayname="Add Item, UoM, Mission and Lot">

			<cfargument name = "Mission"		type="string"  required="true"   default="">							
			<cfargument name = "ItemNo"			type="string"  required="true"   default="">							
			<cfargument name = "UoM" 			type="string"  required="true"   default="">
			<cfargument name = "Lot"			type="string"  required="true"   default="">
			<cfargument name = "LotDate"		type="string"  required="true"   default="">			
			<cfargument name = "DataSource"		type="string"  required="true"   default="AppsPurchase">													
												
			<cfif Lot neq "0">

               <cfset dateValue = "">
               <cf_DateConvert Value="#LotDate#">
               <cfset dte = dateValue>		 

				<cfquery name="getLot" 
				   datasource="#DataSource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				    SELECT * 
				    FROM   Materials.dbo.ProductionLot 
				    WHERE  Mission         = '#Mission#'
				    AND    TransactionLot  = '#Lot#'
				</cfquery>
				
				 
				<cfif getLot.recordcount eq "0">
				 
						<cfquery name="Insert" 
						    datasource="#DataSource#" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						    INSERT INTO Materials.dbo.ProductionLot
						     (Mission,
						      TransactionLot,
						   	  TransactionLotDate,
						   	  OfficerUserId,
						   	  OfficerLastName,
						   	  OfficerFirstName)
						    VALUES
						      ('#Mission#',
						       '#Lot#',
						   	    #dte#,
						   	   '#SESSION.acc#',
						   	   '#SESSION.last#',
						   	   '#SESSION.first#')
						</cfquery> 
				  
				</cfif>

				<cfquery name="Check" 
				    datasource="#DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				     SELECT * 
				     FROM   Materials.dbo.ItemUoMMissionLot 
				     WHERE  ItemNo         = '#ItemNo#'
				     AND    UoM            = '#UoM#'
				     AND    Mission        = '#Mission#'
				     AND    TransactionLot = '#Lot#'
				</cfquery>

				<cfset vBarCode = getBarCode(
									ItemNo			= ItemNo,
									UoM				= UoM,
									Mission			= Mission,
									Lot				= Lot,
									DataSource  	= DataSource)>						

				<cfset vBarCodeAlternate = getBarCodeAlternate(
									Mission			= Mission,
									DataSource  	= DataSource)>						

			 
				<cfif Check.recordCount is 0>
				
				   <cfquery name="Insert" 
				    datasource="#DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				     INSERT INTO Materials.dbo.ItemUomMissionLot 
				            (ItemNo,
				       		 UoM,
				       		 Mission,
				       		 TransactionLot,    
				       		 ItemBarCode,
				       		 ItemBarCodeAlternate,
				       		 OfficerUserId,
				       		 OfficerLastName,
				       		 OfficerFirstName)
				       		 VALUES ('#ItemNo#', 
				             		 '#UoM#',
				             	     '#Mission#', 
				             		 '#Lot#',
				             		 '#vBarCode#',      
				             		 '#vBarCodeAlternate#',
				       				 '#SESSION.acc#', 
				       				 '#SESSION.last#', 
				       				 '#SESSION.first#')
				    </cfquery>
				    
				<cfelse>
				   <cfquery name="Update" 
				    datasource="#DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				     UPDATE Materials.dbo.ItemUomMissionLot
				     SET	ItemBarCode    = '#vBarCode#',
				     		ItemBarCodeAlternate    = '#vBarCodeAlternate#'				        
				     WHERE  ItemNo         = '#ItemNo#'
				     AND    UoM            = '#UoM#'
				     AND    Mission        = '#Mission#'
				     AND    TransactionLot = '#Lot#'
				    </cfquery>					    
				</cfif>
			 
			</cfif> 
		
	</cffunction>	
	
	<cffunction name="checkClassification"
             access="public"
             returntype="struct"
             displayname="Return the number of matches for classification given a certain itemNo">
	
			<cfargument name = "ItemNo"				type="string"  required="true"   default="">							
			<cfargument name = "Classification"     type="array"   required="true"   default="">				
			<cfargument name = "dataSource"			type="string"  required="true"   default="AppsPurchase">
						
				<cfset found    = 0>
				<cfset l = arrayLen(Classification)>
				<cfset vDescription = "">
				<cfset vColor       = "">		
				<cfset descriptions = ArrayNew(1)>
				
				<cfloop from="1" to="#l#" index="i">

						<cfset vTopic        = "#Classification[i]['Topic']#">
						<cfset vListCode     = "#Classification[i]['ListCode']#">						
						<cfset vItemPointer  = "#Classification[i]['ItemPointer']#">											
						
						<cfquery name="getClassification" 
						datasource="#datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						  SELECT IC.* 
						  FROM   Materials.dbo.ItemClassification IC 
						  WHERE  IC.ItemNo   = '#ItemNo#'
						  AND    IC.Topic    = '#vTopic#'
						  AND    IC.ListCode = '#vListCode#'	
						</cfquery>	
						
						<cfif getClassification.recordcount eq 0>
							<!---- if it does not exist then I will have to create all for the item ---->
							<cfbreak>
							
						<cfelse>
							
							<cfset found = found + 1>

							<cfquery name="getOrder" 
							datasource="#datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
								SELECT ListingOrder
								FROM Materials.dbo.Ref_Topic
								WHERE Code = '#vTopic#'
							</cfquery>	
							
							<cfset descriptions[getOrder.ListingOrder]=vListCode>							
							
							<cfif vItemPointer eq "Color">
								<cfset vColor = vListCode>
							</cfif>										

						</cfif>
					
				</cfloop>	
				
				<cfset l = arrayLen(descriptions)>
				<cfloop from="1" to="#l#" index="i">
					<cftry>
						<cfif descriptions[i] neq "">
							<cfif vDescription eq "">
									<cfset vDescription = descriptions[i] >						
							<cfelse>
								<cfset vDescription = vDescription & "/" & descriptions[i]  >														
							</cfif>			
						</cfif>
					<cfcatch>
					
					</cfcatch>					
				</cftry>
				</cfloop>	
		
				<cfset sItem             = StructNew()>
				<cfset sItem.itemNo      = ItemNo >
				<cfset sItem.Description = vDescription >
				<cfset sItem.Color       = vColor>				
				<cfset sItem.existing    = found>									
	
				<cfreturn sItem>
	
	</cffunction>	
		
	<cffunction name="createClassification"
         access="public"
         returntype="struct"
         displayname="Return a struct with the itemNo and the itemDescription as it combines the classificators ">
	
			<cfargument name = "ItemNo"				type="string"  required="true"   default="">							
			<cfargument name = "Classification"     type="array"   required="true"   default="">				
			<cfargument name = "dataSource"			type="string"  required="true"   default="AppsPurchase">													
			
			<cfset vDescription = "">
			<cfset vColor       = "">			
			<cfset l = arrayLen(Classification)>
			<cfset descriptions = ArrayNew(1)>

			<cfloop from="1" to="#l#" index="i">

					<cfset vTopic        = "#Classification[i]['Topic']#">
					<cfset vListCode     = "#Classification[i]['ListCode']#">		
					<cfset vListValue    = "#Classification[i]['ListValue']#">					
					<cfset vItemPointer  = "#Classification[i]['ItemPointer']#">
					
					<cfquery name="qList" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					  SELECT ListValue 
  						FROM Materials.dbo.Ref_TopicList
  						WHERE Code='#vTopic#' AND
  						ListCode='#vListCode#'
					</cfquery>	  
  						
  					<cfif qList.recordcount eq 0>
  						<cfset vTopicValue = qList.ListValue>
  					<cfelse>
					  	<cfset vTopicValue = "">
  					</cfif>												

					<cfquery name="insertClassification" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					INSERT INTO Materials.dbo.ItemClassification(
							ItemNo, 
							Topic, 
							ListCode, 
							TopicValue, 
							OfficerUserId, 
							OfficerLastName, 
							OfficerFirstName )
					VALUES ( '#ItemNo#',
						     '#vTopic#',
						     '#vListCode#', 
							 <cfif vTopicValue eq "">
						     	NULL,
						     <cfelse>
							 	'#vTopicValue#',
							 </cfif> 
						     '#SESSION.acc#',
						     '#SESSION.last#', 
						     '#SESSION.first#' )
					</cfquery>						
					
					<cfquery name="getOrder" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT ListingOrder
						FROM Materials.dbo.Ref_Topic
						WHERE Code = '#vTopic#'
					</cfquery>	
					
					<cfset descriptions[getOrder.ListingOrder]=vListCode>
					
					<cfif vItemPointer eq "Color">
						<cfset vColor = vListValue>
					</cfif>				
				
			</cfloop>
			
			<cfset l = arrayLen(descriptions)>
			<cfloop from="1" to="#l#" index="i">
				<cftry>
					<cfif descriptions[i] neq "">
						<cfif vDescription eq "">
								<cfset vDescription = descriptions[i] >						
						<cfelse>
							<cfset vDescription = vDescription & "/" & descriptions[i]  >														
						</cfif>			
					</cfif>
					<cfcatch></cfcatch>
				</cftry>
			</cfloop>

			<cfset sItem             = StructNew()>
			<cfset sItem.itemNo      = ItemNo>
			<cfset sItem.Description = vDescription>
			<cfset sItem.Color       = vColor>				

			<cfreturn sItem>
	
	</cffunction>	

	<cffunction name="updateDescription"
          access="public"
          returntype="boolean"
          displayname="Update the Item descriptors">

			<cfargument name = "ItemMaster"	               type="string"  required="true"   default="">							
			<cfargument name = "ItemNo"		               type="string"  required="true"   default="">							
			<cfargument name = "Description"               type="string"  required="true"   default="">				
			<cfargument name = "Color"                     type="string"  required="true"   default="">							
			<cfargument name = "dataSource"	               type="string"  required="true"   default="AppsPurchase">
			<cfargument name = "InheritedDescription"      type="string"  required="false"  default="">
			<cfargument name = "InheritedClassification"   type="string"  required="false"  default="">
																			
			<cfif InheritedDescription eq "">
			
				<cfquery name="qItemMaster" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Purchase.dbo.ItemMaster
					WHERE  Code = '#ItemMaster#'
				</cfquery>
				
				<cfset vInheritedDescription = qItemMaster.Description>
				 
			<cfelse>
					<cfset vInheritedDescription = InheritedDescription> 	
			</cfif>					
			
			<cfif InheritedClassification eq "">
				<cfset vInheritedClassification = Description>
			<cfelse>	
				<cfset vInheritedClassification = InheritedClassification>
			</cfif>
						
			<cfquery name="getClassification" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				UPDATE Materials.dbo.Item 
				SET    ItemDescription         = '#vInheritedDescription# #Description#',
				       ItemDescriptionExternal = '#vInheritedDescription# #Description#',
					   Classification          = '#vInheritedClassification#',
					   ItemColor               = '#Color#' 
				WHERE  ItemNo                  = '#ItemNo#'
			</cfquery>		
						
			<cfquery name="Language" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT   L.Code
				    FROM     System.dbo.Ref_SystemLanguage L   
					WHERE    L.Operational >= '2' 
					AND      L.SystemDefault != 1
					ORDER BY SystemDefault DESC, L.Code 
			</cfquery>
			
			<cfloop query="Language">
				<cfquery name="UpdateLanguage" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					UPDATE   Materials.dbo.Item_Language
					SET      ItemDescription = '#vInheritedDescription# #Description#'
					WHERE    ItemNo 		   = '#ItemNo#'
					AND      LanguageCode    = '#Code#'
				</cfquery>
			</cfloop>			
						
			<cfreturn TRUE>
			 
	</cffunction>
	
	<cffunction name="createItemUoM"
        access="public"
        returntype="string"
        displayname="Return a struct with the itemNo and the itemDescription as it combines the classificators ">

		    <cfargument name = "Mission"          type="string"   required="true"   default="">	
			<cfargument name = "ItemNo"	          type="string"   required="true"   default="">							
			<cfargument name = "UoM"              type="string"   required="true"   default="">	
			<cfargument name = "UoMCode"          type="string"   required="true"   default="#UoM#">	
			<cfargument name = "UoMDescription"   type="string"   required="true"   default="#UoMCode#">				
			<cfargument name = "Cost"             type="numeric"  required="true"   default="0">							
			<cfargument name = "Barcode"          type="string"   required="true"   default="">
			<cfargument name = "BarcodeAlternate" type="string" required="true"   default="">										
			<cfargument name = "DataSource"	      type="string"   required="true"   default="AppsPurchase">																 

			<cfif UoMCode neq "">
			
			    <cfquery name="CheckUoM" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				    SELECT *
					FROM Materials.dbo.Ref_UoM
			        WHERE Code = '#UoMCode#'
				</cfquery>		
				
				<cfif CheckUoM.recordcount eq 0>
				
				    <cfquery name="insertRef" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					    INSERT INTO Materials.dbo.Ref_UoM
				            	(Code,Description,ListingOrder,OfficerUserId,OfficerLastName,OfficerFirstName)
				    	VALUES  ('#UoMCode#','#UoMDescription#',0,'#SESSION.acc#','#SESSION.last#','#SESSION.first#')
					</cfquery>		
				
				</cfif>
				
			</cfif>

			<cfquery name="parameter"
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT *
				FROM   Materials.dbo.Ref_ParameterMission
				WHERE  Mission = '#mission#'
			</cfquery>

		    <cfquery name="insertItemUoM" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			    INSERT INTO Materials.dbo.ItemUoM
			            (ItemNo,
						 UoM,
						 UoMCode,
						 UoMDescription,
						 UoMMultiplier,
						 ItemBarcode,
						 StandardCost,
						 Operational,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			    VALUES  ('#ItemNo#',
				         '#UoM#',
						 '#UoMCode#',
						 '#UoMDescription#',
						 1,
						 '#Barcode#',
						 '#ProsisRound(Cost,Parameter.CostPricePrecision)#',
						 1,
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
			</cfquery>		
			 
		    <cfquery name="checkItemUoMMission" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Materials.dbo.ItemUoMMission
				WHERE  ItemNo  = '#ItemNo#' 
				AND    UoM     = '#UoM#' 
				AND    Mission = '#Mission#'
			</cfquery>
			 
			<cfif  checkItemUoMMission.recordcount eq 0>
			
			    <cfquery name="insertItemUoMMission" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				   INSERT INTO Materials.dbo.ItemUoMMission
		                   (ItemNo,UoM,Mission,StandardCost,Operational,OfficerUserId,OfficerLastName,OfficerFirstName)
			       VALUES  ('#ItemNo#',
				            '#UoM#',
							'#Mission#',
							'#ProsisRound(Cost,Parameter.CostPricePrecision)#',
							1,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
				</cfquery>	 
			
			</cfif>			
						 
			<cfreturn UoM> 
			 
	</cffunction>		
	
	<cffunction name="createItemUoMPrice"
             access="public"
	         returntype="numeric"			 
             displayname="Suggested selling price routine for the item | if it does not exist it creates it">			 
			
			<cfargument name = "Currency"    	type="string"  required="true"   default="USD">					
			<cfargument name = "Mission"    	type="string"  required="true"   default="">					
			<cfargument name = "ItemNo"    		type="string"  required="true"   default="">					
			<cfargument name = "UoM"     		type="string"  required="true"   default="0">				
			<cfargument name = "Cost"     		type="numeric" required="true"   default="0">		
			<cfargument name = "DateEffective" 	type="string"  required="true"   default="#DateFormat(now(),CLIENT.DateFormatShow)#">										
			<cfargument name = "Price"     		type="numeric" required="true"   default="0">														
			<cfargument name = "Category"     	type="string"  required="false"  default="">				
			<cfargument name = "dataSource"		type="string"  required="true"   default="AppsPurchase">	
									
			<cfif Category eq "">
			
				 <cfquery name="Item" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT*
					 FROM  Materials.dbo.Item
					 WHERE ItemNo = '#ItemNo#'			
				</cfquery>						
				
				<cfset Category = Item.Category>
			
			</cfif>												

		    <cfquery name="checkWarehouse" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT Warehouse,
				       Category,
				       PriceSchedule,
				       Currency,
				       CostPriceMultiplier,
				       CostPriceCeiling
				 FROM  Materials.dbo.WarehouseCategoryPriceSchedule
				 WHERE Warehouse IN ( SELECT Warehouse
									  FROM   Materials.dbo.Warehouse 
									  WHERE  Mission = '#Mission#'
									  AND    Operational = 1 )
				  AND  PriceSchedule IN (SELECT Code FROM Materials.dbo.Ref_PriceSchedule WHERE Operational = 1) 					  
				  AND  Operational = '1'
				  AND  Category    = '#Category#'		  
			</cfquery>			
									
			<cfset dateValue = "">
		    <CF_DateConvert Value="#DateEffective#">
			<cfset eff = dateValue>				
			
			<cfset vCost = 0>
			
					
			<cfquery name="Parameter"
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM       Materials.dbo.Ref_ParameterMission
					WHERE      Mission = '#mission#'								
			</cfquery>	
			
			<cfquery name="CheckItem" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
					SELECT *  
					FROM   Materials.dbo.ItemUoMPrice
					WHERE  ItemNo         = '#ItemNo#'
					AND	   UoM            = '#UoM#'
					AND	   Mission        = '#Mission#'		
					AND    DateEffective  = #eff#							
			</cfquery>							
			
			<cfif checkItem.recordcount eq "0">
				
				<cfloop query = "checkWarehouse">
				
					<cfquery name="CheckItem" 
						datasource="#datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT *  
							FROM   Materials.dbo.ItemUoMPrice
							WHERE  ItemNo        = '#ItemNo#'
							AND	   UoM           = '#UoM#'
							AND	   PriceSchedule = '#PriceSchedule#'	
							AND    DateEffective = #eff#						
							AND	   Currency      = '#Currency#'							
					</cfquery>
				
					<cfquery name="CheckPrice" 
						datasource="#datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT *  
							FROM   Materials.dbo.ItemUoMPrice
							WHERE  ItemNo        = '#ItemNo#'
							AND	   UoM           = '#UoM#'
							AND	   PriceSchedule = '#PriceSchedule#'
							AND    DateEffective = #eff#
							AND    Mission       = '#Mission#'
							AND    Warehouse     = '#Warehouse#'
							AND	   Currency      = '#Currency#'
					</cfquery>
				
					<cfset vCost = Cost>
					
					<cfif checkPrice.recordcount eq 0>
					
						<cfquery name="CheckTaxCode" 
							datasource="#datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">			
							SELECT TaxCode
							FROM   Materials.dbo.ItemWarehouse				
							WHERE  ItemNo      = '#ItemNo#'
							AND    Warehouse   = '#Warehouse#'							
						</cfquery>	
						
						<cfset vTaxCode = "00">
						
						<cfif CheckTaxCode.recordcount neq 0>
						
							<cfset vTaxCode = ChecktaxCode.TaxCode>
							
						</cfif>
						
						<!--- last chance to determine the tax code --->
						
						<cfif vTaxCode eq "00">																						
							
							<cfquery name="CheckTaxCode" 
							datasource="#datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">			
								SELECT DISTINCT  TaxCode
								FROM   Materials.dbo.WarehouseCategory
								WHERE  Category  = '#Category#' 								
						    </cfquery>	
							
							<cfif CheckTaxCode.recordcount neq 0>
								<cfset vTaxCode = ChecktaxCode.TaxCode>							
							</cfif>		
							
						</cfif>		
										
						<!--- then I have to create a new item based on parameters if and only if the Price has not been passed --->
						
						<cfif Price eq 0>
							
							<cfset vSalesPrice = CalculateSuggestedPrice(
									Cost         = Cost,
									TaxCode      = vTaxCode,
									Multiplier   = CostPriceMultiplier, 
									PriceCeiling = CostPriceCeiling,
									CurrencyTo   = checkWarehouse.Currency,
									Datasource   = datasource)>													
																										
						<cfelse>
						
							<cfif Currency eq checkWarehouse.Currency>
								<cfset vSalesPrice = Price>		
							<cfelse>
							    <cf_exchangerate CurrencyFrom = "#Currency#" CurrencyTo = "#checkWarehouse.Currency#" datasource="AppsPurchase">
							    <cfset vConverted_Amount = round(Price/exc * 100 )/ 100>
								<!--- it calculates an average of the price for the cost--->						
								<cfset vSalesPrice = vConverted_Amount>								
							</cfif>
							
						</cfif>	
	
						<cfquery name="getWarehouse" 
							datasource="#datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Materials.dbo.Warehouse 
							    WHERE  Warehouse = '#Warehouse#' 																
						</cfquery>			
						
						<!---
						<cfif getWarehouse.SupplyWarehouse eq ""> before we updated the entity price only if received by top warehouse, this has been removed
						--->
						
							<!--- entity price --->
							
							<cfquery name="CheckPrice" 
								datasource="#datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
									SELECT *  
									FROM   Materials.dbo.ItemUoMPrice
									WHERE  ItemNo        = '#ItemNo#'
									AND	   UoM           = '#UoM#'
									AND	   PriceSchedule = '#checkWarehouse.PriceSchedule#'
									AND    DateEffective = #eff#
									AND    Mission       = '#Mission#'
									AND    Warehouse IS NULL
									AND	   Currency      = '#checkWarehouse.Currency#'
							</cfquery>
							
							<cfif checkPrice.recordcount eq "0" and vSalesPrice neq "0">
						
								<cfquery name="CheckPrice" 
									datasource="#datasource#" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">			
										INSERT INTO Materials.dbo.ItemUoMPrice
								           (ItemNo
								           ,UoM
								           ,PriceSchedule
								           ,Mission						          
								           ,Currency
								           ,DateEffective
								           ,SalesPrice
				   						   <cfif vTaxCode neq "">
											   ,TaxCode
										   </cfif>	   
								           ,CalculationMode
								           ,CalculationClass
								           ,CalculationPointer
								           ,OfficerUserId
								           ,OfficerLastName
								           ,OfficerFirstName
								           )
								     VALUES (
									       '#ItemNo#'
								           ,'#UoM#' 
								           ,'#checkWarehouse.PriceSchedule#'
								           ,'#Mission#'						           
								           ,'#checkWarehouse.Currency#'
								           ,#eff#
								           ,'#vSalesPrice#'
										   <cfif vTaxCode neq "">
											   ,'#vTaxCode#'
										   </cfif>
								           ,'Price component'
								           ,NULL
								           ,'0'
										   ,'#SESSION.acc#'
								    	   ,'#SESSION.last#'		  
					  	                   ,'#SESSION.first#' )									   
										   
								</cfquery>	
								
							</cfif>							
						
						<!---
						</cfif>	
						--->
						
						<cfif Parameter.priceManagement eq "1" and vSalesPrice neq "0">
						
							<cfquery name="CheckPrice" 
								datasource="#datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">		
								
									INSERT INTO Materials.dbo.ItemUoMPrice
							           (ItemNo
							           ,UoM
							           ,PriceSchedule
							           ,Mission
							           ,Warehouse
							           ,Currency
							           ,DateEffective
							           ,SalesPrice
			   						   <cfif vTaxCode neq "">
										   ,TaxCode
									   </cfif>	   
							           ,CalculationMode
							           ,CalculationClass
							           ,CalculationPointer
							           ,OfficerUserId
							           ,OfficerLastName
							           ,OfficerFirstName )
							     VALUES (
								       '#ItemNo#'
							           ,'#UoM#' 
							           ,'#checkWarehouse.PriceSchedule#'
							           ,'#Mission#'
							           ,'#checkWarehouse.Warehouse#'
							           ,'#checkWarehouse.Currency#'
							           ,#eff#
							           ,'#vSalesPrice#'
									   <cfif vTaxCode neq "">
										   ,'#vTaxCode#'
									   </cfif>
							           ,'Price component'
							           ,NULL
							           ,'0'
									   ,'#SESSION.acc#'
							    	   ,'#SESSION.last#'		  
				  	                   ,'#SESSION.first#' )
							</cfquery>	
							
						</cfif>							
					
					</cfif>
				
				</cfloop>	
				
			</cfif>	
									
			<cfreturn vCost>			
			
	</cffunction>	
	
	<cffunction name="CalculateSuggestedPrice"
             access="public"
	         returntype="numeric"
             displayname="Return the suggested price">
				
				<cfargument name = "Cost"    		type="numeric"  required="true"   default="0">		
				<cfargument name = "Taxcode"  		type="string"   required="true"   default="00">				
				<cfargument name = "Multiplier"	    type="numeric"  required="true"   default="0">					
				<cfargument name = "PriceCeiling"   type="numeric"  required="true"   default="5">		
				<cfargument name = "CurrencyTo"     type="string"   required="true"   default="USD">		
				<cfargument name = "Datasource"     type="string"   required="true"   default="AppsPurchase">	
				
				<cfquery name="getTaxCode" 
						datasource="#datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						SELECT *
						FROM   Accounting.dbo.Ref_Tax
						WHERE  TaxCode = '#taxCode#'				
			    </cfquery>
							
				<cfif getTaxCode.TaxCalculation eq "Inclusive">
					<cfset vCost   = Cost * (1+getTaxCode.Percentage) * Multiplier>
				<cfelse>
					<cfset vCost   = Cost * Multiplier>
				</cfif> 
								
				<cfset exc = 1.00>
				
			    <cf_exchangerate CurrencyFrom = "#APPLICATION.BaseCurrency#" CurrencyTo = "#CurrencyTo#" datasource="#datasource#">
			    
				<cfset vConverted_Amount = round(vCost/exc * 100 )/ 100>
								
				<cfif PriceCeiling neq "" and PriceCeiling neq "0">
				
					<cfset amt = vConverted_Amount / PriceCeiling>
					
					<cfset vConverted_Amount = ceiling(amt)* PriceCeiling>
														
				</cfif>
																			
				<cfreturn vConverted_Amount>
	
	</cffunction>

</cfcomponent>
