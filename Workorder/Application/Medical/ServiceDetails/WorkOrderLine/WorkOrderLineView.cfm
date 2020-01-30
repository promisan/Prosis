
<cfparam name="url.date" default="#dateformat(now(),client.dateformatshow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<!--- consistency check, maybe later moved to tool --->

<cfquery name="reset1" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	UPDATE   WorkOrderLineCharge
	SET      Journal         = NULL, 
	         JournalSerialNo = NULL
	FROM     WorkOrderLineCharge C
	WHERE    Journal IS NOT NULL
	AND      NOT EXISTS
                          (SELECT    'X'
                           FROM      Accounting.dbo.TransactionHeader
                           WHERE     Journal         = C.Journal 
						   AND       JournalSerialNo = C.JournalSerialNo)
							
</cfquery>
			
<cfquery name="reset2" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
								
	UPDATE WorkOrderLine
	SET    ActionStatus       = '1'
	FROM   WorkOrderLine WL, WorkOrderLineCharge WLC
	WHERE  WL.WorkOrderid     = WLC.WorkOrderId
	AND    WL.WorkOrderLine   = WLC.WorkorderLine
	AND    WLC.Journal is NULL			
				
</cfquery>	

<cfquery name="getwol" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM 	WorkOrderLine
		WHERE 	WorkOrderLineId = '#url.drillid#'
</cfquery>
		
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *, 
				 C.PersonNo      as CustomerPersonNo, 
				 WL.ActionStatus as BillingStatus
		FROM     WorkOrderLine WL INNER JOIN
		         WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		         Customer C ON W.CustomerId = C.CustomerId
		WHERE    WorkOrderLineId = '#url.drillid#'		
		AND      WL.Operational  = 1
</cfquery>	

<cfquery name="getHeader" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 WLA.*, 
				 C.PersonNo      as CustomerPersonNo, 
				 WL.ActionStatus as BillingStatus
		FROM     WorkOrderLine WL INNER JOIN
		         WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		         Customer C ON W.CustomerId = C.CustomerId
		         INNER JOIN 
		         WorkORderLineAction as WLA
		         ON WL.WorkOrderLine = WLA.WorkORderLine
		         AND WL.WorkOrderId = WLA.WorkOrderId
			     AND ActionClass = 'Contact'
			     AND WLA.ActionStatus !='9' 

		WHERE    WorkOrderLineId = '#url.drillid#'		
		AND      WL.Operational  = 1
		ORDER BY WLA.DateTimePlanning
</cfquery>	

<cfif get.recordcount eq "0">
	
	<table align="center"><tr><td class="labellarge" style="font-size:25px;padding-top:70px"><font color="808080"><cf_tl id="Record has been removed"></td></tr></table>
	<cfabort>

</cfif>

<cf_tl id="Print" var="vLabelPrint">
<cf_tl id="Edit"  var="vLabelForm">

