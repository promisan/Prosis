
<cfoutput>

<cfajaximport tags="cfwindow">

<script>

var root = "#SESSION.root#";

function showledger(mis,own,per,acc,pap,cc) {     
	ptoken.open(root +  "/Gledger/Application/Lookup/AccountResult.cfm?mission=" + mis + "&orgunitowner=" + own + "&period=" + per + "&account=" + acc + "&pap=" + pap+"&costcenter="+cc, "LedgerDialog");
}

function Statement(mis, ser, per) {
    w = #CLIENT.width# - 80;
    h = #CLIENT.height# - 140;
	ptoken.open(root +  "/Gledger/Inquiry/Statement/StatementSelect.cfm?Mission=" + mis + "&Period=" + per , "TransactionInquiry", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no,menubar=no,status=yes, scrollbars=no, resizable=yes");
}

function ShowTransaction(jrn,ser,mde,tgt,rle) {
    w = #CLIENT.width#  - 80;
    h = #CLIENT.height# - 140;
	if (tgt == "tab") {
	   ptoken.open(root +  "/Gledger/Application/Transaction/View/TransactionView.cfm?journal=" + jrn + "&JournalSerialNo=" + ser + "&mode=" + mde+ "&role=" + rle, "test"+jrn+ser);
	} else {
	   ptoken.open(root +  "/Gledger/Application/Transaction/View/TransactionView.cfm?journal=" + jrn + "&JournalSerialNo=" + ser + "&mode=" + mde+ "&role=" + rle, "test"+jrn+ser ,"left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no,status=yes, scrollbars=no, resizable=yes");	
	}
}

function EnterTransaction(mis,own,jrn,per,refid,reforg) {
    w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 155;
	ptoken.open(root + "/Gledger/Application/Transaction/Standard/TransactionInit.cfm?Mission="+mis+"&OrgUnitOwner="+own+"&Journal="+jrn+"&ReferenceId="+refid+"&ReferenceOrgUnit="+reforg+"&AccountPeriod=" + per + "&ts="+new Date().getTime(), "entry"+jrn);	
}

// take action on a existing transaction to process it further like initiate a receipt or payment
function ProcessTransaction(mis,own,cat,per,jou,ser) {
    w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 155;
	ptoken.open(root + "/Gledger/Application/Transaction/Standard/TransactionInit.cfm?Mission="+mis+"&OrgUnitOwner="+own+"&Category="+cat+"&AccountPeriod=" + per+"&Journal=" + jou +"&JournalSerialNo=" + ser, "entry"+mis);		
}

function CorrectTransaction(jrn,ser,cat) {
    w = 900;
	h = 800;
	ptoken.open(root + "/Gledger/Application/Transaction/Discount/Document.cfm?journal="+jrn+"&journalserialno="+ser+"&Category="+cat, "correction", "toolbar=no,status=yes,height="+h+",width="+w+",scrollbars=no, center=yes, resizable=no");		
}
function ContinueTransaction(jrn,ser,tsr,gla) {
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 155;
	ptoken.open(root + "/Gledger/Application/Transaction/Standard/TransactionInitProcess.cfm?journal=" + jrn + "&journalserialno=" + ser + "&transactionserialno=" + tsr+ "&glaccount=" + gla, "dis"+ser, "toolbar=no,status=yes,height="+h+",width="+w+",scrollbars=no, center=yes, resizable=no");	
}

function EditTransaction(jrn, ser) {
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 170;
	ptoken.open(root + "/Gledger/Application/Transaction/Standard/TransactionEdit.cfm?Journal=" + jrn + "&JournalSerialNo=" + ser + "&h=" + h,"tra"+ser,"height="+h+",width="+w+",scrollbar=no,status=yes,center=yes,resizable=yes");	
}

function editCustomer(customerId){
	window.open("#SESSION.root#/warehouse/application/customer/view/CustomerEditTab.cfm?drillid="+customerId, "EditCustomer");
}

function selectaccount(acc,des,tpe,mis,field,filter,journal) {	
		
	if (field == "undefined") {
	    field = "" }	 
		
	if (filter == "undefined") {
	    filter = ""	}	  
	
	if (journal == "undefined")  {
	    journal = "" } 
   		
	ret = window.showModalDialog(root + "/Gledger/Application/Lookup/AccountSelect.cfm?field="+field+"&filter="+filter+"&mission="+mis+"&journal="+journal+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:650px; dialogWidth:650px; help:no; scroll:no; center:yes; resizable:no");
	
	if (ret) {
		val = ret.split(";");		
		document.getElementById(acc).value = val[0];		
		document.getElementById(des).value = val[1];				
		try {
		document.getElementById(tpe).value = val[2]; } catch(e) {}						
		try {
		   		    
			if (val[3] == "0") {
				document.getElementById("programcode1").value = ""
				document.getElementById("programdescription1").value = ""
				document.getElementById("program0").className = "hide"	
				document.getElementById("program1").className = "hide"	
				document.getElementById("program2").className = "hide"		
				document.getElementById("program3").className = "hide"												
			} else {			
			    document.getElementById("program0").className = "regular"	
				document.getElementById("program1").className = "regular"					
				document.getElementById("program2").className = "regular"	
				document.getElementById("program3").className = "regular"		
			}			
		} catch(e) {}	
	   }	
	   try {
		document.getElementById('processaccount').click() } catch(e) {}					
	}
	
function selectaccountgl(mis,field,filter,journal,applyscript,scope) {		

	// 15/2/2015 newly added to replace modal dialog 	
	try { ProsisUI.closeWindow('glaccountwindow',true) } catch(e) {}
	ProsisUI.createWindow('glaccountwindow', 'Select Ledger Account','',{x:100,y:100,height:document.body.clientHeight-80,width:750,modal:true,center:true})    
    // ColdFusion.Window.show('glaccountwindow')				
    ptoken.navigate(root + '/Gledger/Application/Lookup/AccountView.cfm?mission='+mis+'&field='+field+'&filter='+filter+'&journal='+journal+'&script='+applyscript+'&scope='+scope,'glaccountwindow') 		
}	 
	
function selectbank(hform, bnk, acc, cur) {
  	ptoken.open(root + "/Gledger/Maintenance/Bank/BankSelect.cfm?ID=" + hform + "&ID1=" + bnk + "&ID2=" + acc +"&ID9=" + cur, "BankSelect", "left=100, top=100, width=400, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function selectprogram(mis,per,script,scope)	{
   
    try { ColdFusion.Window.destroy('myprogram',true) } catch(e) {}
	ColdFusion.Window.create('myprogram', 'Program Selection', '',{x:100,y:100,height:document.body.clientHeight-80,width:750,modal:true,center:true})    				
	ptoken.navigate(root + '/Gledger/Application/Lookup/ProgramView.cfm?period='+per+'&mission='+mis+'&script='+script+'&scope='+scope,'myprogram') 		
}
	
function selectdonor(mis,fun,prg,jou,ser,sel,script,scope) {
    try { ColdFusion.Window.destroy('mydonor',true) } catch(e) {}
	ColdFusion.Window.create('mydonor', 'Donor Selection', '',{x:100,y:100,height:document.body.clientHeight-80,width:750,modal:true,center:true})    					
	ptoken.navigate(root + '/Gledger/Application/Lookup/DonorView.cfm?script='+script+'&scope='+scope+'&mission='+mis+'&fund='+fun+'&programcode='+prg+'&journal='+jou+'&journalserialno='+ser+'&selected='+sel,'mydonor')  
}	

</script>

</cfoutput>