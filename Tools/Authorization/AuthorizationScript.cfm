
<cfoutput>
	
	<script language="JavaScript">
		
		function openauthorization(mis,sys,obj,cls) {
			ProsisUI.createWindow('authorizationwindow', 'Authorization','',{x:100,y:100,height:135,width:400,modal:true,center:true,resizable:false})   
					 
	        ptoken.navigate('#SESSION.root#/Tools/Authorization/AuthorizationEntry.cfm?mission='+mis+'&systemfunctionid='+sys+'&object='+obj+'&objectclass='+cls, 'authorizationwindow');	
		}
		
		function setauthorization(mis,sys,obj,cls,val) {	     
		     ptoken.navigate('#SESSION.root#/Tools/Authorization/AuthorizationSubmit.cfm?mission='+mis+'&systemfunctionid='+sys+'&object='+obj+'&objectclass='+cls+'&val='+val, 'authorizationwindow');	
		}
		
		function search(e) {
		  	      
		   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 							  
		   if (keynum == 13) {
		      document.getElementById("autsubmit").click();
		   }		
		   
		  } 				    
				
	</script>

</cfoutput>