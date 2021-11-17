
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfparam name="URL.Mode"   default="view">
<cfparam name="URL.Header" default="Yes">

<cfif url.mode eq "" or (url.mode neq "edit" and url.mode neq "add")>
   <cfset url.mode = "view">   
</cfif>

<!--- End Prosis template framework --->
		
<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort"    default="line">
<cfparam name="URL.View"    default="Hide">
<cfparam name="URL.Lay"     default="Reference">
<cfif url.mode eq "undefined">
  <cfset url.mode = "view">
</cfif>
<cfparam name="URL.Role"    default="">

<cf_tl id="Memo" var="1">
<cfset vMemo="#lt_text#">

<cf_tl id="Approval History" var="1">
<cfset vHistory="#lt_text#">

<cf_tl id="Received Invoices" var="1">
<cfset vReceived="#lt_text#">

<cf_tl id="Purchase Order" var="1"> 

 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase P
		WHERE  PurchaseNo ='#URL.Id1#'
		AND    PurchaseNo IN (SELECT PurchaseNo 
		                      FROM   PurchaseLine
							  WHERE  PurchaseNo = P.PurchaseNo)
</cfquery>	

<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderClass
		WHERE  Code = '#PO.OrderClass#' 
</cfquery>

<cfquery name="PurchaseType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderType
		WHERE  Code = '#PO.OrderType#' 
</cfquery>	
	
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>
	
<cfquery name="Invoice" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      Invoice
		WHERE     InvoiceId IN (SELECT InvoiceId FROM InvoicePurchase WHERE PurchaseNO = '#URL.ID1#')
		AND       ActionStatus != '9'
		order by documentDate
</cfquery>  

<cfquery name="Receipt" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      PurchaseLineReceipt
		WHERE     RequisitionNo IN (SELECT RequisitionNo FROM PurchaseLine WHERE PurchaseNO = '#URL.ID1#')
		AND       ActionStatus != '9'		
</cfquery> 

<cfif PurchaseClass.PurchaseTemplate neq "">
   <cfset tmp = "#PurchaseClass.PurchaseTemplate#">
<cfelseif Parameter.PurchaseTemplate neq "">
   <cfset tmp = "#Parameter.PurchaseTemplate#"> 
<cfelse>
	<cfset tmp = "Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm">  
</cfif>

