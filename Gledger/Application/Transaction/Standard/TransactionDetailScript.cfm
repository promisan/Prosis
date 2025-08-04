<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfoutput>
<cf_tl id="Page" var="1">
<cfset vPage = lt_text >
	
<cf_tl id="of" var="1">
<cfset vOf= lt_text >

<script language="JavaScript">

function tratoggle(itm) {

    if (itm == "item") {
	  document.getElementById("glaccountline").className = "hide"
	} else {
	  document.getElementById("glaccountline").className = "labelmedium"
	}  
   
	se = document.getElementsByName("item")
	cnt = 0
	while (se[cnt]) {
	  se[cnt].className = "hide";
	  cnt++
	}
	
	se = document.getElementsByName(itm)
	cnt = 0
	while (se[cnt]) {	
	  se[cnt].className = "regular";
	  cnt++
	}
		
}
		 
function addline(mode) {
	
	pap    = document.getElementById('transactiondate').value
	
	contra = document.getElementById("glaccount").value;		
	period = document.getElementById("accountperiod").value;		
	tracat = document.getElementById("transactioncategory").value;
	debcre = document.getElementById("entrydebitcredit").value;
	tratpe = document.getElementById("transactiontype").value;
	refer  = document.getElementById("entryreference").value;
	parlid = document.getElementById("parentlineid").value;
	partra = document.getElementById("parenttransactionid").value;
	//encoding...
	refer  = encodeURIComponent(refer);		
	refern = document.getElementById("entryreferencename").value;
	glacc  = document.getElementById("entryglaccount").value;
	gldes  = document.getElementById("entrygldescription").value;
	curr   = document.getElementById("entrycurrency").value;
	amount = document.getElementById("entryamount").value;
	ser    = document.getElementById("serialno").value;
	trdte  = document.getElementById("transactiondateline").value;
	jrnser = document.getElementById("journalserialno").value;
	
	whsnme = document.getElementById("warehouse").value;	
	whsitm = document.getElementById("itemno").value;	
	whsuom = document.getElementById("itemuom").value;
	whsqty = document.getElementById("warehousequantity").value;
	
	if (tratpe == "item" && whsitm == "") {
		alert("There was no item selected.")
		return
	}
	
	if (glacc == "") {
	  alert("There was no account selected.")
	  return	
	}  
	
	if (amount == "") {
	  alert("There was no amount entered.")
	  return	
	}  
			
	<!--- if (confirm("Add transaction ?"))	{ --->
								
	jrnexc = document.getElementById("entryexcjrn").value;	
	<!--- jrnamt = document.getElementById("entryamtjrn").value; --->
	basexc = document.getElementById("entryexcbase").value;
	<!--- basamt = document.getElementById("entryamtbase").value; --->
					
	taxcde = document.getElementById("taxcode").value;
	memo   = document.getElementById("memo").value;
	unit   = document.getElementById("costcenter1").value;
	prog1  = document.getElementById("programcode1").value;
	prog2  = document.getElementById("programcode2").value;
	donor  = document.getElementById("contributionlineid").value;
	fund   = document.getElementById("fund1").value;
	object = document.getElementById("object1").value;
	
	memo = encodeURI(memo);
	
	_cf_loadingtexthtml='';	
	Prosis.busy('yes')
	
	url = "TransactionDetailEntrySubmit.cfm?journal=#url.journal#&"+
			"&mission=#url.mission#&"+
			"&accountperiod="+period+
			"&pap="+pap+
			"&journalserialno="+jrnser+
			"&parentlineid="+parlid+
			"&parenttransactionid="+partra+
			"&transactioncategory="+tracat+
			"&transactiontype="+tratpe+
			"&entrydebitcredit="+debcre+
			"&entryreference="+refer+
			"&entryreferencename="+refern+
			"&warehouse="+whsnme+
			"&itemno="+whsitm+
			"&itemuom="+whsuom+
			"&itemquantity="+whsqty+			
			"&contraglaccount="+contra+
			"&entryglaccount="+glacc+
			"&transactiondate="+trdte+
			"&entrygldescription="+gldes+
			"&currency="+curr+
			"&entryamount="+amount+			
			"&jrnexc="+jrnexc+
			<!--- "&jrnamt="+jrnamt+ --->
			"&basexc="+basexc+
			<!---  "&basamt="+basamt+ --->
			"&taxcode="+taxcde+
			"&memo="+memo+
			"&orgunit1="+unit+
			"&programcode1="+prog1+
			"&programcode2="+prog2+
			"&contributionlineid="+donor+
			"&fund1="+fund+
			"&object1="+object+
			"&serialno="+ser+
			"&mode="+mode
			
			ptoken.navigate(url,'lines')
		
	        <!-- }	-->
				 
	}	
	 
