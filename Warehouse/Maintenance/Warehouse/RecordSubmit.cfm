
<cfset form.warehouse = replace(form.warehouse, ".", "", "ALL")>
<cfset form.warehouse = replace(form.warehouse, ",", "", "ALL")>
<cfset form.warehouse = replace(form.warehouse, " ", "", "ALL")>

<cf_tl id = "You must associate this warehouse to an organization unit!" var="msg1">
<cf_tl id = "A warehouse with this code has been registered already!"    var="msg2">
<cf_tl id = "Warehouse is in use. Operation aborted."                    var="msg3">

<!--- <cfif ParameterExists(Form.Insert)>  --->

<cfif not isDefined("url.id1") >

	<cfif form.orgunit1 eq "">
	
	   <cfoutput>
	   <script language="JavaScript">
	     alert("#msg1#")
		 history.back()
	   </script>  
	   </cfoutput>
	   <cfabort>
	
	</cfif>
	
	<cfset whs = replace("#Form.Warehouse#"," ","","ALL")>
	
	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Warehouse
		WHERE   Warehouse = '#whs#' 
	</cfquery>
	
	<cfif Verify.recordCount is 1>
	
	   	   <cfoutput>
		   <script language="JavaScript">
		     alert("#msg2#")
			 history.back()
		   </script> 
		   </cfoutput> 
	  
	<cfelse>
		           
		<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Organization
			WHERE  OrgUnit = '#Form.OrgUnit1#'
		</cfquery>
		
		<cfif Org.recordcount eq "0">	
		
		 <cfoutput>
		   <script language="JavaScript">
		     alert("#msg1#")
			 history.back()
		   </script>  
		   </cfoutput>
		   <cfabort>	
		
		</cfif>
		
		<cfparam name="Form.WarehouseDefault" default="0">
		<cfparam name="Form.Distribution" default="0">
		<cfparam name="Form.TaskingMode"  default="0">
		<cfparam name="Form.LocationId"   default="">
		
		<cftransaction>
		           
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Warehouse
			        (Warehouse,
					 WarehouseName, 
					 LocationReceipt,
					 WarehouseClass,
					 <cfif Form.LocationId neq "">LocationId,</cfif>			 
					 Country,
					 Address,
					 City,
					 Telephone, 
			         Fax, 
					 <cfif Form.supplyWarehouse neq "">
					 SupplyWarehouse,
					 </cfif>				
					 TaskingMode,
					 ModeSetItem,
					 SaleMode,
					 SaleCurrency,
					 <cfif trim('Form.SaleBackground') neq "">SaleBackground,</cfif>
					 Mission,
					 MissionOrgUnitId,
					 Latitude,
					 Longitude,
					 WarehouseDefault,
					 Distribution,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#whs#', 
			          '#Form.WarehouseName#',
					  '#Form.LocationReceipt#',
					  <cfif FORM.WarehouseClass neq "">'#Form.WarehouseClass#',<cfelse>NULL,</cfif>
					  <cfif Form.LocationId neq "">'#Form.LocationId#',</cfif>
					  '#Form.Country#',
					  '#Form.Address#',
					  '#Form.AddressCity#',
			          '#Form.Telephone#', 
			          '#Form.Fax#', 
					  <cfif Form.supplyWarehouse neq "">
					   '#Form.SupplyWarehouse#',
					  </cfif>
					  '#Form.TaskingMode#',
					  '#Form.ModeSetItem#',
					  '#Form.SaleMode#',
					  '#Form.SaleCurrency#',
					  <cfif trim('Form.SaleBackground') neq "">'#Form.SaleBackground#',</cfif>
					  '#Form.Mission#',
			          '#Org.MissionOrgUnitId#',
					  '#form.cLatitude#',
					  '#form.cLongitude#',
			          '#Form.WarehouseDefault#',
					  '#Form.Distribution#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	     action="Insert"
	  	 datasource="appsMaterials" 	 
		 content="#form#">			
		
		<!--- check location --->
		
		<cfif Form.LocationReceipt neq "">
		
			<cfquery name="Check" 
			   datasource="appsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   SELECT * FROM WarehouseLocation 
				   WHERE Location  = '#Form.LocationReceipt#'
				   AND   Warehouse = '#whs#'
			</cfquery>
		
		   <cfif Check.recordCount is 0>
		
		      <cfquery name="Insert" 
		       datasource="appsMaterials" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
			       INSERT INTO WarehouseLocation (Warehouse, Location, Description, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
			       VALUES ('#whs#', '#Form.LocationReceipt#', 'Receipt Location', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
		      </cfquery>
		
		   </cfif>
		   
		</cfif>  
		
		</cftransaction> 
		  
	</cfif>

<!--- </cfif>

<cfif ParameterExists(Form.Update)> --->

<cfelse>

<cfset whs = replace("#Form.Warehouse#"," ","","ALL")>

<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Organization
		WHERE OrgUnit = '#Form.OrgUnit1#'
</cfquery>

<cfif Org.recordcount eq "0">	
	
	 <cfoutput>
	   <script language="JavaScript">
	     alert("#msg1#")
		 history.back()
	   </script>  
	   </cfoutput>
	   <cfabort>	
	
	</cfif>

<cfparam name="Form.WarehouseDefault" default="0">

<cfif form.warehousedefault eq "1">
	
	<cfquery name="get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Warehouse	
		WHERE Warehouse = '#Form.WarehouseOld#'
	</cfquery>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Warehouse
		SET    WarehouseDefault = 0
		WHERE  Mission = '#get.Mission#'
	</cfquery>	
	
</cfif>

<cfparam name="Form.Distribution" default = "0">
<cfparam name="Form.LocationId"   default = "">
<cfparam name="Form.Operational"  default = "0">
<cfparam name="Form.TaskingMode"  default = "0">

<cftransaction>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Warehouse
		SET    Warehouse            = '#whs#',
		       LocationReceipt      = '#Form.LocationReceipt#',
		       WarehouseName        = '#Form.WarehouseName#', 
			   Country              = '#Form.Country#',
		       Address              = '#Form.Address#',
			   City                 = '#Form.AddressCity#',
			   Fax                  = '#Form.Fax#',
			   Contact              = '#Form.Contact#',
			   eMailAddress         = '#Form.eMailAddress#',
			   Telephone            = '#Form.Telephone#',
		       MissionOrgUnitId     = '#Org.MissionOrgUnitId#',
			   Latitude             = '#Form.cLatitude#',
			   Longitude            = '#Form.cLongitude#', 
			   SaleMode             = '#Form.SaleMode#',
			   SaleCurrency         = '#Form.SaleCurrency#',
			   SaleDiscount         = '#Form.SaleDiscount#',
			   SaleBackground		= <cfif trim('Form.SaleBackground') neq "">'#Form.SaleBackground#'<cfelse>NULL</cfif>,
			   TimeZone             = '#Form.TimeZone#',
			   Operational          = '#Form.Operational#',
			   ModeInitialStock     = '#Form.ModeInitialStock#',
			   WarehouseDefault     = '#Form.WarehouseDefault#',
			   ModeSetItem          = '#Form.ModeSetItem#',
			   TaskingMode          = '#Form.TaskingMode#',
			   Distribution         = '#Form.Distribution#',
			   WarehouseClass       = <cfif FORM.WarehouseClass neq "">'#Form.WarehouseClass#'<cfelse>NULL</cfif>,
			   LocationId           = <cfif Form.LocationId neq "">'#Form.LocationId#'<cfelse>NULL</cfif>, 
			   <cfif Form.SupplyWarehouse neq "">
			   SupplyWarehouse      = '#Form.SupplyWarehouse#'
			   <cfelse>
			   SupplyWarehouse      = NULL
			   </cfif>
		WHERE  Warehouse   = '#Form.WarehouseOld#'
	</cfquery>

	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	 datasource = "appsMaterials"
     action="Update"
	 content="#form#">		
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(Form.DateEffective,CLIENT.DateFormatShow)#">
	<cfset ZSTR = dateValue>
	
	<cfquery name="check" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   WarehouseTimeZone	
		WHERE  Warehouse     = '#Form.WarehouseOld#'
		AND    DateEffective = #ZSTR#
	</cfquery>
	
	<cfif check.recordcount eq "1">
	
		<cfquery name="check" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WarehouseTimeZone	
			SET    TimeZone      = '#Form.TimeZone#'
			WHERE  Warehouse     = '#Form.WarehouseOld#'
			AND    DateEffective = #ZSTR#
		</cfquery>
		
	<cfelse>
	
		<cfquery name="insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO WarehouseTimeZone	
			
					(Warehouse,
					 DateEffective,
					 TimeZone,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				 
			VALUES
			
					('#Form.WarehouseOld#',
					 #ZSTR#,
					 '#Form.TimeZone#',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')				 
			
		</cfquery>
	
	
	</cfif>
	
	<!--- check location --->
	
	<cfif Form.LocationReceipt neq "">
	
	   <cfquery name="Check" 
	   datasource="appsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   WarehouseLocation 
	      WHERE  Location  = '#Form.LocationReceipt#'
	      AND    Warehouse = '#whs#'
	   </cfquery>
	
	   <cfif Check.recordCount is 0>
	
	         <cfquery name="Insert" 
		       datasource="appsMaterials" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
			       INSERT INTO WarehouseLocation (Warehouse, Location, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
			       VALUES ('#whs#', '#Form.LocationReceipt#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
		      </cfquery>
	
	   </cfif>
	</cfif>   

</cftransaction>

</cfif>

<!--- <cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="appsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT    *
	     FROM      ItemWarehouse
	     WHERE     Warehouse  = '#Form.WarehouseOld#'
	</cfquery>

    <cfif CountRec.recordCount gt 0>
		 <cfoutput>
	     <script language="JavaScript">
	         alert("#msg3#")
	      </script>
		  </cfoutput>  
	 	 
    <cfelse>
		
		<cfquery name="Delete" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Warehouse 
				WHERE  Warehouse  = '#Form.WarehouseOld#'
	    </cfquery>
		

		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	     action="Delete"
		 content="#form#">			
			
		
    </cfif>	
	
</cfif>	 --->
	
<script language="JavaScript">   
     parent.window.close();
	 opener.history.go();      
</script>  
	
