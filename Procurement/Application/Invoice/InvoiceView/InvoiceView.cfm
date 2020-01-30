
<cf_tl id="Invoice registration and Invoice Matching" var="1">

<cf_screenTop height="100%" title="#lt_text#  #URL.Mission#" border="0" jQuery="Yes" html="No" scroll="no" MenuAccess="Yes" validateSession="Yes">

<cfoutput>
	
	<script language="JavaScript">
				
	function reloadForm(role,per) {
	    ptoken.navigate('InvoiceViewTree.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&period='+per+'&role='+role,'treebox')
	}
	
	function newinvoice() {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
	    ptoken.open("../InvoiceEntry/LocatePurchaseView.cfm?Mission=#URL.Mission#&Period="+document.getElementById('PeriodSelect').value, "invoice_#url.mission#");	
	}
	
	function updatePeriod(per,mandate,role) {
			
		document.getElementById('PeriodSelect').value = per
	
		if (mandate != document.getElementById('MandateNo').value) {
		   document.getElementById('MandateNo').value = mandate
		   reloadForm(role,per)
		} else {   
		   document.getElementById('MandateNo').value = mandate
		   reloadForm(role,per)
		}
	
	}
	
	function mail(mode,id) {
		  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=/Procurement/Inquiry/Print/VendorInvoice/VendorInvoice.cfr","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
	
	</script>
	
	<cfajaximport tags="cfform">

<cf_layoutscript>
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="yes"}>

<cf_layout attributeCollection="#attrib#">
		
	<cf_layoutarea 
	          position="header"
	          name="controltop">	
			  
			 <cfinclude template="InvoiceMenu.cfm">
			 
	</cf_layoutarea>		
	 
	<cf_layoutarea position="left" name="treebox" maxsize="400" size="280" collapsible="true" splitter="true">
	
		<cf_divScroll>
			 <cfinclude template="InvoiceViewTree.cfm">
		</cf_divScroll>
			 							
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box" style="height:100%" overflow="hidden">
	
			<cfparam name="url.link" default="Tools/Treeview/TreeViewInit.cfm">
			<cfset link = replaceNoCase(url.link,"|","&","ALL")>
			
			<iframe name="right"
		        id="right"
				src="#SESSION.root#/#link#"
		        width="100%"
		        height="100%"
		        align="middle"        
		        frameborder="0"></iframe>		
				
	</cf_layoutarea>			
		
</cf_layout>		

</cfoutput>



