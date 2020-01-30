<cf_systemscript>

<cfquery name="verify" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM    ServiceItemUnitItem
	WHERE	ServiceItem = '#Form.serviceItem#'
	AND		Unit = '#Form.serviceItemUnit#'
	AND		ItemNo = '#Form.ItemNo#'
</cfquery>

<cfparam name="form.operational" default="0">


<cfif ParameterExists(Form.Save)>	
	
	<cfif verify.recordCount gt 0>
	
		<script language="JavaScript">alert("This item was already added to this service and unit.")</script>  
	
	<cfelse>

		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ServiceItemUnitItem (
		           ServiceItem,
		           Unit,
		           ItemNo,
		           Operational,
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		     VALUES ('#Form.serviceItem#',
		             '#Form.serviceItemUnit#',
		             '#Form.ItemNo#',
		             #Form.operational#,
				     '#SESSION.acc#',
				     '#SESSION.last#',
				     '#SESSION.first#')
		
		</cfquery>
		
		<cfoutput>
		<script language="JavaScript">   		    
		    parent.parent.showItemUnitRefresh('#Form.serviceItem#','#Form.serviceItemUnit#')
			parent.parent.ColdFusion.Window.destroy('mydialog',true)	            
		</script> 
	    </cfoutput>
		
	</cfif>
		  
</cfif>

<cfif ParameterExists(Form.Update)>	
	
	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	ServiceItemUnitItem
		SET    	Operational = #Form.operational#
		WHERE	ServiceItem = '#Form.serviceItem#'
		AND		Unit        = '#Form.serviceItemUnit#'
		AND		ItemNo      = '#Form.ItemNo#' 	
	</cfquery>
	
	<cfoutput>
	<script language="JavaScript">   		    
	    parent.parent.showItemUnitRefresh('#Form.serviceItem#','#Form.serviceItemUnit#')
		parent.parent.ColdFusion.Window.destroy('mydialog',true)	            
	</script> 
	</cfoutput>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  FROM ServiceItemUnitItem
		WHERE	ServiceItem = '#Form.serviceItem#'
		AND		Unit        = '#Form.serviceItemUnit#'
		AND		ItemNo      = '#Form.ItemNo#'
	</cfquery>	
	
	<cfoutput>
	<script language="JavaScript">   		    
	    parent.parent.showItemUnitRefresh('#Form.serviceItem#','#Form.serviceItemUnit#')
		parent.parent.ColdFusion.Window.destroy('mydialog',true)	            
	</script> 
	</cfoutput>
	
</cfif>	 