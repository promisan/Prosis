<cf_compression>

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    RequisitionLine
		WHERE   RequisitionNo = '#URL.ID#' 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#'
</cfquery>

<cfparam name="form.Period" default="">
<cfparam name="form.OrgUnit1" default="">
<cfparam name="form.ItemMaster" default="">

<cfif form.period neq "" and form.OrgUnit1 neq "" and form.ItemMaster neq "">
	
	<cfif line.actionStatus gte "2" and Parameter.EnableRequisitionEdit eq "0">
	
		<cfif Parameter.EnableRequisitionEditMode neq "2">
			
			<cfif Form.Period neq Line.Period or
			          Form.OrgUnit1 neq Line.OrgUnit or
			          Form.ItemMaster neq Line.ItemMaster 
					  or Form.RequestDescription neq Line.RequestDescription>
				
				<font color="FF0000"><b><cf_tl id="Attention">:</b> <cf_tl id="Requisition will be sent back to requisitioner upon saving"></font>		    			  
		
			</cfif>		
		
		<cfelse>
		
			<cfif Form.Period neq Line.Period or
			          Form.OrgUnit1 neq Line.OrgUnit or
			          Form.ItemMaster neq Line.ItemMaster>
				
				<font color="FF0000"><b><cf_tl id="Attention">:</b> <cf_tl id="Requisition will be sent back to requisitioner upon saving"></font>		    			  
		
			</cfif>		
			
		</cfif>
	
	</cfif>		  

</cfif>   	