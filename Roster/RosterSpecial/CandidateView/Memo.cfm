

<cfquery name="Memo" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  ApplicantFunction A
	WHERE FunctionId = '#URL.IDFunction#'
	 AND  A.ApplicantNo = '#URL.ApplicantNo#' 
</cfquery>

<cfoutput query="Memo">

	<table width="97%" align="center" cellspacing="0" cellpadding="0">
	
	  <tr>	  
		  <td colspan="2">	  
	  		 <textarea id="#URL.Memo#text" class="regular" name="#URL.Memo#text"
				style   = "width:100%;height:90;font-size:12px,padding:3px">#FunctionJustification#</textarea> 
		  </td>
	  </tr>
	  
	  <tr><td height="1"></td></tr>
	  
	  <tr><td >
	  	 <input type="button" class="button10g" style="height:18px;width:100px" name="Save" value="Save" onClick="javascript:memosave('#URL.Memo#','#ApplicantNo#','#FunctionId#')">	
	  	</td>	
		<td width="90%" style="padding-left:4px" class="labelit" id="p#url.memo#">  
	  </tr>
	  		
	</table>	

</cfoutput>
