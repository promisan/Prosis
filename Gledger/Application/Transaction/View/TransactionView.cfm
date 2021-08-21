
<!--- standard transaction view --->

<cfparam name="url.embed"   default="0">
<cfparam name="url.id"      default="">
<cfparam name="url.role"    default="">

<cfif url.id neq "">
	
	<cfquery name="Log" 
			datasource="appsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			SELECT * 
			FROM   TransactionLine 
			WHERE  TransactionLineId = '#url.id#'
	</cfquery>	
	
	<cfif Log.recordcount lte "0">
	
		<cfquery name="Log" 
			datasource="appsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			SELECT * 
			FROM   TransactionHeader 
			WHERE  TransactionId = '#url.id#'	
		</cfquery>	
		
		<cfset url.journal         = log.Journal>
		<cfset url.journalserialNo = log.journalserialNo>
		
	<cfelse>
	
		<cfset url.journal         = log.Journal>
		<cfset url.journalserialNo = log.journalserialNo>
	
	</cfif>
					
</cfif>	


<!--- --------Hanno : 5/1/2015----------------------------- --->
<!--- -------move this one into a batch as sometimes------- --->
<!--- -------it is not in balance-------------------------- --->

<cfquery name="Transaction" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     H.*, 
	           P.ActionStatus as AccountStatus,
			   J.SystemJournal
	FROM       TransactionHeader H 
	           INNER JOIN Period  P ON H.AccountPeriod = P.AccountPeriod
			   INNER JOIN Journal J ON J.Journal       = H.Journal
	WHERE      H.Journal         = '#URL.Journal#' 
	AND        H.JournalSerialNo = '#URL.JournalSerialNo#' 	
	ORDER BY   H.TransactionDate
</cfquery>

<cfif Transaction.TransactionSource eq "SalesSeries">

	<cfset url.scope="standalone">
	<script>
		<cfinclude template="../../../../Warehouse/Application/Stock/StockControl/SettlementScript.cfm">
	</script>	
	<cf_dialogSettlement scope="standalone">
	<cf_KeyPadScript>

	<style>
			
		.inputamount_active {	   
		    margin-left: 1px;
		    padding-left: 2px;
		    padding-right: 3px;
			text-align:right;
			color:##ffffff;
			background-color: ##3C5AAB;		
		}	
		
		.settlement_title td {
		    font-family: calibri;
		    font-size: 1em;
			font-weight:bold;
		}	
		
		.line_details td {
		    font-family: calibri;
		    font-size: 1em;
		}		
	
		.tdmmenu, .tdcmenu {
			font-family: calibri;
			font-size:12px;
			color:##000;
			background-color:##ffffff;
			text-decoration:none;
			cursor:pointer;
			border:0px solid ##DDD;
			text-align:center;
		}
	
	</style>	
		
</cfif>

<cfoutput>

