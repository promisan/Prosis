<cfif URL.ResourceId eq "">

	<!---- adding it up ---->
	
	<cfquery name="qCheck" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM WorkOrderLineResource
		WHERE WorkOrderId  = '#URL.WorkOrderId#'
		AND WorkOrderLine  = '#URL.WorkOrderLine#'
		AND ResourceItemNo = '#FORM.ItemNo#'
		AND ResourceUoM    = '#FORM.UoM#'	 
	</cfquery>		

	<cfif qCheck.recordcount eq 0>
	
		<cf_AssignId>
		<cfset resourceid = rowguid>	
		
		<cfquery name="qAdd" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	 
		INSERT INTO WorkOrderLineResource
	           (ResourceId
	           ,WorkOrderId
	           ,WorkOrderLine
	           ,ResourceItemNo
	           ,ResourceUoM
	           ,ResourceMode
	           ,Quantity
	           ,Price
	           ,Memo
	           ,OfficerUserId
	           ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#resourceid#'
	           ,'#url.workorderid#'
	           ,'#url.workorderline#'
	           ,'#FORM.ItemNo#'
	           ,'#FORM.uom#'
	           ,'#FORM.ResourceMode#'
	           ,'#FORM.Quantity#'
	           ,'#FORM.Price#'
	           ,'#FORM.Remarks#'
	           ,'#SESSION.acc#'
	           ,'#SESSION.Last#'
	           ,'#SESSION.First#')
		</cfquery>		

		<script>
		    parent.applyfilter(1,'','content');
			parent.ColdFusion.Window.destroy('myservice',true)	
		</script>	

	<cfelse>

		<script>
			alert('Service class Item already exists for this workorder')
		</script>		
			
	</cfif>
	
</cfif>