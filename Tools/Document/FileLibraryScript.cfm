
<cfoutput>

<cfparam name="attributes.mode" default="basic">

<cfif attributes.mode eq "Extended">
	<cfajaximport tags="cfmediaplayer">
</cfif>

<cf_ajaxRequest>

<script>
  
function addfile(mode,host,dir,subdir,fil,box,ref,svr,window,pdf,memo) {

	if (svr=="No") {
		vHeight=460;
	} else {
		vHeight=480;
	}		
		
    if (window == 'cfwindow') {
	
		if (mode == 'attachmentmultiple') {
					
			ProsisUI.createWindow('attachdialog', 'Attachment', '',{x:100,y:100,height:350,width:590,resizable:false,modal:false,center:true,color:'##e1e1e1'})    
			// ColdFusion.Window.show('attachdialog') 					
			ptoken.navigate('#SESSION.root#/Tools/Document/FileFormDialog.cfm?host='+host+'&mode='+mode+'&box='+box+'&dir=' + dir + '&ID=' + subdir + '&ID1=' + fil + '&reload='+ref+'&documentserver='+svr+'&pdfscript='+pdf+'&memo='+memo,'attachdialog') 		
		
		} else {
				    		
			ProsisUI.createWindow('attachdialog', 'Attachment', '',{x:100,y:100,height:400,width:530,resizable:false,modal:true,center:true})    
			// ColdFusion.Window.show('attachdialog') 					
			ptoken.navigate('#SESSION.root#/Tools/Document/FileFormDialog.cfm?host='+host+'&mode='+mode+'&box='+box+'&dir=' + dir + '&ID=' + subdir + '&ID1=' + fil + '&reload='+ref+'&documentserver='+svr+'&pdfscript='+pdf+'&memo='+memo,'attachdialog') 		
		}	
	
	} else {
	
    	if (mode == 'attachmentmultiple') {
					
			ProsisUI.createWindow('attachdialog', 'Attachment', '',{x:100,y:100,height:400,width:590,resizable:false,modal:false,center:true,color:'##e1e1e1'})    
			// ColdFusion.Window.show('attachdialog') 					
			ptoken.navigate('#SESSION.root#/Tools/Document/FileFormDialog.cfm?host='+host+'&mode='+mode+'&box='+box+'&dir=' + dir + '&ID=' + subdir + '&ID1=' + fil + '&reload='+ref+'&documentserver='+svr+'&pdfscript='+pdf+'&memo='+memo,'attachdialog') 		
		
		} else {
				    		
			ProsisUI.createWindow('attachdialog', 'Attachment', '',{x:100,y:100,height:400,width:530,resizable:false,modal:true,center:true})    
			// ColdFusion.Window.show('attachdialog') 					
			ptoken.navigate('#SESSION.root#/Tools/Document/FileFormDialog.cfm?host='+host+'&mode='+mode+'&box='+box+'&dir=' + dir + '&ID=' + subdir + '&ID1=' + fil + '&reload='+ref+'&documentserver='+svr+'&pdfscript='+pdf+'&memo='+memo,'attachdialog') 		
		}	
	
							   	
		// if (mode == 'attachmentmultiple') {
		
		//    _cf_loadingtexthtml="";		 
		//	ColdFusion.navigate('#SESSION.root#/Tools/Document/FileForm.cfm?host='+host+'&mode='+mode+'&box='+box+'&dir=' + dir + '&ID=' + subdir + '&ID1=' + fil + '&reload='+ref+'&documentserver='+svr+'&pdfscript='+pdf,box+'_holder') 						
	
		// } else {					
		//    _cf_loadingtexthtml="";		 
		//	ColdFusion.navigate('#SESSION.root#/Tools/Document/FileForm.cfm?host='+host+'&mode='+mode+'&box='+box+'&dir=' + dir + '&ID=' + subdir + '&ID1=' + fil + '&reload='+ref+'&documentserver='+svr+'&pdfscript='+pdf,box+'_holder') 						
		// }	
		
		
	
	}
	
}

function viewfiles(mode,host,dir,subdir,fil) {   
   ptoken.open("#SESSION.root#/Tools/Document/DocumentView.cfm?mode="+mode+"&ts="+new Date().getTime()+"&host="+host+"&dir="+dir+"&sub="+subdir+"&fil="+fil, "mail","width=800, height=620, status=yes, menubar=yes, toolbar=yes, scrollbars=no, resizable=yes");					
}  

