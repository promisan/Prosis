
<!---
<cf_ajaxRequest>
--->

<cfoutput>

<script language="JavaScript">

	function combomulti(fld,alias,table,pk,desc,order) {
		
		val = document.getElementById(fld).value;		
		ProsisUI.createWindow('combomulti', 'Selection', '',{x:100,y:100,width:700,height:document.body.offsetHeight-200,resizable:false,modal:true,center:true});	
	    ptoken.navigate('#SESSION.root#/tools/combobox/Combo.cfm?fld='+fld+'&alias='+alias+'&table='+table+'&pk='+pk+'&desc='+desc+'&order='+order+'&selected='+val,'combomulti');	  
							
	}	 
			
</script>	

<cf_comboMultiScript>	

</cfoutput>
 