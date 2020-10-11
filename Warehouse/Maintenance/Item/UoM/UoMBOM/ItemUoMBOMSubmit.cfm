<cfparam name="FORM.ItemNo" default="">
<cfparam name="FORM.UoM" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.DateEffective, CLIENT.DateFormatShow)#">
<cfset dte = dateValue>

<cfswitch expression="#URL.mode#">

<cfcase value="add">	
				
		<!--- ---------------------------------------------------------------- --->
		<!--- we apply this to the item itself and its potential BOMN children --->
		<!--- ---------------------------------------------------------------- --->
		
		<cfquery name="UoMList"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     ItemUoM
				WHERE    ItemNo         = '#URL.ID#'
		        AND      UoM            = '#URL.UoM#'
				
				<cfif url.children eq "true">
				UNION ALL
				
				SELECT   *
				FROM     ItemUoM
				WHERE    ItemNo IN (SELECT ItemNo
				                    FROM   Item 
									WHERE  ParentItemNo = '#URL.ID#')
				AND      UoM = '#URL.UoM#'		
				
				</cfif>
						    
		</cfquery>
		<cftransaction>
		<cfloop query="UoMList">		
			
			<cfquery name="qCheck"
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   ItemBOM
				WHERE  Mission    	 = '#form.mission#'
				AND    ItemNo 		 = '#itemno#'
				AND    UoM    		 = '#uom#'
				AND    DateEffective = #dte#
			</cfquery>		

			<cfif qCheck.recordcount eq 0>
				<cf_assignid>
				<cfset bomid = rowguid>	
			
				<cfquery name="insertBOM"
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO ItemBOM
							(BOMId, 
							 Mission, 
							 ItemNo, 
							 UoM, 
							 DateEffective, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName )
						VALUES
							('#BOMid#',
							 '#form.mission#',
							 '#itemno#',
							 '#uom#',
							 #dte#,
							 '#session.acc#',
							 '#session.last#',
							 '#session.first#')		
				</cfquery>
			<cfelse>
				<cfset bomid = qCheck.BOMId>	
			</cfif>		
				
			<cfloop from="0" to="#Form.boxnumbers-1#" index="n">				
		
					<cftry>
						<cfset vDisplay = Evaluate("FORM.IDISPLAY#n#")>
					<cfcatch>
						<cfset vDisplay = 0>
					</cfcatch>		
					</cftry>
					
					<cfif vDisplay eq 1>
			
						<cfset vMaterialItemNo    = Evaluate("FORM.ItemNo#n#")>
						<cfset vMaterialUoM       = Evaluate("FORM.UoM#n#")>
						<cfset vMaterialReference = replace(Evaluate("FORM.ItemReference#n#"),",","","ALL")>
						<cfset vMaterialMemo      = Evaluate("FORM.ItemMemo#n#")>
						<cfset qty 			      = replace(Evaluate("FORM.ItemQuantity#n#"),",","","ALL")>
						<cfset cst 			      = replace(Evaluate("FORM.ItemCost#n#"),",","","ALL")>
																		
						<cfif not LSIsNumeric(qty)>
			
							<script>
							    alert('Incorrect quantity')
							</script>	 		
							<cfabort>
			
						</cfif>
						
						<cfif not LSIsNumeric(cst)>
			
							<script>
							    alert('Incorrect cost price')
							</script>	 		
							<cfabort>
			
						</cfif>		
								
						<cfquery name="qCheckDetails"
							datasource="appsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   ItemBOMDetail
							WHERE  BOMId          = '#BOMid#'
							AND    MaterialItemNo = '#vMaterialItemNo#'
							AND    MaterialUoM    = '#vMaterialUoM#'
						</cfquery>				

						<cfif qCheckDetails.recordcount eq 0>
						
								<cfquery name="InsertBOM"
									datasource="appsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">				
									INSERT INTO ItemBOMDetail
							           	  ( BOMId,		          
								           	MaterialItemNo,
								           	MaterialUoM,
											
								           	MaterialQuantity,
											MaterialCost,											
											MaterialReference,											
								           	MaterialMemo,
								           	OfficerUserId,
								           	OfficerLastName,
								           	OfficerFirstName)
							     	VALUES
								           	('#BOMid#',		           
								           	'#vMaterialItemNo#',
								           	'#vMaterialUoM#',
											
								           	'#qty#',
											'#cst#',
											'#Left(vMaterialReference,10)#',											
											'#Left(vMaterialMemo,100)#',
								           	'#SESSION.acc#',			   
								           	'#SESSION.first#',
								           	'#SESSION.last#')
								</cfquery>
								
						<cfelse>	
						
								<script language="JavaScript">
									alert('Bom detail already exists');
								</script>
								
						</cfif>
				
					</cfif>
				
			</cfloop>				
						
		</cfloop>	
		</cftransaction>
				
		<cfoutput>
			<script>
				try { ProsisUI.closeWindow('bomform',true)} catch(e){};
				ptoken.navigate('UoMBOM/ItemUoMBOM.cfm?ID=#URL.ID#&UoM=#URL.UoM#&Selected=#FORM.mission#','itemUoMBOM');
			</script>
		</cfoutput>
	
