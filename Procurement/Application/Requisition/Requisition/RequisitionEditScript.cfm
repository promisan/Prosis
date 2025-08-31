<!--
    Copyright © 2025 Promisan B.V.

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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfoutput>

<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequisitionLineService 
	WHERE  RequisitionNo = '#URL.id#'
</cfquery>

<cf_dialogPosition>

<cf_verifyOperational module="Warehouse" Warning="No">

<script>

function applyitem(uomid,fld,scope,access) {
	ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/setItem.cfm?access='+access+'&itemuomid='+uomid+'&field='+fld+'&scope='+scope,'process')
}

function positionrefresh(positionparent,expiration,box) {
	ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Position/PositionFunding.cfm?reqid=#url.id#&access=edit&action=insert&positionparentid='+positionparent+'&dateexpiration='+expiration,box)
}

function detailfunding(tpc,box,fund,reqno,period,prg,obj,act,mode,mis,hier,org) {	
    w = #CLIENT.width# - 200;
    h = #CLIENT.height# - 210;	
    ptoken.open("../../Funding/FundingExecutionDetail.cfm?ts="+new Date().getTime()+"&unithierarchy="+org+"&mission="+mis+"&box="+box+"&reqno="+reqno+"&fund="+fund+"&period="+period+"&programcode="+prg+"&programhierarchy="+hier+"&objectcode="+obj+"&isParent=1&mode="+mode, "detail", "left=10, top=10, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");   	
}

// track down

function staccountfunding(reqno,fdid) {
    w = #CLIENT.width# - 260;
    h = #CLIENT.height# - 230;	
    ret = window.showModalDialog("../FundingDetail/FundingDetailSelectView.cfm?ts="+new Date().getTime()+"&requisitionno="+reqno+"&fundingid="+fdid, window, "unadorned:yes; edge:raised; status:no; dialogHeight: "+h+" px; dialogWidth:"+w+" px; help:no; scroll:no; center:yes; resizable:yes");   	
	
	 if (ret == 3) {			 
	 ptoken.navigate('../FundingDetail/FundingDetail.cfm?id='+reqno+'&fundingid='+fdid,'i'+fdid)		 	 
	 }		 
}

function detailactivity(reqno,fdid) {
	ColdFusion.Window.create('dialogactivity', 'Distribute Activities', '',{x:100,y:100,height:600,width:850,resizable:true,modal:true,center:true})
	// document.getElementById(ColdFusion.Window.getWindowObject("dialogactivity").header.id).className = "windowHdr";
	ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/Activity/ActivityListing.cfm?requisitionno='+reqno+'&fundingid='+fdid,'dialogactivity')
}

function verifystatus(id) {        
    ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditVerify.cfm?id='+id,'warning','','','POST','processaction')	 
}

function AddVacancy(pos,req) {
    
    ProsisUI.createWindow('mydialog', 'Receipt', '',{x:100,y:100,height:660,width:700,modal:false,resizable:false,center:true})    
    ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?Mission=#URL.Mission#&ID1=' + pos + '&box=' + req,'mydialog') 	
		 		   			 	 	
}

function processorg(org) {

	  <cfif Parameter.EnforceProgramBudget gte "1">
		  funding('all')
	  </cfif> 
	  
	  <cfif parameter.EnableBeneficiary eq "1" and check.recordcount eq "0">
		  ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Beneficiary/UnitList.cfm?box=bunit&requisitionno=#url.id#&selectunit='+org,'bunit')
	  </cfif>
	  	  
	  se = document.getElementById('orgunit2') 
	  
	  if (se.value == "") {	    
	    applyorgunit('orgunit',org,'2','')			   
	  }
	  
	  verifystatus('#url.id#')	
	  ptoken.navigate('RequisitionUnitInfo.cfm?ID=#URL.ID#&orgunit='+org,'unitinfolist')  
}

