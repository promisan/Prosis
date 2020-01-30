<cfoutput>

	<script LANGUAGE = "JavaScript">

	function finlabel(ent,key,ref,mis,cur,amt,lbl,obj,mde,siz) {
	
	url = "#SESSION.root#/tools/financeObject/Tagging/ObjectListing.cfm?ent="+ent+
		  "&key="+key+
		  "&ref="+ref+
		  "&mis="+mis+
		  "&cur="+cur+
		  "&amt="+amt+
		  "&lbl="+lbl+
		  "&mde="+mde+
		  "&obj="+obj+
		  "&siz="+siz	  
		_cf_loadingtexthtml='';	  
		ptoken.navigate(url,'label')	 	
	}

	</script>

</cfoutput>
