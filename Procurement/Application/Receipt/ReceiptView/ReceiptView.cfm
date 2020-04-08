
<cf_tl id="Receipt and Inspection Management" var="1">

<cf_screenTop height="100%" title="#lt_text#  #URL.Mission#" border="0" 
   html="No" scroll="No" menuAccess="Yes" jquery="Yes" validateSession="Yes">
   
<cfoutput>

<script language="JavaScript">

function clearrows(field, fieldNum) {
	  for (i = 1; i <= fieldNum; i++)	
	  document.getElementById(field+i).style.fontWeight='normal'
 }

function refreshTree() {
	 location.reload();
}

function reloadForm(per) { 
	 ptoken.navigate('ReceiptViewTree.cfm?mission=#URL.Mission#&period='+per,'treebox')
}

function newreceipt() {	
	$('##right').attr('src','../ReceiptEntry/LocatePurchaseView.cfm?Mission=#URL.Mission#&Period='+document.getElementById("PeriodSelect").value);
}

function newSearch() {
	$('##right').attr('src','ReceiptViewOpen.cfm?ID1=Locate&ID=STA&Mission=#URL.Mission#');
}

function updatePeriod(per,mandate) {
	
	document.getElementById("PeriodSelect").value = per
	
	if (mandate != document.getElementById("MandateNo").value) {
	   window.receipt.MandateNo.value = mandate
	   reloadForm(per)
	} else {   
	   window.receipt.MandateNo.value = mandate
	   reloadForm(per)
	}
}

</script>

<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	      type      = "Border"
          position  = "header"
          name      = "controltop">	
		  
		 <cfinclude template="ReceiptMenu.cfm">
		 
	</cf_layoutarea>		 

	<cf_layoutarea 
          type        = "Border"
          position    = "left"
          name        = "treebox"
          size        = "250"
          collapsible = "true"
          splitter    = "true"
		  state       = "open"
          maxsize     = "400">
	
	    <cfinclude template="ReceiptViewTree.cfm">
			
	</cf_layoutarea>

	<cf_layoutarea type="Border" position="center" name="box" overflow="hidden" style="height:100%">
		
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="right"
	    	    id="right"
	        	width="100%"
		        height="100%"
	    	    align="middle"
	        	scrolling="no"
		        frameborder="0"></iframe>
							
	</cf_layoutarea>
		
</cf_layout>	

</cfoutput>

