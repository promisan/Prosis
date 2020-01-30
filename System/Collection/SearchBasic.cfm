

<cfquery name = "Collection"  
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     SELECT   *
     FROM     Collection
     WHERE    CollectionId = '#url.id#'
</cfquery>



<cfoutput>

<cfform method="POST" 
       name="querysearch" 
       onsubmit="return false">
	   
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td height="40">
	
			<cfinput type="Text"
			    style="font:18px;height:25" 
				name="searchtext" 
				required="No" 
				size="55" 
				maxlength="100" 
				tabindex="0" 
				class="regular"
				onKeyPress="return submitenter(this,event)">		
			
		</td>
		<td height="20" colspan="1">
	    	<button name="go" id="go" style="width:100;height:25" value="searchgo" class="button10g" onClick="do_query('','','collection','')">Search</button>
		</td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td>
			<a href="javascript:help('#Collection.SearchEngine#',1)"><font face="Verdana" size="1.5" color="0080C0">How to search ?</a> <br>
			
			<cfif Collection.systemModule eq "Insurance">
			    <cfinclude template="CaseFile/AdvancedSearchScript.cfm">
				<a href="javascript:searchmode('CaseFile/AdvancedSearchView.cfm')"><font face="Verdana" size="1.5" color="0080C0">Advanced search</a>
			</cfif>
	    </td>
		</tr>
		
	</table>
	
</cfform>  

</cfoutput>

		