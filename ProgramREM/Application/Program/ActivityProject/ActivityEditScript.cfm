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
<cfajaximport tags="cfwindow,cfinput-datefield,cfform">

<cf_textareascript>

<cfoutput>

<cf_tl id="You must enter a description" var="1">
<cfset error1="#lt_text#">

<cf_tl id="You must define one or more outputs." var="1">
<cfset error2="#lt_text#">

	<script language="JavaScript">
		
		function clusterdel(code,act) {					
			url = "../ActivityCluster/ClusterRecordSubmit.cfm?activityid="+act+"&id2="+code+"&selclusterid=#Activity.ActivityClusterId#&programcode=#URL.ProgramCode#&action=delete"		
			ColdFusion.navigate(url,'cluster')						 
		 }
		   
		function clusteredit(code,act) {
		    ColdFusion.navigate('../ActivityCluster/ClusterRecord.cfm?activityid='+act+'&id2='+code+'&selclusterid=#Activity.ActivityClusterId#&programcode=#URL.ProgramCode#&action=edit','cluster')										
		 }   
		    
		function clustersave(code,act) {
					
			desc  = document.getElementById("ClusterDescription");
			orde  = document.getElementById("ClusterListingOrder");
			url = "../ActivityCluster/ClusterRecordSubmit.cfm?"+
						"&id2="+code+"&activityid="+act+"&selclusterid=#Activity.ActivityClusterId#&programcode=#URL.ProgramCode#&desc="+desc.value+"&orde="+orde.value
			ptoken.navigate(url,'cluster')							 
		 }    
		   
		function outputend(fld) {
		  
		    try { 
		    itm = document.getElementById("outputdte")
		    itm.className = "hide"
		  
		     if (fld == "entry") {
		     itm = document.getElementById("outputdte")
		     itm.className = "regular" 
			 }
			 } catch(e) {} 
		      
		  }
		 
		function applyunit(orgunit) {
			ColdFusion.navigate('setUnit.cfm?orgunit='+orgunit,'processunit')
		}
		
		function locationtoggle() {
		
			se = document.getElementById('selectlocation')
			
			if (se.className == "hide") {
				se.className = "regular"
			} else {
			    se.className = "hide"
			}
		
		}
		  
		  
		function outputsave(act) {
			
			id   = document.getElementById("ActivityId").value;			
			oid  = document.getElementById("outputid").value;		
			des  = document.getElementById("activityoutput").value;			
			ref  = document.getElementById("referenceoutput").value;	
			val  = document.getElementsByName("select");	
			
			if (val[0].checked == true) { sel = "enddate" } 
			else { sel = "date" }
			
			dte  = document.getElementById("activityoutputdate").value;
			
			if (des == "")
			
			{ alert("#error1#") }
			
			else {
					  			
				url = "OutputEntrySubmit.cfm?"+
						"&id="+id+
						"&outputid="+oid+
						"&programcode=#URL.ProgramCode#"+
						"&ProgramAccess=#ProgramAccess#"+
						"&period=#URL.Period#"+
						"&reference="+ref+
						"&select="+sel+
						"&activityOutputDate="+dte
										
				ptoken.navigate(url,'outputbox','','','POST','outputform')				
			
			}
			
			}
		  		
			function outputact(act,id) {
			
				if (act == "edit") {
						
				url = "OutputEntry.cfm?"+
							"&id=#URL.ActivityID#"+
							"&outputid="+id+
							"&ProgramAccess=#ProgramAccess#"+
							"&programcode=#URL.ProgramCode#"+
							"&period=#URL.Period#"
				} else {
				
				url = "OutputPurge.cfm?"+
							"&id=#URL.ActivityID#"+
							"&outputid="+id+
							"&ProgramAccess=#ProgramAccess#"+
							"&programcode=#URL.ProgramCode#"+
							"&period=#URL.Period#"
				}
				
				ColdFusion.navigate(url,'outputbox')
		   
			}
			
			ie = document.all?1:0
			ns4 = document.layers?1:0
		
			function seldep(itm,fld,st,act){
			 	    
			     if (ie){
				 
		          while (itm.tagName!="TR")
		          {itm=itm.parentElement;}
				  
			     }else{
				 
			          while (itm.tagName!="TR")
			          {itm=itm.parentNode;}
			     }		
						
								 	 		 	
				 if (fld != false){
					
					 document.getElementById("selectme").checked = true
					 end('duration')	
					 itm.className = "labelit highLight2";
					 
					 //  document.getElementById("activitydatestart").value = st
					 //  document.getElementById("activitydate").value = st
					 document.getElementById("pre"+act).className = "regular"				
					 setstartdate(act)
				 
				 }else{			
				 
			     	 itm.className = "labelit regular";	
					 document.getElementById("pre"+act).className = "hide"	
					 setstartdate(act)					 
				 }
			  }
			  
			  function setstartdate(actid) {		  		  
			      ColdFusion.navigate('setActivityStart.cfm?activityid='+actid,'setstartdate','','','POST','activityentryform')		  
			  }
			  
			  function end(fld){
			
			  itm = document.getElementById("duration")
			  itm.className = "hide"
			  itm = document.getElementById("enddate")
			  itm.className = "hide"
			  itm = document.getElementById(fld)
			  itm.className = "regular"
			    
			  }
			  
			  function cl() { 
			   parent.window.close() 
			   returnValue = 0	   
			  }
			  
			  function validate() {		  
			  		  
			   out = 1 // document.getElementById("output") 
			   if (out.value == "0")  { 
			      alert("#error2#")
				  return false
			   } else {			     		 
			    
			     se = document.getElementsByName("activityclusterid")
				 cnt = 0
				 clu = ""
				 while (se[cnt]) {
					 if (se[cnt].checked == true) {
					    clu = se[cnt].value	}	
					cnt++
				 }	   			
							
				if (confirm("Do you want to save this activity ?")) { 	
					  
				       document.activityentryform.onsubmit() 			  	   
					   		  
					   if( _CF_error_messages.length == 0 ) {						      			   
					      id   = document.getElementById("ActivityId").value;						 					 
			              ColdFusion.navigate('ActivityEditSubmit.cfm?Mission=#Program.Mission#&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&ActivityID='+id+'&activityclusterid='+clu,'detail','','','POST','activityentryform')
				          }  		  
				    }
				   
		         }	
			  }		 	 
			  
			  function time(per,id) {
				
				icmin = document.getElementById(per+"Col")
				icmax = document.getElementById(per+"Exp")
				box = document.getElementById("d"+per)
		
				if (box.className == "regular") {
				box.className = "hide"
				icmin.className = "hide"
				icmax.className = "regular"
				} else {	
					
				url = "#SESSION.root#/Attendance/Application/Timesheet/ActivitySummary.cfm?ts="+new Date().getTime()+
				                "&personno="+per+"&activityid="+id										
				box.className = "regular"
				icmin.className = "regular"
				icmax.className = "hide"		
				
				ColdFusion.navigate(url,'i'+per)
			
				 
				 }
		   }   
		  
	</script>

</cfoutput>