<script language="JavaScript">

	function SourceView(jou,ser) {	
		 // try { ColdFusion.Window.destroy('wsettle',true)} catch(e){};
	     ProsisUI.createWindow('source', 'Transaction Source', '',{x:100,y:100,width:900,height:690,resizable:false,modal:true,center:true})		
		 ptoken.navigate('#SESSION.root#/Gledger/Application/Transaction/Source/SourceView.cfm?journal='+jou+'&journalSerialNo='+ser, 'source');		
	}
	
	function PosSettlement() {	
		 // try { ColdFusion.Window.destroy('wsettle',true)} catch(e){};
	     ProsisUI.createWindow('wsettle', 'Settlement', '',{x:100,y:100,width:900,height:690,resizable:false,modal:true,center:true})		
		 ptoken.navigate("#SESSION.root#/Warehouse/Application/SalesOrder/POS/Settlement/SettleView.cfm?journal=#url.journal#&journalSerialNo=#url.journalSerialNo#", "wsettle");		
	}
	
	function PrintReceivable() {			
	     ProsisUI.createWindow('wsettle', 'Settlement', '',{x:100,y:100,width:860,height:670,resizable:false,modal:true,center:true})		
		 ptoken.navigate("TransactionInvoice.cfm?journal=#url.journal#&journalSerialNo=#url.journalSerialNo#", "wsettle");		
	}
	
	function PrintTaxReceivable() {		
		ProsisUI.createWindow('wsettle', 'Invoice', '',{x:100,y:100,width:860,height:document.body.clientHeight-75,resizable:false,modal:true,center:true})
		ptoken.navigate("TransactionTaxInvoice.cfm?journal=#url.journal#&journalSerialNo=#url.journalSerialNo#", "wsettle");
	}
	
	function recalcline(field) {
		out = document.getElementById('out_'+field).value	
	    val = document.getElementById('amt_'+field).value
		exc = document.getElementById('exc_'+field).value
		_cf_loadingtexthtml='';		
		ptoken.navigate('setAmount.cfm?field='+field+'&outstanding='+out+'&amount='+val+'&exchange='+exc,'offsetprocess')			
	}  
	
	function processline(id) {
		ptoken.navigate('TransactionViewLine.cfm?transactionid='+id,'process')
		try {		
		opener.applyfilter('0','',id) } catch(e) { }		
		
	}
	
	function applyprogram(prg,scope) {
	    ptoken.navigate('setProgram.cfm?programcode='+prg+'&scope='+scope,'process')
	}  
	
	function getOutstanding(id) {
		ProsisUI.createWindow('outstanding', 'Outstanding Balance breakdown', '',{x:100,y:100,width:870,height:510,resizable:false,modal:true,center:true})
		ptoken.navigate('getTransactionOffset.cfm?transactionid='+id, 'outstanding');
	}
	
	function getSummary(id) {
		ProsisUI.createWindow('outstanding', 'Contra account distribution', '',{x:100,y:100,width:870,height:510,resizable:false,modal:true,center:true})
		ptoken.navigate('getTransactionSummary.cfm?transactionid='+id, 'outstanding');
	}
	
	function view(sum) {
		ptoken.open("TransactionView.cfm?embed=#url.embed#&journal=#url.journal#&journalserialNo=#url.journalserialno#&mode=regular&summary="+sum,"_self")
	}
	
	function more(bx) {
	
		icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx);
				 		 
		if (se.className == "hide") {
		   	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";		
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
	    	 se.className  = "hide"
		 }		 		
	  }
	  
	function earmark(name,cls) {
		se = document.getElementsByName(name)
		cnt = 0
		while (se[cnt]) {
			se[cnt].className = cls
			cnt++
	    }
		
	}  
	
	function present(mode) {
				     		  		  
		  w = #CLIENT.width# - 100;
		  h = #CLIENT.height# - 140;
		  
		  docid = document.getElementById("printdocumentid").value
		  		  
		  if (docid != "") {			   
			  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?docid="+docid+"&id="+mode+"&id1=#Transaction.transactionid#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
		  } else {
		      alert("No format selected")
		  }	  
	 	} 			  
	  
	function del(jrn,ser) {
		if (confirm("Do you want to delete this transaction ?")) {
		   ptoken.location("TransactionPurge.cfm?jrn=#URL.Journal#&ser=#URL.JournalSerialNo#&journal="+jrn+"&journalserialno="+ser)
		}
	}
    
</script>  

<cf_fileLibraryScript>
<cf_DialogProcurement>
<cf_DialogStaffing>
<cf_dialogOrganization>
<cf_dialogWorkOrder>
<cf_dialogMaterial>
<cf_dialogREMProgram>
<cf_dialogLedger>
<cf_dialogCaseFile>
<cf_ActionListingScript>
<cf_CalendarScript>

<cfajaximport tags="cfform">

<cfparam name="URL.Show"          default="Show">
<cfparam name="URL.Journal"         type="string" default="">
<cfparam name="URL.JournalSerialNo" type="string" default="">
<cfparam name="URL.Mode"            type="string" default="">

<cfquery name="Param" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM     Parameter 
</cfquery>


<cfif url.role eq "" or url.role eq "undefined">

	<cfinvoke component = "Service.Access"  
	   method           = "journal" 
	   journal          = "#url.journal#"
	   orgunit          = "0"
	   returnvariable   = "access">	
	   
<cfelse>

	<cfinvoke component = "Service.Access"  
	   method           = "RoleAccess" 
	   role             = "'#url.role#'"
	   mission          = "#Transaction.mission#"	
	   accesslevel      = "'1','2'"  
	   orgunit          = "0"
	   returnvariable   = "access">	

</cfif>	   	   
	   
<cfif access eq "NONE">

	<cf_tl id="You do not have access to view this transaction" var="1">
	<cf_message message="#lt_text#" return="close">
	<cfabort>

