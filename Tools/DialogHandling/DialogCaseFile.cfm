
<cfoutput>

<cfajaximport tags="cfwindow">

<script>
	
	w = #CLIENT.width# - 70;
	h = #CLIENT.height# - 160;
	
	function showclaim(id,id2)	{
	   ptoken.open("#SESSION.root#/CaseFile/Application/Case/CaseView/CaseView.cfm?claimId="+id+"&Mission="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function elementedit(elementid,claimid) {   
		
		try { ColdFusion.Window.destroy('editelement',true) } catch(e) {}
		ColdFusion.Window.create('editelement', 'Edit Element', '',{x:100,y:100,height:#client.height-140#,width:#client.widthfull-160#,modal:true,resizable:false,center:true})    
		ColdFusion.navigate('#SESSION.root#/CaseFile/Application/Element/Create/ElementEditView.cfm?claimid='+claimid+'&elementid='+elementid,'editelement') 

	}

</script>

</cfoutput>