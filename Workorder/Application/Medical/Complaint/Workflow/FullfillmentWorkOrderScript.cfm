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
<cf_listingscript>
<cf_dialogworkorder>
<cf_dialogAsset>

<cfoutput>

<script language="JavaScript">

	function newreceipt(mis) {		    
	    ptoken.open("#SESSION.root#/Warehouse/Application/Asset/AssetEntry/AssetEntry.cfm?mode=workorder&mission="+mis, "newasset", "left=40, top=40, width=950, height=760, menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");								
	}	
	
	function receiptrefresh(aid) {
	    _cf_loadingtexthtml='';	
	    ptoken.navigate('../../workorder/application/workorder/Assets/getAsset.cfm?assetid='+aid,'assetselectbox')	
	}
	
	function linebillingdetail(wid,lid,bid) {       
			
	   ColdFusion.Window.create('myprovision', 'Provisioning', '',{x:100,y:100,height:document.body.clientHeight-80,width:1130,modal:true,center:true,resizable:true})    
	   ColdFusion.Window.show('myprovision') 					
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingDialog.cfm?mode=workorder&workorderid='+wid+'&workorderline='+lid+'&billingid='+bid,'myprovision') 		 
	}


	
	function linebillingrefresh(wid,lid) {
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingList.cfm?workorderid='+wid+'&workorderline='+lid+'&operational=1','billingdata')	
	}
		
	function linebillingdelete(wid,lid,bid) {     
	   _cf_loadingtexthtml='';		
	   ptoken.navigate('#session.root#/workorder/application/workorder/ServiceDetails/Billing/DetailBillingList.cfm?action=delete&billingid='+bid+'&workorderid='+wid+'&workorderline='+lid ,'billingdata')
	}  
	
	function addsupply(mis,wid,lid) {  	   
	   ptoken.open("#SESSION.root#/Warehouse/Application/Stock/Transaction/TransactionInit.cfm?mode=workorder&mission="+mis+"&workorderid="+wid+"&workorderline="+lid,"workorder","left=20, top=20, width=990,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")	 	
	}


		
</script>

</cfoutput>