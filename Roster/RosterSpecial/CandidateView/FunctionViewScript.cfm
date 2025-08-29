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
	
	function quesave(id,topic) {
	
	   document.mytopic.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('#SESSION.root#/Roster/RosterSpecial/Bucket/BucketQuestion/RecordListingSubmit.cfm?idfunction='+id+'&topicid='+topic,'listing','','','POST','mytopic')
		 }   
	 }
	  
	function va() {	
	    ptoken.open("#SESSION.root#/vactrack/application/Announcement/Announcement.cfm?ID=#URL.IDFunction#&Mode=EDIT","VA","left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, location=no, scrollbars=yes, resizable=no")		
	}	 
	
	function submitCompetence(element,functionId, competenceId){
	
		if (element.checked){
			element.parentNode.style.backgroundColor = "##ffffcf";
			action = "insert";
		}else{
			element.parentNode.style.backgroundColor = "##ffffff";
			action = "delete";
		}
	
		ptoken.navigate("#SESSION.root#/Roster/RosterSpecial/Bucket/BucketCompetence/RecordSubmit.cfm?action="+action+"&functionId="+functionId+"&competenceId="+competenceId,"submitid");	
		setTimeout("document.getElementById('submitid').innerHTML=''", 3000);
	}
	
	function broadcast(fun,status) {
	    ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastBucket.cfm?functionid="+fun+"&status="+status, "broadcast", "status=yes, height=850px, width=920px, scrollbars=no, toolbar=no, resizable=no");		
	}
	
	function more(bx) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
			
		if (se.className=="hide") {
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
		} else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
		}
	}
	
	function search(tpe) {
		fld  = document.getElementById("search");	
		nat  = document.getElementById("nation");
		if (fld.value == "" && nat.value == "")
		   alert("Please enter your criteria")
		else
		{
		opt  = document.getElementById("option");
		if (opt.checked)
			{op = "1"}
		else
			{op ="0"}
		srt  = document.getElementById("sorting");
		se   = document.getElementById("dmore");
		se.className = "regular"
		frm  = document.getElementById("imore");
		frm.className = "regular" 			
		url = "FunctionViewListingContent.cfm?box=more&Total=0&Mode=#mode#&Owner=#Function.Owner#&IDFunction=#URL.IDFunction#&search=1&fld=" + fld.value + "&nat=" + nat.value + "&opt=" + op + "&tpe=" + tpe
		ptoken.navigate(url,'imore')
			
		}
		
	 }
				
	function listing(tab,box,act,mode,filter,level,line,total,process,page,view,print) {
	 			
		try {
		icM  = document.getElementById("d"+box+"Min")
	    icE  = document.getElementById("d"+box+"Exp")
		} catch(e) {}
		
		se   = document.getElementById("d"+box);	
						 		 
		if (se.className == "hide" || act == "show"){	 	
		     try {
	     	 icM.className = "regular";
		     icE.className = "hide";		
			 } catch(e) {}
					
			 se.className  = "regular";
			 url = "FunctionViewListingContent.cfm?tab="+tab+"&box="+box+"&Total="+total+"&mode=#mode#&Owner=#Function.Owner#&IDFunction=#URL.IDFunction#&Filter=" + filter + "&Level=" + level + "&Line=" + line + "&process=" + process + "&Page=" + page + "&View=" + view + "&Print=" + print
			 if (print == '1' || print == '3' ) {
			    w = #client.width# - 100;
			    h = #client.height# - 140;
				ptoken.open(url, "_blank");
			 } else {
			    Prosis.busy('yes')
			    ptoken.navigate(url,'i'+box)				 	
			 }
		 	
		 } else {
		 try {
	   	 icM.className = "hide";
	     icE.className = "regular";
		 } catch(e) {}
		 se.className  = "hide";
		  
		 }
			 		
	  }
	  
	// here further  
	
	function SubmissionPHP(funid,appno) {
	   alert("a")
	}
	
	function ShowFunction(AppNo,FunId,tab,box,owner,process,day,status,processstatus,meaning,processmeaning,total,page,mode) {
	       
	    w = 1150;
	    h = #client.height# - 90;
		if (mode == "php") {
			ptoken.open("#session.root#/Roster/PHP/PHPEntry/PHPProfile.cfm?scope=backoffice&applicantno="+AppNo, AppNo);
		} else {
		 //   ptoken.open("../RosterProcess/ApplicationFunctionView.cfm?box="+box+"&mode=#Mode#&ID=" + AppNo + "&ID1=" + FunId + "&IDFunction=#URL.IDFunction#","app"+AppNo,"left=35,top=15,width=" + w + ",height="+h+",toolbar=no,status=yes,scrollbars=yes,resizable=yes");
	       ptoken.open("../RosterProcess/ApplicationFunctionView.cfm?box="+box+"&mode=#Mode#&ID=" + AppNo + "&ID1=" + FunId + "&IDFunction=#URL.IDFunction#","app"+AppNo);
	
		}
		
		if (ret) {	
			se = document.getElementById(tab)
			if (se) {	   
				ColdFusion.navigate('FunctionViewListing.cfm?page='+page+'&tab='+tab+'&box='+box+'&expand=1&owner='+owner+'&idfunction='+FunId+'&process='+process+'&day='+day+'&status='+status+'&processstatus='+processstatus+'&meaning='+meaning+'&processmeaning='+meaning+'&total='+total,tab)
			} else {
			    document.getElementById("name").click()
			}
		}
	} 
	 	
	function showdocumentcandidate(vacno,persno) {
	    w = screen.width - 80;
	    h = screen.height - 130;
	    ptoken.open("#SESSION.root#/Vactrack/Application/Candidate/CandidateEdit.cfm?ID=" + vacno + "&ID1=" + persno, "_blank");
	}  
	
	function candidateApply(personno){
		ptoken.navigate('#SESSION.root#/Roster/RosterSpecial/CandidateView/ApplicantManualSubmit.cfm?IDFunction=#URL.IDFunction#&owner=#Function.Owner#&personno='+personno,'detail')
	}
	
	function candidate(id) {		
		ProsisUI.createWindow('CandidateSearchWindow', 'Retrieve a candidate', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true,resizable:false});			
		ptoken.navigate('#SESSION.root#/Roster/Candidate/Events/LocateCandidate.cfm?mode=bucket&ID='+id + '&ts='+new Date().getTime(),'CandidateSearchWindow');		
	}
		
	function initial(funno,doctpe) {
	   w = screen.width - 90;
	   h = screen.height - 160;     
	   ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search1InitialClear.cfm?cat=initial&docno=" + funno + "&doctpe=" + doctpe, "_blank", "left=35, top=30, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
	}
	
	function selectall(chk) {
	
	var count=0;
	
	se2  = 'functionid'
	var se  = document.getElementsByName(se2)
	
	while (se[count]) {    
		 	 
		 if (chk == true)
		 { se[count].checked = true; }
		 else
		 
		 { se[count].checked = false }
		 count++;
	}	
	} 
	
	function memoshow(memo,act,app,fun,row) {
	  
		se   = document.getElementById(memo)
								
		if (se.className == "hide") {
			
			se.className = "regular"
			url = "Memo.cfm?memo="+memo+"&IDFunction="+fun+"&ApplicantNo="+app	
			ptoken.navigate(url,'i'+memo)	
				
		} else	{
		
			se.className  = "hide"
		 
		}
	}  
		
	function memosave(memo,app,fun) {
	
	    // icM  = document.getElementById(memo+"Min")
	    // icE  = document.getElementById(memo+"Exp")
		se   = document.getElementById(memo)	
		txt = document.getElementById(memo+"text").value
			
		// se.className  = "hide";
		// icM.className = "hide";
	    // icE.className = "regular";
			
		url = "MemoUpdate.cfm?frm="+memo+"&ApplicantNo=" + app + "&FunctionId=" + fun + "&ID1=" + txt
		ptoken.navigate(url,'p'+memo)			
	}  			   
	
</script> 

</cfoutput>	