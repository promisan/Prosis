
<cfparam name="url.print"            default="0">
<cfparam name="url.accessmode"       default="view">
<cfparam name="url.systemfunctionid" default="">

<cfquery name="get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   ItemTransaction
	WHERE  TransactionId = '#url.drillid#'	
</cfquery>

<!--- we only only issuances that are not POS sales to be changed here --->

<cfif get.TransactionType eq "2" or get.TransactionType eq "9">

   <cfquery name="bat" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WarehouseBatch
			WHERE  BatchNo = '#get.TransactionBatchNo#'			
		</cfquery>
							
	<cfif (findNoCase("Issuance",bat.Batchdescription) or get.TransactionType eq "9") and isValid("GUID","#url.systemfunctionid#")>
	
		<cfinvoke component = "Service.Access"  
	     method             = "WarehouseProcessor"  
		 role               = "'WhsPick'"
		 mission            = "#get.mission#"
		 warehouse          = "#get.warehouse#"		
		 SystemFunctionId   = "#url.SystemFunctionId#" 
		 returnvariable     = "grantedaccess">	 	
		 
	<cfelse>
	
		<cfset grantedaccess = "NONE">	
			 
	</cfif>
						
<cfelse>
	
	<cfset grantedaccess = "NONE">	
		
</cfif>	

<!--- access, request as edit, and not cleared yet --->

<cfif grantedaccess eq "ALL" and url.accessmode eq "Process" and get.actionStatus eq "0">

	<!--- alright --->
	
	<cfset url.accessmode = "Edit">

<cfelse>

	<cfset url.accessmode = "View">

</cfif>

<cfif url.print eq "0">
	  <cf_screentop height="100%" title="Stock Transaction" label="Stock Transaction" jquery="Yes" html="yes" scroll="no" layout="webapp" banner="gray" line="no"> 
	  <cfset pad = "2">
<cfelse>  
	  <cf_screentop height="100%" label="Stock Transaction" html="no" scroll="No" layout="webapp" banner="yellow">
	  <cfset pad = "1">
</cfif>

<cfoutput>

<script language="JavaScript">

 function doit(action) {    	
    
		if (confirm("Do you want to update this transaction ?")) {	
        ColdFusion.navigate('TransactionSubmit.cfm?action='+action+'&drillid=#get.transactionid#&systemfunctionid=#url.systemfunctionid#','process','','','POST','transactionform')
		}	
  }	 
    
 function printme(id) { 
		window.open("TransactionView.cfm?print=1&drillid="+id,"print","width=800,height=600,status=yes,toolbar=no,scrollbars=no,resizable=yes") 
  }
 
</script>

</cfoutput>

<!--- we load this only once --->
    
<cfajaximport tags="cfform,cfdiv,cfwindow">	
<cf_dialogProcurement>
<cf_dialogLedger>
<cf_dialogAsset>
<cf_dialogMaterial>
<cf_dialogworkorder>
<cf_dialogStaffing>

<cf_divscroll>

<table width="100%" height="99%">
	<tr><td>		
						
			<cfif url.print eq "0">
					
				<form name="transactionform" id="transactionform" style="height:100%">
				
				<table width="100%" height="100%">
				<tr><td valign="top" height="100%" id="main">
						
					<cfinclude template="TransactionViewDetail.cfm">		
						
				</td></tr>
				</table>
				
				</form>		
				
			
			<cfelse>
			
				<cfinclude template="TransactionViewDetail.cfm">
				<script>
				  window.print()
			    </script>
			
			</cfif>
		
	
	</td></tr>
</table>

</cf_divscroll>