function mailfiles(mode,host,dir,subdir,fil) {      
	ptoken.open("#SESSION.root#/Tools/Mail/Mail.cfm?contextmode="+mode+"&id1=Mail&host="+host+"&dir="+dir+"&sub="+subdir+"&fil="+fil+"&mode=dialog&GUI=HTML","mail","width=800, height=620, status=yes, toolbar=no, scrollbars=no, resizable=yes");						
}

function attrefresh(mode,path,host,subdir,filter,hl,size,list,insert,remove,color,box,rowh,w,align,border,dialog,input,pdf,memo,embed,svr,present,maxfile) {
		
	url = "#SESSION.root#/tools/document/FileLibraryShow.cfm?Mode="+mode+
	                            "&DocumentPath="+path+
								"&DocumentHost="+host+
								"&SubDirectory="+subdir+
								"&Filter="+filter+
								"&List="+hl+
								"&ShowSize="+size+
								"&Listing="+list+
								"&Insert="+insert+
								"&remove="+remove+
								"&color="+color+
								"&attbox="+box+
								"&rowheader="+rowh+
								"&boxw="+w+
								"&maxfiles="+maxfile+
								"&align="+align+
								"&border="+border+
								"&attachdialog="+dialog+
								"&pdfscript="+pdf+
								"&memo="+memo+
								"&embedgraphic="+embed+
								"&documentserver="+svr+
								"&presentation="+present+
								"&inputsize="+input
	
	_cf_loadingtexthtml="";			
    ptoken.navigate(url,'att_'+box)		 
	

}

function delfile(mode,msg,id,path,host,subdir,filter,name,hl,size,list,insert,remove,color,box,rowh,w,align,border,dialog,input,pdf,memo,embed,svr,present,maxfiles) {
	
	if (confirm(msg)) {	
		
			url = "#SESSION.root#/tools/document/FileDelete.cfm?ts="+new Date().getTime()+
							"&Mode="+mode+
	                        "&AttachmentId="+id+
							"&DocumentPath="+path+
							"&DocumentHost="+host+
							"&SubDirectory="+subdir+
							"&Filter="+filter+
							"&FileName="+name+
							"&List="+hl+
							"&ShowSize="+size+
							"&Listing="+list+
							"&Insert="+insert+
							"&remove="+remove+
							"&maxfiles="+maxfiles+
							"&color="+color+
							"&attbox="+box+
							"&rowheader="+rowh+
							"&boxw="+w+
							"&align="+align+
							"&border="+border+
							"&pdfscript="+pdf+
							"&memo="+memo+
							"&embedgraphic="+embed+
							"&documentserver="+svr+
							"&presentation="+present+
							"&attachdialog="+dialog
	 
	 _cf_loadingtexthtml='';								
	 ptoken.navigate(url,'att_'+box)							
	 
	}
	    
}

function logdocfile(id,box) {

 se = document.getElementById("logbox"+box)
 if (se.className == "hide") {
     se.className = "regular"
	 ptoken.navigate('#SESSION.root#/tools/document/FileLog.cfm?id='+id,'logboxcontent'+box)
 } else {
     se.className = "hide"
 } 
 }	 


function showfile(mode,openas,id) {  
		
	<!--- record an audit trail the -open- action to be logged --->
		
	ptoken.navigate('#SESSION.root#/Tools/Document/FileOpen.cfm?id='+id,'doclogaction')	
	
	<!--- open the file ---> 
    if (mode == "attachment" || mode == "attachmentmultiple") {		  

	    if (openas == "view") {		
		    <!--- ---------------------------------------------------------------- --->
		    <!--- perform the read action which copies the file to a secure place- --->
			<!--- ---------------------------------------------------------------- --->							
			ptoken.open("#SESSION.root#/Tools/Document/FileRead.cfm?scope=actual&id="+id,"_blank");							
		} else {
    	   ptoken.open("#SESSION.root#/Tools/Document/FileEdit.cfm?mode="+mode+"&ts="+new Date().getTime()+"&id="+id, 'FileLibrary');						
		}

	}
}

function showfilelog(id,ser) {
	ptoken.open('#SESSION.root#/Tools/Document/FileRead.cfm?scope=logfile&id='+id+'&ser='+ser,'_blank','width=800, height=600,status=yes,toolbar=no,menubar=yes,scrollbars=yes,resizable=yes');	
}

function embedfile(mode,box,action,id) {     
   if (document.getElementById("b"+box).className == "hide") {
       document.getElementById("b"+box).className = "regular"
	   w = document.body.offsetWidth-200	   
       ptoken.navigate('#SESSION.root#/tools/document/FileEmbed.cfm?width='+w+'&id='+id+'&mode='+mode+'&box='+box,box)
   } else {
       document.getElementById("b"+box).className = "hide"
   }	  
}

</script>

</cfoutput>

