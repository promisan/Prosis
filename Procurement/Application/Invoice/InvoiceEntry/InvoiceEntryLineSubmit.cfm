
<cfparam name="url.tax" default="0">
<cfparam name="url.action" default="">
<cfset table = "stInvoiceIncomingLine">

<cfoutput>
	
	<cfparam name="Form.linedescription" default="">
	<cfparam name="Form.linereference" default="">
	<cfparam name="Form.lineamount" default="0">
	<cfparam name="Form.invoicelineid" default="">
		
	<cfset amt        = replace("#Form.lineamount#",",","")>
	<cfset des         = "#Form.linedescription#">
	<cfset ref         = "#Form.linereference#">
		
	<cfif not LSIsNumeric(amt)>
	
		<script>
			<cf_tl id="Incorrect amount" var="1">
		    alert('#lt_text#');
			ColdFusion.navigate('InvoiceEntryLine.cfm?myform=#url.myform#&tax=#url.tax#&mission=#url.mission#&ID=#URL.ID#&ID2=new','linedetail')		
		</script>	 
		
		<cfabort>
	
	</cfif>
	
	<cfif action eq "delete">
	
		<cfquery name="Delete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM #table# 
			WHERE  InvoiceLineId = '#URL.Id2#' 
		</cfquery>
			
	<cfelseif URL.ID2 neq "new">
			
		<cfquery name="update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">   
		    UPDATE #table# 
			SET    LineDescription = '#des#',
				   LineReference   = '#ref#',
				   LineAmount      = '#amt#'				
			WHERE  InvoiceId = '#URL.Id#'
			AND    InvoiceLineId = '#URL.ID2#'			
		</cfquery>	
		
	<cfelse>
	
		<cfquery name="Total" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM #table#
		</cfquery>
		
		<cfif total.recordcount eq "0">
		  	<cfset No = "1">
		<cfelse>
			<cfset No = total.recordcount+1>		
		</cfif>
	
		<cfquery name="insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">

		    INSERT INTO #table# (			
			 InvoiceId,
			 InvoiceLineId,
			 InvoiceLineNo,
			 LineDescription,
			 LineReference,
			 LineAmount )						
			VALUES (				
			    '#url.id#',
				'#form.invoicelineid#',
				'#no#',
				'#des#',
				'#ref#',
				'#amt#'	)
							
		</cfquery>	
					
	</cfif>
	
	<cfquery name="Total" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		
		    SELECT SUM(LineAmount) as Total 
			FROM   #table#			
			WHERE  InvoiceId = '#URL.Id#'
			
    </cfquery>	
		
	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT  *
		FROM    Ref_ParameterMission
		WHERE   Mission  = '#url.mission#'	
	 </cfquery>
	 
	<cfif total.total neq "">
	     
		<script>
			document.getElementById("documentamount").className = "hide"	
			document.getElementById("documentamount").value = "#total.total#"		
		</script>
		
		<table width="100" style="border:1px solid silver" cellspacing="0" cellpadding="0" align="left">
			<tr><td width="120" style="padding-right:3px" height="23" class="labelmedium" align="right" bgcolor="ffffcf">#numberformat(total.total,"__,__.__")#</td></tr>
		</table>
		   
    <cfelse>

	   <script>	  
			document.getElementById("documentamount").className = "regularxl"
		</script>

    </cfif>
			
	<script>	  
		ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceEntryLine.cfm?myform=#url.myform#&tax=#url.tax#&mission=#url.mission#&ID=#URL.ID#&ID2=new','linedetail') 		
	</script>		
	
	<cfif Parameter.TaxExemption eq "0">
	 			
		<cfif Parameter.InvoiceRequisition eq "0"> 
		
			<script>		  
				try { tagging('#total.total#') } catch(e) {}
								
				if (document.getElementById('payable')) {
				     ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoicePayable.cfm?documentamount=#total.total#&tax=#url.tax#&tag=','payable')
				   }							
			</script>
			
		<cfelse>
		
			<script>	
							 	  
				try { tagging('#total.total#') } catch(e) {}
												
				if (document.getElementById('payable')) {					 
				     ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoicePayable.cfm?documentamount=#total.total#&tax=#url.tax#&tag=','payable')
				   }			
				
			</script>
		
			
		</cfif>
		
	<cfelse>	
			
		<cfif Parameter.InvoiceRequisition eq "0"> 			
			<script>		  
				ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceExemption.cfm?documentamount=#total.total#&tax=#url.tax#&tag=no','exemption')
			</script>
		<cfelse>
			<script>		  
				ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceExemption.cfm?documentamount=#total.total#&tax=#url.tax#&tag=no','exemption')
			</script>
		</cfif>
	
	</cfif>	
	
</cfoutput>
 	

  
