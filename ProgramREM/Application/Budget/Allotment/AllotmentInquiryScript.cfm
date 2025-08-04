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

<script language="JavaScript">
	
	w = "#client.width-120#"
	h = "#client.height-140#"	
	
	function execution(fund,edition) {
	 
	 se = document.getElementsByName('Exec'+edition+fund)
	 cnt = 0	
		 
	 if (document.getElementById('d'+edition+fund+'Exp').className == "regular") {
	 					
		while (se[cnt]) {
	    se[cnt].className = "regular labelit"
		cnt++
	    }	
	 	document.getElementById('d'+edition+fund+'Exp').className = "hide"
		document.getElementById('d'+edition+fund+'Min').className = "regular"
		ptoken.navigate('AllotmentInquiryAmountExecution.cfm?edition='+edition+'&fund='+fund+'&exeshow=regular','moveresult')
		
	 } else {	 
	  
	 	while (se[cnt]) {
	    se[cnt].className = "hide"
		cnt++
	    }	
	   	document.getElementById('d'+edition+fund+'Min').className = "hide"
	   	document.getElementById('d'+edition+fund+'Exp').className = "regular"
		ptoken.navigate('AllotmentInquiryAmountExecution.cfm?edition='+edition+'&fund='+fund+'&exeshow=hide','moveresult')
	 }
	 
	}	
	
	function movedetail(ed) {	
	 document.getElementById('movebutton'+ed).className = "hide"
	 se = document.getElementsByName('moveline'+ed)
	 cnt = 0
	 while (se[cnt]) {
	    if (se[cnt].checked== true) {
		   document.getElementById('movebutton'+ed).className = "regular"
		 }
		 cnt++
	 }		
	}
	
	function allotmentApply(id,val) {
	   ColdFusion.navigate('setAllotmentAmount.cfm?requirementid='+id+'&value='+val,'action_'+id)	
	}
	
	function allotdetailopen(prg,per,ed,mode) {	 	          
		ProsisUI.createWindow('mydialog', 'Configuration', '',{x:100,y:100,height:700,width:870,modal:true,center:true})    			   ;			
		ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/Allotment/Setting/AllotmentView.cfm?mode='+mode+'&programcode='+prg+'&period='+per+'&editionid='+ed,'mydialog') 		 	
	}
	
	function movedetailopen(prg,per,ed) {
	   
		se = document.getElementsByName('moveline'+ed)
		cnt = 0
		lk = ""
		 while (se[cnt]) {
		 
		   if (se[cnt].checked) {
			   if (lk == "") {
			     lk = se[cnt].value
			   } else {
			     lk = lk+','+se[cnt].value
			   }
		   }
		   cnt++
		 }
		 
		ptoken.open("#SESSION.root#/ProgramREM/Application/Budget/Move/RequirementMove.cfm?programcodefrom="+prg+"&programcode="+prg+"&period="+per+"&editionid="+ed+"&ids="+lk,"move", "left=40, top=40, width=900, height=700, status=yes, scrollbars=no, resizable=no")		 
		// not needed 15/1/2014 as the submit method does it  ColdFusion.navigate('AllotmentInquiryAmount.cfm?programcode='+prg+'&period='+per+'&editionid='+ed+'&objectcode='+ret,'moveresult') 		 
				
	}	
		
	function mainmenu(menusel,len) {
		    		 
		 menu=1 
		 len++ 
		
	     while (menu != (len)) {
		 
		  if (menu == menusel) {
		    document.getElementById("menu"+menu).className = "highlight"
		  } else {
		    document.getElementById("menu"+menu).className = "regular"
		  }
				  
		  se = document.getElementsByName("box"+menu)	  
		  cell = 0 	  
		  
		  while (se[cell]) {	 
		  
		     if (menu == menusel) { 
				se[cell].className = "regular"
			 } else {
			    se[cell].className = "hide"
			 }
			 cell++
			 
		  }	  
		  menu++	  	 
		 }
	
	}
		
	function alldetexecution(id,status) {		   
		ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestExecution.cfm?requirementid='+id+'&status='+status,id+'_exe')	
	}
		
	function alldetinsert(cell,edi,obj,id,mode,scope,prg,per) {	
	
	    w = "#client.width-50#"
		h = "#client.height-120#"	
		
		if (id == "") {						
		    ptoken.open("#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode=add&requirementid="+id+'&programcode='+prg+'&period='+per+'&editionid='+edi+'&objectcode='+obj+'&cell='+cell, 'requirement'+obj)			
			// ColdFusion.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestView.cfm?mode=add&requirementid='+id+'&programcode='+prg+'&period='+per+'&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'mydialog') 				
		} else {		
		    ptoken.open("#SESSION.root#/programrem/Application/Budget/Request/RequestDialog.cfm?mode="+mode+"&requirementid="+id+'&programcode='+prg+'&period='+per+'&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'requirement'+obj)				
			// ColdFusion.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestView.cfm?mode="+mode+"&requirementid='+id+'&programcode='+prg+'&period='+per+'&editionid='+edi+'&objectcode='+obj+'&cell='+cell,'mydialog') 						   	
		}		
																			
	}
	
	function refreshview(prg,per,edi,obj) {
		ptoken.navigate('AllotmentInquiryAmount.cfm?programcode='+prg+'&period='+per+'&editionid='+edi+'&objectcode='+obj,'moveresult') 		
	}		
		
	function earmark(area,prg,period,edi,res,cat,prc,row,rowline) {
	    ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Earmark/CostAllocationSubmit.cfm?area='+area+'&programcode='+prg+'&period='+period+'&editionid='+edi+'&resource='+res+'&category='+cat+'&percentage='+prc+'&row='+row+'&rowline='+rowline,'earmarkprocess')
	}

	
</script>
	
</cfoutput>	