<cfoutput>

	<script>
	
	  function executionrequest(po,exe) {
			
		 se = document.getElementById('box'+exe);
		 if (se.className == 'hide') {
		    se.className = 'regular';
			ptoken.navigate('../ExecutionRequest/ViewDrill.cfm?mode=drill&purchaseno='+po+'&executionid='+exe,'c'+exe);
		 } else {
		   se.className = 'hide'; 
		 }
	 }
	 
	 function ask(status) {
	       
		de = document.getElementById("destination")					
	    if (status <= "1") { 
		    sel = "return this Obligation ?" 
		} else { 	     
		    sel = "Approve this Obligation ?" }		
		
		if (confirm("Do you want to "+sel))	{
			document.getElementById("fStatus").submit();		 
		}
			
	}	
	
	function validate(frm,box,target) {	  
	   document.getElementById(frm).onsubmit() 
	   if( _CF_error_messages.length == 0 ) {	           
		    ptoken.navigate(target,box,'','','POST',frm)
	     }   
    }	
		
	function reloadForm(mode,sort,head) {	    
	    
	    if (head == "undefined") {
		    header = 1
		} else { 
		    header = head
		}	
		
		ptoken.location('POView.cfm?header='+header+'&Mode=' + mode + '&role=#URL.Role#&ID1=#URL.ID1#&Sort='+sort) 
	}
	
	function amendpurchase() {	
		if (confirm("Do you want to amend and reset the status of this purchase order"))	{
		    Prosis.busy('yes')
			ptoken.navigate('setPOAmendment.cfm?header=#url.header#&role=#URL.Role#&Purchaseno=#URL.ID1#','amendbox')		 
		}	
	}
	
	function clonepurchase(po) {	
	if (confirm("Do you want to clone the lines of this purchase ?"))	{
		ptoken.navigate('#session.root#/Procurement/Application/PurchaseOrder/Purchase/applyCopyRequisition.cfm?purchaseNo='+po,'processrequisition')
	} 	
	}	
	
	function gettimesheet(po) {
   	    	
		w = document.body.clientWidth-50										
		ProsisUI.createWindow('timesheet', 'Timesheet', '#session.root#/Procurement/Application/PurchaseOrder/Timesheet/TimeSheet.cfm?purchaseno='+po,{x:30,y:30,height:document.body.clientHeight-50,width:w,resizable:false,modal:true,center:true});	
	}
			
	function more(bx,act,bx2) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
		se2   = document.getElementById(bx2)
			
		if (se.className=="hide") {
			se.className  = "regular";
			if (se2) { se2.className  = "regular"; }
			icM.className = "regular";
		    icE.className = "hide";
		} else	{
			se.className  = "hide";
			if (se2) { se2.className  = "hide"; }
		    icM.className = "hide";
		    icE.className = "regular";
		}
		}
			
		function clause(cl) {
		 	 w = #CLIENT.width# - 100;
			 h = #CLIENT.height# - 140;
		     ptoken.open("#session.root#/Procurement/Application/PurchaseOrder/Purchase/POViewClausePrint.cfm?PurchaseNo=#URL.ID1#&ClauseCode="+cl,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	  	}
										  
		function invadd(orgunit,po,personno) {	
		     ptoken.open("#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryView.cfm?html=yes&Mission=#PO.Mission#&Period=#PO.Period#&OrgUnit="+orgunit+"&PersonNo="+personno+"&PurchaseNo="+po,"_blank","width=1050, height=960, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");							   						 
		 }	
		 			
	</script>

</cfoutput>

<!--- check if the person has edit rights to the purchase order --->

<cfajaximport tags="cfform">

	<cf_DialogProcurement>
	<cf_DialogWorkOrder>
	<cf_dialogOrganization>
	<cf_dialogLedger>
	<cf_timesheetscript>
          		
	<cfquery name="Access" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT    *
	  FROM    PurchaseActor
	  WHERE   PurchaseNo = '#URL.ID1#'
	  AND     ActorUserId = '#SESSION.acc#'
	</cfquery>
	
	<cfif url.mode eq "View">	
				
		<cfif (Access.recordcount gte "1" or getAdministrator("#PO.Mission#") eq "1") and PO.ActionStatus lte "2">		
			<cfset url.mode = "Edit">			
		</cfif>	
		
	</cfif>
		
	<cfinvoke component="Service.Access"
	   Method         = "procApprover"
	   OrgUnit        = "#PO.OrgUnit#"
	   OrderClass     = "#PO.OrderClass#"
	   ReturnVariable = "ApprovalAccess">	
		   
	<cfif (ApprovalAccess eq "NONE" or ApprovalAccess eq "READ") and Access.recordcount eq "0">

		<cfset url.access = "View">

	</cfif>	   
	
	<cfif PO.recordcount eq "0">	
	  	   	
	   <cf_message message = "Order [#URL.ID1#] does not have any lines associated." return="no">
	    
	   <cfabort>
	   	
	</cfif>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObject
	WHERE  ObjectKeyValue1 = '#url.id1#'
	AND    Operational = 1
</cfquery>

<cf_verifyOperational        
         module    = "Procurement" 
		 Warning   = "No">	
		 
<cfif url.header eq "Yes" and Object.recordcount gte "1" and operational eq "1">

		<cf_screentop  
			    layout        = "webapp" 
				html          = "No" 
				label         = "#lt_text# #URL.Id1#" 		
				banner        = "gray" 
				bannerforce   = "Yes"
				scroll        = "No"	
				line          = "no"
				jQuery        = "Yes"
				systemmodule  = "Procurement"
				FunctionClass = "Window"
				FunctionName  = "PurchaseOrder"
				menuAccess    = "context"
				height        = "100%">
			  
		<cf_layoutscript>
		<cf_textareascript>
		
		<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  
				
		<cf_layout attributeCollection="#attrib#">

			<cf_layoutarea 
		          position="header"
				  size="50"
		          name="controltop">	
				  
				<cf_ViewTopMenu label="#lt_text# #URL.Id1#" menuaccess="context" background="gray">
						
			</cf_layoutarea>		 
		
			<cf_layoutarea  position="center" name="box">											
			     
				     <cfset url.header = "No"> 					
				     <cfinclude template="POViewGeneral.cfm">					
				 		
			</cf_layoutarea>	
						
			<cf_layoutarea 
				    position="right" 
					name="commentbox" 
					minsize="20%" 
					maxsize="30%" 
					size="380" 
					overflow="yes" 
					initcollapsed="yes"
					collapsible="true" 
					splitter="true">
				
					<cf_divscroll style="height:100%">
						<cf_commentlisting objectid="#Object.ObjectId#"  ajax="No">		
					</cf_divscroll>
					
			</cf_layoutarea>	
							
		</cf_layout>				
			  			  
<cfelse>		
			
		<cfif url.header eq "Yes">
				
			<cf_screentop  
			    layout        = "webapp" 
				html          = "#url.header#" 
				label         = "#lt_text# #URL.Id1#" 		
				banner        = "green" 
				bannerforce   = "Yes"
				scroll        = "No"	
				line          = "no"
				jQuery        = "Yes"
				systemmodule  = "Procurement"
				FunctionClass = "Window"
				FunctionName  = "PurchaseOrder"
				menuAccess    = "context"
				height        = "100%">
			
		<cfelse>
				
			<cf_screentop  
			    layout        = "webapp" 
				html          = "No" 
				label         = "#lt_text# #URL.Id1#" 		
				banner        = "green" 
				bannerforce   = "Yes"
				scroll        = "No"	
				line          = "no"
				jQuery        = "Yes"
				systemmodule  = "Procurement"
				FunctionClass = "Window"
				FunctionName  = "PurchaseOrder"	
				height        = "100%">
			
		</cfif>	
						
		<cf_divscroll style="height:98%">	
		    <cfset url.header = "no">	 
			<cfinclude template="POViewGeneral.cfm">
		</cf_divscroll>		  			  
			  
</cfif>	