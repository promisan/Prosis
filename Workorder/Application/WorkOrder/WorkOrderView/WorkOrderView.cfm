	
<cfparam name="URL.WorkorderId" default="7DE913BF-CB23-4401-ACB7-9D427D989FA7">
<cfparam name="url.idmenu" default="">
<cfparam name="url.systemfunctionid" default="#url.idmenu#">



<cf_calendarScript>

<cfoutput>

	<script>
	
	function deleteorder(id) {
	  ColdFusion.navigate('WorkOrderPurge.cfm?workorderid='+id,'action')
	}
	
	function billingsearch() {
	
	  se = document.getElementById("find")	 
	  if (window.event.keyCode == "13")
			{	document.getElementById("locate").click() }						
	  }
		
	function billingsearching(tabno,id,val)  {
	   ptoken.navigate('../Funding/BillingLine.cfm?tabno='+tabno+'&workorderid='+id+'&search='+val,'contentbox'+tabno)	
	}		
	
	function agreement(tabno,workorderid,transactionid) {	  	   	   
	   try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
	   ColdFusion.Window.create('mydialog', 'Agreement', '',{x:100,y:100,height:document.body.clientHeight-80,width:800,modal:true,resizable:false,center:true})    
	   ptoken.navigate('#SESSION.root#/Workorder/Application/WorkOrder/ServiceAgreement/Service.cfm?tabno='+tabno+'&workorderid='+workorderid+'&transactionid='+transactionid,'mydialog') 		   	  
	}
	
	function agreementrefresh(tabno,workorderid) {
	   ptoken.navigate('#SESSION.root#/workorder/Application/WorkOrder/ServiceAgreement/ServiceLine.cfm?tabno='+tabno+'&workorderid='+workorderid,'contentbox'+tabno)	 
	}  	
	
	function workflowevents(tabno,workorderid,workordereventid) {	 
   	   try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
	   ColdFusion.Window.create('mydialog', 'Agreement', '',{x:100,y:100,height:document.body.clientHeight-80,width:800,modal:true,resizable:false,center:true})    
	   ptoken.navigate('#SESSION.root#/Workorder/Application/WorkOrder/ServiceReview/Service.cfm?tabno='+tabno+'&workorderid='+workorderid+'&workordereventid='+workordereventid,'mydialog') 		   	  	  
	}		
	
	function workfloweventsrefresh(tabno,workorderid) {
	   ptoken.navigate('#SESSION.root#/workorder/Application/WorkOrder/ServiceReview/ServiceLine.cfm?tabno='+tabno+'&workorderid='+workorderid,'contentbox'+tabno)	 	
	}
	
	function agreementdetail(workorderid,unit) { 	   
	   ptoken.open("#SESSION.root#/Workorder/Application/WorkOrder/ServiceDetails/ServiceLineListing.cfm?filter=any&workorderid="+workorderid+"&unit="+unit+"&systemfunctionid=#url.systemfunctionid#","_blank")	 
	}
	
	function agreementworkflow(key,box) {
		
		    se = document.getElementById(box)
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)
				
			if (se.className == "hide") {		
			   se.className = "regular" 		   
			   co.className = "regular"
			   ex.className = "hide"			
			   ColdFusion.navigate('../serviceagreement/servicelineWorkflow.cfm?ajaxid='+key,key)	
	   		 
			} else {  se.className = "hide"
			          ex.className = "regular"
			   	      co.className = "hide" 
		    } 			
		}		
					
	function eventworkflow(key,box) {
		
		    se = document.getElementById(box)
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)
				
			if (se.className == "hide") {		
			   se.className = "regular" 		   
			   co.className = "regular"
			   ex.className = "hide"			
			   ColdFusion.navigate('../servicereview/servicelineWorkflow.cfm?ajaxid='+key,key)	
	   		 
			} else {  se.className = "hide"
			          ex.className = "regular"
			   	      co.className = "hide" 
		    } 	
		
		}			
	
	function agreementpurge(row,wid,lid) {
		if (confirm("Do you want to deactivate this baseline ?"))	{
			ColdFusion.navigate('../ServiceAgreement/ServiceLinePurge.cfm?row='+row+'&workorderid='+wid+'&ID2='+lid,'agreementdelete'+row)
		} 		
	}
	
	function eventpurge(row,wid,lid) {
		if (confirm("Do you want to deactivate this event ?"))	{
			ColdFusion.navigate('../ServiceReview/ServiceLinePurge.cfm?row='+row+'&workorderid='+wid+'&ID2='+lid,'eventdelete'+row)
		} 	
	}	
	
	function lineadd(wid,lid) {
		 ptoken.open("../ServiceDetails/ServiceLineView.cfm?mode=edit&workorderid=#url.workorderid#&ts="+new Date().getTime(),"_blank","left=20, top=20, status=yes, height=920, width=1130, help:no, scrollbar=no, center=true, resizable=yes");			
		 // if (ret) {	applyfilter('1','','content') }				
	}	
	
	function linepurge(row,wid,lid) {
		if (confirm("Do you want to deactivate this line ?"))	{
			ColdFusion.navigate('../ServiceDetails/ServiceLinePurge.cfm?row='+row+'&workorderid='+wid+'&ID2='+lid,'servicedelete'+row)
		} 
		return false
	}
	
	function linefundingold(tab,row,wid,lid) {
	      
	    se = document.getElementById('detail'+row)
		if (se.className == "hide") {
		  se.className = "regular"
		  ColdFusion.navigate('../Funding/Billingline.cfm?tabno='+tab+'&row='+row+'&WorkOrderId='+wid+'&workorderline='+lid,'detail'+row)
		} else { se.className = "hide" }
		
	}
	
	function addImplementerOrgUnit(mission, mandateno, woid) {
	
		try { ColdFusion.Window.destroy('implementer') } catch(e) {}
		ColdFusion.Window.create('implementer', 'Implementer', '', {height:400,width:500,modal:false,closable:true,center:true,minheight:200,minwidth:200 });
	    ColdFusion.navigate('#SESSION.root#/Workorder/Application/WorkOrder/Implementer/ImplementerAdd.cfm?workorderid='+woid+'&mission='+mission+'&mandateNo='+mandateno,'implementer')
	 		
	}

	function present(mode,tmp) {
			     	
		window.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?templatepath="+tmp+"&id="+mode+"&id1=#URL.WorkOrderId#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")		 
	} 
	
	function addPublication(wo) {
		try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
		ColdFusion.Window.create('mydialog', 'Publication', '',{x:30,y:30,height:400,width:500,modal:true,center:true});    
		ColdFusion.Window.show('mydialog'); 				
		ColdFusion.navigate('#SESSION.root#/Workorder/Application/Activity/Publication/PublicationEdit.cfm?workorderid='+wo+'&publicationId=&ts='+new Date().getTime(),'mydialog');
	}				
		
	function selectImplementer(mission,mandate) {				
		selectorgmisn(mission,mandate,'','applyunit'); 
	}
	
	function deleteImplementerOrgUnit(mission, mandateno, woid, orgunit){	    
		_cf_loadingtexthtml='';	
		ColdFusion.navigate('#session.root#/workorder/Application/WorkOrder/Implementer/ImplementerListPurge.cfm?workOrderId='+woid+'&mission='+mission+'&mandateno='+mandateno+'&orgunit='+orgunit,'divImplementerList');
	}
	
	function applyunit(org) {		
	   		
		_cf_loadingtexthtml='';			
		var rollover = $('##rollover').is(':checked');		
		woid = document.getElementById('workorderid').value		
		ColdFusion.navigate('#session.root#/workorder/Application/WorkOrder/Implementer/ImplementerListContent.cfm?orgUnitImplementer='+org+'&WorkOrderId='+woid+'&rollover='+rollover,'divImplementerTree');
	}
	
	function submitPublishForm(wo,pub) {
		document.frmPublish.onsubmit();
		if( _CF_error_messages.length == 0 ) {
			ColdFusion.navigate('#session.root#/workOrder/Application/Activity/Publication/PublicationSubmit.cfm?workOrderId='+wo+'&publicationId='+pub+'&systemfunctionid=#url.systemfunctionid#','processPublication','','','POST','frmPublish');
		}   
	}
	
	function applyaccount(acc,sc) {
		ColdFusion.navigate('#session.root#/workorder/application/workorder/gledger/applyAccount.cfm?account='+acc+'&area='+sc, 'divProcess');
	}

	</script>

