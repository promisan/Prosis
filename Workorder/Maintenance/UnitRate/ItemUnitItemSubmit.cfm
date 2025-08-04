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
			parent.parent.ProsisUI.closeWindow('mydialog',true)	            
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
		parent.parent.ProsisUI.closeWindow('mydialog',true)	            
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
		parent.parent.ProsisUI.closeWindow('mydialog',true)	            
	</script> 
	</cfoutput>
	
</cfif>	 