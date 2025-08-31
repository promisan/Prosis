/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
	function submenuselect(subm) { 
	      var count=0;
		  var se  = document.getElementsByName('subm')	  	
		  while (se[count]) {    
		    se[count].className = "submenuregular" 
		    count++;
		  }	
	      subm.className = "submenuselected"	    
	  }		
		
	function faqpage (dir,op,op2)	{
	ColdFusion.navigate('../../../custom/portal/muc/faq.cfm?dir='+dir+'&id='+op+'&id2='+op2,'faqdetail');
	}

	function flash(dir,op,op2) {
      ColdFusion.navigate('flash.cfm?dir='+dir+'&id='+op+'&id2='+op2,'flash');
	}

	function mainmenuselect(opt) { 
	      var count=0;
		  var se  = document.getElementsByName('opt')	  	
		  while (se[count]) {    
		    se[count].className = "menuregular" 
		    count++;
		  }	
	      opt.className = "menuselected"	    
	 }
	  
	function itemselect(it) { 
		var count=0;
		var se  = document.getElementsByName('it')	  	
		while (se[count]) {    
			se[count].className = "itemregular" 
			count++;
			}	
			it.className = "itemselected"	    
		}
	  
	ie = document.all?1:0
	ns4 = document.layers?1:0
		function h2(itm,fld,name) {			 
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }		 
		 	 		 	
		 if (fld != false){
				
		 if (itm.className != "itemselected") {	 
			 itm.className = "itemhighlight";
		     itm.style.cursor = "pointer";
	    	 self.status = name;
			 }		
		 
		 }else{
			
		 if (itm.className != "itemselected") {	 
			 itm.className = "itemregular";		
			 itm.style.cursor = "";
			 self.status = name;
			 }		 
		 }
	  }
	  
	function widselect(wid) { 
		var count=0;
		var se  = document.getElementsByName('wid')	  	
		while (se[count]) {    
		se[count].className = "widgetregular" 
		count++;
		}	
		wid.className = "widgetselected" 
	}
	  
	function widclass(tis) { 
		var count=0;
		var se  = document.getElementsByName('tis')	  	
		while (se[count]) {    
		se[count].className = "widgetnormal" 
		count++;
		}	
		tis.className = "widgethighlight"	    
	}
	 
	 function ReverseDisplayx(d) {
		var myArray = new Array();
		var i;
		
		myArray[0] = 'sub1x';
		myArray[1] = 'sub2x';
		myArray[2] = 'sub3x';
	
		if(document.getElementById(d).style.display == "none") { document.getElementById(d).style.display = "block"; }
		else { document.getElementById(d).style.display = "none"; }
		
		for ( i=0;i<=myArray.length-1;i++)
		{
			if(myArray[i] != d) 
			{document.getElementById(myArray[i]).style.display = "none";}
		}
	}

	function BalanceCheck(tid) {	
		ColdFusion.navigate('../../Custom/portal/muc/Balance_check.cfm?webapp='+tid+'&id='+tid,'balance');
	}

	function RequestAccess(tid) {
		ColdFusion.navigate('Extended/RequestAccess.cfm?mode=strict&id='+tid,'balance');	
	}
	
	function ResetPassword(tid) {
		ColdFusion.navigate('Extended/ResetPassword.cfm?mode=strict&id='+tid,'balance');
	}
	
	function ChangePassword(tid,mode,window,tlink) {
		ColdFusion.navigate('Extended/ChangePassword.cfm?quirks=0&id='+tid+'&mode='+mode+'&window='+window+'&link='+tlink,'balance');			
	}	
	
	function openInIFrame(url) {
		document.getElementById('PortalView').contentWindow.goToBalance(url);
	}
	
	function menu(d) {
		document.getElementById('PortalView').contentWindow.menuselect(d);
	}
	
	function modal() {
		document.getElementById('lprompt').style.display = "none";
		
		try {
			  document.getElementById('lbg').style.display = "none";
		  	}
	    catch(err)
		 	{
			
		    }		
	}
	
	
	

	
	

	
	