</cfoutput>

<cfajaximport tags="cfform,cfmenu,cfdiv,cfinput-datefield,cfinput-autosuggest,cfwindow">

<cfif CLIENT.googlemapid neq "">
     <cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
</cfif>
	
<cfif URL.WorkorderId eq "">
	<cfset init = 1>
    <cf_assignId>
    <cfset URL.WorkorderId = rowguid>
<cfelse>
    <cfset init = 0>	
</cfif>	

<cfparam name="Client.googlemapid" default="">
	
<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Wo.*, 
	         SI.Description AS ServiceItemDescription,
			 C.OrgUnit,
			 C.CustomerName AS CustomerName, 
             C.Reference AS CustomerReference, 
			 C.PhoneNumber AS CustomerPhoneNo
    FROM     WorkOrder Wo INNER JOIN
             ServiceItem SI ON Wo.ServiceItem = SI.Code INNER JOIN
             Customer C ON Wo.CustomerId = C.CustomerId	
	WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
</cfquery>	

<cfif workorder.recordcount eq "0">

	<cf_message message="Record was removed from the database" return="close">
	<cfabort>

</cfif>

<cfif init eq "0">		
    <cfset label =	"#WorkOrder.CustomerName# #WorkOrder.Reference#">	
	<cfset vmission="#WorkOrder.Mission#" >