</cfcase>

<cfcase value="edit">	

		<cftransaction>
		<!--- ---------------------------------------------------------------- --->
		<!--- we apply this to the item itself and its potential BOMN children --->
		<!--- ---------------------------------------------------------------- --->
				
		<cfquery name="getBOM"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *  
				FROM   ItemBOM
				WHERE  BOMId         = '#url.bomId#'				
		</cfquery>	
				
		<cfquery name="UoMList"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     ItemUoM
				WHERE    ItemNo         = '#URL.ID#'
		        AND      UoM            = '#URL.UoM#'
				
				<cfif url.children eq "true">	
								
				UNION ALL
				
				SELECT   *
				FROM     ItemUoM
				WHERE    ItemNo IN (SELECT ItemNo
				                    FROM   Item 
									WHERE  ParentItemNo = '#URL.ID#')
				AND      UoM = '#URL.UoM#'		
				
				</cfif>
						    
		</cfquery>
		
		<cfloop query="UoMList">			
					
			<cfquery name="check"
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *  
					FROM   ItemBOM
					WHERE  Mission       = '#getBOM.Mission#'
					AND    ItemNo        = '#itemno#'
					AND    UoM           = '#uom#' 
					AND    DateEffective = #dte#		
			</cfquery>	
						
			<cfif check.recordcount gte 1>
												
				<cfquery name="deleteBOM"
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
					DELETE ItemBOM
					WHERE  BOMId = '#check.BomId#'		
				</cfquery>	
				
				<cfset bomid = check.bomid>
				
			<cfelse>
			
				<cf_assignid>
				<cfset bomid = rowguid>	
				
			</cfif>
			
			<cfquery name="insertBOM"
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ItemBOM
						(BOMId, 
						 Mission, 
						 ItemNo, 
						 UoM, 
						 DateEffective, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName )
					VALUES
						('#BOMid#',
						 '#getBOM.Mission#',
						 '#itemno#',
						 '#uom#',
						 #dte#,
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#')								
			</cfquery>	
			
			<cfloop from="0" to="#Form.boxnumbers-1#" index="n">				
	
					<cftry>
						<cfset vDisplay = Evaluate("FORM.IDISPLAY#n#")>
					<cfcatch>
						<cfset vDisplay = 0>
					</cfcatch>		
					</cftry>				
				
				<cfif vDisplay eq 1>
		
					<cfset vMaterialItemNo    = Evaluate("FORM.ItemNo#n#")>
					<cfset vMaterialUoM       = Evaluate("FORM.UoM#n#")>
					<cfset vMaterialMemo      = Evaluate("FORM.ItemMemo#n#")>
					<cfset qty 			      = replace(Evaluate("FORM.ItemQuantity#n#"),",","","ALL")>
					<cfset cst             	  = replace(Evaluate("FORM.ItemCost#n#"),",","","ALL")>
					<cfset vMaterialReference = replace(Evaluate("FORM.ItemReference#n#"),",","","ALL")>
					
					<cfquery name="qCheckDetails"
							datasource="appsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   ItemBOMDetail
							WHERE  BOMId          = '#BOMid#'
							AND    MaterialItemNo = '#vMaterialItemNo#'
							AND    MaterialUoM    = '#vMaterialUoM#'
						</cfquery>				

						<cfif qCheckDetails.recordcount eq 0>
																			
							<cfquery name="InsertBOM"
								datasource="appsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">				
								INSERT INTO ItemBOMDetail
							           	(BOMId,		          
							           	MaterialItemNo,
							           	MaterialUoM,
							           	MaterialQuantity,
										MaterialCost,		
										MaterialReference,							
							           	MaterialMemo,
							           	OfficerUserId,
							           	OfficerLastName,
							           	OfficerFirstName)
						     	VALUES ('#BOMid#',		           
							           	'#vMaterialItemNo#',
							           	'#vMaterialUoM#',
							           	'#qty#',
										'#cst#',	
										'#Left(vMaterialReference,10)#',													
										'#Left(vMaterialMemo,100)#',
							           	'#SESSION.acc#',			   
							           	'#SESSION.first#',
							           	'#SESSION.last#')
							</cfquery>	
							
						<cfelse>
						
								<script language="JavaScript">
									alert('Bom detail already exists');
								</script>
							
						</cfif>	
				
				</cfif>
			
			</cfloop>				
		
		</cfloop>
		
		</cftransaction>

		<cfoutput>
			<script>
				try { ProsisUI.closeWindow('bomform',true)} catch(e){};
				ptoken.navigate('UoMBOM/ItemUoMBOM.cfm?ID=#URL.ID#&UoM=#URL.UoM#&Selected=#FORM.mission#','itemUoMBOM');
			</script>
		</cfoutput>
		
</cfcase>

</cfswitch>