function selectmas(flditemmaster,mis,per,reqno) {         
		try { ProsisUI.closeWindow('mymaster',true) } catch(e) {}
		ProsisUI.createWindow('mymaster', 'Procurement Master', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,resizable:false,center:true})    					
		ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Item/ItemSearchView.cfm?id='+reqno+'&mission='+mis+'&period='+per+'&flditemmaster='+flditemmaster, 'mymaster');	       			
}

function selectmasapply(val,mode) {      
        ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/setItemMaster.cfm?itemmaster='+val+'&mode='+mode,'process')		
}

function hidedescription() {
    document.getElementById('requestmemo').className = "hide"
	document.getElementById('requesttype').click()
}

function processmas(val,fldcostprice,price,dialog,enforce,mode) {
																			
		<cfif Line.RequestType neq "Warehouse">
					
			if (price != "") {					
			    pr = document.getElementById(fldcostprice).value					
				if (pr != '0.00') {					   				
					document.getElementById(fldcostprice).value = price	
					base2('#url.id#',price,document.getElementById('requestquantity').value)				
				}
			}
			
		</cfif>		
								
		ptoken.navigate('RequisitionEntryInterface.cfm?option=itm&access=#access#&reqid=#url.id#&itemmaster='+val,'reqcls1')												
					
		try { budgetcheck()	} catch(e) {}				
					
		try { 		
			
		 <!--- load custom entry field --->			
		 ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditFormCustom.cfm?mode=edit&id=#url.id#&mission=#line.mission#&master='+val,'custom')	
		 funding('item')					 			 			
		 selectmasapply(val,mode) 			 
		 
		 } 
		 catch(e) {}  			 
		 verifystatus('#url.id#')			
			 			
}

function tagging(amt) {
     
	 <cfif Parameter.enableReqTag eq "1">		
	     if (amt == 'undefined') {
		    bv = document.getElementById("requesttotal").value		
		 } else {
		    bv = amt
		 }			 				
		 finlabel('REQ','#URL.ID#','Requisition','#Line.Mission#','#APPLICATION.BaseCurrency#',bv,'no','Purchase.dbo.RequisitionLineFunding','multiple','100%') 
	 </cfif>
}

function memoload(acc) {			
	url = "#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditMemoShow.cfm?id=#URL.ID#&access="+acc;
	ptoken.navigate(url,'memo')  		
}

function flowload(cl) {				
	url = "#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditFlowShow.cfm?entityclass="+cl+"&ajaxid=prepare_#URL.ID#";
	ptoken.navigate(url,'prepare_#URL.ID#')	 
}

function reqclass(clss,acc,des,mas) {   
	if (clss == "warehouse") {
	    url = "#SESSION.root#/Procurement/Application/Requisition/Requisition/setInterface.cfm?id=#URL.ID#&mis=#URL.mission#&option=itm&access="+acc+"&item="+des+"&itemmaster="+mas;
	} else {
	    url = "#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryInterface.cfm?init=0&reqid=#URL.ID#&mis=#URL.mission#&option=itm&access="+acc+"&des="+des+"&itemmaster="+mas; 
	}				
	ptoken.navigate(url,'reqcls1') 			
}

function requom(clss,acc,qty,uom,uomwhs) {	
	
	if (clss == "warehouse") {
	     url = "#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryWarehouse.cfm?reqid=#URL.ID#&mis=#URL.mission#&option=uom&access="+acc+"&qty="+qty+"&uom="+uom+"&uomwhs="+uomwhs
	} else {
	     url = "#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryInterface.cfm?reqid=#URL.ID#&mis=#URL.mission#&option=uom&access="+acc+"&qty="+qty+"&uom="+uom 
	}	
	ptoken.navigate(url,'reqcls2')	 
	
}

function budgetcheck() {    
    per = document.getElementById("period").value	
	mas = document.getElementById("itemmaster").value	
	ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditFormBudget.cfm?requisitionno=#url.id#&mission=#url.mission#&period='+per+'&itemmaster='+mas,'budgetentry')
}