</cfif>	 

<!--- ----------------------------------------------------- --->
<!--- recalculated the balance outstanding of a transaction --->
<!--- ----------------------------------------------------- --->

<cfif Transaction.OrgUnitOwner eq "0">

  <cfset label  = "GL Transaction #Transaction.Mission#">
  <cfset title  = "GL Transaction #Transaction.Mission#">

<cfelse>	
	
	<cfquery name="getOrg" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#transaction.OrgUnitOwner#'	
	</cfquery>
	
    <cfset label = "GL Transaction <b>#getOrg.OrgUnitNameShort#</b>">
	<cfset title = "GL Transaction #getOrg.OrgUnitNameShort#">
	
</cfif>

<cfquery name="JournalList" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM     Journal
	WHERE    Journal         = '#URL.Journal#' 
</cfquery>

<!--- ----------------------------------------------------- --->
<!--- recalculated the balance outstanding of a transaction --->
<!--- ----------------------------------------------------- --->

<!--- define the correct matching balance --->
		
<cfif Transaction.matchingRequired eq "1">

    <cf_TransactionOutstanding 
	    journal="#url.journal#" 
	    journalserialNo="#url.journalserialNo#">
		
	<!--- as this may change the value on the outstnading field, we refresh the content before we present --->	
		
	<cfquery name="Transaction" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     H.*, 
		           P.ActionStatus as AccountStatus,
				   J.SystemJournal
		FROM       TransactionHeader H 
		           INNER JOIN Period  P ON H.AccountPeriod = P.AccountPeriod
				   INNER JOIN Journal J ON J.Journal       = H.Journal
		WHERE      H.Journal         = '#URL.Journal#' 
		AND        H.JournalSerialNo = '#URL.JournalSerialNo#' 	
		ORDER BY   H.TransactionDate
	</cfquery>
								
</cfif>

<cfinvoke component="Service.Access"
	   Method="Journal"
	   Journal="#URL.Journal#"
	   OrgUnit="#Transaction.OrgUnitOwner#"
	   ReturnVariable="Access">	  

<!--- exceptional siatuations only --->

<cfif Transaction.recordCount eq "0">
	
	<script language="JavaScript">
	    parent.window.close();
		try {
	    parent.opener.reloadForm();		
		} catch(e) {}
	</script>
	
	<cfabort>

</cfif>

</cfoutput>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObject
	WHERE  ObjectKeyValue4 = '#transaction.Transactionid#'
	AND    Operational = 1
</cfquery>

<cf_verifyOperational        
         module    = "Accounting" 
		 Warning   = "No">		
		
<cfif url.embed eq "0" and Object.recordcount gte "1">

		<cf_screentop height="100%" 
              html="No" 
			  title="#title#" 
			  layout="webapp" 			  
			  line="no"
			  menuAccess="Context"
			  systemmodule="Accounting"
			  functionclass="Window"
			  functionname="Transaction View" 
			  busy="busy10.gif"
			  jquery="Yes"
			  label="#label#" 
			  scroll="no">
			  
		<cf_layoutscript>
		<cf_textareascript>
		
		<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  

		<cfparam name="url.summary" default="1">
		
		<cf_layout attributeCollection="#attrib#">

			<cf_layoutarea 
		          position="header"
				  size="50"
		          name="controltop">	
				  
				<cf_ViewTopMenu label="#Title#" menuaccess="context" background="blue">
						
			</cf_layoutarea>		 
		
			<cf_layoutarea  position="center" name="box">
			
				<table style="height:100%;width:100%">
				<tr><td style="padding-left:15px">
				
			     <cf_divscroll style="height:98%">		 
					 <cfinclude template="TransactionViewDetail.cfm">	
				 </cf_divscroll>
				 
				 </td></tr>
				 </table>
		
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

		<cf_screentop height="100%" 
              html="yes" 
			  title="#title#" 
			  layout="webapp" 			 
			  line="no"			  
			  systemmodule="Accounting"
			  functionclass="Window"
			  functionname="Transaction View" 
			  jquery="Yes" 
			  busy="busy10.gif"
			  label="#label#" 
			  scroll="no">
			  
		<cfparam name="url.summary" default="1">	
		
		<cf_divscroll style="height:98%">		 
			<cfinclude template="TransactionViewDetail.cfm">
		</cf_divscroll>		  			  
			  
</cfif>	