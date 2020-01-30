
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
		        '#Form.Mission#',
			    '#Form.StandardCost#', 
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')				
	</cfquery>

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