function editline(jrnserno,period,tradte,tracat,tratpe,debcre,refer,refern,glacc,curr,amount,taxcde,memo,unit,prog,prog2,donor,ser,fund,object,whs,itm,uom,qty,parent,parenttransactionid,exch,exchbase) {
	
	pap    = document.getElementById('transactiondate').value
							
	cnt = 1
	
	while (cnt != 20) {
	try { document.getElementById("d"+cnt).className = "regular" } catch(e) {}
	cnt++
	}
	mainmenu('menu','1','box','1','highlight1')
    // document.getElementById('menu1').click(); disabled as it affects the content -			
	document.getElementById("d"+ser).className = "labelmedium2 highlight2"
	//encoding...
	refer  = encodeURIComponent(refer);
	memo   = encodeURIComponent(memo);
	_cf_loadingtexthtml='';	
			
	url = "TransactionDetailEntry.cfm?mode=1&journal=#url.journal#&"+
			 "&journalserialno="+jrnserno+
			 "&mission=#url.mission#&"+
			 "&accountperiod="+period+
			 "&pap="+pap+
			 "&parentlineid="+parent+
			 "&entrydebitcredit="+debcre+
			 "&parenttransactionid="+parenttransactionid+			
			 "&transactiondate="+tradte+
			 "&transactioncategory="+tracat+
			 "&transactiontype="+tratpe+		   	 
		   	 "&entryreference="+refer+
			 "&entryreferencename="+refern+
			 "&entryglaccount="+glacc+
			 "&entryexcjrn="+exch+
			 "&entryexcbase="+exchbase+
			 "&currency="+curr+
			 "&entryamount="+amount+			
			 "&taxcode="+taxcde+
			 "&memo="+memo+
			 "&orgunit1="+unit+
			 "&programcode1="+prog+
			 "&programcode2="+prog2+
			 "&contributionlineid="+donor+
			 "&fund1="+fund+
			 "&object1="+object+
			 "&serialno="+ser+
			 "&warehouse="+whs+
			 "&itemno="+itm+
			 "&itemuom="+uom+
			 "&itemquantity="+qty+
			 "&ts="+new Date().getTime()
			 
			 
			 ptoken.navigate(url,'contentbox1')
			 			 
						 
	}	
	
function addlines() {
	
     sort 	= $("##group").val();
	 page 	= $("##page").val();
	 period = $("##accountperiod").val();		
	 tradte = $("##transactiondate").val();		 
	 contra = $("##glaccount").val();
	 modesel= $("##lastselectedmode").val();
     Prosis.busy('yes')
	 ptoken.navigate('Transaction#sc#Insert.cfm?mode='+modesel+'&journal=#url.journal#&'+'&mission=#url.mission#&'+'&id1='+sort+'&contraglaccount='+contra+'&page='+page+'&accountperiod='+period+'&transactiondate='+tradte,'lines','','','POST','transactionheader')		
	 try {
	  document.getElementById('refreshcontent').click()
	} catch(e) {}  
	
}		

function recalcline(line,field) {

	out = document.getElementById('out_'+field).value	
    val = document.getElementById('val_'+field).value
	exc = document.getElementById('exc_'+field).value
	_cf_loadingtexthtml='';	
	ptoken.navigate('TransactionDetailReconcileAmount.cfm?line='+line+'&field='+field+'&outstanding='+out+'&amount='+val+'&exchange='+exc,'total')		
	
}  
		
function reconciled() { 	

	if (confirm("Do you want to set selected transactions as already reconciled?"))	{
	
        sel = ''
		count = 0
		se = document.getElementsByName("selected")
		while (se[count]) {
				if (se[count].checked == true)	{
				     if (sel == "") {
					    sel = "'"+se[count].value+"'"
					 }
					 
					 else {
					    sel = sel+",'"+se[count].value+"'"
					 }
				}	 
			count++
			} 
						
		  if (sel == "") {
			   Alert("You did not select any lines")
    	    } else {
		
		    sort   = document.getElementById("group").value;
			page   = document.getElementById("page").value;
			period = document.getElementById("accountperiod").value;	
			
			/// add lines 
			
		  	url = "Transaction#sc#Manual.cfm?journal=#url.journal#&"+
				"&mission=#url.mission#&"+
				"&id1="+sort+
				"&page="+page+
				"&accountperiod="+period+
				"&sel="+sel;
							
			ptoken.navigate(url,'lines')	
				 
			}		
		}	
		
		}	
		
		
	function refselect() {		
		//The following line calls refresh the template that is associated with the field {search}
		 ColdFusion.Event.callBindHandlers('search',null,'change')			 
			 				
	} 
			
	function setFilters() {
		srt   = $('##iSorting').val();
		jou   = $('##iJournal').val();
		per   = $('##iPeriod').val();
		mde   = $('##iMode').val();
		ptoken.navigate('setTransactionReconcileFilter.cfm?mode='+mde+'&id1='+srt+'&ijournal='+jou+'&period='+per,'tSearch','setPaging');		
	}				
	
	function setPaging(){		
		
		var t   = '#vPage#';
		var o   = '#vOf#';
		var p 	= $('##iPages').val();
		var s   = $('##iPageSelected').val();		
		
		$('##page').find('option').remove();		
		for (var i = 1; i <= p; i++) {
			vtext = t +' '+ i.toString() +' '+ o +' '+ p.toString();
			
			$('##page').append(
				$("<option></option>").attr("value", i).text(vtext)
			);
		}	
		
		$('##page').val(s);		
	
	}
				
	</script>
	
</cfoutput>	