<cf_screentop 
	label="#dateformat(getHeader.DateTimePlanning,client.dateformatshow)# #get.CustomerName# #get.mission#" 
	height="100%" 
	jQuery="Yes"	
	banner="blue"
	layout="webapp" 	
	scroll="No" 
	html="no">
		
	<cf_layoutscript>	
	<cf_CalendarScript>
	<cf_listingscript>			
	<cf_actionListingScript>
	<cf_FileLibraryScript>
	<cf_picturescript>
	<cf_KeyPadScript>
	<cf_dialogSettlement>
	<cf_dialogMaterial>
	<cf_dialogWorkOrder>
	<cf_dialogOrganization>
	<cf_DialogSystem>
	<cf_DialogLedger>
	<cf_DialogStaffing>
	
	<cfajaximport tags="cfform,cfdiv,cfwindow">
	<cf_textareascript>
		
	<script language="JavaScript">
	
	 function scrollbottom() {	 
	    $('#myContainer').animate({ scrollTop: 1000 }, 350);     
		// $('html, body').animate({ scrollTop: $(document).height() }, 'slow');		
	 }	
	
	 function lineopen(wlid) { 	   
	    Prosis.busy('yes') 
		ptoken.open('WorkOrderLineView.cfm?drillid='+wlid,'_self') 
	 }
	 
	 function addsupply(mis,wid,lid) {  	   
	    ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Stock/Transaction/TransactionInit.cfm?mode=workorder&mission="+mis+"&workorderid="+wid+"&workorderline="+lid,"workorder","left=20, top=20, width=960,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")	 	
	}
	
	function lineactionrefresh(wid,wli) {	   
		<cfoutput>	
		_cf_loadingtexthtml="";		
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/WorkActionListing.cfm?WorkOrderId='+wid+'&workorderline='+wli,'actioncontent')		
		</cfoutput>
	}	
	 
	function workflowaction(key,box) {	
		  
	    se = document.getElementById(box)
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {		
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "hide"				   
		   ptoken.navigate('<cfoutput>#session.root#</cfoutput>/workorder/application/workorder/servicedetails/action/WorkActionWorkflow.cfm?ajaxid='+key,key)		   
		   
		   
		} else {se.className = "hide"
		        ex.className = "regular"				
		   	    co.className = "hide" 
	    } 		
		
	}		
	
	 function settlementview(wol,org,dte,box) {
  	     _cf_loadingtexthtml="";
		 ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/Medical/ServiceDetails/WorkOrderLine/WorkOrderLineSettlement.cfm?workorderlineid='+wol+'&transactiondate='+dte+'&orgunitowner='+org,box+'_settlement');					
	 }		
		
	 function dosettlement(wol,own,dte,stme) {	 
	     try { ColdFusion.Window.destroy('wsettle',true)} catch(e){};
	     ColdFusion.Window.create('wsettle', 'Settlement', '',{x:100,y:100,width:870,height:670,resizable:false,modal:false,center:true})		
		 ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/Settlement/SettleView.cfm?workorderlineid='+wol+'&orgunitowner='+own+'&transactiondate='+dte+'&transactiontime='+stme,'wsettle');	
	 }		 
	 
	 function settlementlineadd(wol,org,ter,dte, stme) {
	
         _cf_loadingtexthtml="";	 
		 val = document.getElementById("line_amount_number").value				
		 if (val + 0 != 0) {			   					    							   
	    	ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/Settlement/SettlementUpdate.cfm?workorderlineid='+wol+'&orgunitowner='+org+'&transactiondate='+dte+'&transactiontime='+stme+'&terminal='+ter,'dlines','','','POST','salesdetails');			
		 } else {
			 alert('Please enter an amount');
			 document.getElementById('line_amount_number').setfocus()
		 }			
	}	
	
	function settlementlinedelete(id,wol,org,ter,dte,stme) {
	    _cf_loadingtexthtml="";
		ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/Settlement/SettlementDelete.cfm?settleid='+id+'&workorderlineid='+wol+'&orgunitowner='+org+'&terminal='+ter+'&transactiondate='+dte+'&transactiontime='+stme,'dlines');				
	}

	function printForm(journal, journalserialno) {
		try { ColdFusion.Window.destroy('wPrintForm',true)} catch(e){};
       	ColdFusion.Window.create('wPrintForm', '<cfoutput>#vLabelPrint#</cfoutput>', '',{x:100,y:100,width:600,height:200,resizable:false,modal:true,center:true})		
	   	ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/medical/servicedetails/workorderline/PrintForm.cfm?journal='+journal+'&journalserialno='+journalserialno,'wPrintForm');	
	}

	function printFormSelected(journal, journalserialno,serviceitem) {
		try { ColdFusion.Window.destroy('wPrintForm',true)} catch(e){};
       	ColdFusion.Window.create('wPrintForm', '<cfoutput>#vLabelPrint#</cfoutput>', '',{x:100,y:100,width:600,height:200,resizable:false,modal:true,center:true})		
	   	ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/medical/servicedetails/workorderline/PrintForm.cfm?journal='+journal+'&journalserialno='+journalserialno+'&serviceselected='+serviceitem,'wPrintForm');	
	}

	function doPrintFormat(journal, journalserialno, documentid, template) {
		ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/"+template+"?journal="+journal+"&journalserialno="+journalserialno+"&printdocumentid="+documentid,"doPrintFormat","left=100, top=100, width=500, height=500, status=no, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	
	function editForm(wli) {
	   	try { ColdFusion.Window.destroy('wEditForm',true)} catch(e){};
       	ColdFusion.Window.create('wEditForm', '<cfoutput>#vLabelForm#</cfoutput>', '',{x:100,y:100,width:600,height:400,resizable:false,modal:true,center:true})		
	   	ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/WorkOrder/Application/Medical/ServiceDetails/WorkOrderLine/WorkOrderLineEdit.cfm?workorderlineid='+wli,'wEditForm');		
	}
			  
	</script>	
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
			<cf_ViewTopMenu label="#dateformat(getHeader.DateTimePlanning,client.dateformatshow)# #get.CustomerName# #get.mission#" menuaccess="context" background="blue" systemModule="WorkOrder">
						 			  
	</cf_layoutarea>	
	
	<cf_layoutarea position="center" name="box">				
						
		<cf_divscroll style="height:99%">
		
		<table width="100%">
				
			<tr class="hide"><td id="process"></td></tr>				
				
			<tr><td style="padding-left:1px;padding-right:1px" id="boxappdetail">			
			<cfset url.id = get.CustomerPersonNo>
			<cfinclude template="../../../../../Roster/Candidate/Details/Applicant/ApplicantDetail.cfm">				
			</td></tr>			
			<tr><td>		
		    <cfdiv id="myContainer" bind="url:WorkOrderLineViewContent.cfm?drillid=#url.drillid#">				
			</td></tr>
			
		</table>			
					
		</cf_divscroll>				
									
	</cf_layoutarea>		
	
	<cf_layoutarea 
		    position    = "left" 
			name        = "contentbox" 
			maxsize     = "400" 		
			size        = "16%" 		
			minsize     = "290"
			initcollapsed = "true"
			collapsible = "true" 
			splitter    = "true"
			overflow    = "scroll">
									
			<cf_divscroll style="padding:5px;height:99%">
			     <table><tr><td style="padding:5px">
				<cf_compositiontreedata mission="#get.mission#" ajax="No">		
				</td></tr></table>
			</cf_divscroll>
						
						
	</cf_layoutarea>		
	
		
	<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM    OrganizationObject    
    	WHERE   EntityCode = 'Candidate' 
		AND     ObjectKeyValue1 = '#url.id#' 
		AND     Operational = '1'
	</cfquery>	
					
	<cf_wfactive objectId="#Check.ObjectId#">	
					
	<cfif wfexist eq "1">
	  
		<cf_layoutarea 
		    position    = "right" 
			name        = "commentbox" 
			maxsize     = "500" 		
			size        = "25%" 		
			minsize     = "360"
			initcollapsed = "true"
			collapsible = "true" 
			splitter    = "true"
			overflow    = "scroll">
							
			<cf_divscroll style="height:99%">
				<cf_commentlisting objectid="#Check.ObjectId#"  ajax="No">		
			</cf_divscroll>
																	
		</cf_layoutarea>	
	
	</cfif>
				
</cf_layout>	

