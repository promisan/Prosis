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

<!--- check if a master record exists for this item --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset dte = dateValue>

<cfparam name="url.children" default="false">

<cftransaction>

<!--- ---------------------------------------------------------------- --->
<!--- we apply this to the item itself and its potential BOMN children --->
<!--- ---------------------------------------------------------------- --->

<cfquery name="UoMList"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo         = '#URL.ItemNo#'
        AND      UoM            = '#URL.UoM#'
		
		<cfif url.children eq "true">
		UNION ALL
		
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo IN (SELECT ItemNo
		                    FROM   Item 
							WHERE  ParentItemNo = '#URL.ItemNo#')
		AND      UoM = '#URL.UoM#'		
		
		</cfif>
				    
</cfquery>

<cfloop query="UoMList">
	
	<cfquery name="checkBOM"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ItemBOM
			WHERE  Mission        = '#Form.mission#'
	        AND    ItemNo         = '#ItemNo#'
	        AND    UoM            = '#UoM#'
			AND    DateEffective  = #dte#      
	</cfquery>

	<cfif checkBOM.recordcount eq "1">
	
		<cfset bomid = checkBOM.BOMid>
		
		<!--- clean the details --->
		
		<cfquery name="clean"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM ItemBOMDetail
				WHERE  BOMId = '#bomid#'		    
		</cfquery>
	
	<cfelse>
	
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
	
	</cfif>
	
	<cfloop list="#FORM.chk_material#" index="materialid">
			
			<cfquery name="get"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   ItemBOMDetail
				WHERE  MaterialId = '#materialid#'		    
			</cfquery>
						
			<cfif get.recordcount eq "1">
								
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
			           	MaterialMemo,
			           	OfficerUserId,
			           	OfficerLastName,
			           	OfficerFirstName)
			     	VALUES
			           	('#BOMid#',		           
			           	'#get.MaterialitemNo#',
			           	'#get.MaterialUom#',
			           	'#get.MaterialQuantity#',
						'#get.MaterialCost#',
						'#get.MaterialMemo#',
			           	'#SESSION.acc#',			   
			           	'#SESSION.first#',
			           	'#SESSION.last#')
				</cfquery>		
			
			</cfif>
										
	</cfloop>	

</cfloop>

</cftransaction>	

<cfoutput>
	<script>
		try { ColdFusion.Window.destroy('bomform',true)} catch(e){};
		ColdFusion.navigate('UoMBOM/ItemUoMBOMListing.cfm?ID=#URL.ItemNo#&UoM=#URL.UoM#','itemUoMBOM');
	</script>
</cfoutput>
