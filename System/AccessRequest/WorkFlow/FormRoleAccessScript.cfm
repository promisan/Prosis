
<!--- scripts for workflow embedded dialog --->

<cfoutput>

<input type="text" id="requestidcontent">

<script language="JavaScript">
	
	function applyaccess(id,mis,org,role,acc) {
		
		if (mis == "") {	
		   id1 = "global"	
		} else {	
		   id1 = "tree"	
		}	
		
		document.getElementById('requestidcontent').value = id
			
		
		ProsisUI.createWindow('myaccess', 'Access', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    
		ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessView.cfm?requestid='+id+'&id1='+id1+'&ID='+role+'&Mission='+mis+'&acc=' + acc ,'myaccess') 		
				
	}
	
	function refreshaccess(acc,id) {
	   ptoken.navigate('#SESSION.root#/System/AccessRequest/Workflow/FormRoleAccessDetail.cfm?account='+acc+'&requestid='+document.getElementById('requestidcontent').value,'box'+acc)	
	}

</script>

</cfoutput>