<cfelse>			
   	<cfset label =	"New Order">			
	<cfset vmission="#URL.mission#">
</cfif>	

<cfif workorder.orgunit eq "">

	<cfset access =  "ALL">

<cfelse>

	<!--- define access --->

	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workorder.mission#" 
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">	
	   
</cfif>	   

<cf_screentop height="100%" width="100%" 
	jQuery="Yes" 
	scroll="yes" 
	label="#label#" 
	html="yes" 
	layout="webapp" 
	line="no" 
	busy="busy10.gif"
	menuaccess="context" 
	banner="gray">
	
<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_dialogStaffing>

<cf_dialogOrganization>
<cf_dialogWorkOrder>
<cf_dialogLedger>

<cf_dialogPosition>
<cf_listingscript>
<cf_MenuScript>
	
<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">						
							
	<tr><td valign="top" colspan="2">				
	    <cfset url.mission = vmission>
		<cfinclude template="WorkorderViewTab.cfm">		 			
	</td></tr>		
			
	<!--- --------- --->
	<!--- container --->
	<!--- --------- --->
	
	<tr><td colspan="2" height="1" class="line"></td></tr>
	
	<tr><td colspan="2" height="100%" style="padding:10px">		
	  			
		<table width="100%" height="100%">
		<tr>
		
		<cfoutput>
		<cfloop index="itm" from="1" to="#menu#">		
			<cfif itm eq "1">
				<cf_menucontainer item="#itm#" class="regular" iframe="">
			<cfelse>
			    <cf_menucontainer item="#itm#" class="hide" iframe="">
			</cfif>			
		</cfloop>
		</cfoutput>
		
		</tr>
		</table>
				
	</td></tr>
						
</table>

<div id="divProcess" style="display:none;">

<cf_screenbottom layout="webapp">

<script>
	document.getElementById("menu1").click()
</script>

