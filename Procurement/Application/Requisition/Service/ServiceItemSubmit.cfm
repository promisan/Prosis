
<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   RequisitionLine	   
			   WHERE  RequisitionNo      = '#URL.ID#'			  	
</cfquery>

<cfif Check.recordcount eq "0">

		<script>
		    alert('Requisition no longer exists. Please create a new requisition.')						
		</script>	
		 
		<cfabort>

</cfif>

<cfoutput>

	<cfparam name="Form.Operational"    default="0">
	<cfparam name="Form.FieldName"      default="">
	<cfparam name="Form.svcquantity"    default="1">
	<cfparam name="Form.svcservicequantity" default="1">
	<cfparam name="Form.svcrate"        default="1">
	<cfparam name="Form.svcuom"         default="">	
	<cfparam name="Form.svceffective"   default="">
	<cfparam name="Form.svcexpiration"  default="">
	<cfparam name="Form.svcorgunit"     default="">
		
	<cfset svcqty      = replace("#Form.svcservicequantity#",",","")>
	<cfset qty         = replace("#Form.svcquantity#",",","")>
	<cfset rate        = replace("#Form.svcrate#",",","","ALL")>
	<cfset des         = "#Form.svcdescription#">
	<cfset ref         = "#Form.svcref#">
	<cfset uom         = "#Form.svcuom#">
	<cfset org         = "#Form.svcorgunit#">
		
	<cfif Form.svceffective neq "">
	    <CF_DateConvert Value="#Form.svceffective#">
		<cfset eff = dateValue>
	<cfelse>
	    <cfset eff = 'NULL'>
	</cfif>	
	
	<cfif Form.svcexpiration neq "">
	    <CF_DateConvert Value="#Form.svcexpiration#">
		<cfset exp = dateValue>
	<cfelse>
	    <cfset exp = 'NULL'>
	</cfif>	
	
	<cfif not isDate(eff) and form.svceffective neq "">
	
			<script>
			 	alert('Incorrect Effective Date')
			</script>	
			<cfabort>
			
	</cfif>
	
	<cfif not isDate(exp) and form.svcexpiration neq "">
	
			<script>
			 	alert('Incorrect Expiration Date')
			</script>	
			<cfabort>			
			
	</cfif>
	
	<cfif not LSIsNumeric(svcqty)>
	
		<script>
		    alert('Incorrect quantity')
		</script>	 		
		<cfabort>
	
	</cfif>
	
	<cfif not LSIsNumeric(qty)>
	
		<script>
		    alert('Incorrect quantity')
		</script>	
		<cfabort>
	
	</cfif>
	
	
	<cfif not LSIsNumeric(rate)>
	
		<script>
		    alert('Incorrect rate')
		</script>			
		<cfabort>
	
	</cfif>
	
	<cfif URL.ID2 neq "new">
	
		 <cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			   UPDATE RequisitionLineService 
			   SET    ServiceDescription = '#des#',
			          ServiceQuantity    = '#svcqty#',
			          UoM                = '#Uom#',
					  UoMRate            = '#rate#',
					  ServiceEffective   = #eff#,
					  ServiceExpiration  = #exp#,
					  <cfif svcorgunit eq "">
					  ServiceOrgUnit     = NULL,
					  <cfelse>
					  ServiceOrgUnit     = '#org#',
					  </cfif>
				      Quantity           = '#qty#',
					  PersonnelActionNo  = '#ref#'		   
			   WHERE  RequisitionNo      = '#URL.ID#'
			   AND    Serviceid          = '#URL.ID2#'		
	   	</cfquery>
			
	
	<cfelse>
			
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO RequisitionLineService 
			         (RequisitionNo,
					 ServiceDescription,
					 ServiceQuantity,
					 ServiceEffective,
					 ServiceExpiration,
					 ServiceOrgUnit,
					 UoM, 
					 UoMRate,
					 Quantity,
					 PersonnelActionNo)
			      VALUES ('#URL.ID#',
				          '#des#',
						  '#svcqty#',
						  #eff#,
						  #exp#,
						  <cfif svcorgunit eq "">NULL<cfelse>'#org#'</cfif>,
						  '#uom#',
						  '#Rate#',
						  '#qty#',
						  '#ref#')
			</cfquery>
		
					
	</cfif>
	
	<cfquery name="Total" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   SUM(ServiceQuantity * Quantity * UoMRate) AS Total
			 FROM     RequisitionLineService
			 WHERE    RequisitionNo      = '#URL.ID#'		 
	</cfquery>
	
	<cfquery name="Update" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   UPDATE RequisitionLine 
		   SET    RequestQuantity    = '1',
		          RequestCostPrice   = '#Total.Total#',
		          RequestAmountBase  = '#Total.Total#'  
		   WHERE  RequisitionNo      = '#URL.ID#'		  
	</cfquery>
	
	<cf_assignId>
	
	<cfsavecontent variable="content">
		    <cfinclude template="../Requisition/RequisitionEditLog.cfm">							
	</cfsavecontent>
				
	<cfquery name="InsertAction" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT  INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionId,
					  ActionStatus, 
					  ActionDate, 
					  ActionMemo,
					  ActionContent,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		     VALUES  (
			 		  '#URL.ID#', 
				      '#rowguid#',						 
					  '#Check.ActionStatus#',						
					  getdate(), 
					  'Update Amount to #numberFormat(Total.Total,",.__")#',
					  '#Content#',
					  '#SESSION.acc#', 
					  '#SESSION.last#', 
					  '#SESSION.first#'
					 )
	</cfquery>
	
	<cfquery name="Clean" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   DELETE RequisitionLineUnit		  
		   WHERE  RequisitionNo      = '#URL.ID#'		  
	</cfquery>
	
	<script>
	    		
		try { document.getElementById("requestquantity").value      = "1"			    			  		 
		      document.getElementById("requestcostprice").value     = "#Total.Total#"
			  document.getElementById("requestcurrencyprice").value = "#Total.Total#"				 
		} catch(e) { }
		base2('#url.id#','#Total.Total#','1')	
		tagging() 
		ColdFusion.navigate('#SESSION.root#/procurement/application/requisition/Service/ServiceItem.cfm?ID=#URL.ID#&access=edit&mode=#url.mode#','iservice') 

		<cfif url.id2 eq "new">
			ColdFusion.navigate('../Service/ServiceItemDialog.cfm?ID=#URL.ID#&ID2=new&access=edit&mode=#url.mode#','dialogservice')		
		<cfelse>
			ColdFusion.Window.hide('dialogservice')		
		</cfif>
		
	</script>		

</cfoutput>
 	

  
