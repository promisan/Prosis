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

<cfparam name="url.script" default="">

<cfoutput>

	<script>	
	 		       
		function goback() {
					
			se  = document.getElementById("value").value		
			if (se != "") {
			self.returnValue = se
			} else {
			self.returnValue = "blank"
			}
			self.close();
			}
			    		   
		function combosearch(fld,alias,table,pk,desc,order,filterstring,filtervalue) {
			sel = document.getElementById("value")
			val = document.getElementById("find")
			adv = document.getElementById("variant")
			
			if (adv.checked) {
				v = 1
			} else {
			    v = 0
			}
			_cf_loadingtexthtml='';	
			url = "#session.root#/tools/comboBox/ComboMultiResult.cfm?fld="+fld+"&alias="+alias+"&table="+table+"&pk="+pk+"&desc="+desc+"&order="+order+"&filterstring="+filterstring+"&filtervalue="+filtervalue+"&val="+val.value+"&selected="+sel.value+"&adv="+v;
			ColdFusion.navigate(url,'result')									
			}
				
		function add(fld,alias,table,pk,desc,order,filterstring,filtervalue,val) {
			  			
				tot = document.getElementById("value").length
				se  = document.getElementById("value").value
				pos = se.indexOf(val);
				if (pos == -1) {
					if  (tot = 0) { 
					  document.getElementById("value").value = val 
					} else {
					  document.getElementById("value").value = se+","+val
					}
				}	
				
				selected(fld,alias,table,pk,desc,order)
				combosearch(fld,alias,table,pk,desc,order,filterstring,filtervalue)
			}	
			
					
		function remove(fld,alias,table,pk,desc,order,del) {
			  
				se = document.getElementById("value").value;
				tot = se.length
				len = del.length
				
				if  (tot != len) { len = len+1 }
				
				pos = se.indexOf(del);	
				senew = se.substring(0,pos)+se.substring(pos+len,se.length)
				document.getElementById("value").value = senew
				se = document.getElementById("value").value;
				selected(fld,alias,table,pk,desc,order)			
			}
					
		function purge(fld,alias,table,pk,desc,order,fil,sel) {
				document.getElementById("value").value = "";
				selected(fld,alias,table,pk,desc,order)
				combosearch(fld,alias,table,pk,desc,order,fil,sel)
			}		
					
		function selected(fld,alias,table,pk,desc,order) {
				
				val = document.getElementById("value")
				url = "#session.root#/tools/comboBox/ComboMultiSelected.cfm?fld="+fld+"&alias="+alias+"&table="+table+"&pk="+pk+"&desc="+desc+"&order="+order+"&mode=edit&selected="+val.value;
				_cf_loadingtexthtml='';	
				ColdFusion.navigate(url,'select')							
			}
			
		function finishSelection(fld,alias,table,pk,desc) {
	
			val = document.getElementById("value").value
			<cfif url.script neq "">			
			    parent.#url.script#(val)
			<cfelse>		
			        
				url = "#SESSION.root#/Tools/ComboBox/ComboMultiSelected.cfm?mode=view&fld="+fld+"&alias="+alias+"&table="+table+"&pk="+pk+"&desc="+desc+"&selected="+val;
				parent.ColdFusion.navigate(url,"combo"+fld);
				try { parent.ProsisUI.closeWindow('combomulti',true)} catch(e){};	
			</cfif>
						
			
		}
						   
	</script>
	
</cfoutput>