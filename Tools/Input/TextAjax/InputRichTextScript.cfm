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