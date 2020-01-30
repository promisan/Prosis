
<cf_screentop height="100%" html="No">

<cfparam name="URL.ID2" default="">

<cfset cnt = 0>

<cfquery name="Criteria" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteria
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#' 
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteriaList
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
	ORDER BY ListOrder
</cfquery>




<cfform action="CriteriaListSubmit.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#" method="POST" enablecab="Yes" name="fund">

	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="left">
	    
	  <tr>
	    <td width="100%" class="regular">
	    <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
	    <TR>
		   <td width="38%" class="labelit">Value</td>
		   <td width="48%" class="labelit">Description</td>
		   <td class="labelit">Sorting</td>
		   <td class="labelit" width="10%" align="center">Enable</td>
		   <td class="labelit" width="7%"></td>
		   <td class="labelit" width="7%"></td>
	    </TR>	
		
		<tr><td colspan="6" class="linedotted"></td></tr>
	
		<cfoutput>
		<cfloop query="Detail">
		
		<cfset nm = ListValue>
		<cfset de = ListDisplay>
		<cfset od = ListOrder>
		<cfset op = Operational>
												
		<cfif URL.ID2 eq nm>
		
		    <input type="hidden" name="ListValue" id="ListValue" value="<cfoutput>#nm#</cfoutput>">
												
			<TR>
			   <td>&nbsp;#nm#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regular">
	           </td>
			    <td>
			   	   <cfinput type="Text"
			       name="ListOrder"
			       value="#od#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
			       size="2"
			       maxlength="2"
			       class="regular">
	           </td>
			   <td class="regular" align="center">
			      <input type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq Operational>checked</cfif>>
				</td>
			   <td colspan="2" align="right"><input type="submit" value=" Update " class="button10p">&nbsp;</td>
		    </TR>	
					
		<cfelse>
		
			<TR>
			   <td class="labelit">#nm#</td>
			   <td class="labelit">#de#</td>
			   <td class="labelit">#od#</td>
			   <td align="center"><cfif #op# eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td>
			     <cfif URL.Status eq "0" or SESSION.isAdministrator eq "Yes">
			     <A href="CriteriaList.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#">
				 <img src="#SESSION.root#/Images/edit.gif" alt=""  border="0">
				 </a>
				 </cfif>
			   </td>
			   <td width="30">
			    <cfif URL.Status eq "0" or SESSION.isAdministrator eq "Yes">
			    <A href="CriteriaListPurge.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#">
				<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
				<a>
				</cfif>
			  </td>
			   
		    </TR>	
		
		</cfif>
						
		</cfloop>
		</cfoutput>
						
		<cfif URL.ID2 eq "" and (URL.Status eq "0" or SESSION.isAdministrator eq "Yes")>
					
			<TR>
			<td>
			   <cfinput type="Text" name="ListValue" message="You must enter a value" required="Yes" size="20" maxlength="20" class="regular">			
			</td>
			
			<td>
			   <cfinput type="Text" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regular">
			</td>
			
			<td>
			  <cfinput type="Text"
			       name="ListOrder"
			       value="#detail.recordcount+1#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
				   style="text-align:center"
			       size="1"
			       maxlength="2"
			       class="regular">
			</td>
			
			<td align="center">
				<input type="checkbox" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right"><input type="submit" value=" Add " class="button4">&nbsp;</td>
			    
			</TR>	
			
			<cfset cnt = cnt + 20>
								
		</cfif>	
		
		</table>
		
		</td>
		</tr>
				
		<tr><td height="2" colspan="5"></td></tr> 
			
	</table>	
		

	<cfoutput>
	<script language="JavaScript">
	
	{
	
	frm  = parent.document.getElementById("ilist");
	he = 28+#cnt#+#detail.recordcount*22#;
	frm.height = he
	}
	
	</script>
	</cfoutput>

</cfform>
