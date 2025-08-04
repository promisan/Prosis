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
<cfparam name="URL.debug" default=0>
	
	<cfoutput>			
									
		<script language="JavaScript">
		  			    
		  function tableoutput(id,tpe,mde) {		
			    ptoken.open("#SESSION.root#/Tools/CFReport/Analysis/OutputPrepareExcel.cfm?id="+id+"&tpe="+tpe+"&mode="+mde, "_blank", "left=10, top=10, width=800, height=700, toolbar=no, menubar=yes, status=yes, scrollbars=yes, resizable=yes")
		  } 			 
						 
		  function excel(id,tpe,mde) {
		  		<cfif URL.debug eq 0>					
		  	    	ptoken.open("#SESSION.root#/Tools/CFReport/Analysis/OutputPrepareExcelFormatted.cfm?id="+id+"&tpe="+tpe+"&table=#Table#", "_blank", "left=10, top=10, width=920, height=730, toolbar=yes, menubar=yes, status=yes, scrollbars=yes, resizable=yes")
		  		</cfif>	
		  } 
						 
		  function mail(id,tpe,mde) {		
			    ptoken.open("#SESSION.root#/Tools/CFReport/Analysis/OutputPrepareExcel.cfm?id="+id+"&tpe="+tpe+"&mode="+mde, "_blank", "left=10, top=10, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
			 }  
			 
		  function collapseall() {
			
			cnt = 0
			ex = document.getElementsByName("Expanded");
			while (ex[cnt]){
				cnt++
			}		
			
			cnt = cnt-1
										
			while (ex[cnt]){	
			        if (ex[cnt].className == "regular") {		        
					ex[cnt].click()
					}
					cnt = cnt-1
					}			
								
			}
			
		  function expandall() {
			
			cnt = 0
			ex = document.getElementsByName("Expanded");													
			while (ex[cnt]){	
			        if (ex[cnt].className == "hide") {		        
					ex[cnt].click()
					}
					cnt = cnt+1
					}			
								
		  }
		  
		  function drillgraph(id) {
		  			   	
			dr = document.getElementById(id+"_graph")
			ex = document.getElementById(id+"_exp")
			cl = document.getElementById(id+"_col")
			if (dr.className == "hide") {
			   dr.className = "regular" ;			
			   cl.className = "regular"   	   			  	   
			   ex.className = "hide"
			} else {
			   dr.className = "hide" 
			   ex.className = "regular"   	   			  	   
			   cl.className = "hide"
			}
			
		  }
		  
		  function drilldown(id) {
		  		    
		    se = document.getElementById("row_"+id)						
			if (se.className == "hide") {
			   se.className = "regular" ;			   	   
			  <!--- document.getElementById("drill_"+id).click()			   --->
			} else {
			   se.className = "hide" 
			}
			
		  }					
					 
		  function show(box,act) {
							 		 
		  	  var count = 0					  		  
			  se   = document.getElementsByName(box+"_row")
			  <!--- expanded icon --->
			  expa = document.getElementById(box+"_exp")
			  <!--- collapsed icon --->
			  coll = document.getElementById(box+"_col")
			  	
			 	
			  <!--- if expanded or if action asks for hide --->			  
			  if (expa.className == "regular" || act == "hide") {
			      coll.className = "regular"
			      expa.className = "hide"
			  } else {
			      coll.className = "hide";
			      expa.className = "regular";
			     
			  } 
			  			  
			  while (se[count]) {				 
				 			  	
				  if (se[count]) {		
					     				    
						  if (se[count].className == "regular") { 
							    se[count].className = "hide" 
								<!--- also hide the children of this node --->
								 chi = se[count].children 
								 val = chi[0].id;								 
								 if (val != "") {
									 childhide(val)
								 } 
						  } else {	
							    se[count].className = "regular" 
						  }
						    
						  count++ 		  
					  }
				  }
					
			}
												
		   function childhide(box) {
							 		 
		  	  var ch1 = 0
			  se_1  = document.getElementsByName(box+"_row")
			  
			  if (document.getElementById(box+"_exp")) {
				  document.getElementById(box+"_exp").className = "hide"
				  document.getElementById(box+"_col").className = "regular"
			  }	  
							 						  
			  while (se_1[ch1]) { 		  			 
				  se_1[ch1].className = "hide" 
				  chi = se_1[ch1].children 
				  val = chi[0].id;
				  if (val != "") {
				  childhide2(val)
				  }
				  ch1++ 		  
			  }	
			  
			}
			
			function childhide2(box) {
							 		 
		  	  var ch2 = 0
			  se_2  = document.getElementsByName(box+"_row")
			  
			  if (document.getElementById(box+"_exp")) {
				  document.getElementById(box+"_exp").className = "hide"
				  document.getElementById(box+"_col").className = "regular"
			  }	  
							 						  
			  while (se_2[ch2]) { 		  			 
				  se_2[ch2].className = "hide" 				 
				  ch2++ 		  
			  }	
			  
			}
															
			function hide(box) {	
				document.getElementById(box).className = "hide";
			}		
									
			function drill(controlid,alias,node,fileno,section,frame,mode,af,av,as,bf,bv,bs,yf,yv,ys,xf,xv,xs,header,srt,condition) {
			      request(controlid,alias,node,fileno,section,frame,mode,af,av,as,bf,bv,bs,yf,yv,ys,xf,xv,xs,header,srt,condition)																								
			}
									
			w = 0
			h = 0
			if (screen) {
			w = #CLIENT.width# - 40
			h = #CLIENT.height# - 140
			}
					
		    function request(id,alias,node,fileno,section,frame,mode,af,av,as,bf,bv,bs,yf,yv,ys,xf,xv,xs,header,srt,condition) {
								
				url = "#SESSION.root#/component/analysis/CrossTabSelection.cfm?ts="+new Date().getTime()+
					"&controlid="+id+
					"&alias="+alias+
					"&node="+node+
					"&section="+section+
					"&frame="+frame+
					"&table=#SESSION.acc#_"+fileno+"_"+node+
					"_summary&af="+af+
					"&av="+av+
					"&as="+as+
					"&bf="+bf+
					"&bv="+bv+
					"&bs="+bs+
					"&ff="+yf+
					"&fv="+yv+
					"&fs="+ys+
					"&xf="+xf+
					"&xv="+xv+
					"&xs="+xs+
					"&header="+header+
					"&condition="+condition;
								
		  	     ptoken.open(url, "olapdialog") 
				 							
			}			
	
	</script>
				
</cfoutput>				