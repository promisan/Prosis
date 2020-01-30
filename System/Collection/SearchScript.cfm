
<!--- collection search screen scripts --->

<cfoutput>
	<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>				
	<script type="text/javascript">
		
		function set_focus() {
		     try {
		     document.getElementById("searchtext").focus();
			 } catch(e) {}
		}
					
		function do_select(option) {		
		    
		    document.getElementById("previewstatus").value = option
			
		    cnt = 0
			se = document.getElementsByName("preview_normal")
			while (se[cnt]) {			  
			  if (option == "preview_normal") {
			    se[cnt].className = "regular" 
				} else {
				 se[cnt].className = "hide" 
				}
			    cnt++	
			}
			
			cnt = 0
			se = document.getElementsByName("preview_auto")
			while (se[cnt]) {
			  if (option == "preview_auto") {
			     se[cnt].className = "regular" 
				} else {
				 se[cnt].className = "hide" 
				}
				cnt++
			}
		
		}
		
		function do_query(cat,tme,engine,id,searchid) {

		    if (engine=='advanced'){
				ColdFusion.navigate('SearchResult.cfm?searchid='+searchid+'&engine='+engine+'&category='+cat+'&time='+tme,'getcontent')			
			} else {						    
				document.querysearch.onsubmit() 			
				// ColdFusion.navigate('DocumentInit.cfm','detail');
				if( _CF_error_messages.length == 0 ) {
					if (engine=='collection' && document.querysearch.searchtext.value != '') {
						ColdFusion.navigate('SearchResult.cfm?engine='+engine+'&collectionid=#url.id#&category='+cat+'&time='+tme,'getcontent','','','POST','querysearch')			
					}
				}	
			 }   	
		}
		
		function redo_query(val) {		   
		    document.getElementById('searchtext').value = val
			do_query('','')		
		}
		
		function list(p) {
		    cat = document.getElementById('categoryselect').value
			tim = document.getElementById('timeselect').value
			document.querysearch.onsubmit() 				
			if( _CF_error_messages.length == 0 ) {
				if (document.querysearch.searchtext.value != '') {
					ColdFusion.navigate('SearchResult.cfm?collectionid=#url.id#&category='+cat+'&time='+tim+'&page='+p,'getcontent','','','POST','querysearch')		
				}	
			 } 	
		}
		
		function help(se,m) {
		
			if (m==1)
				$('##search_'+se).fadeIn('slow');
			else	
				$('##search_'+se).fadeOut('slow');
		
		}
		
		function searchmode(val) {
				
		 if (val == '') {		   
	 	   $("##sheader").fadeIn('slow');
		   ColdFusion.navigate('SearchBasic.cfm?id=#url.id#','searchbox')
		 } else {				   
		   ColdFusion.navigate(val+'?id=#url.id#','searchbox')		 
		 }
		 
		 }		 
		 
				
		// document preview
		
		function hl(currentrow) {
		  se = document.getElementsByName('resultset')
		  cnt = 0
		  while (se[cnt]) {		      
		      if (cnt != currentrow) {
			     se[cnt].className = "regular"				 
			  }
			  cnt++
		  }
		
		}
		
		// doc preview 
				
		function do_viewdocument(attid,enforce,searchid) {  

			document.getElementById('detail').className = "hide"				
		    id = document.getElementById("attachmentid").value;					
			if (attid != id || enforce == '1')	{		   
				document.getElementById("attachmentid").value = attid;			
				ht = document.getElementById("presentationbox").clientHeight
				ColdFusion.navigate('DocumentDetail.cfm?collectionid=#url.id#&height='+ht+'&attachmentid='+attid+'&searchid='+searchid,'detail')	
			}				    
		}		
				
		// data preview 
		
		function do_viewelement(id,searchid,eclass) {	
		     
		     document.getElementById('detail').className = "hide"   
			 document.getElementById("attachmentid").value = id;	
			 ht = document.getElementById("presentationbox").clientHeight;
		     ColdFusion.navigate('DocumentDetail.cfm?collectionid=#url.id#&height='+ht+'&id='+id+'&elementclass='+eclass+'&searchid='+searchid,'detail')	
	 	}
		
		// mouse over preview 
		
		function on_the_fly_preview(mode,thisid,row) {				  	
						
			se = document.getElementById('previewstatus') 
			
			// old value
			id = document.getElementById("attachmentid").value;		
			
			// new value
			document.getElementById("attachmentid").value = thisid;	
			
			ht = document.getElementById("presentationbox").clientHeight
																   
			if (se.value == "preview_auto" && thisid != id) {
						    													  				
			    // Function that prevent refreshing in case the user has already open.
								    				    
				document.getElementById('detail').className = "hide" 									
				if (mode == "document") {
				ColdFusion.navigate('DocumentDetail.cfm?collectionid=#url.id#&height='+ht+'&presentation=quick&attachmentid='+thisid,'detail')
				} else {
				ColdFusion.navigate('DocumentDetail.cfm?collectionid=#url.id#&height='+ht+'&presentation=quick&id='+thisid,'detail')														
				}
					
			}
			
			// highlight 
			
			if (thisid != id) {			    
				 hl(row)
			}	
			
		}
		
		// print detail
		
		function do_print(search,attid,id) {		
		  window.open("DocumentDetailContent.cfm?collectionid=#url.id#&searchid="+search+"&presentation=print&attachmentid="+attid+"&id="+id,"_blank","left=100, top=100, width=800, height=800, toolbar=no, status=yes, scrollbars=yes, resizable=yes")	
		  
		}  
		
		// pressing [enter] will trigger the search --->
		function submitenter(myfield,e) {
			var keycode;
			if (window.event) keycode = window.event.keyCode;
			else if (e) keycode = e.which;
			else return true;
		
			if (keycode == 13) {
				   do_query('','','collection');
				   return false;
			   } else
			   return true;
		}			
				
		function get_file(id) {		    
			window.open('DocumentAccess.cfm?id='+id,'_blank');
		}
		
		// custom code to be moved 
		
		w = #CLIENT.width# - 61;
		h = #CLIENT.height# - 120;
		function showobject(id,id2)	{
		   window.open("#SESSION.root#/CaseFile/Application/Case/CaseView/CaseView.cfm?claimId="+id+"&Mission="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		
		function do_friendly_print() {
			window.open("SearchResultPrint.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
		}	
		
		// excel export function	
				
		function facttabledetailxls1(control,format,filter,querystring,datasource) {  		 		   
			w = #CLIENT.width# - 80;
		    h = #CLIENT.height# - 110;	
			window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&data=1&controlid="+control+"&"+querystring+"&format="+format, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
		}		
		
	</script>

</cfoutput>
