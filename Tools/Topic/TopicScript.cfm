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

<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-autosuggest">

<cfoutput>

	<script language="JavaScript">
	
	function listingshow() {	  
	    _cf_loadingtexthtml='';	 
		Prosis.busy('yes')
	    ptoken.navigate('#SESSION.root#/tools/topic/TopicListingDetail.cfm?#link#','topiclist')
	}
	
	function recordadd() {	
		w = 880;
		<cfif language eq "Yes">
			h = 770;
		<cfelse>
			h = 600;
		</cfif>
		var left = (window.screen.width/2)-(w/2);
		var top = (window.screen.height/2)-(h/2);
		ptoken.open("#SESSION.root#/tools/topic/TopicListingAdd.cfm?idmenu=#url.idmenu#&#link#", "Add", "left="+left+", top="+top+", width="+w+" , height= "+h+", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
    function recordedit(code) {	
		w = 880;
		<cfif language eq "Yes">
			h = 790;
		<cfelse>
			h = 740;
		</cfif>
		var left = (window.screen.width/2)-(w/2);
		var top = (window.screen.height/2)-(h);
		ptoken.open("#SESSION.root#/tools/topic/TopicListingEdit.cfm?code="+code+"&idmenu=#url.idmenu#&#link#", "Edit","left="+left+", top="+top+", width="+w+" , height= "+h+", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function addtopic(code) {
	
	   document.newtopic.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('#SESSION.root#/tools/topic/TopicListingSubmit.cfm?#link#&id2='+code,'topiclist','','','POST','newtopic')
		 }   
	 }	 

	
	function showDetail(code,systemmodule,link,serialno,div){
		d = document.getElementById(div);
		if (d.className == 'hide'){
			d.className = 'regular';
			_cf_loadingtexthtml='';	 
			ptoken.navigate('#SESSION.root#/Tools/Topic/TopicDetail.cfm?link='+link+'&code='+code+'&serialno='+serialno+'&systemmodule='+systemmodule,div);
		}else{
			d.className = 'hide';
		}
	}
	
	function option(sel) {
	  
	   if (sel != 'Text') {
	     document.getElementById("ValueLength").className="hide"
	   } else {
	     document.getElementById("ValueLength").className="regularH"
	   }
	   if (sel != 'Lookup') {
	      lookup.className='hide'
		} else {
		  lookup.className='regular'
		}
		if (sel != 'List') {
		 try {
		  document.getElementById("list1").className = "hide"
		  document.getElementById("list2").className = "hide"	
		 } catch(e) {}
		} else {
		 try {	 	     
			 document.getElementById("list1").className = "regular"
		     document.getElementById("list2").className = "regular"	
			} catch(e) {}
		}
	}
		
	
	</script>

</cfoutput>