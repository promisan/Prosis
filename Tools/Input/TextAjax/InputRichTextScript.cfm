
<cfoutput>
<script>
	 function getformfield(mode,dsn,tbl,key1,val1,key2,val2,fld,nme) {
		ColdFusion.navigate('#SESSION.root#/tools/Input/TextAjax/InputRichTextAction.cfm'+
		    '?mode='+mode+
			'&datasource='+dsn+
            '&tablename='+tbl+
			'&keyfield1='+key1+
			'&keyvalue1='+val1+
			'&keyfield2='+key2+
			'&keyvalue2='+val2+
			'&name='+nme+
			'&field='+fld,'i'+nme) 			
				
	 }	
	 
	 function saveFormField(dsn,tbl,key1,val1,key2,val2,fld,nme) {
		 	
	 	ColdFusion.navigate('#SESSION.root#/tools/Input/TextAjax/InputRichTextSave.cfm'+
                 '?datasource='+dsn+
                 '&tablename='+tbl+
				 '&keyfield1='+key1+
				 '&keyvalue1='+val1+
				 '&keyfield2='+key2+
				 '&keyvalue2='+val2+
				 '&name='+nme+
				 '&field='+fld,'i'+nme,'','','POST','frm'+nme)		 
				 
				 
				 
			 		
	 }	
	
</script>
</cfoutput>