function budget(clr,budgetid,act) {	
	per = document.getElementById("period").value			
	ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryBudget.cfm?archive=#url.archive#&clear='+clr+'&mission=#URL.Mission#&access=#access#&per='+per+'&id=#URL.ID#&budgetid='+budgetid+'&action='+act,'budgetbox')						
}

function bd() {

   w    = #CLIENT.width# - 100;
   h    = #CLIENT.height# - 150;  
   edt  = document.getElementById("editionid").value	
   per  = document.getElementById("period").value
   unit = document.getElementById("orgunit1").value   
     
   if (unit != "") {   
   	  ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Budget/RequisitionBudgetSelect.cfm?Mission=#URL.Mission#&ID=#URL.ID#&editionid="+edt+"&Period=" + per + "&Org=" + unit, "_blank", "left=10, top=10, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");			     	 
   } else { alert("You must select a unit.") }	     
}

function funding(clr,fundingid,act,fd,obj,pg,perc,pgper) {	
		
	_cf_loadingtexthtml='';				
	per = document.getElementById("period").value		
	mas = document.getElementById("itemmaster").value		
	ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEntryFunding.cfm?objectcode='+obj+'&itemmaster='+mas+'&archive=#url.archive#&clear='+clr+'&mission=#URL.Mission#&access=#access#&per='+per+'&id=#URL.ID#&fundingid='+fundingid+'&action='+act+'&fund='+fd+'&programcode='+pg+'&percentage='+perc+'&period='+pgper,'fundbox')
}

function fd() {

   w    = #CLIENT.width#  - 40;
   h    = #CLIENT.height# - 160;   
   per  = document.getElementById("period").value
   unit = document.getElementById("orgunit1").value   
   mas  = document.getElementById("itemmaster").value
     
   if (unit != "") {   
   	  ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Funding/RequisitionEntryFundingSelect.cfm?Mission=#URL.Mission#&ID=#URL.ID#&ItemMaster="+mas+"&Period=" + per + "&Org=" + unit, "_blank", "left=10, top=10, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");			
   }  else  { alert("You must select a unit.") }	 
    
}

function base2(id,currencyVal,quantityVal) {
          
   <cfif Parameter.EnableCurrency eq "0">

	   ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditAmount.cfm?id='+id+'&quantity='+quantityVal+'&price='+currencyVal+'&currency=#APPLICATION.BaseCurrency#','amountbox')

   <cfelse>      
       
	   cur = document.getElementById('requestcurrency').value    
       ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditAmount.cfm?id='+id+'&quantity='+quantityVal+'&price='+currencyVal+'&currency='+cur,'amountbox')     
	   
   </cfif>   
}

function changeperiod(req,per,acc) {
    
    try {    
	    itm = document.getElementById("mission1");
		itm.value = ""
		itm = document.getElementById("orgunit1");
		itm.value = ""
		itm = document.getElementById("orgunit2");
		itm.value = ""
		itm = document.getElementById("orgunitname1");
		itm.value = ""
		itm = document.getElementById("orgunitname2");
		itm.value = ""
		<cfif Parameter.EnforceProgramBudget gte "1">
				funding('all')
		</cfif> 
	} catch(e) {}	
	budgetcheck()
}

function deletedetail(id,id2) {
  
	if (confirm("Do you want to remove this detail ?"))	{
		_cf_loadingtexthtml='';	
		ptoken.navigate('../Service/ServiceItemPurge.cfm?ID='+id+'&ID2='+id2,'iservice')
	} 
	
}
	
function maintainquick(mis,man,org) {     	 
	ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?ts="+new Date().getTime()+"&header=no&ID=ORG&ID1="+org+"&ID2="+mis+"&ID3="+man, "unitinfoframe")	
}	

</script>

</cfoutput>
