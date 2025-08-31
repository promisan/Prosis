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
<cfoutput>
	
	<script language="JavaScript">
	
	function hlr(ar,cls) {
		se = document.getElementById("line_"+ar)
		if (se)
			se.className = cls
	}	
		  
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function increase(val) {
		if (val=='')
			val = 0;		
		var x = new Number();
		x = parseInt(val);
		x = x+1		
		return x;	
	}
	
	function decrease(val) {
		if (val=='')
			val = 0;
		 var x = new Number();
		 x = parseInt(val);
		 x = x-1	 
		 return x;
	}
	
	function hl(bx,itm,fld,parent,maximum,id,clss,classmin,classmax){
		 
		 try{
		     if (ie){
		          while (itm.tagName!="TR")
		          {itm=itm.parentElement;}
		     }else{
		          while (itm.tagName!="TR")
		          {itm=itm.parentNode;}
		     }
						 		 	
			 if (fld != false) {
			     itm.className = "highLight1";				
			 	 sel  = document.getElementById("clCount_"+parent);
			 	 cls  = document.getElementById("dtCount_"+id+"_"+clss);
			 	 
				 sel.value = increase(sel.value);
				 cls.value = increase(cls.value);
				 
				 	 
			   } else {
			     itm.className = "header";		
				 sel  = document.getElementById("clCount_"+parent);	
				 cls  = document.getElementById("dtCount_"+id+"_"+clss);	 
				 sel.value = decrease(sel.value);
				 cls.value = decrease(cls.value);		 
			    }
		}catch(ex){
						
		}
	  }  
	  
	function expand(ar,box,id,id1,own) {			
		
		se  = document.getElementById("main_"+box+"_"+ar)
		iconExp = document.getElementById(box+"_"+ar+"Exp");
		iconMin = document.getElementById(box+"_"+ar+"Min");
		
		if (iconExp.className == "regular") {	
			iconExp.className = "hide"
			iconMin.className = "regular"
		} else {	
			iconExp.className = "regular"
			iconMin.className = "hide"
		}
		
		if (se.className == "hide") {		
			se.className = "regular";
			det = document.getElementById("content_"+box+"_"+ar)		
			if (det.className == "hide") {							
				det.className = "regular"
				url = "#SESSION.root#/Roster/Candidate/Details/Keyword/KeywordEntryDetail.cfm?owner="+own+"&id="+id+"&id1="+id1+"&ar="+ar;
				ptoken.navigate(url,"content_"+box+"_"+ar)			
				}			 	 
		 } else {
		  se.className = "hide";
		 }
	}
	
	function check_range(form, ctrl, value) {
	
		var ctrl_id = ctrl.id;
		var err_msg = $('##'+ctrl_id+'_message').val();
		var min = $('##'+ctrl_id+'_min').val();
		var max = $('##'+ctrl_id+'_max').val();
		
		if (value>max || value < min) {
			return false
		} else {
			return true;
		}	
	}
	
	function show_error(form, ctrl, value, msg) {		
		alert(msg);
	}  
	  
	</script>
	
</cfoutput>