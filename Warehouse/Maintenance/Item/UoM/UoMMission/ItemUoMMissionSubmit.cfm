
<cfquery name="verifyUnique" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	TOP 1 Mission
		FROM    ItemUoMMission
		WHERE	ItemNo = '#Form.ItemNo#'
		AND		UoM = '#Form.UoM#'
		AND		Mission = '#Form.Mission#'
</cfquery>

<cfset StandardCost = replace("#Form.StandardCost#",",","")>

<cfoutput>


<cf_tl id="The combination of item, uom and mission already exists.  Operation aborted." class="message" var = "vAlready">

<cfif ParameterExists(Form.Save)>	
	
	<cfif verifyUnique.recordCount gt 0>
	
		<script language="JavaScript">alert("#vAlready#")</script>  
	
	<cfelse>
	
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ItemUoMMission
		          (ItemNo,
		           UoM,
		           Mission,
				   TransactionUoM,
				   Selfservice,
				   EnableStockClassification,
				   StandardCost,
		           Operational,
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		     VALUES
		           ('#Form.ItemNo#',
		           '#Form.UoM#',
				   '#Form.Mission#',
				   <cfif Form.TransactionUoM neq "">
				   '#Form.TransactionUoM#',
				   <cfelse>
				   NULL,
				   </cfif>
				   '#Form.Selfservice#',
				   '#Form.EnableStockClassification#',
				   #StandardCost#,
				   #Form.Operational#,
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')		
		</cfquery>
		
		<script language="JavaScript">   
		
		  parent.parent.uommissionrefresh('#Form.ItemNo#','#Form.UoM#','')	 
		  parent.parent.ColdFusion.Window.destroy('mydialog',true)	
	          
		</script> 
		
	</cfif>
		  
</cfif>

<cfif ParameterExists(Form.Update)>	
	
	<cfif verifyUnique.recordCount gt 0 and Form.Mission neq Form.MissionOld>
	
		<script language="JavaScript">alert("#vAlready#")</script>  
	
	<cfelse>
	
		<cfquery name="get" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ItemUoM	
			WHERE  ItemNo              = '#Form.ItemNo#'
			AND    UoM                 = '#Form.UoM#'			
	    </cfquery>
	
		<cfquery name="Check" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ItemUoMMission		
			WHERE  ItemNo              = '#Form.ItemNo#'
			AND    UoM                 = '#Form.UoM#'
			AND    Mission             = '#Form.MissionOld#'		
	    </cfquery>
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE ItemUoMMission
			SET    Mission                   = '#Form.Mission#',
				   <cfif Form.TransactionUoM neq "">
					   TransactionUoM					 = '#Form.TransactionUoM#',
				   <cfelse>
				   	   TransactionUoM = NULL,
				   </cfif>
				   StandardCost              = #StandardCost#,
				   Selfservice               = '#Form.Selfservice#',
				   EnableStockClassification = '#Form.EnableStockClassification#',
				   Operational               = '#Form.Operational#'
			WHERE  ItemNo                    = '#Form.ItemNo#'
			AND    UoM                       = '#Form.UoM#'
			AND    Mission                   = '#Form.MissionOld#'		
		</cfquery>
						
		<!--- check for price changes --->
		
		<cfif check.standardcost neq standardcost>		
							 
			 <cfinvoke component = "Service.Process.Materials.Stock"  
		       method            = "setStockPrice" 
		       mission           = "#Form.MissionOld#"
			   ItemNo            = "#Form.ItemNo#"			  
			   UoM               = "#Form.UOM#"			   
			   Price             = "#standardcost#">	 
			 
			<cfif get.UoMCode neq "">			
			
				<!--- also update the standard cost of child items 18/1/2014 
		        but ONLY if the global UoM is the same --->
			
				<cfquery name="getChildren" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT U.* 
					FROM   ItemUoM U, Item I
					WHERE  U.ItemNo = I.ItemNo
					AND    I.ItemNo IN (SELECT ItemNo 
					                    FROM   Item 
									    WHERE  ParentItemNo = '#Form.ItemNo#')
					AND    U.UoMCode = '#get.UoMCode#'			
                </cfquery> 	
				
				<cfloop query="getChildren">
				
					<!--- update the standard cost of the children for that mission --->
					
					<cfquery name="check" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT  *
						   FROM    ItemUoMMission						   
						   WHERE   ItemNo         = '#itemNo#' 
						   AND     UoM            = '#UoM#'
						   AND     Mission        = '#Form.MissionOld#'		
					 </cfquery>	
					 
					<cfif check.recordcount eq "1">
		
						<cfquery name="Update" 
							datasource="appsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							   UPDATE  ItemUoMMission
							   SET     StandardCost   = '#StandardCost#',
									   Operational    = '#Form.Operational#'							   
							   WHERE   ItemNo         = '#check.itemNo#' 
							   AND     UoM            = '#check.UoM#'
							   AND     Mission        = '#check.Mission#'		
						 </cfquery>	
						 
						  <cfinvoke component = "Service.Process.Materials.Stock"  
					       method            = "setStockPrice" 
					       mission           = "#check.mission#"
						   ItemNo            = "#check.ItemNo#"			  
						   UoM               = "#check.UOM#"			   
						   Price             = "#standardcost#">	 
					   
					  </cfif> 
				 			 
				 </cfloop>		
			 
			 </cfif>
		   									
		</cfif>
		
		<!--- transaction lots --->
		
		<cfquery name="GetLots" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	ItemUoMMissionLot
				WHERE	ItemNo = '#Form.ItemNo#'
				AND		UoM = '#Form.UoM#'
				AND 	Mission = '#Form.mission#'
		</cfquery>
		
		<cfloop query="GetLots">
			
			<cfif isDefined("Form.lot_transactionLot_#transactionLot#")>
			
				<cfset vLotItemBarcode = "">
				<cfset vLotDateEffective = "">
				<cfset vLotDateExpiration = "">
				<cfset vLotRemarks = "">
				
				<cfif isDefined("Form.lot_itemBarCode_#transactionLot#")>
					<cfset vLotItemBarcode = trim(evaluate("Form.lot_itemBarCode_#transactionLot#"))>
				</cfif>
				
				<cfif isDefined("Form.lot_dateEffective_#transactionLot#")>
					<cfset vLotDateEffectiveTemp = evaluate("Form.lot_dateEffective_#transactionLot#")>
					<cfset dateValue = "">
					<CF_DateConvert Value="#vLotDateEffectiveTemp#">
					<cfset vLotDateEffective = dateValue>
				</cfif>
				
				<cfif isDefined("Form.lot_dateExpiration_#transactionLot#")>
					<cfset vLotDateExpirationTemp = evaluate("Form.lot_dateExpiration_#transactionLot#")>
					<cfset dateValue = "">
					<CF_DateConvert Value="#vLotDateExpirationTemp#">
					<cfset vLotDateExpiration = dateValue>
				</cfif>
				
				<cfif isDefined("Form.lot_remarks_#transactionLot#")>
					<cfset vLotRemarks = trim(evaluate("Form.lot_remarks_#transactionLot#"))>
				</cfif>
				
				<cfquery name="updateLots" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE 	ItemUoMMissionLot
						SET		ItemBarcode = '#vLotItemBarcode#',
								DateEffective = <cfif vLotDateEffective neq "">#vLotDateEffective#<cfelse>null</cfif>,
								DateExpiration = <cfif vLotDateExpiration neq "">#vLotDateExpiration#<cfelse>null</cfif>,
								Remarks = <cfif vLotRemarks neq "">'#vLotRemarks#'<cfelse>null</cfif>
						WHERE	ItemNo = '#Form.ItemNo#'
						AND		UoM = '#Form.UoM#'
						AND 	Mission = '#Form.mission#'
				</cfquery>
				
			</cfif>
		
		</cfloop>
		
		<script language="JavaScript">   
		
		  parent.parent.uommissionrefresh('#Form.ItemNo#','#Form.UoM#','')	 
		  parent.parent.ColdFusion.Window.destroy('mydialog',true)	
	          
		</script> 
		
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ItemUoMMission
		WHERE  ItemNo  = '#Form.ItemNo#'
		AND    UoM     = '#Form.UoM#'
		AND    Mission = '#Form.MissionOld#'
	</cfquery>	
	
	<script language="JavaScript">   
		
		  parent.parent.uommissionrefresh('#Form.ItemNo#','#Form.UoM#','')	 
		  parent.parent.ColdFusion.Window.destroy('mydialog',true)	
	          
	</script> 
	
</cfif>

</cfoutput>