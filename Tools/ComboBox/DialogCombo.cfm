
<cf_ajaxRequest>

<cfoutput>

<script language="JavaScript">

	function combomulti(fld,alias,table,pk,desc,order) {
		
		val = document.getElementById(fld).value;
		try { ColdFusion.Window.destroy('combomulti',true)} catch(e){};			
		ColdFusion.Window.create('combomulti', 'Selection', '',{x:100,y:100,width:700,height:document.body.offsetHeight-200,resizable:false,modal:true,center:true});	
	    ColdFusion.navigate('#SESSION.root#/tools/combobox/Combo.cfm?fld='+fld+'&alias='+alias+'&table='+table+'&pk='+pk+'&desc='+desc+'&order='+order+'&selected='+val,'combomulti');	  
							
	}	 
			
</script>	

<cf_comboMultiScript>	

</cfoutput>
 