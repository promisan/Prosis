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

<cf_ajaxNavigate>

<cfoutput>

<!--- scripts is also in stockscript, we better move this centrally --->

<script>

function stocktransfer(s,modid,stockorderid,mission,whs) {

	pge = 1; 
				
	url = "#SESSION.root#/warehouse/application/stock/transfer/transferView.cfm?"+
				"&height="+document.body.offsetHeight+
				"&systemfunctionid="+modid+
	            "&warehouse="+whs+
				"&mission="+mis+
				"&page="+pge+				
				"&stockorderid="+stockorderid					
		
	 ptoken.navigate(url,'dialog')	
	}		
	 
	 
function trfsave(id,whsto,locto,meter,ini,fnl,qty,mem,itemuomid,dte,hr,mi) {
		whs  = document.getElementById("warehouse").value	 		
		mis  = document.getElementById("mission").value	
		url = "#SESSION.root#/warehouse/application/stock/Transfer/StockTransferSave.cfm?whs="+whs+"&id="+id+"&warehouse=" + whsto+"&location="+locto+"&quantity="+qty+"&meter="+meter+"&initial="+ini+"&final="+fnl+"&memo="+mem+"&itemuomid="+itemuomid+"&date="+dte+"&hour="+hr+"&minute="+mi		
		ptoken.navigate(url,'f'+id)			 				
	 }			  
	 
function trfsubmit(mis,modid,stockorderid) {		
	  	whs  = document.getElementById("warehouse").value	
		mis  = document.getElementById("mission").value					
		url  = "#SESSION.root#/warehouse/application/stock/Transfer/StockTransferSubmit.cfm?StockOrderid="+stockorderid+"&SystemFunctionId="+modid+"&tpe=8&mis="+mis+"&whs="+whs  	
		ptoken.navigate(url,'dialog','','','POST','transferform')				
	}	
		
</script>

</cfoutput>