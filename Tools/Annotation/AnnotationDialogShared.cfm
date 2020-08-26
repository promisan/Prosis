
<table width="100%" cellspacing="0" cellpadding="0">
   	
	<cfoutput query="Color">
		
		<tr  class="labelmedium">
		
			<cfquery name="Check" 
			 datasource="AppsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   UserAnnotationRecord U
			 WHERE  U.Account      = '#SESSION.acc#'
			 AND    U.EntityCode   = '#url.entity#'
			 AND    U.AnnotationId = '#annotationid#'
			 AND    U.Scope        = 'Shared'
			 <cfif key1 neq "">
			 AND    U.ObjectKeyValue1 = '#url.key1#'	
			 </cfif>
			 <cfif key2 neq "">
			 AND    U.ObjectKeyValue2 = '#url.key2#'	
			 </cfif>
			 <cfif key3 neq "">
			 AND    U.ObjectKeyValue3 = '#url.key3#'	
			 </cfif>
			 <cfif key4 neq "">
			 AND    U.ObjectKeyValue4 = '#url.key4#'	
			 </cfif>	 		
		    </cfquery>	
					
			<td height="20" width="30">
			<input type="checkbox" class="radiol" onclick="annotationtoggle(this.checked,'box#currentrow#_shared')" name="an#currentrow#_shared" id="an#currentrow#_shared" value="1" <cfif check.recordcount gte "1">checked</cfif>></td>
			<td width="85%">#Description#</td>	
			<td align="right" width="20">
				<table><tr><td  bgcolor="#color#" style="width:15px;height:15px;border: 1px solid gray;"></td></tr></table>
			</td>
		
		</tr>
		
		<cfif check.recordcount gte "1">
			<cfset cl = "regular line">		
		<cfelse>		
			<cfset cl = "hide">
		</cfif>
		
		<tr id="box#currentrow#_shared" class="#cl#">
		    <td></td>
			<td height="100%" colspan="1" align="center">
			  <textarea class="regular" name="memo#currentrow#_shared" style="width:100%;height:50">#check.annotation#</textarea>	
		    </td>
		</tr>
						
	</cfoutput>
	
			
</table>